Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167Ab1LPQhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:46 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/24] iwlwifi: transport layer shouldn't access the AGG SM
Date: Fri, 16 Dec 2011 07:37:18 -0800
Message-Id: <1324049849-831-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173802_775681_26AE1ACD)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is another step towards the move of tid_data from the shared
area.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   11 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   26 ++++--------------------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 8db9144..88ee557 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -377,6 +377,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			goto drop_unlock_sta;
 		tid_data = &priv->shrd->tid_data[sta_id][tid];
 
+		/* aggregation is on for this <sta,tid> */
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    tid_data->agg.state != IWL_AGG_ON) {
+			IWL_ERR(priv, "TX_CTL_AMPDU while not in AGG:"
+				" Tx flags = 0x%08x, agg.state = %d",
+				info->flags, tid_data->agg.state);
+			IWL_ERR(priv, "sta_id = %d, tid = %d seq_num = %d",
+				sta_id, tid, SEQ_TO_SN(tid_data->seq_number));
+			goto drop_unlock_sta;
+		}
+
 		seq_number = tid_data->seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 06db602..cfa0bf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1058,7 +1058,6 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
 	u16 len, firstlen, secondlen;
-	u16 seq_number = 0;
 	u8 wait_write_ptr = 0;
 	u8 txq_id;
 	bool is_agg = false;
@@ -1084,26 +1083,11 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		txq_id =
 		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
 
-	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
-		struct iwl_tid_data *tid_data;
-		tid_data = &trans->shrd->tid_data[sta_id][tid];
-		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-			return -1;
-
-		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-			if (WARN_ON_ONCE(tid_data->agg.state != IWL_AGG_ON)) {
-				IWL_ERR(trans, "TX_CTL_AMPDU while not in AGG:"
-					" Tx flags = 0x%08x, agg.state = %d",
-					info->flags, tid_data->agg.state);
-				IWL_ERR(trans, "sta_id = %d, tid = %d "
-					"txq_id = %d, seq_num = %d", sta_id,
-					tid, trans_pcie->agg_txq[sta_id][tid],
-					SEQ_TO_SN(seq_number));
-			}
-			txq_id = trans_pcie->agg_txq[sta_id][tid];
-			is_agg = true;
-		}
+	/* aggregation is on for this <sta,tid> */
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		WARN_ON(tid >= IWL_MAX_TID_COUNT);
+		txq_id = trans_pcie->agg_txq[sta_id][tid];
+		is_agg = true;
 	}
 
 	txq = &trans_pcie->txq[txq_id];
-- 
1.7.0.4

