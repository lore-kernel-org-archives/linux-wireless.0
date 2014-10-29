Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57255 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbaJ2Lo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:44:58 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <crlo@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	<pchen@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: restart rxreorder timer correctly
Date: Wed, 29 Oct 2014 22:44:34 +0530
Message-ID: <1414602874-14733-1-git-send-email-patila@marvell.com> (sfid-20141029_124502_348308_ABD5D1B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

During 11n RX reordering, if there is a hole in RX table,
driver will not send packets to kernel until the rxreorder
timer expires or the table is full.
However, currently driver always restarts rxreorder timer when
receiving a packet, which causes the timer hardly to expire.
So while connected with to 11n AP in a busy environment,
ping packets may get blocked for about 30 seconds.

This patch fixes this timer restarting by ensuring rxreorder timer
would only be restarted either timer is not set or start_win
has changed.

Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
Signed-off-by: Plus Chen <pchen@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 52 +++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/11n_rxreorder.h |  2 ++
 drivers/net/wireless/mwifiex/main.h          |  1 +
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 4005707..5ef5a0e 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -196,6 +196,7 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 	mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, start_win);
 
 	del_timer_sync(&tbl->timer_context.timer);
+	tbl->timer_context.timer_is_set = false;
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_del(&tbl->list);
@@ -297,6 +298,7 @@ mwifiex_flush_data(unsigned long context)
 		(struct reorder_tmr_cnxt *) context;
 	int start_win, seq_num;
 
+	ctx->timer_is_set = false;
 	seq_num = mwifiex_11n_find_last_seq_num(ctx);
 
 	if (seq_num < 0)
@@ -385,6 +387,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 
 	new_node->timer_context.ptr = new_node;
 	new_node->timer_context.priv = priv;
+	new_node->timer_context.timer_is_set = false;
 
 	init_timer(&new_node->timer_context.timer);
 	new_node->timer_context.timer.function = mwifiex_flush_data;
@@ -399,6 +402,22 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 }
 
+static void
+mwifiex_11n_rxreorder_timer_restart(struct mwifiex_rx_reorder_tbl *tbl)
+{
+	u32 min_flush_time;
+
+	if (tbl->win_size >= MWIFIEX_BA_WIN_SIZE_32)
+		min_flush_time = MIN_FLUSH_TIMER_15_MS;
+	else
+		min_flush_time = MIN_FLUSH_TIMER_MS;
+
+	mod_timer(&tbl->timer_context.timer,
+		  jiffies + msecs_to_jiffies(min_flush_time * tbl->win_size));
+
+	tbl->timer_context.timer_is_set = true;
+}
+
 /*
  * This function prepares command for adding a BA request.
  *
@@ -523,31 +542,31 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				u8 *ta, u8 pkt_type, void *payload)
 {
 	struct mwifiex_rx_reorder_tbl *tbl;
-	int start_win, end_win, win_size;
+	int prev_start_win, start_win, end_win, win_size;
 	u16 pkt_index;
 	bool init_window_shift = false;
+	int ret = 0;
 
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
 		if (pkt_type != PKT_TYPE_BAR)
 			mwifiex_11n_dispatch_pkt(priv, payload);
-		return 0;
+		return ret;
 	}
 
 	if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
 		mwifiex_11n_dispatch_pkt(priv, payload);
-		return 0;
+		return ret;
 	}
 
 	start_win = tbl->start_win;
+	prev_start_win = start_win;
 	win_size = tbl->win_size;
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
 	if (tbl->flags & RXREOR_INIT_WINDOW_SHIFT) {
 		init_window_shift = true;
 		tbl->flags &= ~RXREOR_INIT_WINDOW_SHIFT;
 	}
-	mod_timer(&tbl->timer_context.timer,
-		  jiffies + msecs_to_jiffies(MIN_FLUSH_TIMER_MS * win_size));
 
 	if (tbl->flags & RXREOR_FORCE_NO_DROP) {
 		dev_dbg(priv->adapter->dev,
@@ -568,11 +587,14 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {
 			if (seq_num >= ((start_win + TWOPOW11) &
 					(MAX_TID_VALUE - 1)) &&
-			    seq_num < start_win)
-				return -1;
+			    seq_num < start_win) {
+				ret = -1;
+				goto done;
+			}
 		} else if ((seq_num < start_win) ||
-			   (seq_num > (start_win + TWOPOW11))) {
-			return -1;
+			   (seq_num >= (start_win + TWOPOW11))) {
+			ret = -1;
+			goto done;
 		}
 	}
 
@@ -601,8 +623,10 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		else
 			pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
 
-		if (tbl->rx_reorder_ptr[pkt_index])
-			return -1;
+		if (tbl->rx_reorder_ptr[pkt_index]) {
+			ret = -1;
+			goto done;
+		}
 
 		tbl->rx_reorder_ptr[pkt_index] = payload;
 	}
@@ -613,7 +637,11 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	 */
 	mwifiex_11n_scan_and_dispatch(priv, tbl);
 
-	return 0;
+done:
+	if (!tbl->timer_context.timer_is_set ||
+	    prev_start_win != tbl->start_win)
+		mwifiex_11n_rxreorder_timer_restart(tbl);
+	return ret;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 3a87bb0..63ecea8 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -21,6 +21,8 @@
 #define _MWIFIEX_11N_RXREORDER_H_
 
 #define MIN_FLUSH_TIMER_MS		50
+#define MIN_FLUSH_TIMER_15_MS		15
+#define MWIFIEX_BA_WIN_SIZE_32		32
 
 #define PKT_TYPE_BAR 0xE7
 #define MAX_TID_VALUE			(2 << 11)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e263574..f55658d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -592,6 +592,7 @@ struct reorder_tmr_cnxt {
 	struct timer_list timer;
 	struct mwifiex_rx_reorder_tbl *ptr;
 	struct mwifiex_private *priv;
+	u8 timer_is_set;
 };
 
 struct mwifiex_rx_reorder_tbl {
-- 
1.8.1.4

