Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0H0Q4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/27] iwlagn: queue frames according to context
Date: Fri, 27 Aug 2010 09:59:48 -0700
Message-Id: <1282928395-32762-21-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Frames for different contexts need to be put
on different queues, and multicast after DTIM
frames have a special queue yet which also
depends on the context, so put all this into
the context.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   42 +++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   27 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    5 +++
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 64daddd..5950184 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -71,18 +71,6 @@ static const u8 tid_to_ac[] = {
 	2, 3, 3, 2, 1, 1, 0, 0
 };
 
-static const u8 ac_to_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-};
-
-static inline int get_fifo_from_ac(u8 ac)
-{
-	return ac_to_fifo[ac];
-}
-
 static inline int get_ac_from_tid(u16 tid)
 {
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
@@ -92,10 +80,10 @@ static inline int get_ac_from_tid(u16 tid)
 	return -EINVAL;
 }
 
-static inline int get_fifo_from_tid(u16 tid)
+static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
 {
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return get_fifo_from_ac(tid_to_ac[tid]);
+		return ctx->ac_to_fifo[tid_to_ac[tid]];
 
 	/* no support for TIDs 8-15 yet */
 	return -EINVAL;
@@ -333,11 +321,6 @@ void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
 	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, mask);
 }
 
-static inline int get_queue_from_ac(u16 ac)
-{
-	return ac;
-}
-
 /*
  * handle build REPLY_TX command notification.
  */
@@ -595,7 +578,20 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
 	}
 
-	txq_id = get_queue_from_ac(skb_get_queue_mapping(skb));
+	/*
+	 * Send this frame after DTIM -- there's a special queue
+	 * reserved for this for contexts that support AP mode.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+		txq_id = ctx->mcast_queue;
+		/*
+		 * The microcode will clear the more data
+		 * bit in the last frame it transmits.
+		 */
+		hdr->frame_control |=
+			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	} else
+		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
 	/* irqs already disabled/saved above when locking priv->lock */
 	spin_lock(&priv->sta_lock);
@@ -984,7 +980,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	unsigned long flags;
 	struct iwl_tid_data *tid_data;
 
-	tx_fifo = get_fifo_from_tid(tid);
+	tx_fifo = get_fifo_from_tid(iwl_rxon_ctx_from_vif(vif), tid);
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
@@ -1045,7 +1041,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	int write_ptr, read_ptr;
 	unsigned long flags;
 
-	tx_fifo_id = get_fifo_from_tid(tid);
+	tx_fifo_id = get_fifo_from_tid(iwl_rxon_ctx_from_vif(vif), tid);
 	if (unlikely(tx_fifo_id < 0))
 		return tx_fifo_id;
 
@@ -1133,7 +1129,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 		if ((txq_id  == tid_data->agg.txq_id) &&
 		    (q->read_ptr == q->write_ptr)) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = get_fifo_from_tid(tid);
+			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b07d397..143c12a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4196,6 +4196,28 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 	return priv->cfg->ops->lib->set_hw_params(priv);
 }
 
+static const u8 iwlagn_bss_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+
+static const u8 iwlagn_bss_ac_to_queue[] = {
+	0, 1, 2, 3,
+};
+
+static const u8 iwlagn_pan_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_BK_IPAN,
+};
+
+static const u8 iwlagn_pan_ac_to_queue[] = {
+	7, 6, 5, 4,
+};
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0, i;
@@ -4242,6 +4264,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo = iwlagn_bss_ac_to_fifo;
+	priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue = iwlagn_bss_ac_to_queue;
 
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd = REPLY_WIPAN_RXON_TIMING;
@@ -4251,6 +4275,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
 	priv->contexts[IWL_RXON_CTX_PAN].bcast_sta_id = IWLAGN_PAN_BCAST_ID;
 	priv->contexts[IWL_RXON_CTX_PAN].station_flags = STA_FLG_PAN_STATION;
+	priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo = iwlagn_pan_ac_to_fifo;
+	priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue = iwlagn_pan_ac_to_queue;
+	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 99b6b81..422c71e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1111,6 +1111,11 @@ enum iwl_rxon_context_id {
 
 struct iwl_rxon_context {
 	struct ieee80211_vif *vif;
+
+	const u8 *ac_to_fifo;
+	const u8 *ac_to_queue;
+	u8 mcast_queue;
+
 	enum iwl_rxon_context_id ctxid;
 	/*
 	 * We declare this const so it can only be
-- 
1.7.0.4

