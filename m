Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61986 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaJIJt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:49:58 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so832070wgg.13
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 02:49:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: speed up hw recovery
Date: Thu,  9 Oct 2014 11:38:47 +0200
Message-Id: <1412847527-25983-4-git-send-email-michal.kazior@tieto.com> (sfid-20141009_115004_483967_5477B7C6)
In-Reply-To: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
References: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases hw recovery was taking an absurdly
long time due to ath10k waiting for things that
would never really complete.

Instead of waiting for inevitable timeouts poke
all completions and wakequeues and check if it's
still worth waiting.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  5 +++++
 drivers/net/wireless/ath/ath10k/mac.c  | 14 ++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h  |  1 +
 drivers/net/wireless/ath/ath10k/txrx.c |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.c  |  4 ++++
 6 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5000348..11c213f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -685,6 +685,20 @@ static void ath10k_core_restart(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
 
+	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
+	barrier();
+	ieee80211_stop_queues(ar->hw);
+	ath10k_drain_tx(ar);
+	complete_all(&ar->scan.started);
+	complete_all(&ar->scan.completed);
+	complete_all(&ar->scan.on_channel);
+	complete_all(&ar->offchan_tx_completed);
+	complete_all(&ar->install_key_done);
+	complete_all(&ar->vdev_setup_done);
+	wake_up(&ar->htt.empty_tx_wq);
+	wake_up(&ar->wmi.tx_credits_wq);
+	wake_up(&ar->peer_mapping_wq);
+
 	mutex_lock(&ar->conf_mutex);
 
 	switch (ar->state) {
@@ -722,6 +736,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
+
 	ath10k_bmi_start(ar);
 
 	if (ath10k_init_configure_target(ar)) {
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1ac2f14..528802d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -371,6 +371,11 @@ enum ath10k_dev_flags {
 	/* Indicates that ath10k device is during CAC phase of DFS */
 	ATH10K_CAC_RUNNING,
 	ATH10K_FLAG_CORE_REGISTERED,
+
+	/* Device has crashed and needs to restart. This indicates any pending
+	 * waiters should immediately cancel instead of waiting for a time out.
+	 */
+	ATH10K_FLAG_CRASH_FLUSH,
 };
 
 enum ath10k_scan_state {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 001ff1a..f6b4db0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -519,6 +519,9 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+		return -ESHUTDOWN;
+
 	ret = wait_for_completion_timeout(&ar->vdev_setup_done,
 					  ATH10K_VDEV_SETUP_TIMEOUT_HZ);
 	if (ret == 0)
@@ -551,6 +554,8 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 	arg.channel.max_reg_power = channel->max_reg_power * 2;
 	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
 
+	reinit_completion(&ar->vdev_setup_done);
+
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to request monitor vdev %i start: %d\n",
@@ -598,6 +603,8 @@ static int ath10k_monitor_vdev_stop(struct ath10k *ar)
 		ath10k_warn(ar, "failed to put down monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
+	reinit_completion(&ar->vdev_setup_done);
+
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
 		ath10k_warn(ar, "failed to to request monitor vdev %i stop: %d\n",
@@ -2362,7 +2369,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 }
 
 /* Must not be called with conf_mutex held as workers can use that also. */
-static void ath10k_drain_tx(struct ath10k *ar)
+void ath10k_drain_tx(struct ath10k *ar)
 {
 	/* make sure rcu-protected mac80211 tx path itself is drained */
 	synchronize_net();
@@ -3883,7 +3890,9 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			empty = (ar->htt.num_pending_tx == 0);
 			spin_unlock_bh(&ar->htt.tx_lock);
 
-			skip = (ar->state == ATH10K_STATE_WEDGED);
+			skip = (ar->state == ATH10K_STATE_WEDGED) ||
+			       test_bit(ATH10K_FLAG_CRASH_FLUSH,
+					&ar->dev_flags);
 
 			(empty || skip);
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
@@ -3980,6 +3989,7 @@ static void ath10k_restart_complete(struct ieee80211_hw *hw)
 	if (ar->state == ATH10K_STATE_RESTARTED) {
 		ath10k_info(ar, "device successfully recovered\n");
 		ar->state = ATH10K_STATE_ON;
+		ieee80211_wake_queues(ar->hw);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 965c511..4e3c989 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -40,6 +40,7 @@ void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar);
 void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work);
 void ath10k_halt(struct ath10k *ar);
 void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif);
+void ath10k_drain_tx(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index f9c90e3..7579de8 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -146,7 +146,8 @@ static int ath10k_wait_for_peer_common(struct ath10k *ar, int vdev_id,
 			mapped = !!ath10k_peer_find(ar, vdev_id, addr);
 			spin_unlock_bh(&ar->data_lock);
 
-			mapped == expect_mapped;
+			(mapped == expect_mapped ||
+			 test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags));
 		}), 3*HZ);
 
 	if (ret <= 0)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 829fccf..0adfdb8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -779,6 +779,10 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 		ath10k_wmi_tx_beacons_nowait(ar);
 
 		ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
+
+		if (ret && test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+			ret = -ESHUTDOWN;
+
 		(ret != -EAGAIN);
 	}), 3*HZ);
 
-- 
1.8.5.3

