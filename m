Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:51363 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301Ab2IKBca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:32:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/10] mwifiex: separate TxPD processing routine for AP
Date: Mon, 10 Sep 2012 18:30:49 -0700
Message-Id: <1347327049-13665-11-git-send-email-bzhao@marvell.com> (sfid-20120911_033234_384189_7AFDFE4C)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds separate tx packet descriptor routine for AP
interface. This function fills bss_type, bss_num, wmm packet
delay information etc for TxPD going on AP interface.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/txrx.c     |    6 ++-
 drivers/net/wireless/mwifiex/uap_txrx.c |   70 +++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index bb75390..12ceea4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -812,6 +812,7 @@ struct mwifiex_sta_node *
 mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
 void mwifiex_delete_all_station_list(struct mwifiex_private *priv);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
+void *mwifiex_process_uap_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
 			    struct mwifiex_scan_cmd_config *scan_cfg);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 985073d..2af2639 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -75,7 +75,11 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	u8 *head_ptr;
 	struct txpd *local_tx_pd = NULL;
 
-	head_ptr = mwifiex_process_sta_txpd(priv, skb);
+	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+		head_ptr = mwifiex_process_uap_txpd(priv, skb);
+	else
+		head_ptr = mwifiex_process_sta_txpd(priv, skb);
+
 	if (head_ptr) {
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			local_tx_pd =
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 6d814f0..df17d08 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -253,3 +253,73 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 
 	return ret;
 }
+
+/*
+ * This function fills the TxPD for AP tx packets.
+ *
+ * The Tx buffer received by this function should already have the
+ * header space allocated for TxPD.
+ *
+ * This function inserts the TxPD in between interface header and actual
+ * data and adjusts the buffer pointers accordingly.
+ *
+ * The following TxPD fields are set by this function, as required -
+ *      - BSS number
+ *      - Tx packet length and offset
+ *      - Priority
+ *      - Packet delay
+ *      - Priority specific Tx control
+ *      - Flags
+ */
+void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
+			       struct sk_buff *skb)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct uap_txpd *txpd;
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+	int pad, len;
+
+	if (!skb->len) {
+		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
+		tx_info->status_code = -1;
+		return skb->data;
+	}
+
+	/* If skb->data is not aligned, add padding */
+	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
+
+	len = sizeof(*txpd) + pad;
+
+	BUG_ON(skb_headroom(skb) < len + INTF_HEADER_LEN);
+
+	skb_push(skb, len);
+
+	txpd = (struct uap_txpd *)skb->data;
+	memset(txpd, 0, sizeof(*txpd));
+	txpd->bss_num = priv->bss_num;
+	txpd->bss_type = priv->bss_type;
+	txpd->tx_pkt_length = cpu_to_le16((u16)(skb->len - len));
+
+	txpd->priority = (u8)skb->priority;
+	txpd->pkt_delay_2ms = mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
+
+	if (txpd->priority < ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
+		/*
+		 * Set the priority specific tx_control field, setting of 0 will
+		 * cause the default value to be used later in this function.
+		 */
+		txpd->tx_control =
+		    cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[txpd->priority]);
+
+	/* Offset of actual data */
+	txpd->tx_pkt_offset = cpu_to_le16(len);
+
+	/* make space for INTF_HEADER_LEN */
+	skb_push(skb, INTF_HEADER_LEN);
+
+	if (!txpd->tx_control)
+		/* TxCtrl set by user or default */
+		txpd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
+
+	return skb->data;
+}
-- 
1.7.0.2

