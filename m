Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:51671 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758016Ab2JTCUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 7/7] mwifiex: rx path enhancement to derive priv only once
Date: Fri, 19 Oct 2012 19:19:21 -0700
Message-Id: <1350699561-852-8-git-send-email-bzhao@marvell.com> (sfid-20121020_042038_320370_4038C005)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We derive mwifiex_private structure which is per interface from
received skb's rx_info. Once priv is derived, same priv can be
propagated to other functions instead of callee deriving priv
from rx_info again.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    8 +++-----
 drivers/net/wireless/mwifiex/main.h          |   10 +++++-----
 drivers/net/wireless/mwifiex/sta_rx.c        |   26 ++++++++------------------
 drivers/net/wireless/mwifiex/txrx.c          |   10 ++++++++--
 drivers/net/wireless/mwifiex/uap_txrx.c      |   17 +++++------------
 drivers/net/wireless/mwifiex/util.c          |   19 +++----------------
 6 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 9402b93..4a97acd 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -58,8 +58,7 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
 			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 				mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
 			else
-				mwifiex_process_rx_packet(priv->adapter,
-							  rx_tmp_ptr);
+				mwifiex_process_rx_packet(priv, rx_tmp_ptr);
 		}
 	}
 
@@ -106,7 +105,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 			mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
 		else
-			mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
+			mwifiex_process_rx_packet(priv, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -442,8 +441,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 				mwifiex_handle_uap_rx_forward(priv, payload);
 			else
-				mwifiex_process_rx_packet(priv->adapter,
-							  payload);
+				mwifiex_process_rx_packet(priv, payload);
 		}
 		return 0;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 4ed46b6..81f8772 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -747,9 +747,9 @@ int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter);
 
 int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
 
-int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
+int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb);
 
-int mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 				struct sk_buff *skb);
 
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
@@ -806,7 +806,7 @@ void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
 int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 			      struct sk_buff *skb);
 int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
 			    u16 cmd_action, u32 cmd_oid,
@@ -816,9 +816,9 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 			    void *data_buf, void *cmd_buf);
 int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
 				struct host_cmd_ds_command *resp);
-int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
+int mwifiex_process_sta_rx_packet(struct mwifiex_private *,
 				  struct sk_buff *skb);
-int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 				  struct sk_buff *skb);
 int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
 				  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 07d32b7..b5c1095 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -38,14 +38,10 @@
  *
  * The completion callback is called after processing in complete.
  */
-int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 			      struct sk_buff *skb)
 {
 	int ret;
-	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct mwifiex_private *priv =
-			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
-					       rx_info->bss_type);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
@@ -98,9 +94,9 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
 
-	ret = mwifiex_recv_packet(adapter, skb);
+	ret = mwifiex_recv_packet(priv, skb);
 	if (ret == -1)
-		dev_err(adapter->dev, "recv packet failed\n");
+		dev_err(priv->adapter->dev, "recv packet failed\n");
 
 	return ret;
 }
@@ -117,21 +113,15 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
  *
  * The completion callback is called after processing in complete.
  */
-int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 				  struct sk_buff *skb)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct rxpd *local_rx_pd;
-	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
 	u16 rx_pkt_type, rx_pkt_offset, rx_pkt_length, seq_num;
-	struct mwifiex_private *priv =
-			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
-					       rx_info->bss_type);
-
-	if (!priv)
-		return -1;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = le16_to_cpu(local_rx_pd->rx_pkt_type);
@@ -169,13 +159,13 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 
 		while (!skb_queue_empty(&list)) {
 			rx_skb = __skb_dequeue(&list);
-			ret = mwifiex_recv_packet(adapter, rx_skb);
+			ret = mwifiex_recv_packet(priv, rx_skb);
 			if (ret == -1)
 				dev_err(adapter->dev, "Rx of A-MSDU failed");
 		}
 		return 0;
 	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
-		ret = mwifiex_process_mgmt_packet(adapter, skb);
+		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
 			dev_err(adapter->dev, "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
@@ -188,7 +178,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	 */
 	if (!IS_11N_ENABLED(priv) ||
 	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
-		mwifiex_process_rx_packet(adapter, skb);
+		mwifiex_process_rx_packet(priv, skb);
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 2af2639..5cb3f7a 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -48,13 +48,19 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
+	if (!priv) {
+		dev_err(adapter->dev, "data: priv not found. Drop RX packet\n");
+		dev_kfree_skb_any(skb);
+		return -1;
+	}
+
 	rx_info->bss_num = priv->bss_num;
 	rx_info->bss_type = priv->bss_type;
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
-		return mwifiex_process_uap_rx_packet(adapter, skb);
+		return mwifiex_process_uap_rx_packet(priv, skb);
 
-	return mwifiex_process_sta_rx_packet(adapter, skb);
+	return mwifiex_process_sta_rx_packet(priv, skb);
 }
 EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
 
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 0966ac2..a018e42 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -146,7 +146,7 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
 	}
 
 	/* Forward unicat/Inter-BSS packets to kernel. */
-	return mwifiex_process_rx_packet(adapter, skb);
+	return mwifiex_process_rx_packet(priv, skb);
 }
 
 /*
@@ -159,24 +159,17 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
  *
  * The completion callback is called after processing is complete.
  */
-int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
+int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 				  struct sk_buff *skb)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
 	struct uap_rxpd *uap_rx_pd;
-	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u16 rx_pkt_type;
 	u8 ta[ETH_ALEN], pkt_type;
 	struct mwifiex_sta_node *node;
 
-	struct mwifiex_private *priv =
-			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
-					       rx_info->bss_type);
-
-	if (!priv)
-		return -1;
-
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
 	rx_pkt_type = le16_to_cpu(uap_rx_pd->rx_pkt_type);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
@@ -210,7 +203,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 
 		while (!skb_queue_empty(&list)) {
 			rx_skb = __skb_dequeue(&list);
-			ret = mwifiex_recv_packet(adapter, rx_skb);
+			ret = mwifiex_recv_packet(priv, rx_skb);
 			if (ret)
 				dev_err(adapter->dev,
 					"AP:Rx A-MSDU failed");
@@ -218,7 +211,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 
 		return 0;
 	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
-		ret = mwifiex_process_mgmt_packet(adapter, skb);
+		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
 			dev_err(adapter->dev, "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index ae88f80..0982375 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -146,20 +146,16 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
  * to the kernel.
  */
 int
-mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
+mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 			    struct sk_buff *skb)
 {
 	struct rxpd *rx_pd;
-	struct mwifiex_private *priv;
 	u16 pkt_len;
 
 	if (!skb)
 		return -1;
 
 	rx_pd = (struct rxpd *)skb->data;
-	priv = mwifiex_get_priv_by_id(adapter, rx_pd->bss_num, rx_pd->bss_type);
-	if (!priv)
-		return -1;
 
 	skb_pull(skb, le16_to_cpu(rx_pd->rx_pkt_offset));
 	skb_pull(skb, sizeof(pkt_len));
@@ -190,20 +186,11 @@ mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
  * the function creates a blank SKB, fills it with the data from the
  * received buffer and then sends this new SKB to the kernel.
  */
-int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 {
-	struct mwifiex_rxinfo *rx_info;
-	struct mwifiex_private *priv;
-
 	if (!skb)
 		return -1;
 
-	rx_info = MWIFIEX_SKB_RXCB(skb);
-	priv = mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
-				      rx_info->bss_type);
-	if (!priv)
-		return -1;
-
 	skb->dev = priv->netdev;
 	skb->protocol = eth_type_trans(skb, priv->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
@@ -225,7 +212,7 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	 * fragments. Currently we fail the Filesndl-ht.scr script
 	 * for UDP, hence this fix
 	 */
-	if ((adapter->iface_type == MWIFIEX_USB) &&
+	if ((priv->adapter->iface_type == MWIFIEX_USB) &&
 	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
 		skb->truesize += (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
 
-- 
1.7.0.2

