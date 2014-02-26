Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:46909 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaBZAiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 19:38:50 -0500
Received: by mail-pd0-f202.google.com with SMTP id v10so33191pde.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 16:38:50 -0800 (PST)
Received: from corp2gmr1-1.hot.corp.google.com (corp2gmr1-1.hot.corp.google.com [172.24.189.92])
        by gmr-mx.google.com with ESMTPS id x29si746557yha.0.2014.02.25.16.32.55
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Feb 2014 16:32:55 -0800 (PST)
Received: from clearcreek.mtv.corp.google.com (clearcreek.mtv.corp.google.com [172.22.73.104])
	by corp2gmr1-1.hot.corp.google.com (Postfix) with ESMTP id D294F31C3BF
	for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 16:32:54 -0800 (PST)
From: Paul Stewart <pstew@chromium.org>
Date: Tue, 25 Feb 2014 16:31:37 -0800
Subject: [PATCH] mwifiex: Track BA sequence number reset
To: linux-wireless@vger.kernel.org
Message-Id: <20140226003254.6ADE9200505@clearcreek.mtv.corp.google.com> (sfid-20140226_013854_463441_32A467AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some stations reset the sequence number for traffic-ids (TIDs)
as they initiate a block-ACK session.  In order to detect such
behavior, mwifiex must note the starting sequence number given
during the ADDBA request.  If the first received sequence number
after the ADDBA falls outside the receive window for this TID but
after the the ADDBA starting sequence number, we can assume that
this AP has reset its sequence number during the ADDBA.  In this
case we must adjust the input window backward to incorporate this
received sequence number instead of ignoring it.  Otherwise, we
could fail to successfully retrieve an arbitrarily large number
of downstream frames at the beginning of the block-ACK session.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 27 +++++++++++++++++++++------
 drivers/net/wireless/mwifiex/11n_rxreorder.h |  3 ++-
 drivers/net/wireless/mwifiex/main.h          |  1 +
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index eb17282..35329cf 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -279,6 +279,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	new_node->tid = tid;
 	memcpy(new_node->ta, ta, ETH_ALEN);
 	new_node->start_win = seq_num;
+	new_node->init_win = seq_num;
+	new_node->flags = 0;
 
 	if (mwifiex_queuing_ra_based(priv)) {
 		dev_dbg(priv->adapter->dev,
@@ -298,11 +300,12 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	}
 
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
-	    last_seq >= new_node->start_win)
+	    last_seq >= new_node->start_win) {
 		new_node->start_win = last_seq + 1;
+		new_node->flags |= RXREOR_INIT_WINDOW_SHIFT;
+	}
 
 	new_node->win_size = win_size;
-	new_node->flags = 0;
 
 	new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
 					GFP_KERNEL);
@@ -452,6 +455,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	struct mwifiex_rx_reorder_tbl *tbl;
 	int start_win, end_win, win_size;
 	u16 pkt_index;
+	bool init_window_shift = false;
 
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
@@ -466,18 +470,29 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	start_win = tbl->start_win;
 	win_size = tbl->win_size;
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
+	if (tbl->flags & RXREOR_INIT_WINDOW_SHIFT) {
+		init_window_shift = true;
+		tbl->flags &= ~RXREOR_INIT_WINDOW_SHIFT;
+	}
 	mod_timer(&tbl->timer_context.timer,
 		  jiffies + msecs_to_jiffies(MIN_FLUSH_TIMER_MS * win_size));
 
-	/*
-	 * If seq_num is less then starting win then ignore and drop the
-	 * packet
-	 */
 	if (tbl->flags & RXREOR_FORCE_NO_DROP) {
 		dev_dbg(priv->adapter->dev,
 			"RXREOR_FORCE_NO_DROP when HS is activated\n");
 		tbl->flags &= ~RXREOR_FORCE_NO_DROP;
+	} else if (init_window_shift && seq_num < start_win &&
+		   seq_num >= tbl->init_win) {
+		dev_dbg(priv->adapter->dev,
+			"Sender TID sequence number reset %d->%d for SSN %d\n",
+			start_win, seq_num, tbl->init_win);
+		tbl->start_win = start_win = seq_num;
+		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
 	} else {
+		/*
+		 * If seq_num is less then starting win then ignore and drop
+		 * the packet
+		 */
 		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {
 			if (seq_num >= ((start_win + TWOPOW11) &
 					(MAX_TID_VALUE - 1)) &&
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 4064041..0fc76e4 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -42,7 +42,8 @@
 #define BA_SETUP_PACKET_OFFSET		16
 
 enum mwifiex_rxreor_flags {
-	RXREOR_FORCE_NO_DROP	= 1<<0,
+	RXREOR_FORCE_NO_DROP		= 1<<0,
+	RXREOR_INIT_WINDOW_SHIFT	= 1<<1,
 };
 
 static inline void mwifiex_reset_11n_rx_seq_num(struct mwifiex_private *priv)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 407f8ea..cb1148f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -575,6 +575,7 @@ struct mwifiex_rx_reorder_tbl {
 	struct list_head list;
 	int tid;
 	u8 ta[ETH_ALEN];
+	int init_win;
 	int start_win;
 	int win_size;
 	void **rx_reorder_ptr;
-- 
1.9.0.rc1.175.g0b1dcb5

