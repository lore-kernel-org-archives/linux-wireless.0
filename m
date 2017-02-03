Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38050 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752729AbdBCOlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:41:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:01 +0200
Message-Id: <20170203143812.7525-15-luca@coelho.fi> (sfid-20170203_154124_826114_401CE3F0)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: overwrite skb info later
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We don't really need clear the skb's status area nor store the
dev_cmd into it until we really commit to the frame by handing
it to the transport - defer those operations until just before
we do that.

This doesn't entirely fix the bug with frames not getting sent
out after having been deferred due to DQA, because it doesn't
restore the info->driver_data[0] place that was already set to
zero (or another value) by the A-MSDU logic.

Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index e2f82c10b019..0dcf0ebab45d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -466,7 +466,6 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		      struct ieee80211_sta *sta, u8 sta_id)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct iwl_device_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 
@@ -486,12 +485,18 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	iwl_mvm_set_tx_cmd_rate(mvm, tx_cmd, info, sta, hdr->frame_control);
 
+	return dev_cmd;
+}
+
+static void iwl_mvm_skb_prepare_status(struct sk_buff *skb,
+				       struct iwl_device_cmd *cmd)
+{
+	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
+
 	memset(&skb_info->status, 0, sizeof(skb_info->status));
 	memset(skb_info->driver_data, 0, sizeof(skb_info->driver_data));
 
-	skb_info->driver_data[1] = dev_cmd;
-
-	return dev_cmd;
+	skb_info->driver_data[1] = cmd;
 }
 
 static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
@@ -607,6 +612,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	if (!dev_cmd)
 		return -1;
 
+	/* From now on, we cannot access info->control */
+	iwl_mvm_skb_prepare_status(skb, dev_cmd);
+
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	/* Copy MAC header from skb into command buffer */
@@ -917,7 +925,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		goto drop;
 
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
-	/* From now on, we cannot access info->control */
 
 	/*
 	 * we handle that entirely ourselves -- for uAPSD the firmware
@@ -1024,6 +1031,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	IWL_DEBUG_TX(mvm, "TX to [%d|%d] Q:%d - seq: 0x%x\n", mvmsta->sta_id,
 		     tid, txq_id, IEEE80211_SEQ_TO_SN(seq_number));
 
+	/* From now on, we cannot access info->control */
+	iwl_mvm_skb_prepare_status(skb, dev_cmd);
+
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
-- 
2.11.0
