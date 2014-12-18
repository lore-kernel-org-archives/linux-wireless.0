Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47843 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbaLRG3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:37 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 3/4] mwifiex: make tx packet 64 byte DMA aligned
Date: Thu, 18 Dec 2014 17:28:45 +0530
Message-ID: <1418903926-11859-3-git-send-email-patila@marvell.com> (sfid-20141218_073432_569859_ED05D645)
In-Reply-To: <1418903926-11859-1-git-send-email-patila@marvell.com>
References: <1418903926-11859-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch adds support for DMA alignment of 64 bytes for TX packets.

v2: incorporate review comments from Joe - define pad as unsigned int;
    remove magic numbers from definition of MWIFIEX_MIN_DATA_HEADER_LEN

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 15 ++++++++++++---
 drivers/net/wireless/mwifiex/decl.h     |  9 ++++++---
 drivers/net/wireless/mwifiex/sta_tx.c   | 19 ++++++++++---------
 drivers/net/wireless/mwifiex/uap_txrx.c | 28 +++++++++++++++-------------
 4 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 8720a3d..9b983b5 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -101,6 +101,13 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 {
 	struct txpd *local_tx_pd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+	unsigned int pad;
+	int headroom = (priv->adapter->iface_type ==
+			MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
+
+	pad = ((void *)skb->data - sizeof(*local_tx_pd) -
+		headroom - NULL) & (MWIFIEX_DMA_ALIGN_SZ - 1);
+	skb_push(skb, pad);
 
 	skb_push(skb, sizeof(*local_tx_pd));
 
@@ -114,10 +121,12 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 	/* Always zero as the data is followed by struct txpd */
-	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd) +
+						 pad);
 	local_tx_pd->tx_pkt_type = cpu_to_le16(PKT_TYPE_AMSDU);
 	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
-						 sizeof(*local_tx_pd));
+						 sizeof(*local_tx_pd) -
+						 pad);
 
 	if (tx_info->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
 		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_TDLS_PACKET;
@@ -182,7 +191,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				       ra_list_flags);
 		return -1;
 	}
-	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
+	skb_reserve(skb_aggr, MWIFIEX_MIN_DATA_HEADER_LEN);
 	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
 
 	memset(tx_info_aggr, 0, sizeof(*tx_info_aggr));
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 2269acf..7fe3f1b 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -32,9 +32,12 @@
 
 #define MWIFIEX_MAX_BSS_NUM         (3)
 
-#define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
-					 *   + 4 byte alignment
-					 */
+#define MWIFIEX_DMA_ALIGN_SZ	    64
+#define MAX_TXPD_SZ		    32
+#define INTF_HDR_ALIGN		     4
+
+#define MWIFIEX_MIN_DATA_HEADER_LEN (MWIFIEX_DMA_ALIGN_SZ + INTF_HDR_ALIGN + \
+				     MAX_TXPD_SZ)
 #define MWIFIEX_MGMT_FRAME_HEADER_SIZE	8	/* sizeof(pkt_type)
 						 *   + sizeof(tx_control)
 						 */
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index b896d73..1debe76 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -47,8 +47,10 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct txpd *local_tx_pd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
-	u8 pad;
+	unsigned int pad;
 	u16 pkt_type, pkt_offset;
+	int hroom = (priv->adapter->iface_type == MWIFIEX_USB) ? 0 :
+		       INTF_HEADER_LEN;
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
@@ -56,13 +58,12 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		return skb->data;
 	}
 
-	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
+	BUG_ON(skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN);
 
-	/* If skb->data is not aligned; add padding */
-	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
+	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
 
-	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN
-				    + pad));
+	pad = ((void *)skb->data - (sizeof(*local_tx_pd) + hroom)-
+			 NULL) & (MWIFIEX_DMA_ALIGN_SZ - 1);
 	skb_push(skb, sizeof(*local_tx_pd) + pad);
 
 	local_tx_pd = (struct txpd *) skb->data;
@@ -70,8 +71,8 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 	local_tx_pd->tx_pkt_length = cpu_to_le16((u16)(skb->len -
-						       (sizeof(struct txpd)
-							+ pad)));
+						       (sizeof(struct txpd) +
+							pad)));
 
 	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
@@ -115,7 +116,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	local_tx_pd->tx_pkt_offset = cpu_to_le16(pkt_offset);
 
 	/* make space for INTF_HEADER_LEN */
-	skb_push(skb, INTF_HEADER_LEN);
+	skb_push(skb, hroom);
 
 	if (!local_tx_pd->tx_control)
 		/* TxCtrl set by user or default */
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index be3a203..38ac4d7 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -348,8 +348,10 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct uap_txpd *txpd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
-	int pad, len;
-	u16 pkt_type;
+	int pad;
+	u16 pkt_type, pkt_offset;
+	int hroom = (priv->adapter->iface_type == MWIFIEX_USB) ? 0 :
+		       INTF_HEADER_LEN;
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
@@ -357,22 +359,21 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 		return skb->data;
 	}
 
-	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
-
-	/* If skb->data is not aligned, add padding */
-	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
+	BUG_ON(skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN);
 
-	len = sizeof(*txpd) + pad;
+	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
 
-	BUG_ON(skb_headroom(skb) < len + INTF_HEADER_LEN);
+	pad = ((void *)skb->data - (sizeof(*txpd) + hroom) - NULL) &
+			(MWIFIEX_DMA_ALIGN_SZ - 1);
 
-	skb_push(skb, len);
+	skb_push(skb, sizeof(*txpd) + pad);
 
 	txpd = (struct uap_txpd *)skb->data;
 	memset(txpd, 0, sizeof(*txpd));
 	txpd->bss_num = priv->bss_num;
 	txpd->bss_type = priv->bss_type;
-	txpd->tx_pkt_length = cpu_to_le16((u16)(skb->len - len));
+	txpd->tx_pkt_length = cpu_to_le16((u16)(skb->len - (sizeof(*txpd) +
+						pad)));
 	txpd->priority = (u8)skb->priority;
 
 	txpd->pkt_delay_2ms = mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
@@ -392,16 +393,17 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 		    cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[txpd->priority]);
 
 	/* Offset of actual data */
+	pkt_offset = sizeof(*txpd) + pad;
 	if (pkt_type == PKT_TYPE_MGMT) {
 		/* Set the packet type and add header for management frame */
 		txpd->tx_pkt_type = cpu_to_le16(pkt_type);
-		len += MWIFIEX_MGMT_FRAME_HEADER_SIZE;
+		pkt_offset += MWIFIEX_MGMT_FRAME_HEADER_SIZE;
 	}
 
-	txpd->tx_pkt_offset = cpu_to_le16(len);
+	txpd->tx_pkt_offset = cpu_to_le16(pkt_offset);
 
 	/* make space for INTF_HEADER_LEN */
-	skb_push(skb, INTF_HEADER_LEN);
+	skb_push(skb, hroom);
 
 	if (!txpd->tx_control)
 		/* TxCtrl set by user or default */
-- 
1.8.1.4

