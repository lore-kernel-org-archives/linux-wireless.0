Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40542 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbcEJUHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:07:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:05:58 +0300
Message-Id: <1462910797-20303-2-git-send-email-luca@coelho.fi> (sfid-20160510_220719_831278_CD11037F)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 02/41] iwlwifi: mvm: support p2p device frames tx on dqa queue #2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Support sending P2P device frames should be sent from
queue #2, as required in DQA mode.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 16 ++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 12 ++++++++----
 4 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 206fd89..41b80ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -90,6 +90,7 @@ enum {
  * DQA queue numbers
  *
  * @IWL_MVM_DQA_CMD_QUEUE: a queue reserved for sending HCMDs to the FW
+ * @IWL_MVM_DQA_P2P_DEVICE_QUEUE: a queue reserved for P2P device frames
  * @IWL_MVM_DQA_GCAST_QUEUE: a queue reserved for P2P GO/SoftAP GCAST frames
  * @IWL_MVM_DQA_BSS_CLIENT_QUEUE: a queue reserved for BSS activity, to ensure
  *	that we are never left without the possibility to connect to an AP.
@@ -107,6 +108,7 @@ enum {
  */
 enum iwl_mvm_dqa_txq {
 	IWL_MVM_DQA_CMD_QUEUE = 0,
+	IWL_MVM_DQA_P2P_DEVICE_QUEUE = 2,
 	IWL_MVM_DQA_GCAST_QUEUE = 3,
 	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
 	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 0bcd8c7..7aae068 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -501,9 +501,11 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
-				      IWL_MVM_OFFCHANNEL_QUEUE,
-				      IWL_MVM_TX_FIFO_VO, 0, wdg_timeout);
+		if (!iwl_mvm_is_dqa_supported(mvm))
+			iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+					      IWL_MVM_OFFCHANNEL_QUEUE,
+					      IWL_MVM_TX_FIFO_VO, 0,
+					      wdg_timeout);
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue, vif->cab_queue,
@@ -533,9 +535,11 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
-				    IWL_MVM_OFFCHANNEL_QUEUE, IWL_MAX_TID_COUNT,
-				    0);
+		if (!iwl_mvm_is_dqa_supported(mvm))
+			iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+					    IWL_MVM_OFFCHANNEL_QUEUE,
+					    IWL_MAX_TID_COUNT, 0);
+
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5350ca6..701511d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1016,6 +1016,10 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		    (mvmvif->bcast_sta.tfd_queue_msk &
 		     BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)))
 			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		else if ((vif->type == NL80211_IFTYPE_P2P_DEVICE) &&
+			 (mvmvif->bcast_sta.tfd_queue_msk &
+			  BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)))
+			queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
 		else if (WARN(1, "Missed required TXQ for adding bcast STA\n"))
 			return -EINVAL;
 
@@ -1068,6 +1072,9 @@ int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 		if (iwl_mvm_is_dqa_supported(mvm))
 			qmask |= BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+	} else if (iwl_mvm_is_dqa_supported(mvm) &&
+		   vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+		qmask |= BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
 	}
 
 	return iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta, qmask,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index b4ac530f4..a8e5a67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -478,10 +478,14 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 				      struct ieee80211_tx_info *info, __le16 fc)
 {
-	if (iwl_mvm_is_dqa_supported(mvm) &&
-	    info->control.vif->type == NL80211_IFTYPE_AP &&
-	    ieee80211_is_probe_resp(fc))
-		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		if (info->control.vif->type == NL80211_IFTYPE_AP &&
+		    ieee80211_is_probe_resp(fc))
+			return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		else if (ieee80211_is_mgmt(fc) &&
+			 info->control.vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	}
 
 	return info->hw_queue;
 }
-- 
2.8.1

