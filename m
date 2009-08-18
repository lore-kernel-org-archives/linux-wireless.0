Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45768 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbZHRDzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:13 -0400
Date: Tue, 18 Aug 2009 05:55:14 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 25/29] mwl8k: get rid of mwl8k_get_stats() workqueue use
Message-ID: <20090818035514.GD18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   33 ++-------------------------------
 1 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d16ba1b..b863b74 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2859,43 +2859,14 @@ static int mwl8k_get_tx_stats(struct ieee80211_hw *hw,
 			sizeof(struct ieee80211_tx_queue_stats));
 	}
 	spin_unlock_bh(&priv->tx_lock);
-	return 0;
-}
-
-struct mwl8k_get_stats_worker {
-	struct mwl8k_work_struct header;
-	struct ieee80211_low_level_stats *stats;
-};
 
-static int mwl8k_get_stats_wt(struct work_struct *wt)
-{
-	struct mwl8k_get_stats_worker *worker =
-		(struct mwl8k_get_stats_worker *)wt;
-
-	return mwl8k_cmd_802_11_get_stat(worker->header.hw, worker->stats);
+	return 0;
 }
 
 static int mwl8k_get_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_low_level_stats *stats)
 {
-	int rc;
-	struct mwl8k_get_stats_worker *worker;
-
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return -ENOMEM;
-
-	worker->header.sleep = 1;
-	worker->stats = stats;
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_get_stats_wt);
-
-	kfree(worker);
-	if (rc == -ETIMEDOUT) {
-		printk(KERN_ERR "%s() timed out\n", __func__);
-		rc = -EINVAL;
-	}
-
-	return rc;
+	return mwl8k_cmd_802_11_get_stat(hw, stats);
 }
 
 static const struct ieee80211_ops mwl8k_ops = {
-- 
1.5.6.4
