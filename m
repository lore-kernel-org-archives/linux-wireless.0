Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51480 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1EQCNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 22:13:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: reduce CPU usage by tracking tx_pkts_queued
Date: Mon, 16 May 2011 19:17:49 -0700
Message-Id: <1305598673-26606-2-git-send-email-bzhao@marvell.com> (sfid-20110517_041324_511611_29464923)
In-Reply-To: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
References: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

This patch adds tx_pkts_queued to track number of packets being
enqueued & dequeued so that mwifiex_wmm_lists_empty() evaluation
is lightweight.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    4 ++++
 drivers/net/wireless/mwifiex/main.h     |    3 ++-
 drivers/net/wireless/mwifiex/wmm.c      |   22 +++++++++++++---------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index d3d5e08..f807447 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -196,6 +196,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		if (skb_src)
 			pra_list->total_pkts_size -= skb_src->len;
 
+		atomic_dec(&priv->wmm.tx_pkts_queued);
+
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		mwifiex_11n_form_amsdu_pkt(skb_aggr, skb_src, &pad);
@@ -257,6 +259,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		pra_list->total_pkts_size += skb_aggr->len;
 
+		atomic_inc(&priv->wmm.tx_pkts_queued);
+
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 672701d..537b40d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -213,7 +213,8 @@ struct mwifiex_wmm_desc {
 	u32 drv_pkt_delay_max;
 	u8 queue_priority[IEEE80211_MAX_QUEUES];
 	u32 user_pri_pkt_tx_ctrl[WMM_HIGHEST_PRIORITY + 1];	/* UP: 0 to 7 */
-
+	/* Number of transmit packets queued */
+	atomic_t tx_pkts_queued;
 };
 
 struct mwifiex_802_11_security {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index faa09e3..52d2185 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -399,6 +399,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
 		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
 		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
+
+		atomic_set(&priv->wmm.tx_pkts_queued, 0);
 	}
 }
 
@@ -408,17 +410,13 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 int
 mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 {
-	int i, j;
+	int i;
 	struct mwifiex_private *priv;
 
-	for (j = 0; j < adapter->priv_num; ++j) {
-		priv = adapter->priv[j];
-		if (priv) {
-			for (i = 0; i < MAX_NUM_TID; i++)
-				if (!mwifiex_wmm_is_ra_list_empty(
-					     &priv->wmm.tid_tbl_ptr[i].ra_list))
-					return false;
-		}
+	for (i = 0; i < adapter->priv_num; ++i) {
+		priv = adapter->priv[i];
+		if (priv && atomic_read(&priv->wmm.tx_pkts_queued))
+				return false;
 	}
 
 	return true;
@@ -468,6 +466,8 @@ static void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 	for (i = 0; i < MAX_NUM_TID; i++)
 		mwifiex_wmm_del_pkts_in_ralist(priv, &priv->wmm.tid_tbl_ptr[i].
 						     ra_list);
+
+	atomic_set(&priv->wmm.tx_pkts_queued, 0);
 }
 
 /*
@@ -638,6 +638,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	ra_list->total_pkts_size += skb->len;
 
+	atomic_inc(&priv->wmm.tx_pkts_queued);
+
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
@@ -1028,6 +1030,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 				.bss_prio_cur->list,
 				struct mwifiex_bss_prio_node,
 				list);
+		atomic_dec(&priv->wmm.tx_pkts_queued);
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	}
@@ -1134,6 +1137,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 				.bss_prio_cur->list,
 				struct mwifiex_bss_prio_node,
 				list);
+		atomic_dec(&priv->wmm.tx_pkts_queued);
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	}
-- 
1.7.0.2

