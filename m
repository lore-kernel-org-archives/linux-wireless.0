Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39956 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEVHYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:16 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so3839659wiw.16
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:15 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/11] iwlwifi: mvm: disable reduced Tx power when not applicable
Date: Thu, 22 May 2014 10:23:52 +0300
Message-Id: <1400743435-702-8-git-send-email-egrumbach@gmail.com> (sfid-20140522_092730_667319_58878180)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I forgot to disable the reduced Tx power in a few paths.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index cbad3ef..e35f5a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -831,8 +831,11 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
 				    smps_mode);
 		data->reduced_tx_power = false;
-		if (vif->type == NL80211_IFTYPE_STATION)
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
+						    false);
 			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
+		}
 		return;
 	}
 
@@ -905,6 +908,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
 	    !data->notif->bt_status) {
 		data->reduced_tx_power = false;
+		iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false);
 		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
 	}
-- 
1.8.3.2

