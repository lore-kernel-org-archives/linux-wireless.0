Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752335AbdJCPXn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 11:23:43 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] mwifiex: kill useless list_empty checks
Date: Tue, 3 Oct 2017 20:49:43 +0530
Message-ID: <1507043984-9832-1-git-send-email-gbhat@marvell.com> (sfid-20171003_172347_842414_EBBE2115)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

There's absolutely no reason to check to see if a list is empty
before iterating through it.  It's just like writing code like
this:

if (count != 0) {
  for (i = 0; i < count; i++) {
     ...
  }
}

The loop will already be avoided if "count == 0" so there was no
reason to check.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c           | 9 ---------
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 6 ------
 drivers/net/wireless/marvell/mwifiex/init.c          | 4 ----
 drivers/net/wireless/marvell/mwifiex/tdls.c          | 7 -------
 4 files changed, 26 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 7252069..8772e39 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -658,12 +658,6 @@ void mwifiex_11n_delba(struct mwifiex_private *priv, int tid)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
-	if (list_empty(&priv->rx_reorder_tbl_ptr)) {
-		dev_dbg(priv->adapter->dev,
-			"mwifiex_11n_delba: rx_reorder_tbl_ptr empty\n");
-		goto exit;
-	}
-
 	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
 		if (rx_reor_tbl_ptr->tid == tid) {
 			dev_dbg(priv->adapter->dev,
@@ -854,9 +848,6 @@ u8 mwifiex_get_sec_chan_offset(int chan)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_stream_tbl_ptr;
 
-	if (list_empty(&priv->tx_ba_stream_tbl_ptr))
-		return;
-
 	list_for_each_entry(tx_ba_stream_tbl_ptr,
 			    &priv->tx_ba_stream_tbl_ptr, list) {
 		if (tx_ba_stream_tbl_ptr->ba_status == BA_SETUP_COMPLETE) {
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 274dd5a..d87df2d 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -835,12 +835,6 @@ void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags)
 			continue;
 
 		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, lock_flags);
-		if (list_empty(&priv->rx_reorder_tbl_ptr)) {
-			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
-					       lock_flags);
-			continue;
-		}
-
 		list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list)
 			tbl->flags = flags;
 		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, lock_flags);
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index e11919d..1176706 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -579,10 +579,6 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 
 		{
 			spin_lock_irqsave(lock, flags);
-			if (list_empty(head)) {
-				spin_unlock_irqrestore(lock, flags);
-				continue;
-			}
 			list_for_each_entry_safe(bssprio_node, tmp_node, head,
 						 list) {
 				if (bssprio_node->priv == priv) {
diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index e76af286..9fe0bae 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -1413,13 +1413,6 @@ void mwifiex_check_auto_tdls(unsigned long context)
 
 	priv->check_tdls_tx = false;
 
-	if (list_empty(&priv->auto_tdls_list)) {
-		mod_timer(&priv->auto_tdls_timer,
-			  jiffies +
-			  msecs_to_jiffies(MWIFIEX_TIMER_10S));
-		return;
-	}
-
 	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
 	list_for_each_entry(tdls_peer, &priv->auto_tdls_list, list) {
 		if ((jiffies - tdls_peer->rssi_jiffies) >
-- 
1.9.1
