Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [67.231.156.173] ([67.231.156.173]:2211 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbaCHDmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:14 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/6] mwifiex: create separate function mwifiex_11n_dispatch_pkt()
Date: Fri, 7 Mar 2014 19:41:30 -0800
Message-ID: <1394250091-18477-5-git-send-email-bzhao@marvell.com> (sfid-20140308_044222_361119_FA2D245D)
In-Reply-To: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
References: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Existing mwifiex_11n_dispatch_pkt() function is renamed as
mwifiex_11n_dispatch_pkt_until_start_win() and a new function
mwifiex_11n_dispatch_pkt() is created for a common code which
dispatches single packet based on interface type.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 47 ++++++++++++++--------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 8a8218d..2be015b 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -26,6 +26,17 @@
 #include "11n.h"
 #include "11n_rxreorder.h"
 
+/* This function will process the rx packet and forward it to kernel/upper
+ * layer.
+ */
+static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
+{
+	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+		return mwifiex_handle_uap_rx_forward(priv, payload);
+
+	return mwifiex_process_rx_packet(priv, payload);
+}
+
 /*
  * This function dispatches all packets in the Rx reorder table until the
  * start window.
@@ -35,8 +46,9 @@
  * circular buffer.
  */
 static void
-mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
-			 struct mwifiex_rx_reorder_tbl *tbl, int start_win)
+mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
+					 struct mwifiex_rx_reorder_tbl *tbl,
+					 int start_win)
 {
 	int pkt_to_send, i;
 	void *rx_tmp_ptr;
@@ -54,12 +66,8 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
 			tbl->rx_reorder_ptr[i] = NULL;
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		if (rx_tmp_ptr) {
-			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
-				mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
-			else
-				mwifiex_process_rx_packet(priv, rx_tmp_ptr);
-		}
+		if (rx_tmp_ptr)
+			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -101,11 +109,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-
-		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
-			mwifiex_handle_uap_rx_forward(priv, rx_tmp_ptr);
-		else
-			mwifiex_process_rx_packet(priv, rx_tmp_ptr);
+		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -141,7 +145,7 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 		return;
 
 	start_win = (tbl->start_win + tbl->win_size) & (MAX_TID_VALUE - 1);
-	mwifiex_11n_dispatch_pkt(priv, tbl, start_win);
+	mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, start_win);
 
 	del_timer_sync(&tbl->timer_context.timer);
 
@@ -238,7 +242,8 @@ mwifiex_flush_data(unsigned long context)
 
 	dev_dbg(ctx->priv->adapter->dev, "info: flush data %d\n", seq_num);
 	start_win = (ctx->ptr->start_win + seq_num + 1) & (MAX_TID_VALUE - 1);
-	mwifiex_11n_dispatch_pkt(ctx->priv, ctx->ptr, start_win);
+	mwifiex_11n_dispatch_pkt_until_start_win(ctx->priv, ctx->ptr,
+						 start_win);
 }
 
 /*
@@ -267,7 +272,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	 */
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (tbl) {
-		mwifiex_11n_dispatch_pkt(priv, tbl, seq_num);
+		mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, seq_num);
 		return;
 	}
 	/* if !tbl then create one */
@@ -459,12 +464,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
-		if (pkt_type != PKT_TYPE_BAR) {
-			if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
-				mwifiex_handle_uap_rx_forward(priv, payload);
-			else
-				mwifiex_process_rx_packet(priv, payload);
-		}
+		if (pkt_type != PKT_TYPE_BAR)
+			mwifiex_11n_dispatch_pkt(priv, payload);
 		return 0;
 	}
 	start_win = tbl->start_win;
@@ -520,7 +521,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			start_win = (end_win - win_size) + 1;
 		else
 			start_win = (MAX_TID_VALUE - (win_size - seq_num)) + 1;
-		mwifiex_11n_dispatch_pkt(priv, tbl, start_win);
+		mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, start_win);
 	}
 
 	if (pkt_type != PKT_TYPE_BAR) {
-- 
1.8.2.3

