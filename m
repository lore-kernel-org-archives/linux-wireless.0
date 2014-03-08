Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [67.231.156.173] ([67.231.156.173]:26610 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbaCHDmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/6] mwifiex: code rearrangement for better readability
Date: Fri, 7 Mar 2014 19:41:29 -0800
Message-ID: <1394250091-18477-4-git-send-email-bzhao@marvell.com> (sfid-20140308_044226_706428_982A97EA)
In-Reply-To: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
References: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use negative check for 'status' and return from the function.
This improves readability by avoiding line splits. Also, local
variable is used for start window calculations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 20 +++++++--------
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 38 ++++++++++++++--------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index d9c65b6..3606c88 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -166,21 +166,21 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	tid = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
 		& IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
-	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
-		tx_ba_tbl = mwifiex_get_ba_tbl(priv, tid,
-						add_ba_rsp->peer_mac_addr);
-		if (tx_ba_tbl) {
-			dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
-			tx_ba_tbl->ba_status = BA_SETUP_COMPLETE;
-		} else {
-			dev_err(priv->adapter->dev, "BA stream not created\n");
-		}
-	} else {
+	if (le16_to_cpu(add_ba_rsp->status_code) != BA_RESULT_SUCCESS) {
 		mwifiex_del_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr,
 				   TYPE_DELBA_SENT, true);
 		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
 			priv->aggr_prio_tbl[tid].ampdu_ap =
 				BA_STREAM_NOT_ALLOWED;
+		return 0;
+	}
+
+	tx_ba_tbl = mwifiex_get_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr);
+	if (tx_ba_tbl) {
+		dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
+		tx_ba_tbl->ba_status = BA_SETUP_COMPLETE;
+	} else {
+		dev_err(priv->adapter->dev, "BA stream not created\n");
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index c3323c4..8a8218d 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -135,12 +135,13 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 			     struct mwifiex_rx_reorder_tbl *tbl)
 {
 	unsigned long flags;
+	int start_win;
 
 	if (!tbl)
 		return;
 
-	mwifiex_11n_dispatch_pkt(priv, tbl, (tbl->start_win + tbl->win_size) &
-					    (MAX_TID_VALUE - 1));
+	start_win = (tbl->start_win + tbl->win_size) & (MAX_TID_VALUE - 1);
+	mwifiex_11n_dispatch_pkt(priv, tbl, start_win);
 
 	del_timer_sync(&tbl->timer_context.timer);
 
@@ -228,17 +229,16 @@ mwifiex_flush_data(unsigned long context)
 {
 	struct reorder_tmr_cnxt *ctx =
 		(struct reorder_tmr_cnxt *) context;
-	int start_win;
+	int start_win, seq_num;
 
-	start_win = mwifiex_11n_find_last_seq_num(ctx->ptr);
+	seq_num = mwifiex_11n_find_last_seq_num(ctx->ptr);
 
-	if (start_win < 0)
+	if (seq_num < 0)
 		return;
 
-	dev_dbg(ctx->priv->adapter->dev, "info: flush data %d\n", start_win);
-	mwifiex_11n_dispatch_pkt(ctx->priv, ctx->ptr,
-				 (ctx->ptr->start_win + start_win + 1) &
-				 (MAX_TID_VALUE - 1));
+	dev_dbg(ctx->priv->adapter->dev, "info: flush data %d\n", seq_num);
+	start_win = (ctx->ptr->start_win + seq_num + 1) & (MAX_TID_VALUE - 1);
+	mwifiex_11n_dispatch_pkt(ctx->priv, ctx->ptr, start_win);
 }
 
 /*
@@ -611,16 +611,7 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	 * Check if we had rejected the ADDBA, if yes then do not create
 	 * the stream
 	 */
-	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
-		win_size = (block_ack_param_set &
-			IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
-			>> BLOCKACKPARAM_WINSIZE_POS;
-
-		dev_dbg(priv->adapter->dev,
-			"cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
-			add_ba_rsp->peer_mac_addr, tid,
-			add_ba_rsp->ssn, win_size);
-	} else {
+	if (le16_to_cpu(add_ba_rsp->status_code) != BA_RESULT_SUCCESS) {
 		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
 			add_ba_rsp->peer_mac_addr, tid);
 
@@ -628,8 +619,17 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 						     add_ba_rsp->peer_mac_addr);
 		if (tbl)
 			mwifiex_del_rx_reorder_entry(priv, tbl);
+
+		return 0;
 	}
 
+	win_size = (block_ack_param_set & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
+		    >> BLOCKACKPARAM_WINSIZE_POS;
+
+	dev_dbg(priv->adapter->dev,
+		"cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
+		add_ba_rsp->peer_mac_addr, tid, add_ba_rsp->ssn, win_size);
+
 	return 0;
 }
 
-- 
1.8.2.3

