Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51479 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1EQCNO (ORCPT
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
Subject: [PATCH 2/5] mwifiex: reduce CPU usage by tracking highest_queued_prio
Date: Mon, 16 May 2011 19:17:50 -0700
Message-Id: <1305598673-26606-3-git-send-email-bzhao@marvell.com> (sfid-20110517_041320_199810_75FE1B58)
In-Reply-To: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
References: <1305598673-26606-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

This patch adds highest_queued_prio to track priority of packets as
they are enqueued so that mwifiex_wmm_get_highest_priolist_ptr()
starts checking at the first level where we have packets, instead of
the highest. The function also lowers priority value to the level
where first packet is found.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |    2 ++
 drivers/net/wireless/mwifiex/wmm.c  |   29 ++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 537b40d..ea3184d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -215,6 +215,8 @@ struct mwifiex_wmm_desc {
 	u32 user_pri_pkt_tx_ctrl[WMM_HIGHEST_PRIORITY + 1];	/* UP: 0 to 7 */
 	/* Number of transmit packets queued */
 	atomic_t tx_pkts_queued;
+	/* Tracks highest priority with a packet queued */
+	atomic_t highest_queued_prio;
 };
 
 struct mwifiex_802_11_security {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 52d2185..f3d5f23 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -177,14 +177,20 @@ static void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
  * This function map ACs to TIDs.
  */
 static void
-mwifiex_wmm_queue_priorities_tid(u8 queue_priority[])
+mwifiex_wmm_queue_priorities_tid(struct mwifiex_wmm_desc *wmm)
 {
+	u8 *queue_priority = wmm->queue_priority;
 	int i;
 
 	for (i = 0; i < 4; ++i) {
 		tos_to_tid[7 - (i * 2)] = ac_to_tid[queue_priority[i]][1];
 		tos_to_tid[6 - (i * 2)] = ac_to_tid[queue_priority[i]][0];
 	}
+
+	for (i = 0; i < MAX_NUM_TID; ++i)
+		tos_to_tid_inv[tos_to_tid[i]] = (u8)i;
+
+	atomic_set(&wmm->highest_queued_prio, HIGH_PRIO_TID);
 }
 
 /*
@@ -246,7 +252,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		}
 	}
 
-	mwifiex_wmm_queue_priorities_tid(priv->wmm.queue_priority);
+	mwifiex_wmm_queue_priorities_tid(&priv->wmm);
 }
 
 /*
@@ -401,6 +407,7 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
 
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
+		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 	}
 }
 
@@ -468,6 +475,7 @@ static void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 						     ra_list);
 
 	atomic_set(&priv->wmm.tx_pkts_queued, 0);
+	atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 }
 
 /*
@@ -640,6 +648,11 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	atomic_inc(&priv->wmm.tx_pkts_queued);
 
+	if (atomic_read(&priv->wmm.highest_queued_prio) <
+						tos_to_tid_inv[tid_down])
+		atomic_set(&priv->wmm.highest_queued_prio,
+						tos_to_tid_inv[tid_down]);
+
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
@@ -865,9 +878,14 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 		}
 
 		do {
+			atomic_t *hqp;
+			spinlock_t *lock;
+
 			priv_tmp = bssprio_node->priv;
+			hqp = &priv_tmp->wmm.highest_queued_prio;
+			lock = &priv_tmp->wmm.ra_list_spinlock;
 
-			for (i = HIGH_PRIO_TID; i >= LOW_PRIO_TID; --i) {
+			for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
 
 				tid_ptr = &(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
@@ -905,6 +923,11 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 					is_list_empty =
 						skb_queue_empty(&ptr->skb_head);
 					if (!is_list_empty) {
+						spin_lock_irqsave(lock, flags);
+						if (atomic_read(hqp) > i)
+							atomic_set(hqp, i);
+						spin_unlock_irqrestore(lock,
+									flags);
 						*priv = priv_tmp;
 						*tid = tos_to_tid[i];
 						return ptr;
-- 
1.7.0.2

