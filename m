Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50295 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaGULUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 07:20:13 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so3934623wib.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 04:20:09 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, sw@simonwunderlich.de,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: introduce a stricter scan state machine
Date: Mon, 21 Jul 2014 13:11:20 +0200
Message-Id: <1405941081-17359-2-git-send-email-michal.kazior@tieto.com> (sfid-20140721_132019_391285_022E8DFD)
In-Reply-To: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
References: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This aims at fixing some rare scan bugs related to
firmware reporting unexpected scan event
sequences.

One such bug was if spectral scan phyerr reporting
prevented firmware from properly propagating scan
events to host. This leadsl to scan timeout. After
that next scan would trigger scan completed event
first (before scan started event) leading to
ar->scan.in_progress and timeout timer states to
be overwritten incorrectly and making the very
next scan to hang forever.

Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   4 +-
 drivers/net/wireless/ath/ath10k/core.h |  10 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 219 +++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/mac.h  |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 144 +++++++++++++++++-----
 5 files changed, 252 insertions(+), 128 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 93adb8c..f2e89f4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -652,7 +652,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
 		del_timer_sync(&ar->scan.timeout);
-		ath10k_reset_scan((unsigned long)ar);
+		ath10k_scan_reset(ar, true);
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
@@ -1062,7 +1062,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
 
-	setup_timer(&ar->scan.timeout, ath10k_reset_scan, (unsigned long)ar);
+	setup_timer(&ar->scan.timeout, ath10k_scan_timeout, (unsigned long)ar);
 
 	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
 	if (!ar->workqueue)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 83a5fa9..2498d4f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -341,6 +341,13 @@ enum ath10k_dev_flags {
 	ATH10K_FLAG_CORE_REGISTERED,
 };
 
+enum ath10k_scan_state {
+	ATH10K_SCAN_IDLE,
+	ATH10K_SCAN_STARTING,
+	ATH10K_SCAN_RUNNING,
+	ATH10K_SCAN_RUNNING_AND_ABORTING,
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -411,9 +418,8 @@ struct ath10k {
 		struct completion completed;
 		struct completion on_channel;
 		struct timer_list timeout;
+		enum ath10k_scan_state state;
 		bool is_roc;
-		bool in_progress;
-		bool aborting;
 		int vdev_id;
 		int roc_freq;
 	} scan;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b8314a5..a22744b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2138,34 +2138,43 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 /* Scanning */
 /************/
 
-/*
- * This gets called if we dont get a heart-beat during scan.
- * This may indicate the FW has hung and we need to abort the
- * scan manually to prevent cancel_hw_scan() from deadlocking
- */
-void ath10k_reset_scan(unsigned long ptr)
+void ath10k_scan_reset(struct ath10k *ar, bool notify)
 {
-	struct ath10k *ar = (struct ath10k *)ptr;
-
 	spin_lock_bh(&ar->data_lock);
-	if (!ar->scan.in_progress) {
-		spin_unlock_bh(&ar->data_lock);
-		return;
-	}
 
-	ath10k_warn("scan timed out, firmware problem?\n");
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		break;
+	case ATH10K_SCAN_STARTING:
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		ath10k_warn("clearing scan state\n");
+
+		if (notify) {
+			if (ar->scan.is_roc)
+				ieee80211_remain_on_channel_expired(ar->hw);
+			else
+				ieee80211_scan_completed(ar->hw,
+							 1 /* aborted */);
+		}
 
-	if (ar->scan.is_roc)
-		ieee80211_remain_on_channel_expired(ar->hw);
-	else
-		ieee80211_scan_completed(ar->hw, 1 /* aborted */);
+		ar->scan.state = ATH10K_SCAN_IDLE;
+		ath10k_offchan_tx_purge(ar);
+		complete_all(&ar->scan.completed);
+		break;
+	}
 
-	ar->scan.in_progress = false;
-	complete_all(&ar->scan.completed);
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static int ath10k_abort_scan(struct ath10k *ar)
+void ath10k_scan_timeout(unsigned long ptr)
+{
+	struct ath10k *ar = (struct ath10k *)ptr;
+
+	ath10k_scan_reset(ar, true);
+}
+
+static int ath10k_stop_scan(struct ath10k *ar)
 {
 	struct wmi_stop_scan_arg arg = {
 		.req_id = 1, /* FIXME */
@@ -2174,49 +2183,66 @@ static int ath10k_abort_scan(struct ath10k *ar)
 	};
 	int ret;
 
+	ret = ath10k_wmi_stop_scan(ar, &arg);
+	if (ret) {
+		ath10k_warn("failed to stop wmi scan: %d\n", ret);
+		goto out;
+	}
+
+	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
+	if (ret == 0) {
+		ath10k_warn("failed to receive scan abortion completion: timed out\n");
+		ret = -ETIMEDOUT;
+	} else if (ret > 0) {
+		ret = 0;
+	}
+
+out:
+	/* Scan state should be updated upon scan completion but in case
+	 * firmware fails it is still desired to reset the scan state to avoid
+	 * scan request being refused later. There's a chance firmware will
+	 * recover on its own without a restart in due time.
+	 */
+	ath10k_scan_reset(ar, false);
+
+	return ret;
+}
+
+static void ath10k_abort_scan(struct ath10k *ar)
+{
+	int ret;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	del_timer_sync(&ar->scan.timeout);
 
 	spin_lock_bh(&ar->data_lock);
-	if (!ar->scan.in_progress) {
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		ath10k_warn("cannot abort scan: it is idle\n");
+		goto unlock;
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn("cannot abort scan: it is starting\n");
+		goto unlock;
+	case ATH10K_SCAN_RUNNING:
+		ar->scan.state = ATH10K_SCAN_RUNNING_AND_ABORTING;
 		spin_unlock_bh(&ar->data_lock);
-		return 0;
-	}
 
-	ar->scan.aborting = true;
-	spin_unlock_bh(&ar->data_lock);
+		ret = ath10k_stop_scan(ar);
+		if (ret)
+			ath10k_warn("failed to abort scan: %d\n", ret);
 
-	ret = ath10k_wmi_stop_scan(ar, &arg);
-	if (ret) {
-		ath10k_warn("failed to stop wmi scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
-		ath10k_offchan_tx_purge(ar);
-		spin_unlock_bh(&ar->data_lock);
-		return -EIO;
+		break;
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		ath10k_warn("cannot abort scan: it is already being aborted\n");
+		goto unlock;
 	}
 
-	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
-	if (ret == 0)
-		ath10k_warn("timed out while waiting for scan to stop\n");
-
-	/* scan completion may be done right after we timeout here, so let's
-	 * check the in_progress and tell mac80211 scan is completed. if we
-	 * don't do that and FW fails to send us scan completion indication
-	 * then userspace won't be able to scan anymore */
-	ret = 0;
-
-	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		ath10k_warn("failed to stop scan, it's still in progress\n");
-		ar->scan.in_progress = false;
-		ath10k_offchan_tx_purge(ar);
-		ret = -ETIMEDOUT;
-	}
+unlock:
 	spin_unlock_bh(&ar->data_lock);
-
-	return ret;
+	return;
 }
 
 static int ath10k_start_scan(struct ath10k *ar,
@@ -2232,15 +2258,14 @@ static int ath10k_start_scan(struct ath10k *ar,
 
 	ret = wait_for_completion_timeout(&ar->scan.started, 1*HZ);
 	if (ret == 0) {
-		ath10k_abort_scan(ar);
-		return ret;
+		ret = ath10k_stop_scan(ar);
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
+	/* Add a 200ms margin to account for event/command processing */
 	mod_timer(&ar->scan.timeout, jiffies +
 		  msecs_to_jiffies(arg->max_scan_time+200));
 	return 0;
@@ -2323,8 +2348,6 @@ void ath10k_halt(struct ath10k *ar)
 		ath10k_monitor_stop(ar);
 	}
 
-	del_timer_sync(&ar->scan.timeout);
-	ath10k_reset_scan((unsigned long)ar);
 	ath10k_peer_cleanup_all(ar);
 	ath10k_core_stop(ar);
 	ath10k_hif_power_down(ar);
@@ -3149,20 +3172,26 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
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
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
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
@@ -3196,8 +3225,9 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 	if (ret) {
 		ath10k_warn("failed to start hw scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
+		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
+		goto exit;
 	}
 
 exit:
@@ -3209,14 +3239,9 @@ static void ath10k_cancel_hw_scan(struct ieee80211_hw *hw,
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
+	ath10k_abort_scan(ar);
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -3639,27 +3664,33 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
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
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
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
@@ -3676,7 +3707,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	if (ret) {
 		ath10k_warn("failed to start roc scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
-		ar->scan.in_progress = false;
+		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
 		goto exit;
 	}
@@ -3684,7 +3715,11 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
 	if (ret == 0) {
 		ath10k_warn("failed to switch to channel for roc scan\n");
-		ath10k_abort_scan(ar);
+
+		ret = ath10k_stop_scan(ar);
+		if (ret)
+			ath10k_warn("failed to stop scan: %d\n", ret);
+
 		ret = -ETIMEDOUT;
 		goto exit;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index ba10219..19e63c0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -31,7 +31,8 @@ void ath10k_mac_destroy(struct ath10k *ar);
 int ath10k_mac_register(struct ath10k *ar);
 void ath10k_mac_unregister(struct ath10k *ar);
 struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id);
-void ath10k_reset_scan(unsigned long ptr);
+void ath10k_scan_reset(struct ath10k *ar, bool notify);
+void ath10k_scan_timeout(unsigned long ptr);
 void ath10k_offchan_tx_purge(struct ath10k *ar);
 void ath10k_offchan_tx_work(struct work_struct *work);
 void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6f83cae..7ff5280 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -690,6 +690,108 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	return ret;
 }
 
+static void ath10k_wmi_event_scan_started(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		ath10k_warn("received scan started event without a scan request, ignoring\n");
+		break;
+	case ATH10K_SCAN_STARTING:
+		ar->scan.state = ATH10K_SCAN_RUNNING;
+
+		if (ar->scan.is_roc)
+			ieee80211_ready_on_channel(ar->hw);
+
+		complete(&ar->scan.started);
+		break;
+	case ATH10K_SCAN_RUNNING:
+		ath10k_warn("received scan started event but scan is already running, ignoring\n");
+		break;
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		ath10k_warn("received scan started event but scan is aborting, ignoring\n");
+		break;
+	}
+}
+
+static void ath10k_wmi_event_scan_completed(struct ath10k *ar)
+{
+	int aborting = 0;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+		ath10k_warn("received unexpected scan event: completed while idle\n");
+		break;
+	case ATH10K_SCAN_STARTING:
+		/* One suspected reason this can happen is if firmware doesn't
+		 * deliver some scan events to the host for, e.g. when
+		 * transport pipe is full. This has been observed with spectral
+		 * scan phyerr events starving wmi transport pipe. In such case
+		 * the "scan completed" event should be (and is) ignored.
+		 */
+		ath10k_warn("received unexpected scan event: completed while starting\n");
+		break;
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		aborting = 1;
+		/* fall through */
+	case ATH10K_SCAN_RUNNING:
+		ar->scan_channel = NULL;
+
+		if (ar->scan.is_roc) {
+			ath10k_offchan_tx_purge(ar);
+
+			if (!aborting)
+				ieee80211_remain_on_channel_expired(ar->hw);
+		} else {
+			ieee80211_scan_completed(ar->hw, aborting);
+		}
+
+		ar->scan.state = ATH10K_SCAN_IDLE;
+		del_timer(&ar->scan.timeout);
+		complete_all(&ar->scan.completed);
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
+		break;
+	case ATH10K_SCAN_STARTING:
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
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
+		break;
+	case ATH10K_SCAN_STARTING:
+		break;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		ar->scan_channel = ieee80211_get_channel(ar->hw->wiphy, freq);
+
+		if (ar->scan.is_roc && ar->scan.roc_freq == freq)
+			complete(&ar->scan.on_channel);
+
+		break;
+	}
+}
+
 static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_scan_event *event = (struct wmi_scan_event *)skb->data;
@@ -718,10 +820,7 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 	switch (event_type) {
 	case WMI_SCAN_EVENT_STARTED:
 		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_STARTED\n");
-		if (ar->scan.in_progress && ar->scan.is_roc)
-			ieee80211_ready_on_channel(ar->hw);
-
-		complete(&ar->scan.started);
+		ath10k_wmi_event_scan_started(ar);
 		break;
 	case WMI_SCAN_EVENT_COMPLETED:
 		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_COMPLETED\n");
@@ -741,37 +840,15 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		default:
 			break;
 		}
-
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
 		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_BSS_CHANNEL\n");
-		ar->scan_channel = NULL;
+		ath10k_wmi_event_scan_bss_chan(ar);
 		break;
 	case WMI_SCAN_EVENT_FOREIGN_CHANNEL:
 		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_FOREIGN_CHANNEL\n");
-		ar->scan_channel = ieee80211_get_channel(ar->hw->wiphy, freq);
-		if (ar->scan.in_progress && ar->scan.is_roc &&
-		    ar->scan.roc_freq == freq) {
-			complete(&ar->scan.on_channel);
-		}
+		ath10k_wmi_event_scan_foreign_chan(ar, freq);
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
 		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_DEQUEUED\n");
@@ -1041,9 +1118,14 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 
 	spin_lock_bh(&ar->data_lock);
 
-	if (!ar->scan.in_progress) {
-		ath10k_warn("chan info event without a scan request?\n");
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn("received chan info event without a scan request, ignoring\n");
 		goto exit;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_RUNNING_AND_ABORTING:
+		break;
 	}
 
 	idx = freq_to_idx(ar, freq);
-- 
1.8.5.3

