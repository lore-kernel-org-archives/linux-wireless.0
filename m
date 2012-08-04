Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog028.obsmtp.com ([74.125.150.102]:57022 "EHLO
	na6sys009bog028.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2HDBTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:19:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/16] mwifiex: support RX AMSDU aggregation for uAP
Date: Fri,  3 Aug 2012 18:06:09 -0700
Message-Id: <1344042374-6892-12-git-send-email-bzhao@marvell.com> (sfid-20120804_031955_293755_805B2854)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for reception and decoding of AMSDU
aggregation frames for AP interface.
Patch also adds support for handling AMSDU aggregation event.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   26 +++++++++---
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    2 +
 drivers/net/wireless/mwifiex/uap_event.c     |   13 ++++++
 drivers/net/wireless/mwifiex/uap_txrx.c      |   56 ++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 591ccd3..20367fe 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -54,8 +54,13 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
 			tbl->rx_reorder_ptr[i] = NULL;
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		if (rx_tmp_ptr)
-			mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
+		if (rx_tmp_ptr) {
+			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+				mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
+			else
+				mwifiex_process_rx_packet(priv->adapter,
+							  rx_tmp_ptr);
+		}
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -97,7 +102,11 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
+
+		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+			mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
+		else
+			mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -148,7 +157,7 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
  * This function returns the pointer to an entry in Rx reordering
  * table which matches the given TA/TID pair.
  */
-static struct mwifiex_rx_reorder_tbl *
+struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 {
 	struct mwifiex_rx_reorder_tbl *tbl;
@@ -396,8 +405,13 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
-		if (pkt_type != PKT_TYPE_BAR)
-			mwifiex_process_rx_packet(priv->adapter, payload);
+		if (pkt_type != PKT_TYPE_BAR) {
+			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+				mwifiex_handle_uap_rx_forward(priv, payload);
+			else
+				mwifiex_process_rx_packet(priv->adapter,
+							  payload);
+		}
 		return 0;
 	}
 	start_win = tbl->start_win;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 6c9815a..1cd51d8 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -68,5 +68,7 @@ struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
 							   mwifiex_private
 							   *priv, int tid,
 							   u8 *ta);
+struct mwifiex_rx_reorder_tbl *
+mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta);
 
 #endif /* _MWIFIEX_11N_RXREORDER_H_ */
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 37cc642..6270c80 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -242,6 +242,19 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		/* For future development */
 		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
 		break;
+	case EVENT_AMSDU_AGGR_CTRL:
+		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
+			*(u16 *)adapter->event_body);
+
+		if (priv->media_connected) {
+			adapter->tx_buf_size =
+			       min(adapter->curr_tx_buf_size,
+				   le16_to_cpu(*(__le16 *)adapter->event_body));
+
+			dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
+				adapter->tx_buf_size);
+		}
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index f55c5ac..6d814f0 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -21,6 +21,8 @@
 #include "ioctl.h"
 #include "main.h"
 #include "wmm.h"
+#include "11n_aggr.h"
+#include "11n_rxreorder.h"
 
 static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 					 struct sk_buff *skb)
@@ -165,6 +167,9 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u16 rx_pkt_type;
+	u8 ta[ETH_ALEN], pkt_type;
+	struct mwifiex_sta_node *node;
+
 	struct mwifiex_private *priv =
 			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
 					       rx_info->bss_type);
@@ -191,15 +196,60 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 
 		return 0;
 	}
-	ret = mwifiex_handle_uap_rx_forward(priv, skb);
 
-	if (ret) {
-		priv->stats.rx_dropped++;
+	if (le16_to_cpu(uap_rx_pd->rx_pkt_type) == PKT_TYPE_AMSDU) {
+		struct sk_buff_head list;
+		struct sk_buff *rx_skb;
+
+		__skb_queue_head_init(&list);
+		skb_pull(skb, le16_to_cpu(uap_rx_pd->rx_pkt_offset));
+		skb_trim(skb, le16_to_cpu(uap_rx_pd->rx_pkt_length));
+
+		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
+					 priv->wdev->iftype, 0, false);
+
+		while (!skb_queue_empty(&list)) {
+			rx_skb = __skb_dequeue(&list);
+			ret = mwifiex_recv_packet(adapter, rx_skb);
+			if (ret)
+				dev_err(adapter->dev,
+					"AP:Rx A-MSDU failed");
+		}
+
+		return 0;
+	}
+
+	memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
+
+	if (rx_pkt_type != PKT_TYPE_BAR && uap_rx_pd->priority < MAX_NUM_TID) {
+		node = mwifiex_get_sta_entry(priv, ta);
+		if (node)
+			node->rx_seq[uap_rx_pd->priority] =
+						le16_to_cpu(uap_rx_pd->seq_num);
+	}
+
+	if (!priv->ap_11n_enabled ||
+	    (!mwifiex_11n_get_rx_reorder_tbl(priv, uap_rx_pd->priority, ta) &&
+	    (le16_to_cpu(uap_rx_pd->rx_pkt_type) != PKT_TYPE_AMSDU))) {
+		ret = mwifiex_handle_uap_rx_forward(priv, skb);
+		return ret;
+	}
+
+	/* Reorder and send to kernel */
+	pkt_type = (u8)le16_to_cpu(uap_rx_pd->rx_pkt_type);
+	ret = mwifiex_11n_rx_reorder_pkt(priv, le16_to_cpu(uap_rx_pd->seq_num),
+					 uap_rx_pd->priority, ta, pkt_type,
+					 skb);
+
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
 		if (adapter->if_ops.data_complete)
 			adapter->if_ops.data_complete(adapter, skb);
 		else
 			dev_kfree_skb_any(skb);
 	}
 
+	if (ret)
+		priv->stats.rx_dropped++;
+
 	return ret;
 }
-- 
1.7.0.2

