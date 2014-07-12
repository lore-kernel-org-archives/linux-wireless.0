Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20606 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbaGLDxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:53:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: access rx_reorder_tbl_ptr only while holding lock
Date: Fri, 11 Jul 2014 20:53:13 -0700
Message-ID: <1405137194-13794-1-git-send-email-bzhao@marvell.com> (sfid-20140712_055404_772722_F10405B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch fixes a bug in which rx_reorder_tbl_ptr is accessed
without holding spinlock at few places.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index b22bae3..06a2c21 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -249,13 +249,22 @@ void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta)
  * buffered in Rx reordering table.
  */
 static int
-mwifiex_11n_find_last_seq_num(struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr)
+mwifiex_11n_find_last_seq_num(struct reorder_tmr_cnxt *ctx)
 {
+	struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr = ctx->ptr;
+	struct mwifiex_private *priv = ctx->priv;
+	unsigned long flags;
 	int i;
 
-	for (i = (rx_reorder_tbl_ptr->win_size - 1); i >= 0; --i)
-		if (rx_reorder_tbl_ptr->rx_reorder_ptr[i])
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	for (i = rx_reorder_tbl_ptr->win_size - 1; i >= 0; --i) {
+		if (rx_reorder_tbl_ptr->rx_reorder_ptr[i]) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
 			return i;
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	return -1;
 }
@@ -274,7 +283,7 @@ mwifiex_flush_data(unsigned long context)
 		(struct reorder_tmr_cnxt *) context;
 	int start_win, seq_num;
 
-	seq_num = mwifiex_11n_find_last_seq_num(ctx->ptr);
+	seq_num = mwifiex_11n_find_last_seq_num(ctx);
 
 	if (seq_num < 0)
 		return;
@@ -729,9 +738,9 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 		mwifiex_del_rx_reorder_entry(priv, del_tbl_ptr);
 		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	}
+	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
-	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	mwifiex_reset_11n_rx_seq_num(priv);
 }
 
@@ -749,10 +758,14 @@ void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags)
 		priv = adapter->priv[i];
 		if (!priv)
 			continue;
-		if (list_empty(&priv->rx_reorder_tbl_ptr))
-			continue;
 
 		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, lock_flags);
+		if (list_empty(&priv->rx_reorder_tbl_ptr)) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       lock_flags);
+			continue;
+		}
+
 		list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list)
 			tbl->flags = flags;
 		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, lock_flags);
-- 
1.8.2.3

