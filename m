Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41795 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaHENGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 09:06:00 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1277131wib.8
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2014 06:05:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 2/2] ath10k: introduce a stricter scan state machine
Date: Tue,  5 Aug 2014 14:54:44 +0200
Message-Id: <1407243284-19803-3-git-send-email-michal.kazior@tieto.com> (sfid-20140805_150606_934416_081C522E)
In-Reply-To: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
References: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This aims at fixing some rare scan bugs related to
firmware reporting unexpected scan event
sequences.

One such bug was if spectral scan phyerr reporting
prevented firmware from properly propagating scan
events to host. This led to scan timeout. After
that next scan would trigger scan completed event
first (before scan started event) leading to
ar->scan.in_progress and timeout timer states to
be overwritten incorrectly and making the very
next scan to hang forever.

Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * rename RUNNING_AND_ABORTING to ABORTING [Kalle]
     * make sure to reset scan state in ath10k_halt (although this shouldn't be necessary it's better to stay on the safe side) [Kalle]
     * change scan timeout from a timer to delayed worker (so its possible to stop scan)
     * stop scan on timeout (prevents "scan start failure" in some cases)
     * print current scan state in scan events

 drivers/net/wireless/ath/ath10k/core.c |   5 +-
 drivers/net/wireless/ath/ath10k/core.h |  27 +++-
 drivers/net/wireless/ath/ath10k/mac.c  | 238 ++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/mac.h  |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 143 +++++++++++++++-----
 5 files changed, 280 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bef797d..1d795ab 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -665,8 +665,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
-		del_timer_sync(&ar->scan.timeout);
-		ath10k_reset_scan((unsigned long)ar);
+		ath10k_scan_finish(ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
@@ -1076,7 +1075,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
 
-	setup_timer(&ar->scan.timeout, ath10k_reset_scan, (unsigned long)ar);
+	INIT_DELAYED_WORK(&ar->scan.timeout, ath10k_scan_timeout_work);
 
 	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
 	if (!ar->workqueue)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ded3af2..660494e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -346,6 +346,28 @@ enum ath10k_dev_flags {
 	ATH10K_FLAG_CORE_REGISTERED,
 };
 
+enum ath10k_scan_state {
+	ATH10K_SCAN_IDLE,
+	ATH10K_SCAN_STARTING,
+	ATH10K_SCAN_RUNNING,
+	ATH10K_SCAN_ABORTING,
+};
+
+static inline const char *ath10k_scan_state_str(enum ath10k_scan_state state)
+{
+	switch (state) {
+	case ATH10K_SCAN_IDLE:
+		return "idle";
+	case ATH10K_SCAN_STARTING:
+		return "starting";
+	case ATH10K_SCAN_RUNNING:
+		return "running";
+	case ATH10K_SCAN_ABORTING:
+		return "aborting";
+	}
+	return "unknown";
+}
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -415,10 +437,9 @@ struct ath10k {
 		struct completion started;
 		struct completion completed;
 		struct completion on_channel;
-		struct timer_list timeout;
+		struct delayed_work timeout;
+		enum ath10k_scan_state state;
 		bool is_roc;
-		bool in_progress;
-		bool aborting;
 		int vdev_id;
 		int roc_freq;
 	} scan;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d61bb1..d54e045 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2145,34 +2145,40 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 /* Scanning */
 /************/
 
-/*
- * This gets called if we dont get a heart-beat during scan.
- * This may indicate the FW has hung and we need to abort the
- * scan manually to prevent cancel_hw_scan() from deadlocking
- */
-void ath10k_reset_scan(unsigned long ptr)
+void __ath10k_scan_finish(struct ath10k *ar)
 {
-	struct ath10k *ar = (struct ath10k *)ptr;
+	lockdep_assert_held(&ar->data_lock);
 
-	spin_lock_bh(&ar->data_lock);
-	if (!ar->scan.in_progress) {
-		spin_unlock_bh(&ar->data_lock);
-		return;
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		if (ar->scan.is_roc)
+			ieee80211_remain_on_channel_expired(ar->hw);
+		else
+			ieee80211_scan_completed(ar->hw,
+						 (ar->scan.state ==
+						  ATH10K_SCAN_ABORTING));
+		/* fall through */
+	case ATH10K_SCAN_STARTING:
+		ar->scan.state = ATH10K_SCAN_IDLE;
+		ar->scan_channel = NULL;
+		ath10k_offchan_tx_purge(ar);
+		cancel_delayed_work(&ar->scan.timeout);
+		complete_all(&ar->scan.completed);
+		break;
 	}
+}
 
-	ath10k_warn("scan timed out, firmware problem?\n");
-
-	if (ar->scan.is_roc)
-		ieee80211_remain_on_channel_expired(ar->hw);
-	else
-		ieee80211_scan_completed(ar->hw, 1 /* aborted */);
-
-	ar->scan.in_progress = false;
-	complete_all(&ar->scan.completed);
+void ath10k_scan_finish(struct ath10k *ar)
+{
+	spin_lock_bh(&ar->data_lock);
+	__ath10k_scan_finish(ar);
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static int ath10k_abort_scan(struct ath10k *ar)
+static int ath10k_scan_stop(struct ath10k *ar)
 {
 	struct wmi_stop_scan_arg arg = {
 		.req_id = 1, /* FIXME */
@@ -2183,47 +2189,79 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	del_timer_sync(&ar->scan.timeout);
-
-	spin_lock_bh(&ar->data_lock);
-	if (!ar->scan.in_progress) {
-		spin_unlock_bh(&ar->data_lock);
-		return 0;
-	}
-
-	ar->scan.aborting = true;
-	spin_unlock_bh(&ar->data_lock);
-
 	ret = ath10k_wmi_stop_scan(ar, &arg);
 	if (ret) {
 		ath10k_warn("failed to stop wmi scan: %d\n", ret);
-		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
-		ath10k_offchan_tx_purge(ar);
-		spin_unlock_bh(&ar->data_lock);
-		return -EIO;
+		goto out;
 	}
 
 	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
-	if (ret == 0)
-		ath10k_warn("timed out while waiting for scan to stop\n");
+	if (ret == 0) {
+		ath10k_warn("failed to receive scan abortion completion: timed out\n");
+		ret = -ETIMEDOUT;
+	} else if (ret > 0) {
+		ret = 0;
+	}
 
-	/* scan completion may be done right after we timeout here, so let's
-	 * check the in_progress and tell mac80211 scan is completed. if we
-	 * don't do that and FW fails to send us scan completion indication
-	 * then userspace won't be able to scan anymore */
-	ret = 0;
+out:
+	/* Scan state should be updated upon scan completion but in case
+	 * firmware fails to deliver the event (for whatever reason) it is
+	 * desired to clean up scan state anyway. Firmware may have just
+	 * dropped the scan completion event delivery due to transport pipe
+	 * being overflown with data and/or it can recover on its own before
+	 * next scan request is submitted.
+	 */
+	spin_lock_bh(&ar->data_lock);
+	if (ar->scan.state != ATH10K_SCAN_IDLE)
+		__ath10k_scan_finish(ar);
+	spin_unlock_bh(&ar->data_lock);
+
+	return ret;
+}
+
+static void ath10k_scan_abort(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		ath10k_warn("failed to stop scan, it's still in progress\n");
-		ar->scan.in_progress = false;
-		ath10k_offchan_tx_purge(ar);
-		ret = -ETIMEDOUT;
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		/* This can happen if timeout worker kicked in and called
+		 * abortion while scan completion was being processed.
+		 */
+		break;
+	case ATH10K_SCAN_STARTING:
+	case ATH10K_SCAN_ABORTING:
+		ath10k_warn("refusing scan abortion due to invalid scan state: %s (%d)\n",
+			    ath10k_scan_state_str(ar->scan.state),
+			    ar->scan.state);
+		break;
+	case ATH10K_SCAN_RUNNING:
+		ar->scan.state = ATH10K_SCAN_ABORTING;
+		spin_unlock_bh(&ar->data_lock);
+
+		ret = ath10k_scan_stop(ar);
+		if (ret)
+			ath10k_warn("failed to abort scan: %d\n", ret);
+
+		spin_lock_bh(&ar->data_lock);
+		break;
 	}
+
 	spin_unlock_bh(&ar->data_lock);
+}
 
-	return ret;
+void ath10k_scan_timeout_work(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k,
+					 scan.timeout.work);
+
+	mutex_lock(&ar->conf_mutex);
+	ath10k_scan_abort(ar);
+	mutex_unlock(&ar->conf_mutex);
 }
 
 static int ath10k_start_scan(struct ath10k *ar,
@@ -2239,17 +2277,16 @@ static int ath10k_start_scan(struct ath10k *ar,
 
 	ret = wait_for_completion_timeout(&ar->scan.started, 1*HZ);
 	if (ret == 0) {
-		ath10k_abort_scan(ar);
-		return ret;
+		ret = ath10k_scan_stop(ar);
+		if (ret)
+			ath10k_warn("failed to stop scan: %d\n", ret);
+
+		return -ETIMEDOUT;
 	}
 
-	/* the scan can complete earlier, before we even
-	 * start the timer. in that case the timer handler
-	 * checks ar->scan.in_progress and bails out if its
-	 * false. Add a 200ms margin to account event/command
-	 * processing. */
-	mod_timer(&ar->scan.timeout, jiffies +
-		  msecs_to_jiffies(arg->max_scan_time+200));
+	/* Add a 200ms margin to account for event/command processing */
+	ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,
+				     msecs_to_jiffies(arg->max_scan_time+200));
 	return 0;
 }
 
@@ -2325,8 +2362,7 @@ void ath10k_halt(struct ath10k *ar)
 		ath10k_monitor_stop(ar);
 	}
 
-	del_timer_sync(&ar->scan.timeout);
-	ath10k_reset_scan((unsigned long)ar);
+	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
 	ath10k_core_stop(ar);
 	ath10k_hif_power_down(ar);
@@ -2515,6 +2551,7 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	}
 	mutex_unlock(&ar->conf_mutex);
 
+	cancel_delayed_work_sync(&ar->scan.timeout);
 	cancel_work_sync(&ar->restart_work);
 }
 
@@ -3151,20 +3188,26 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		spin_unlock_bh(&ar->data_lock);
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		reinit_completion(&ar->scan.started);
+		reinit_completion(&ar->scan.completed);
+		ar->scan.state = ATH10K_SCAN_STARTING;
+		ar->scan.is_roc = false;
+		ar->scan.vdev_id = arvif->vdev_id;
+		ret = 0;
+		break;
+	case ATH10K_SCAN_STARTING:
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
 		ret = -EBUSY;
-		goto exit;
+		break;
 	}
-
-	reinit_completion(&ar->scan.started);
-	reinit_completion(&ar->scan.completed);
-	ar->scan.in_progress = true;
-	ar->scan.aborting = false;
-	ar->scan.is_roc = false;
-	ar->scan.vdev_id = arvif->vdev_id;
 	spin_unlock_bh(&ar->data_lock);
 
+	if (ret)
+		goto exit;
+
 	memset(&arg, 0, sizeof(arg));
 	ath10k_wmi_start_scan_init(ar, &arg);
 	arg.vdev_id = arvif->vdev_id;
@@ -3198,7 +3241,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 	if (ret) {
 		ath10k_warn("failed to start hw scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
+		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
 	}
 
@@ -3211,14 +3254,10 @@ static void ath10k_cancel_hw_scan(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif)
 {
 	struct ath10k *ar = hw->priv;
-	int ret;
 
 	mutex_lock(&ar->conf_mutex);
-	ret = ath10k_abort_scan(ar);
-	if (ret) {
-		ath10k_warn("failed to abort scan: %d\n", ret);
-		ieee80211_scan_completed(hw, 1 /* aborted */);
-	}
+	cancel_delayed_work_sync(&ar->scan.timeout);
+	ath10k_scan_abort(ar);
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -3641,27 +3680,33 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct wmi_start_scan_arg arg;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		spin_unlock_bh(&ar->data_lock);
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		reinit_completion(&ar->scan.started);
+		reinit_completion(&ar->scan.completed);
+		reinit_completion(&ar->scan.on_channel);
+		ar->scan.state = ATH10K_SCAN_STARTING;
+		ar->scan.is_roc = true;
+		ar->scan.vdev_id = arvif->vdev_id;
+		ar->scan.roc_freq = chan->center_freq;
+		ret = 0;
+		break;
+	case ATH10K_SCAN_STARTING:
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
 		ret = -EBUSY;
-		goto exit;
+		break;
 	}
-
-	reinit_completion(&ar->scan.started);
-	reinit_completion(&ar->scan.completed);
-	reinit_completion(&ar->scan.on_channel);
-	ar->scan.in_progress = true;
-	ar->scan.aborting = false;
-	ar->scan.is_roc = true;
-	ar->scan.vdev_id = arvif->vdev_id;
-	ar->scan.roc_freq = chan->center_freq;
 	spin_unlock_bh(&ar->data_lock);
 
+	if (ret)
+		goto exit;
+
 	memset(&arg, 0, sizeof(arg));
 	ath10k_wmi_start_scan_init(ar, &arg);
 	arg.vdev_id = arvif->vdev_id;
@@ -3678,7 +3723,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	if (ret) {
 		ath10k_warn("failed to start roc scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
+		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
 		goto exit;
 	}
@@ -3686,7 +3731,11 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
 	if (ret == 0) {
 		ath10k_warn("failed to switch to channel for roc scan\n");
-		ath10k_abort_scan(ar);
+
+		ret = ath10k_scan_stop(ar);
+		if (ret)
+			ath10k_warn("failed to stop scan: %d\n", ret);
+
 		ret = -ETIMEDOUT;
 		goto exit;
 	}
@@ -3702,7 +3751,8 @@ static int ath10k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	ath10k_abort_scan(ar);
+	cancel_delayed_work_sync(&ar->scan.timeout);
+	ath10k_scan_abort(ar);
 	mutex_unlock(&ar->conf_mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index ef4f843..e64fce7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -31,7 +31,9 @@ void ath10k_mac_destroy(struct ath10k *ar);
 int ath10k_mac_register(struct ath10k *ar);
 void ath10k_mac_unregister(struct ath10k *ar);
 struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id);
-void ath10k_reset_scan(unsigned long ptr);
+void __ath10k_scan_finish(struct ath10k *ar);
+void ath10k_scan_finish(struct ath10k *ar);
+void ath10k_scan_timeout_work(struct work_struct *work);
 void ath10k_offchan_tx_purge(struct ath10k *ar);
 void ath10k_offchan_tx_work(struct work_struct *work);
 void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 98bfffd..bd318d9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -811,6 +811,94 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	return ret;
 }
 
+static void ath10k_wmi_event_scan_started(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		ath10k_warn("received scan started event in an invalid scan state: %s (%d)\n",
+			    ath10k_scan_state_str(ar->scan.state),
+			    ar->scan.state);
+		break;
+	case ATH10K_SCAN_STARTING:
+		ar->scan.state = ATH10K_SCAN_RUNNING;
+
+		if (ar->scan.is_roc)
+			ieee80211_ready_on_channel(ar->hw);
+
+		complete(&ar->scan.started);
+		break;
+	}
+}
+
+static void ath10k_wmi_event_scan_completed(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		/* One suspected reason scan can be completed while starting is
+		 * if firmware fails to deliver all scan events to the host,
+		 * e.g. when transport pipe is full. This has been observed
+		 * with spectral scan phyerr events starving wmi transport
+		 * pipe. In such case the "scan completed" event should be (and
+		 * is) ignored by the host as it may be just firmware's scan
+		 * state machine recovering.
+		 */
+		ath10k_warn("received scan completed event in an invalid scan state: %s (%d)\n",
+			    ath10k_scan_state_str(ar->scan.state),
+			    ar->scan.state);
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		__ath10k_scan_finish(ar);
+		break;
+	}
+}
+
+static void ath10k_wmi_event_scan_bss_chan(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn("received scan bss chan event in an invalid scan state: %s (%d)\n",
+			    ath10k_scan_state_str(ar->scan.state),
+			    ar->scan.state);
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		ar->scan_channel = NULL;
+		break;
+	}
+}
+
+static void ath10k_wmi_event_scan_foreign_chan(struct ath10k *ar, u32 freq)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn("received scan foreign chan event in an invalid scan state: %s (%d)\n",
+			    ath10k_scan_state_str(ar->scan.state),
+			    ar->scan.state);
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		ar->scan_channel = ieee80211_get_channel(ar->hw->wiphy, freq);
+
+		if (ar->scan.is_roc && ar->scan.roc_freq == freq)
+			complete(&ar->scan.on_channel);
+		break;
+	}
+}
+
 static const char *
 ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 			       enum wmi_scan_completion_reason reason)
@@ -864,54 +952,32 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 	scan_id    = __le32_to_cpu(event->scan_id);
 	vdev_id    = __le32_to_cpu(event->vdev_id);
 
+	spin_lock_bh(&ar->data_lock);
+
 	ath10k_dbg(ATH10K_DBG_WMI,
-		   "scan event %s type %d reason %d freq %d req_id %d "
-		   "scan_id %d vdev_id %d\n",
+		   "scan event %s type %d reason %d freq %d req_id %d scan_id %d vdev_id %d state %s (%d)\n",
 		   ath10k_wmi_event_scan_type_str(event_type, reason),
-		   event_type, reason, freq, req_id, scan_id, vdev_id);
-
-	spin_lock_bh(&ar->data_lock);
+		   event_type, reason, freq, req_id, scan_id, vdev_id,
+		   ath10k_scan_state_str(ar->scan.state), ar->scan.state);
 
 	switch (event_type) {
 	case WMI_SCAN_EVENT_STARTED:
-		if (ar->scan.in_progress && ar->scan.is_roc)
-			ieee80211_ready_on_channel(ar->hw);
-
-		complete(&ar->scan.started);
+		ath10k_wmi_event_scan_started(ar);
 		break;
 	case WMI_SCAN_EVENT_COMPLETED:
-		ar->scan_channel = NULL;
-		if (!ar->scan.in_progress) {
-			ath10k_warn("no scan requested, ignoring\n");
-			break;
-		}
-
-		if (ar->scan.is_roc) {
-			ath10k_offchan_tx_purge(ar);
-
-			if (!ar->scan.aborting)
-				ieee80211_remain_on_channel_expired(ar->hw);
-		} else {
-			ieee80211_scan_completed(ar->hw, ar->scan.aborting);
-		}
-
-		del_timer(&ar->scan.timeout);
-		complete_all(&ar->scan.completed);
-		ar->scan.in_progress = false;
+		ath10k_wmi_event_scan_completed(ar);
 		break;
 	case WMI_SCAN_EVENT_BSS_CHANNEL:
-		ar->scan_channel = NULL;
+		ath10k_wmi_event_scan_bss_chan(ar);
 		break;
 	case WMI_SCAN_EVENT_FOREIGN_CHANNEL:
-		ar->scan_channel = ieee80211_get_channel(ar->hw->wiphy, freq);
-		if (ar->scan.in_progress && ar->scan.is_roc &&
-		    ar->scan.roc_freq == freq) {
-			complete(&ar->scan.on_channel);
-		}
+		ath10k_wmi_event_scan_foreign_chan(ar, freq);
+		break;
+	case WMI_SCAN_EVENT_START_FAILED:
+		ath10k_warn("received scan start failure event\n");
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
 	case WMI_SCAN_EVENT_PREEMPTED:
-	case WMI_SCAN_EVENT_START_FAILED:
 	default:
 		break;
 	}
@@ -1171,9 +1237,14 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 
 	spin_lock_bh(&ar->data_lock);
 
-	if (!ar->scan.in_progress) {
-		ath10k_warn("chan info event without a scan request?\n");
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn("received chan info event without a scan request, ignoring\n");
 		goto exit;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		break;
 	}
 
 	idx = freq_to_idx(ar, freq);
-- 
1.8.5.3

