Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:40334 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760Ab3GWCSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/21] mwifiex: delete AP TX queues when bridged packets reach threshold
Date: Mon, 22 Jul 2013 19:17:41 -0700
Message-ID: <1374545878-15683-5-git-send-email-bzhao@marvell.com> (sfid-20130723_041901_119032_D1B2A87B)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Delete packets from TX queues for this mwifiex_private structure
when bridged packet count reaches maximum threshold. Bridged packets
from each RA List are deleted till they fall to low threshold of 128.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h     |  3 +-
 drivers/net/wireless/mwifiex/init.c     |  1 +
 drivers/net/wireless/mwifiex/main.h     |  1 +
 drivers/net/wireless/mwifiex/uap_txrx.c | 66 ++++++++++++++++++++++++++++++++-
 4 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 94cc09d..a599347 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -75,7 +75,8 @@
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 #define MWIFIEX_BUF_FLAG_BRIDGED_PKT	   BIT(1)
 
-#define MWIFIEX_BRIDGED_PKTS_THRESHOLD     1024
+#define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
+#define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
 
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2cf8b96..09c4b76 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -135,6 +135,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->csa_chan = 0;
 	priv->csa_expire_time = 0;
+	priv->del_list_idx = 0;
 
 	return mwifiex_add_bss_prio_tbl(priv);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a3036d1..bb28d3d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -515,6 +515,7 @@ struct mwifiex_private {
 	bool scan_aborting;
 	u8 csa_chan;
 	unsigned long csa_expire_time;
+	u8 del_list_idx;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 11df2b2..1cfe5a7 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -24,6 +24,69 @@
 #include "11n_aggr.h"
 #include "11n_rxreorder.h"
 
+/* This function checks if particular RA list has packets more than low bridge
+ * packet threshold and then deletes packet from this RA list.
+ * Function deletes packets from such RA list and returns true. If no such list
+ * is found, false is returned.
+ */
+static bool
+mwifiex_uap_del_tx_pkts_in_ralist(struct mwifiex_private *priv,
+				  struct list_head *ra_list_head)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	struct sk_buff *skb, *tmp;
+	bool pkt_deleted = false;
+	struct mwifiex_txinfo *tx_info;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	list_for_each_entry(ra_list, ra_list_head, list) {
+		if (skb_queue_empty(&ra_list->skb_head))
+			continue;
+
+		skb_queue_walk_safe(&ra_list->skb_head, skb, tmp) {
+			tx_info = MWIFIEX_SKB_TXCB(skb);
+			if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT) {
+				__skb_unlink(skb, &ra_list->skb_head);
+				mwifiex_write_data_complete(adapter, skb, 0,
+							    -1);
+				atomic_dec(&priv->wmm.tx_pkts_queued);
+				pkt_deleted = true;
+			}
+			if ((atomic_read(&adapter->pending_bridged_pkts) <=
+					     MWIFIEX_BRIDGED_PKTS_THR_LOW))
+				break;
+		}
+	}
+
+	return pkt_deleted;
+}
+
+/* This function deletes packets from particular RA List. RA list index
+ * from which packets are deleted is preserved so that packets from next RA
+ * list are deleted upon subsequent call thus maintaining fairness.
+ */
+static void mwifiex_uap_cleanup_tx_queues(struct mwifiex_private *priv)
+{
+	unsigned long flags;
+	struct list_head *ra_list;
+	int i;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	for (i = 0; i < MAX_NUM_TID; i++, priv->del_list_idx++) {
+		if (priv->del_list_idx == MAX_NUM_TID)
+			priv->del_list_idx = 0;
+		ra_list = &priv->wmm.tid_tbl_ptr[priv->del_list_idx].ra_list;
+		if (mwifiex_uap_del_tx_pkts_in_ralist(priv, ra_list)) {
+			priv->del_list_idx++;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
+
 static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 					 struct sk_buff *skb)
 {
@@ -40,10 +103,11 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
 
 	if ((atomic_read(&adapter->pending_bridged_pkts) >=
-					     MWIFIEX_BRIDGED_PKTS_THRESHOLD)) {
+					     MWIFIEX_BRIDGED_PKTS_THR_HIGH)) {
 		dev_err(priv->adapter->dev,
 			"Tx: Bridge packet limit reached. Drop packet!\n");
 		kfree_skb(skb);
+		mwifiex_uap_cleanup_tx_queues(priv);
 		return;
 	}
 
-- 
1.8.2.3

