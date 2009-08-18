Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45749 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZHRDxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:49 -0400
Date: Tue, 18 Aug 2009 05:53:50 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 17/29] mwl8k: mwl8k_queue_work() cleanup
Message-ID: <20090818035350.GV18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Delete most of the mwl8k_work_struct fields and options, since most
of them are unused or never changed from their defaults:
- We always use priv->config_wq, so delete the wqueue argument from
  mwl8k_queue_work().
- MWL8K_WQ_SPIN is never used.
- MWL8K_WQ_TX_WAIT_EMPTY is always set, so assume it unconditionally.
- MWL8K_WQ_FREE_WORKSTRUCT is implied by MWL8K_WQ_POST_REQUEST, so
  delete it and assume it whenever the latter is set.
- One of MWL8K_WQ_{POST_REQUEST,SLEEP} is always set, so change this
  into a bool flag.
- timeout_ms/txwait_attempts/tx_timeout_ms are never changed from
  their defaults, so just hardcode these in the workqueue worker.
- step is never used.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  210 +++++++++--------------------------------
 1 files changed, 46 insertions(+), 164 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f0d1fa7..905f750 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1113,7 +1113,7 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 	return ndescs;
 }
 
-static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
+static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	DECLARE_COMPLETION_ONSTACK(cmd_wait);
@@ -1140,7 +1140,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 		int newcount;
 
 		timeout = wait_for_completion_timeout(&cmd_wait,
-					msecs_to_jiffies(delay_ms));
+					msecs_to_jiffies(1000));
 		if (timeout)
 			return 0;
 
@@ -1149,8 +1149,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 		newcount = mwl8k_txq_busy(priv);
 		spin_unlock_bh(&priv->tx_lock);
 
-		printk(KERN_ERR "%s(%u) TIMEDOUT:%ums Pend:%u-->%u\n",
-		       __func__, __LINE__, delay_ms, count, newcount);
+		printk(KERN_ERR "%s(%u) TIMEDOUT:1000ms Pend:%u-->%u\n",
+		       __func__, __LINE__, count, newcount);
 
 		mwl8k_scan_tx_ring(priv, txinfo);
 		for (index = 0; index < MWL8K_TX_QUEUES; index++)
@@ -2391,82 +2391,18 @@ struct mwl8k_work_struct {
 	int rc;
 
 	/*
-	 * Optional field. Refer to explanation of MWL8K_WQ_XXX_XXX
-	 * flags for explanation.  Defaults to MWL8K_WQ_DEFAULT_OPTIONS.
+	 * Whether to sleep for request completion.
 	 */
-	u32 options;
-
-	/* Optional field.  Defaults to MWL8K_CONFIG_TIMEOUT_MS.  */
-	unsigned long timeout_ms;
-
-	/* Optional field.  Defaults to MWL8K_WQ_TXWAIT_ATTEMPTS.  */
-	u32 txwait_attempts;
-
-	/* Optional field.  Defaults to MWL8K_TXWAIT_MS.  */
-	u32 tx_timeout_ms;
-	u32 step;
+	bool sleep;
 };
 
-/* Flags controlling behavior of config queue requests */
-
-/* Caller spins while waiting for completion.  */
-#define MWL8K_WQ_SPIN			0x00000001
-
-/* Wait for TX queues to empty before proceeding with configuration.  */
-#define MWL8K_WQ_TX_WAIT_EMPTY		0x00000002
-
-/* Queue request and return immediately.  */
-#define MWL8K_WQ_POST_REQUEST		0x00000004
-
-/*
- * Caller sleeps and waits for task complete notification.
- * Do not use in atomic context.
- */
-#define MWL8K_WQ_SLEEP			0x00000008
-
-/* Free work struct when task is done.  */
-#define MWL8K_WQ_FREE_WORKSTRUCT	0x00000010
-
-/*
- * Config request is queued and returns to caller imediately.  Use
- * this in atomic context. Work struct is freed by mwl8k_queue_work()
- * when this flag is set.
- */
-#define MWL8K_WQ_QUEUE_ONLY	(MWL8K_WQ_POST_REQUEST | \
-				 MWL8K_WQ_FREE_WORKSTRUCT)
-
-/* Default work queue behavior is to sleep and wait for tx completion.  */
-#define MWL8K_WQ_DEFAULT_OPTIONS (MWL8K_WQ_SLEEP | MWL8K_WQ_TX_WAIT_EMPTY)
-
-/*
- * Default config request timeout.  Add adjustments to make sure the
- * config thread waits long enough for both tx wait and cmd wait before
- * timing out.
- */
-
-/* Time to wait for all TXQs to drain.  TX Doorbell is pressed each time.  */
-#define MWL8K_TXWAIT_TIMEOUT_MS		1000
-
-/* Default number of TX wait attempts.  */
-#define MWL8K_WQ_TXWAIT_ATTEMPTS	4
-
-/* Total time to wait for TXQ to drain.  */
-#define MWL8K_TXWAIT_MS			(MWL8K_TXWAIT_TIMEOUT_MS * \
-						MWL8K_WQ_TXWAIT_ATTEMPTS)
-
-/* Scheduling slop.  */
-#define MWL8K_OS_SCHEDULE_OVERHEAD_MS	200
-
-#define MWL8K_CONFIG_TIMEOUT_MS	(MWL8K_CMD_TIMEOUT_MS + \
-				 MWL8K_TXWAIT_MS + \
-				 MWL8K_OS_SCHEDULE_OVERHEAD_MS)
-
 static void mwl8k_config_thread(struct work_struct *wt)
 {
 	struct mwl8k_work_struct *worker = (struct mwl8k_work_struct *)wt;
 	struct ieee80211_hw *hw = worker->hw;
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
+	int iter;
 
 	spin_lock_irq(&priv->tx_lock);
 	priv->inconfig = true;
@@ -2479,44 +2415,16 @@ static void mwl8k_config_thread(struct work_struct *wt)
 	 * reconfiguration. This avoids interrupting any in-flight
 	 * DMA transfers to the hardware.
 	 */
-	if (worker->options & MWL8K_WQ_TX_WAIT_EMPTY) {
-		u32 timeout;
-		u32 time_remaining;
-		u32 iter;
-		u32 tx_wait_attempts = worker->txwait_attempts;
-
-		time_remaining = worker->tx_timeout_ms;
-		if (!tx_wait_attempts)
-			tx_wait_attempts = 1;
-
-		timeout = worker->tx_timeout_ms/tx_wait_attempts;
-		if (!timeout)
-			timeout = 1;
-
-		iter = tx_wait_attempts;
-		do {
-			int wait_time;
-
-			if (time_remaining > timeout) {
-				time_remaining -= timeout;
-				wait_time = timeout;
-			} else
-				wait_time = time_remaining;
-
-			if (!wait_time)
-				wait_time = 1;
-
-			rc = mwl8k_tx_wait_empty(hw, wait_time);
-			if (rc)
-				printk(KERN_ERR "%s() txwait timeout=%ums "
-					"Retry:%u/%u\n", __func__, timeout,
-					tx_wait_attempts - iter + 1,
-					tx_wait_attempts);
+	iter = 4;
+	do {
+		rc = mwl8k_tx_wait_empty(hw);
+		if (rc)
+			printk(KERN_ERR "%s() txwait timeout=1000ms "
+				"Retry:%u/%u\n", __func__, 4 - iter + 1, 4);
+	} while (rc && --iter);
 
-		} while (rc && --iter);
+	rc = iter ? 0 : -ETIMEDOUT;
 
-		rc = iter ? 0 : -ETIMEDOUT;
-	}
 	if (!rc)
 		rc = worker->wfunc(wt);
 
@@ -2525,58 +2433,38 @@ static void mwl8k_config_thread(struct work_struct *wt)
 	if (priv->pending_tx_pkts && priv->radio_on)
 		mwl8k_tx_start(priv);
 	spin_unlock_irq(&priv->tx_lock);
+
 	ieee80211_wake_queues(hw);
 
-	worker->rc = rc;
-	if (worker->options & MWL8K_WQ_SLEEP)
+	if (worker->sleep) {
+		worker->rc = rc;
 		complete(worker->cmd_wait);
-
-	if (worker->options & MWL8K_WQ_FREE_WORKSTRUCT)
+	} else {
 		kfree(wt);
+	}
 }
 
 static int mwl8k_queue_work(struct ieee80211_hw *hw,
 				struct mwl8k_work_struct *worker,
-				struct workqueue_struct *wqueue,
 				int (*wfunc)(struct work_struct *w))
 {
+	struct mwl8k_priv *priv = hw->priv;
 	unsigned long timeout = 0;
 	int rc = 0;
 
 	DECLARE_COMPLETION_ONSTACK(cmd_wait);
 
-	if (!worker->timeout_ms)
-		worker->timeout_ms = MWL8K_CONFIG_TIMEOUT_MS;
-
-	if (!worker->options)
-		worker->options = MWL8K_WQ_DEFAULT_OPTIONS;
-
-	if (!worker->txwait_attempts)
-		worker->txwait_attempts = MWL8K_WQ_TXWAIT_ATTEMPTS;
-
-	if (!worker->tx_timeout_ms)
-		worker->tx_timeout_ms = MWL8K_TXWAIT_MS;
-
 	worker->hw = hw;
 	worker->cmd_wait = &cmd_wait;
 	worker->rc = 1;
 	worker->wfunc = wfunc;
 
 	INIT_WORK(&worker->wt, mwl8k_config_thread);
-	queue_work(wqueue, &worker->wt);
+	queue_work(priv->config_wq, &worker->wt);
 
-	if (worker->options & MWL8K_WQ_POST_REQUEST) {
-		rc = 0;
-	} else {
-		if (worker->options & MWL8K_WQ_SPIN) {
-			timeout = worker->timeout_ms;
-			while (timeout && (worker->rc > 0)) {
-				mdelay(1);
-				timeout--;
-			}
-		} else if (worker->options & MWL8K_WQ_SLEEP)
-			timeout = wait_for_completion_timeout(&cmd_wait,
-				msecs_to_jiffies(worker->timeout_ms));
+	if (worker->sleep) {
+		timeout = wait_for_completion_timeout(&cmd_wait,
+			msecs_to_jiffies(10000));
 
 		if (timeout)
 			rc = worker->rc;
@@ -2669,8 +2557,9 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		goto mwl8k_start_disable_irq;
 	}
 
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq, mwl8k_start_wt);
+	worker->header.sleep = 1;
+
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_start_wt);
 	kfree(worker);
 	if (!rc)
 		return rc;
@@ -2720,8 +2609,9 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	if (worker == NULL)
 		return;
 
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq, mwl8k_stop_wt);
+	worker->header.sleep = 1;
+
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_stop_wt);
 	kfree(worker);
 	if (rc == -ETIMEDOUT)
 		printk(KERN_ERR "%s() timed out\n", __func__);
@@ -2850,15 +2740,15 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	int rc = 0;
 	struct mwl8k_config_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (worker == NULL)
 		return -ENOMEM;
 
+	worker->header.sleep = 1;
 	worker->changed = changed;
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq, mwl8k_config_wt);
+
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_config_wt);
 	if (rc == -ETIMEDOUT) {
 		printk(KERN_ERR "%s() timed out.\n", __func__);
 		rc = -EINVAL;
@@ -2951,7 +2841,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changed)
 {
 	struct mwl8k_bss_info_changed_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	int rc;
 
@@ -2965,12 +2854,11 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 	if (worker == NULL)
 		return;
 
+	worker->header.sleep = 1;
 	worker->vif = vif;
 	worker->info = info;
 	worker->changed = changed;
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq,
-			      mwl8k_bss_info_changed_wt);
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_bss_info_changed_wt);
 	kfree(worker);
 	if (rc == -ETIMEDOUT)
 		printk(KERN_ERR "%s() timed out\n", __func__);
@@ -3025,7 +2913,6 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   struct dev_addr_list *mclist)
 {
 	struct mwl8k_configure_filter_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 
 	/* Clear unsupported feature flags */
 	*total_flags &= MWL8K_SUPPORTED_IF_FLAGS;
@@ -3037,15 +2924,14 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	if (worker == NULL)
 		return;
 
-	worker->header.options = MWL8K_WQ_QUEUE_ONLY | MWL8K_WQ_TX_WAIT_EMPTY;
+	worker->header.sleep = 0;
 	worker->changed_flags = changed_flags;
 	worker->total_flags = *total_flags;
 	if (mc_count)
 		worker->set_multicast_adr =
 			__mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
 
-	mwl8k_queue_work(hw, &worker->header, priv->config_wq,
-			 mwl8k_configure_filter_wt);
+	mwl8k_queue_work(hw, &worker->header, mwl8k_configure_filter_wt);
 }
 
 struct mwl8k_set_rts_threshold_worker {
@@ -3071,17 +2957,15 @@ static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	int rc;
 	struct mwl8k_set_rts_threshold_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (worker == NULL)
 		return -ENOMEM;
 
+	worker->header.sleep = 1;
 	worker->value = value;
 
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq,
-			      mwl8k_set_rts_threshold_wt);
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_set_rts_threshold_wt);
 	kfree(worker);
 
 	if (rc == -ETIMEDOUT) {
@@ -3129,16 +3013,15 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	int rc;
 	struct mwl8k_conf_tx_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (worker == NULL)
 		return -ENOMEM;
 
+	worker->header.sleep = 1;
 	worker->queue = queue;
 	worker->params = params;
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq, mwl8k_conf_tx_wt);
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_conf_tx_wt);
 	kfree(worker);
 	if (rc == -ETIMEDOUT) {
 		printk(KERN_ERR "%s() timed out\n", __func__);
@@ -3182,15 +3065,14 @@ static int mwl8k_get_stats(struct ieee80211_hw *hw,
 {
 	int rc;
 	struct mwl8k_get_stats_worker *worker;
-	struct mwl8k_priv *priv = hw->priv;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (worker == NULL)
 		return -ENOMEM;
 
+	worker->header.sleep = 1;
 	worker->stats = stats;
-	rc = mwl8k_queue_work(hw, &worker->header,
-			      priv->config_wq, mwl8k_get_stats_wt);
+	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_get_stats_wt);
 
 	kfree(worker);
 	if (rc == -ETIMEDOUT) {
-- 
1.5.6.4
