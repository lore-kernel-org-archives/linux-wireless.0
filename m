Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56828 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751576Ab1KHFlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:41:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: change return types to void
Date: Mon,  7 Nov 2011 21:41:08 -0800
Message-Id: <1320730872-25619-4-git-send-email-bzhao@marvell.com> (sfid-20111108_064139_138458_5EA999DC)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Functions mwifiex_11n_dispatch_pkt_until_start_win and
mwifiex_11n_scan_and_dispatch used to always return value
zero for all inputs. Changing these functions to void.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 7aa9aa0..681d3f2 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -33,7 +33,7 @@
  * Since the buffer is linear, the function uses rotation to simulate
  * circular buffer.
  */
-static int
+static void
 mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 					 struct mwifiex_rx_reorder_tbl
 					 *rx_reor_tbl_ptr, int start_win)
@@ -71,8 +71,6 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 
 	rx_reor_tbl_ptr->start_win = start_win;
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-
-	return 0;
 }
 
 /*
@@ -83,7 +81,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
  * Since the buffer is linear, the function uses rotation to simulate
  * circular buffer.
  */
-static int
+static void
 mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
 {
@@ -119,7 +117,6 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
 		&(MAX_TID_VALUE - 1);
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-	return 0;
 }
 
 /*
@@ -405,7 +402,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				u8 *ta, u8 pkt_type, void *payload)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
-	int start_win, end_win, win_size, ret;
+	int start_win, end_win, win_size;
 	u16 pkt_index;
 
 	rx_reor_tbl_ptr =
@@ -452,11 +449,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			start_win = (end_win - win_size) + 1;
 		else
 			start_win = (MAX_TID_VALUE - (win_size - seq_num)) + 1;
-		ret = mwifiex_11n_dispatch_pkt_until_start_win(priv,
+		mwifiex_11n_dispatch_pkt_until_start_win(priv,
 						rx_reor_tbl_ptr, start_win);
-
-		if (ret)
-			return ret;
 	}
 
 	if (pkt_type != PKT_TYPE_BAR) {
@@ -475,9 +469,9 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	 * Dispatch all packets sequentially from start_win until a
 	 * hole is found and adjust the start_win appropriately
 	 */
-	ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
+	mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.7.0.2

