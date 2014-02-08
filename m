Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44709 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbaBHA1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:54 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 14/30] mwifiex: make tos_to_tid_inv part of mwifiex_private structure
Date: Fri, 7 Feb 2014 16:27:29 -0800
Message-ID: <1391819254-21130-4-git-send-email-bzhao@marvell.com> (sfid-20140208_012757_376595_151CE931)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

tos_to_tid_inv values are needed even during TDLS restore
operations. Currently tos_to_tid_inv is part of wmm.c and
is declared static.
Make it part of private structure so that it can be used in
other files as well.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |  1 +
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/wmm.c  | 34 +++++++++++-----------------------
 drivers/net/wireless/mwifiex/wmm.h  | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 308c56f..dead659 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -137,6 +137,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->csa_expire_time = 0;
 	priv->del_list_idx = 0;
 	priv->hs2_enabled = false;
+	memcpy(priv->tos_to_tid_inv, tos_to_tid_inv, MAX_NUM_TID);
 
 	return mwifiex_add_bss_prio_tbl(priv);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1076c3f..58855af 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -461,6 +461,7 @@ struct mwifiex_private {
 	struct mwifiex_tx_aggr aggr_prio_tbl[MAX_NUM_TID];
 	struct mwifiex_add_ba_param add_ba_param;
 	u16 rx_seq[MAX_NUM_TID];
+	u8 tos_to_tid_inv[MAX_NUM_TID];
 	struct list_head rx_reorder_tbl_ptr;
 	/* spin lock for rx_reorder_tbl_ptr queue */
 	spinlock_t rx_reorder_tbl_lock;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index ee44789..2999c3b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -64,21 +64,6 @@ static u8 tos_to_tid[] = {
 	0x07			/* 1 1 1 AC_VO */
 };
 
-/*
- * This table inverses the tos_to_tid operation to get a priority
- * which is in sequential order, and can be compared.
- * Use this to compare the priority of two different TIDs.
- */
-static u8 tos_to_tid_inv[] = {
-	0x02,  /* from tos_to_tid[2] = 0 */
-	0x00,  /* from tos_to_tid[0] = 1 */
-	0x01,  /* from tos_to_tid[1] = 2 */
-	0x03,
-	0x04,
-	0x05,
-	0x06,
-	0x07};
-
 static u8 ac_to_tid[4][2] = { {1, 2}, {0, 3}, {4, 5}, {6, 7} };
 
 /*
@@ -213,8 +198,9 @@ static void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
  * This function map ACs to TIDs.
  */
 static void
-mwifiex_wmm_queue_priorities_tid(struct mwifiex_wmm_desc *wmm)
+mwifiex_wmm_queue_priorities_tid(struct mwifiex_private *priv)
 {
+	struct mwifiex_wmm_desc *wmm = &priv->wmm;
 	u8 *queue_priority = wmm->queue_priority;
 	int i;
 
@@ -224,7 +210,7 @@ mwifiex_wmm_queue_priorities_tid(struct mwifiex_wmm_desc *wmm)
 	}
 
 	for (i = 0; i < MAX_NUM_TID; ++i)
-		tos_to_tid_inv[tos_to_tid[i]] = (u8)i;
+		priv->tos_to_tid_inv[tos_to_tid[i]] = (u8)i;
 
 	atomic_set(&wmm->highest_queued_prio, HIGH_PRIO_TID);
 }
@@ -285,7 +271,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		}
 	}
 
-	mwifiex_wmm_queue_priorities_tid(&priv->wmm);
+	mwifiex_wmm_queue_priorities_tid(priv);
 }
 
 /*
@@ -421,9 +407,11 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 			continue;
 
 		for (i = 0; i < MAX_NUM_TID; ++i) {
-			priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
-			priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
-			priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].amsdu = priv->tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_ap =
+							priv->tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_user =
+							priv->tos_to_tid_inv[i];
 		}
 
 		priv->aggr_prio_tbl[6].amsdu
@@ -683,9 +671,9 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	ra_list->total_pkt_count++;
 
 	if (atomic_read(&priv->wmm.highest_queued_prio) <
-						tos_to_tid_inv[tid_down])
+						priv->tos_to_tid_inv[tid_down])
 		atomic_set(&priv->wmm.highest_queued_prio,
-			   tos_to_tid_inv[tid_down]);
+			   priv->tos_to_tid_inv[tid_down]);
 
 	atomic_inc(&priv->wmm.tx_pkts_queued);
 
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 0f129d4..d4e6073 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -34,6 +34,21 @@ enum ieee_types_wmm_ecw_bitmasks {
 static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
 /*
+ * This table inverses the tos_to_tid operation to get a priority
+ * which is in sequential order, and can be compared.
+ * Use this to compare the priority of two different TIDs.
+ */
+static const u8 tos_to_tid_inv[] = {
+	0x02,  /* from tos_to_tid[2] = 0 */
+	0x00,  /* from tos_to_tid[0] = 1 */
+	0x01,  /* from tos_to_tid[1] = 2 */
+	0x03,
+	0x04,
+	0x05,
+	0x06,
+	0x07};
+
+/*
  * This function retrieves the TID of the given RA list.
  */
 static inline int
-- 
1.8.2.3

