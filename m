Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45772 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZHRDza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:30 -0400
Date: Tue, 18 Aug 2009 05:55:31 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 27/29] mwl8k: remove mwl8k_queue_work()
Message-ID: <20090818035531.GF18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   75 ------------------------------------------
 1 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index dea1440..c8aa552 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2425,81 +2425,6 @@ static int mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return rc;
 }
 
-struct mwl8k_work_struct {
-	/* Initialized by mwl8k_queue_work().  */
-	struct work_struct wt;
-
-	/* Required field passed in to mwl8k_queue_work().  */
-	struct ieee80211_hw *hw;
-
-	/* Required field passed in to mwl8k_queue_work().  */
-	int (*wfunc)(struct work_struct *w);
-
-	/* Initialized by mwl8k_queue_work().  */
-	struct completion *cmd_wait;
-
-	/* Result code.  */
-	int rc;
-
-	/*
-	 * Whether to sleep for request completion.
-	 */
-	bool sleep;
-};
-
-static void mwl8k_config_thread(struct work_struct *wt)
-{
-	struct mwl8k_work_struct *worker = (struct mwl8k_work_struct *)wt;
-	struct ieee80211_hw *hw = worker->hw;
-	int rc = 0;
-
-	rc = mwl8k_fw_lock(hw);
-	if (!rc) {
-		rc = worker->wfunc(wt);
-		mwl8k_fw_unlock(hw);
-	}
-
-	if (worker->sleep) {
-		worker->rc = rc;
-		complete(worker->cmd_wait);
-	} else {
-		kfree(wt);
-	}
-}
-
-static int mwl8k_queue_work(struct ieee80211_hw *hw,
-				struct mwl8k_work_struct *worker,
-				int (*wfunc)(struct work_struct *w))
-{
-	struct mwl8k_priv *priv = hw->priv;
-	unsigned long timeout = 0;
-	int rc = 0;
-
-	DECLARE_COMPLETION_ONSTACK(cmd_wait);
-
-	worker->hw = hw;
-	worker->cmd_wait = &cmd_wait;
-	worker->rc = 1;
-	worker->wfunc = wfunc;
-
-	INIT_WORK(&worker->wt, mwl8k_config_thread);
-	queue_work(priv->config_wq, &worker->wt);
-
-	if (worker->sleep) {
-		timeout = wait_for_completion_timeout(&cmd_wait,
-			msecs_to_jiffies(10000));
-
-		if (timeout)
-			rc = worker->rc;
-		else {
-			cancel_work_sync(&worker->wt);
-			rc = -ETIMEDOUT;
-		}
-	}
-
-	return rc;
-}
-
 static int mwl8k_start(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
-- 
1.5.6.4
