Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYHDIDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/10] iwlwifi: cleanup iwl_tx_skb
Date: Mon,  4 Aug 2008 16:00:44 +0800
Message-Id: <1217836848-24288-7-git-send-email-yi.zhu@intel.com> (sfid-20080804_100400_093259_2BDEDC57)
In-Reply-To: <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up iwl_tx_skb function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c    |   40 +++++++++++++----------------
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8a9feba..981fdad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2719,7 +2719,7 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MACDUMP("enter\n");
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
@@ -2733,7 +2733,7 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (iwl_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MACDUMP("leave\n");
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index b4ffd33..d2daa17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -114,7 +114,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_MAC80211      (1 << 1)
 #define IWL_DL_HOST_COMMAND  (1 << 2)
 #define IWL_DL_STATE         (1 << 3)
-
+#define IWL_DL_MACDUMP		(1 << 4)
 #define IWL_DL_RADIO         (1 << 7)
 #define IWL_DL_POWER         (1 << 8)
 #define IWL_DL_TEMP          (1 << 9)
@@ -154,6 +154,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
 
 #define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_MACDUMP(f, a...)     IWL_DEBUG(IWL_DL_MACDUMP, f, ## a)
 #define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
 #define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
 #define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 80f8ca2..86225d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -764,20 +764,19 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_tfd_frame *tfd;
-	u32 *control_flags;
-	int txq_id = skb_get_queue_mapping(skb);
-	struct iwl_tx_queue *txq = NULL;
-	struct iwl_queue *q = NULL;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	struct iwl_cmd *out_cmd;
+	struct iwl_tx_cmd *tx_cmd;
+	int swq_id, txq_id;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
-	struct iwl_cmd *out_cmd = NULL;
-	struct iwl_tx_cmd *tx_cmd;
 	u16 len, idx, len_org;
 	u16 seq_number = 0;
-	u8 id, hdr_len, unicast;
-	u8 sta_id;
 	__le16 fc;
+	u8 hdr_len, unicast;
+	u8 sta_id;
 	u8 wait_write_ptr = 0;
 	u8 tid = 0;
 	u8 *qc = NULL;
@@ -802,7 +801,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	unicast = !is_multicast_ether_addr(hdr->addr1);
-	id = 0;
 
 	fc = hdr->frame_control;
 
@@ -840,14 +838,16 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX("station Id %d\n", sta_id);
 
+	swq_id = skb_get_queue_mapping(skb);
+	txq_id = swq_id;
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
-		seq_number = priv->stations[sta_id].tid[tid].seq_number &
-				IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = cpu_to_le16(seq_number) |
-			(hdr->seq_ctrl &
-				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
+		seq_number = priv->stations[sta_id].tid[tid].seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl = hdr->seq_ctrl &
+				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
@@ -864,7 +864,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Set up first empty TFD within this queue's circular TFD buffer */
 	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
-	control_flags = (u32 *) tfd;
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
@@ -983,8 +982,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		} else {
-			ieee80211_stop_queue(priv->hw,
-					     skb_get_queue_mapping(skb));
+			ieee80211_stop_queue(priv->hw, swq_id);
 		}
 	}
 
@@ -1013,13 +1011,12 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tfd_frame *tfd;
-	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
-	u32 idx;
-	u16 fix_size;
 	dma_addr_t phys_addr;
-	int len, ret;
 	unsigned long flags;
+	int len, ret;
+	u32 idx;
+	u16 fix_size;
 
 	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
@@ -1045,7 +1042,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
-	control_flags = (u32 *) tfd;
 
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
-- 
1.5.3.6

