Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58915 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0KBA4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:22 -0400
Received: by mail-pw0-f46.google.com with SMTP id 3so1423603pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 17:56:22 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 3/7] mwl8k: allow for padding in AP transmit descriptor
Date: Mon,  1 Nov 2010 17:55:47 -0700
Message-Id: <1288659351-22313-3-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Nemavat <pnemavat@marvell.com>

The AP transmit descriptor has padding of 20 bytes at the
end of the descriptor. This padding is not used by mwl8k driver
but it still has to be accounted for while calculating the size
of the descriptor in order to calculate start of next descriptor.
Allow for different transmit descriptor size due to padding for AP
transmit descriptor.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cfda87a..9d614b8 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -121,7 +121,8 @@ struct mwl8k_tx_queue {
 	int tail;
 
 	unsigned int len;
-	struct mwl8k_tx_desc *txd;
+	void *txd;
+
 	dma_addr_t txd_dma;
 	struct sk_buff **skb;
 };
@@ -210,6 +211,9 @@ struct mwl8k_priv {
 
 	/* Most recently reported noise in dBm */
 	s8 noise;
+
+	/* Size of the tx descriptor for the currently loaded firmware */
+	unsigned short txd_size;
 };
 
 /* Per interface specific private data */
@@ -1116,6 +1120,15 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 #define MWL8K_QOS_ACK_POLICY_BLOCKACK		0x0060
 #define MWL8K_QOS_EOSP				0x0010
 
+/*
+ * The size of the tx descriptors used by the firmware varies depending on
+ * whether we use AP firmware or STA firmware.  However, the fields used by
+ * this driver are identical, so the difference in size is treated as padding
+ * at the end of the structure.
+ */
+#define MWL8K_TX_DESC_SIZE_STA			32
+#define MWL8K_TX_DESC_SIZE_AP			52
+
 struct mwl8k_tx_desc {
 	__le32 status;
 	__u8 data_rate;
@@ -1144,7 +1157,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	txq->head = 0;
 	txq->tail = 0;
 
-	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
+	size = MWL8K_TX_DESCS * priv->txd_size;
 
 	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
 	if (txq->txd == NULL) {
@@ -1165,12 +1178,12 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 		struct mwl8k_tx_desc *tx_desc;
 		int nexti;
 
-		tx_desc = txq->txd + i;
+		tx_desc = txq->txd + i * priv->txd_size;
 		nexti = (i + 1) % MWL8K_TX_DESCS;
 
 		tx_desc->status = 0;
 		tx_desc->next_txd_phys_addr =
-			cpu_to_le32(txq->txd_dma + nexti * sizeof(*tx_desc));
+			cpu_to_le32(txq->txd_dma + nexti * priv->txd_size);
 	}
 
 	return 0;
@@ -1198,9 +1211,10 @@ static void mwl8k_dump_tx_rings(struct ieee80211_hw *hw)
 		int desc;
 
 		for (desc = 0; desc < MWL8K_TX_DESCS; desc++) {
-			struct mwl8k_tx_desc *tx_desc = txq->txd + desc;
+			struct mwl8k_tx_desc *tx_desc;
 			u32 status;
 
+			tx_desc = txq->txd + desc * priv->txd_size;
 			status = le32_to_cpu(tx_desc->status);
 			if (status & MWL8K_TXD_STATUS_FW_OWNED)
 				fw_owned++;
@@ -1309,7 +1323,7 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		u32 status;
 
 		tx = txq->head;
-		tx_desc = txq->txd + tx;
+		tx_desc = txq->txd + tx * priv->txd_size;
 
 		status = le32_to_cpu(tx_desc->status);
 
@@ -1367,7 +1381,7 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 	txq->skb = NULL;
 
 	pci_free_consistent(priv->pdev,
-			    MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc),
+			    MWL8K_TX_DESCS * priv->txd_size,
 			    txq->txd, txq->txd_dma);
 	txq->txd = NULL;
 }
@@ -1440,7 +1454,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	BUG_ON(txq->skb[txq->tail] != NULL);
 	txq->skb[txq->tail] = skb;
 
-	tx = txq->txd + txq->tail;
+	tx = txq->txd + txq->tail * priv->txd_size;
 	tx->data_rate = txdatarate;
 	tx->tx_priority = index;
 	tx->qos_control = cpu_to_le16(qos);
@@ -4038,8 +4052,10 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 				  "Driver does not have AP firmware image support for this hardware\n");
 			goto err_stop_firmware;
 		}
+		priv->txd_size = MWL8K_TX_DESC_SIZE_AP;
 	} else {
 		priv->rxd_ops = &rxd_sta_ops;
+		priv->txd_size = MWL8K_TX_DESC_SIZE_STA;
 	}
 
 	priv->sniffer_enabled = false;
-- 
1.7.1.1

