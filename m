Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:52839 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab2I1CBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 22:01:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: enhance RX reordering to avoid packet drop during host sleep
Date: Thu, 27 Sep 2012 19:00:10 -0700
Message-Id: <1348797610-16623-1-git-send-email-bzhao@marvell.com> (sfid-20120928_040154_542319_59A6053A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Once hostsleep is activated, this patch takes care of not
dropping packets in RX reorder table.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   49 +++++++++++++++++++++----
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    5 +++
 drivers/net/wireless/mwifiex/cmdevt.c        |    2 +
 drivers/net/wireless/mwifiex/main.h          |    1 +
 4 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 24e2582..9402b93 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -302,6 +302,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->start_win = last_seq + 1;
 
 	new_node->win_size = win_size;
+	new_node->flags = 0;
 
 	new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
 					GFP_KERNEL);
@@ -457,13 +458,20 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	 * If seq_num is less then starting win then ignore and drop the
 	 * packet
 	 */
-	if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
-		if (seq_num >= ((start_win + TWOPOW11) &
-				(MAX_TID_VALUE - 1)) && (seq_num < start_win))
+	if (tbl->flags & RXREOR_FORCE_NO_DROP) {
+		dev_dbg(priv->adapter->dev,
+			"RXREOR_FORCE_NO_DROP when HS is activated\n");
+		tbl->flags &= ~RXREOR_FORCE_NO_DROP;
+	} else {
+		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {
+			if (seq_num >= ((start_win + TWOPOW11) &
+					(MAX_TID_VALUE - 1)) &&
+			    seq_num < start_win)
+				return -1;
+		} else if ((seq_num < start_win) ||
+			   (seq_num > (start_win + TWOPOW11))) {
 			return -1;
-	} else if ((seq_num < start_win) ||
-		   (seq_num > (start_win + TWOPOW11))) {
-		return -1;
+		}
 	}
 
 	/*
@@ -474,8 +482,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		seq_num = ((seq_num + win_size) - 1) & (MAX_TID_VALUE - 1);
 
 	if (((end_win < start_win) &&
-	     (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win))) &&
-	     (seq_num > end_win)) ||
+	     (seq_num < start_win) && (seq_num > end_win)) ||
 	    ((end_win > start_win) && ((seq_num > end_win) ||
 				       (seq_num < start_win)))) {
 		end_win = seq_num;
@@ -637,3 +644,29 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	mwifiex_reset_11n_rx_seq_num(priv);
 }
+
+/*
+ * This function updates all rx_reorder_tbl's flags.
+ */
+void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags)
+{
+	struct mwifiex_private *priv;
+	struct mwifiex_rx_reorder_tbl *tbl;
+	unsigned long lock_flags;
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (!priv)
+			continue;
+		if (list_empty(&priv->rx_reorder_tbl_ptr))
+			continue;
+
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, lock_flags);
+		list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list)
+			tbl->flags = flags;
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, lock_flags);
+	}
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 7284859..4064041 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -41,6 +41,10 @@
 #define BA_SETUP_MAX_PACKET_THRESHOLD	16
 #define BA_SETUP_PACKET_OFFSET		16
 
+enum mwifiex_rxreor_flags {
+	RXREOR_FORCE_NO_DROP	= 1<<0,
+};
+
 static inline void mwifiex_reset_11n_rx_seq_num(struct mwifiex_private *priv)
 {
 	memset(priv->rx_seq, 0xff, sizeof(priv->rx_seq));
@@ -73,5 +77,6 @@ struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
 struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta);
 void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta);
+void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags);
 
 #endif /* _MWIFIEX_11N_RXREORDER_H_ */
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 225c1a4..8d46510 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1088,6 +1088,8 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 	if (activated) {
 		if (priv->adapter->is_hs_configured) {
 			priv->adapter->hs_activated = true;
+			mwifiex_update_rxreor_flags(priv->adapter,
+						    RXREOR_FORCE_NO_DROP);
 			dev_dbg(priv->adapter->dev, "event: hs_activated\n");
 			priv->adapter->hs_activate_wait_q_woken = true;
 			wake_up_interruptible(
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 956312f..bfb3fa6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -535,6 +535,7 @@ struct mwifiex_rx_reorder_tbl {
 	int win_size;
 	void **rx_reorder_ptr;
 	struct reorder_tmr_cnxt timer_context;
+	u8 flags;
 };
 
 struct mwifiex_bss_prio_node {
-- 
1.7.0.2

