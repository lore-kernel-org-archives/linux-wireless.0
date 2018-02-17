Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59272 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751077AbeBQIeF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:49 +0200
Message-Id: <20180217083354.31160-5-luca@coelho.fi> (sfid-20180217_093419_256568_9E522DF5)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 4/9] iwlwifi: mvm: fix assert 0x2B00 on older FWs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We should add the multicast station before adding the
broadcast station.

However, in older FW, the firmware will start beaconing
when we add the multicast station, and since the broadcast
station is not added at this point so the transmission
of the beacon will fail on assert 0x2b00.

This is fixed in later firmware, so make the order
of addition depend on the TLV.

Fixes: 26d6c16bed53 ("iwlwifi: mvm: add multicast station")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 45 ++++++++++++++++++-----
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 08de822c3ef0..ebf511150f4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -2106,15 +2107,40 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_remove;
 
-	ret = iwl_mvm_add_mcast_sta(mvm, vif);
-	if (ret)
-		goto out_unbind;
-
-	/* Send the bcast station. At this stage the TBTT and DTIM time events
-	 * are added and applied to the scheduler */
-	ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
-	if (ret)
-		goto out_rm_mcast;
+	/*
+	 * This is not very nice, but the simplest:
+	 * For older FWs adding the mcast sta before the bcast station may
+	 * cause assert 0x2b00.
+	 * This is fixed in later FW so make the order of removal depend on
+	 * the TLV
+	 */
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE)) {
+		ret = iwl_mvm_add_mcast_sta(mvm, vif);
+		if (ret)
+			goto out_unbind;
+		/*
+		 * Send the bcast station. At this stage the TBTT and DTIM time
+		 * events are added and applied to the scheduler
+		 */
+		ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
+		if (ret) {
+			iwl_mvm_rm_mcast_sta(mvm, vif);
+			goto out_unbind;
+		}
+	} else {
+		/*
+		 * Send the bcast station. At this stage the TBTT and DTIM time
+		 * events are added and applied to the scheduler
+		 */
+		iwl_mvm_send_add_bcast_sta(mvm, vif);
+		if (ret)
+			goto out_unbind;
+		iwl_mvm_add_mcast_sta(mvm, vif);
+		if (ret) {
+			iwl_mvm_send_rm_bcast_sta(mvm, vif);
+			goto out_unbind;
+		}
+	}
 
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
@@ -2144,7 +2170,6 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	iwl_mvm_power_update_mac(mvm);
 	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
-out_rm_mcast:
 	iwl_mvm_rm_mcast_sta(mvm, vif);
 out_unbind:
 	iwl_mvm_binding_remove_vif(mvm, vif);
-- 
2.15.1
