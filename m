Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40532 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbcEJUG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:06:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:05:57 +0300
Message-Id: <1462910797-20303-1-git-send-email-luca@coelho.fi> (sfid-20160510_220704_957210_B8124E8C)
In-Reply-To: <1462910585.25219.7.camel@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
Subject: [PATCH 01/41] iwlwifi: mvm: allocate queue for probe response in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode, allocate a dedicated queue (#9) for P2P GO/soft
AP probe responses.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  6 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 44 ++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 26 +++++++++++---
 4 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 60eed84..206fd89 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -97,6 +97,8 @@ enum {
  *	Each MGMT queue is mapped to a single STA
  *	MGMT frames are frames that return true on ieee80211_is_mgmt()
  * @IWL_MVM_DQA_MAX_MGMT_QUEUE: last TXQ in pool for MGMT frames
+ * @IWL_MVM_DQA_AP_PROBE_RESP_QUEUE: a queue reserved for P2P GO/SoftAP probe
+ *	responses
  * @IWL_MVM_DQA_MIN_DATA_QUEUE: first TXQ in pool for DATA frames.
  *	DATA frames are intended for !ieee80211_is_mgmt() frames, but if
  *	the MGMT TXQ pool is exhausted, mgmt frames can be sent on DATA queues
@@ -109,6 +111,7 @@ enum iwl_mvm_dqa_txq {
 	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
 	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
 	IWL_MVM_DQA_MAX_MGMT_QUEUE = 8,
+	IWL_MVM_DQA_AP_PROBE_RESP_QUEUE = 9,
 	IWL_MVM_DQA_MIN_DATA_QUEUE = 10,
 	IWL_MVM_DQA_MAX_DATA_QUEUE = 31,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 456067b..0bcd8c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -540,6 +540,12 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 				    IWL_MAX_TID_COUNT, 0);
+
+		if (iwl_mvm_is_dqa_supported(mvm))
+			iwl_mvm_disable_txq(mvm,
+					    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
+					    vif->hw_queue[0], IWL_MAX_TID_COUNT,
+					    0);
 		/* fall through */
 	default:
 		/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 12614b7..5350ca6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1000,6 +1000,29 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		struct iwl_trans_txq_scd_cfg cfg = {
+			.fifo = IWL_MVM_TX_FIFO_VO,
+			.sta_id = mvmvif->bcast_sta.sta_id,
+			.tid = IWL_MAX_TID_COUNT,
+			.aggregate = false,
+			.frame_limit = IWL_FRAME_LIMIT,
+		};
+		unsigned int wdg_timeout =
+			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
+		int queue;
+
+		if ((vif->type == NL80211_IFTYPE_AP) &&
+		    (mvmvif->bcast_sta.tfd_queue_msk &
+		     BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)))
+			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		else if (WARN(1, "Missed required TXQ for adding bcast STA\n"))
+			return -EINVAL;
+
+		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0, &cfg,
+				   wdg_timeout);
+	}
+
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		baddr = vif->bss_conf.bssid;
 
@@ -1028,20 +1051,25 @@ int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	u32 qmask;
+	u32 qmask = 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	qmask = iwl_mvm_mac_get_queues_mask(vif);
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		qmask = iwl_mvm_mac_get_queues_mask(vif);
 
-	/*
-	 * The firmware defines the TFD queue mask to only be relevant
-	 * for *unicast* queues, so the multicast (CAB) queue shouldn't
-	 * be included.
-	 */
-	if (vif->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP) {
+		/*
+		 * The firmware defines the TFD queue mask to only be relevant
+		 * for *unicast* queues, so the multicast (CAB) queue shouldn't
+		 * be included.
+		 */
 		qmask &= ~BIT(vif->cab_queue);
 
+		if (iwl_mvm_is_dqa_supported(mvm))
+			qmask |= BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+	}
+
 	return iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta, qmask,
 					ieee80211_vif_type_p2p(vif));
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c53aa0f..b4ac530f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -475,6 +475,17 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	return dev_cmd;
 }
 
+static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
+				      struct ieee80211_tx_info *info, __le16 fc)
+{
+	if (iwl_mvm_is_dqa_supported(mvm) &&
+	    info->control.vif->type == NL80211_IFTYPE_AP &&
+	    ieee80211_is_probe_resp(fc))
+		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+
+	return info->hw_queue;
+}
+
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -484,6 +495,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	struct iwl_tx_cmd *tx_cmd;
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	int queue;
 
 	memcpy(&info, skb->cb, sizeof(info));
 
@@ -508,6 +520,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	    info.control.vif->type == NL80211_IFTYPE_STATION)
 		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
 
+	queue = info.hw_queue;
+
 	/*
 	 * If the interface on which the frame is sent is the P2P_DEVICE
 	 * or an AP/GO interface use the broadcast station associated
@@ -523,10 +537,12 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			iwl_mvm_vif_from_mac80211(info.control.vif);
 
 		if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
-		    info.control.vif->type == NL80211_IFTYPE_AP)
+		    info.control.vif->type == NL80211_IFTYPE_AP) {
 			sta_id = mvmvif->bcast_sta.sta_id;
-		else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
-			 is_multicast_ether_addr(hdr->addr1)) {
+			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
+							   hdr->frame_control);
+		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
+			   is_multicast_ether_addr(hdr->addr1)) {
 			u8 ap_sta_id = ACCESS_ONCE(mvmvif->ap_sta_id);
 
 			if (ap_sta_id != IWL_MVM_STATION_COUNT)
@@ -534,7 +550,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		}
 	}
 
-	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, info.hw_queue);
+	IWL_DEBUG_TX(mvm, "station Id %d, queue=%d\n", sta_id, queue);
 
 	dev_cmd = iwl_mvm_set_tx_params(mvm, skb, &info, hdrlen, NULL, sta_id);
 	if (!dev_cmd)
@@ -545,7 +561,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
-	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, info.hw_queue)) {
+	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, queue)) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 		return -1;
 	}
-- 
2.8.1

