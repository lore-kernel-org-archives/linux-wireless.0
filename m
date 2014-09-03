Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:41589 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaICT4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:33 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so9043243wev.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/36] iwlwifi: mvm: use dynamic SMPS for P2P Client
Date: Wed,  3 Sep 2014 22:55:51 +0300
Message-Id: <1409774184-24665-3-git-send-email-egrumbach@gmail.com> (sfid-20140903_215637_751528_B75534BC)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to force the GO to use protection and enhances
the reliability of the link.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7c87965..83c2ce6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1481,8 +1481,12 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 			iwl_mvm_sf_update(mvm, vif, false);
 			iwl_mvm_power_vif_assoc(mvm, vif);
-			if (vif->p2p)
+			if (vif->p2p) {
 				iwl_mvm_ref(mvm, IWL_MVM_REF_P2P_CLIENT);
+				iwl_mvm_update_smps(mvm, vif,
+						    IWL_MVM_SMPS_REQ_PROT,
+						    IEEE80211_SMPS_DYNAMIC);
+			}
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/*
 			 * If update fails - SF might be running in associated
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 802d29e..771cf46 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -253,6 +253,7 @@ struct iwl_dbgfs_bf {
 enum iwl_mvm_smps_type_request {
 	IWL_MVM_SMPS_REQ_BT_COEX,
 	IWL_MVM_SMPS_REQ_TT,
+	IWL_MVM_SMPS_REQ_PROT,
 	NUM_IWL_MVM_SMPS_REQ,
 };
 
-- 
1.9.1

