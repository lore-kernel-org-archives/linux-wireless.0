Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:41949 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751642Ab2ALEG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 23:06:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: use bss_type and bss_num to retrieve priv
Date: Wed, 11 Jan 2012 20:06:11 -0800
Message-Id: <1326341172-8034-1-git-send-email-bzhao@marvell.com> (sfid-20120112_050636_008005_DBA0B63B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Current implementation, for retrieving priv from adapter,
uses bss_index. In multi interface environment supporting
different types, bss_index may not be unique.

Use bss_type along with bss_num to retrieve the priv.
bss_index is removed with this change.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    3 ++-
 drivers/net/wireless/mwifiex/cfg80211.c |    1 -
 drivers/net/wireless/mwifiex/cmdevt.c   |    3 ++-
 drivers/net/wireless/mwifiex/decl.h     |    6 ++++--
 drivers/net/wireless/mwifiex/init.c     |    5 +++--
 drivers/net/wireless/mwifiex/main.c     |   23 ++++++-----------------
 drivers/net/wireless/mwifiex/main.h     |    3 ---
 drivers/net/wireless/mwifiex/sta_rx.c   |    6 ++++--
 drivers/net/wireless/mwifiex/sta_tx.c   |    3 ++-
 drivers/net/wireless/mwifiex/txrx.c     |    6 ++++--
 drivers/net/wireless/mwifiex/util.c     |    3 ++-
 drivers/net/wireless/mwifiex/wmm.c      |    3 ++-
 12 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 079e553..ea6832d 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -182,7 +182,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
 	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
 
-	tx_info_aggr->bss_index = tx_info_src->bss_index;
+	tx_info_aggr->bss_type = tx_info_src->bss_type;
+	tx_info_aggr->bss_num = tx_info_src->bss_num;
 	skb_aggr->priority = skb_src->priority;
 
 	do {
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c3b6c46..36f67da 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1217,7 +1217,6 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
 		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
-		priv->bss_index = 0;
 		priv->bss_num = 0;
 
 		break;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6e0a3ea..6623db6 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -391,7 +391,8 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	if (skb) {
 		rx_info = MWIFIEX_SKB_RXCB(skb);
-		rx_info->bss_index = priv->bss_index;
+		rx_info->bss_num = priv->bss_num;
+		rx_info->bss_type = priv->bss_type;
 	}
 
 	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index ae17ce0..3735c77 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -102,7 +102,8 @@ struct mwifiex_wait_queue {
 };
 
 struct mwifiex_rxinfo {
-	u8 bss_index;
+	u8 bss_num;
+	u8 bss_type;
 	struct sk_buff *parent;
 	u8 use_count;
 };
@@ -110,7 +111,8 @@ struct mwifiex_rxinfo {
 struct mwifiex_txinfo {
 	u32 status_code;
 	u8 flags;
-	u8 bss_index;
+	u8 bss_num;
+	u8 bss_type;
 };
 
 enum mwifiex_wmm_ac_e {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e05b417..e13b6d9 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -526,8 +526,9 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
 		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
 		dev_dbg(adapter->dev, "info: delete BSS priority table,"
-				" index = %d, i = %d, head = %p, cur = %p\n",
-			      priv->bss_index, i, head, *cur);
+				" bss_type = %d, bss_num = %d, i = %d,"
+				" head = %p, cur = %p\n",
+			      priv->bss_type, priv->bss_num, i, head, *cur);
 		if (*cur) {
 			spin_lock_irqsave(lock, flags);
 			if (list_empty(head)) {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 84be196..1a0775d 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -424,8 +424,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
 
-	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d): Data <= kernel\n",
-				jiffies, priv->bss_index);
+	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
+				jiffies, priv->bss_type, priv->bss_num);
 
 	if (priv->adapter->surprise_removed) {
 		kfree_skb(skb);
@@ -458,7 +458,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
-	tx_info->bss_index = priv->bss_index;
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
 	mwifiex_fill_buffer(skb);
 
 	mwifiex_wmm_add_buf_txqueue(priv->adapter, skb);
@@ -531,8 +532,8 @@ mwifiex_tx_timeout(struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_index=%d\n",
-				jiffies, priv->bss_index);
+	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_type-num = %d-%d\n",
+				jiffies, priv->bss_type, priv->bss_num);
 	mwifiex_set_trans_start(dev);
 	priv->num_tx_timeout++;
 }
@@ -605,18 +606,6 @@ int is_command_pending(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function returns the correct private structure pointer based
- * upon the BSS number.
- */
-struct mwifiex_private *
-mwifiex_bss_index_to_priv(struct mwifiex_adapter *adapter, u8 bss_index)
-{
-	if (!adapter || (bss_index >= adapter->priv_num))
-		return NULL;
-	return adapter->priv[bss_index];
-}
-
-/*
  * This is the main work queue function.
  *
  * It handles the main process, which in turn handles the complete
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3186aa4..6712ea8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -352,7 +352,6 @@ struct mwifiex_private;
 
 struct mwifiex_private {
 	struct mwifiex_adapter *adapter;
-	u8 bss_index;
 	u8 bss_type;
 	u8 bss_role;
 	u8 bss_priority;
@@ -884,8 +883,6 @@ mwifiex_netdev_get_priv(struct net_device *dev)
 	return (struct mwifiex_private *) (*(unsigned long *) netdev_priv(dev));
 }
 
-struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
-						*adapter, u8 bss_index);
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 5e1ef7e..d7a5d76 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -43,7 +43,8 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 {
 	int ret;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
+	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
+			rx_info->bss_num, rx_info->bss_type);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
@@ -124,7 +125,8 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
 	u16 rx_pkt_type;
-	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
+	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
+			rx_info->bss_num, rx_info->bss_type);
 
 	if (!priv)
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index d97facd..94d31a9 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -136,7 +136,8 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		return -1;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
-	tx_info->bss_index = priv->bss_index;
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
 	skb_reserve(skb, sizeof(struct txpd) + INTF_HEADER_LEN);
 	skb_push(skb, sizeof(struct txpd));
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index d9274a1..9a6eacc 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -48,7 +48,8 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-	rx_info->bss_index = priv->bss_index;
+	rx_info->bss_num = priv->bss_num;
+	rx_info->bss_type = priv->bss_type;
 
 	return mwifiex_process_sta_rx_packet(adapter, skb);
 }
@@ -130,7 +131,8 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		return 0;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
-	priv = mwifiex_bss_index_to_priv(adapter, tx_info->bss_index);
+	priv = mwifiex_get_priv_by_id(adapter, tx_info->bss_num,
+			tx_info->bss_type);
 	if (!priv)
 		goto done;
 
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 06976f5..9c48f37 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -159,7 +159,8 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -1;
 
 	rx_info = MWIFIEX_SKB_RXCB(skb);
-	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
+	priv = mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
+			rx_info->bss_type);
 	if (!priv)
 		return -1;
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6c239c3..e6a2cb1 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -603,7 +603,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 			    struct sk_buff *skb)
 {
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
-	struct mwifiex_private *priv = adapter->priv[tx_info->bss_index];
+	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
+			tx_info->bss_num, tx_info->bss_type);
 	u32 tid;
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 ra[ETH_ALEN], tid_down;
-- 
1.7.0.2

