Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45428 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 14:15:06 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so6907833wgh.22
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 11:15:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: fix merge damage
Date: Mon, 21 Jul 2014 21:14:57 +0300
Message-Id: <1405966498-4936-1-git-send-email-egrumbach@gmail.com> (sfid-20140721_201511_130060_FF40413D)
In-Reply-To: <53CD5785.80408@gmail.com>
References: <53CD5785.80408@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9bfb906..98556d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -303,13 +303,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
-	    !iwlwifi_mod_params.uapsd_disable) {
-		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
-		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
-		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
-	}
-
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
-- 
1.8.3.2

