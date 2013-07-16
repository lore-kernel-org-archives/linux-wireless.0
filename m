Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56207 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab3GPHz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:55:58 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/3] ath10k: implement device recovery
Date: Tue, 16 Jul 2013 09:54:35 +0200
Message-ID: <1373961277-14784-2-git-send-email-michal.kazior@tieto.com> (sfid-20130716_095658_617809_F1146B7F)
In-Reply-To: <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
 <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restart the hardware if FW crashes.

If FW crashes during recovery we leave the
hardware in a "wedged" state to avoid recursive
recoveries.

When in "wedged" state userspace may bring
interfaces down (to issue stop()) and then bring
one interface (to issue start()) to reload
hardware manually.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   30 ++++++++++
 drivers/net/wireless/ath/ath10k/core.h |   19 ++++++
 drivers/net/wireless/ath/ath10k/htc.c  |    3 +
 drivers/net/wireless/ath/ath10k/mac.c  |  101 ++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/mac.h  |    1 +
 drivers/net/wireless/ath/ath10k/pci.c  |    2 +
 drivers/net/wireless/ath/ath10k/wmi.c  |    7 +++
 7 files changed, 144 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c37f79f..7226c23 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -476,6 +476,34 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_core_restart(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
+
+	mutex_lock(&ar->conf_mutex);
+
+	switch (ar->state) {
+	case ATH10K_STATE_ON:
+		ath10k_halt(ar);
+		ar->state = ATH10K_STATE_RESTARTING;
+		ieee80211_restart_hw(ar->hw);
+		break;
+	case ATH10K_STATE_OFF:
+		/* this can happen if driver is being unloaded */
+		ath10k_warn("cannot restart a device that hasn't been started\n");
+		break;
+	case ATH10K_STATE_RESTARTING:
+	case ATH10K_STATE_RESTARTED:
+		ar->state = ATH10K_STATE_WEDGED;
+		/* fall through */
+	case ATH10K_STATE_WEDGED:
+		ath10k_warn("device is wedged, will not restart\n");
+		break;
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops)
 {
@@ -519,6 +547,8 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 
 	init_waitqueue_head(&ar->event_queue);
 
+	INIT_WORK(&ar->restart_work, ath10k_core_restart);
+
 	return ar;
 
 err_wq:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 413f1c5..9f21ecb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -250,6 +250,23 @@ struct ath10k_debug {
 enum ath10k_state {
 	ATH10K_STATE_OFF = 0,
 	ATH10K_STATE_ON,
+
+	/* When doing firmware recovery the device is first powered down.
+	 * mac80211 is supposed to call in to start() hook later on. It is
+	 * however possible that driver unloading and firmware crash overlap.
+	 * mac80211 can wait on conf_mutex in stop() while the device is
+	 * stopped in ath10k_core_restart() work holding conf_mutex. The state
+	 * RESTARTED means that the device is up and mac80211 has started hw
+	 * reconfiguration. Once mac80211 is done with the reconfiguration we
+	 * set the state to STATE_ON in restart_complete(). */
+	ATH10K_STATE_RESTARTING,
+	ATH10K_STATE_RESTARTED,
+
+	/* The device has crashed while restarting hw. This state is like ON
+	 * but commands are blocked in HTC and -ECOMM response is given. This
+	 * prevents completion timeouts and makes the driver more responsive to
+	 * userspace commands. This is also prevents recursive recovery. */
+	ATH10K_STATE_WEDGED,
 };
 
 struct ath10k {
@@ -355,6 +372,8 @@ struct ath10k {
 
 	enum ath10k_state state;
 
+	struct work_struct restart_work;
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7d5a366..72e072c 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -246,6 +246,9 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 {
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 
+	if (htc->ar->state == ATH10K_STATE_WEDGED)
+		return -ECOMM;
+
 	if (eid >= ATH10K_HTC_EP_COUNT) {
 		ath10k_warn("Invalid endpoint id: %d\n", eid);
 		return -ENOENT;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2dfd446..b1bb318 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1738,7 +1738,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 /*
  * Initialize various parameters with default vaules.
  */
-static void ath10k_halt(struct ath10k *ar)
+void ath10k_halt(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1764,7 +1764,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->state != ATH10K_STATE_OFF) {
+	if (ar->state != ATH10K_STATE_OFF &&
+	    ar->state != ATH10K_STATE_RESTARTING) {
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -1784,6 +1785,11 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
+	if (ar->state == ATH10K_STATE_OFF)
+		ar->state = ATH10K_STATE_ON;
+	else if (ar->state == ATH10K_STATE_RESTARTING)
+		ar->state = ATH10K_STATE_RESTARTED;
+
 	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS, 1);
 	if (ret)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
@@ -1806,22 +1812,47 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	if (ar->state == ATH10K_STATE_ON)
+	if (ar->state == ATH10K_STATE_ON ||
+	    ar->state == ATH10K_STATE_RESTARTED ||
+	    ar->state == ATH10K_STATE_WEDGED)
 		ath10k_halt(ar);
 
 	ar->state = ATH10K_STATE_OFF;
 	mutex_unlock(&ar->conf_mutex);
 
 	cancel_work_sync(&ar->offchan_tx_work);
+	cancel_work_sync(&ar->restart_work);
 }
 
-static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
+static void ath10k_config_ps(struct ath10k *ar)
 {
 	struct ath10k_generic_iter ar_iter;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	/* During HW reconfiguration mac80211 reports all interfaces that were
+	 * running until reconfiguration was started. Since FW doesn't have any
+	 * vdevs at this point we must not iterate over this interface list.
+	 * This setting will be updated upon add_interface(). */
+	if (ar->state == ATH10K_STATE_RESTARTED)
+		return;
+
+	memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
+	ar_iter.ar = ar;
+
+	ieee80211_iterate_active_interfaces_atomic(
+		ar->hw, IEEE80211_IFACE_ITER_NORMAL,
+		ath10k_ps_iter, &ar_iter);
+
+	if (ar_iter.ret)
+		ath10k_warn("failed to set ps config (%d)\n", ar_iter.ret);
+}
+
+static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
+{
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
-	u32 flags;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -1833,18 +1864,8 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&ar->data_lock);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
-		ar_iter.ar = ar;
-		flags = IEEE80211_IFACE_ITER_RESUME_ALL;
-
-		ieee80211_iterate_active_interfaces_atomic(hw,
-							   flags,
-							   ath10k_ps_iter,
-							   &ar_iter);
-
-		ret = ar_iter.ret;
-	}
+	if (changed & IEEE80211_CONF_CHANGE_PS)
+		ath10k_config_ps(ar);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (conf->flags & IEEE80211_CONF_MONITOR)
@@ -1853,6 +1874,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 			ret = ath10k_monitor_destroy(ar);
 	}
 
+	ath10k_wmi_flush_tx(ar);
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 }
@@ -2695,6 +2717,13 @@ static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
+	/* During HW reconfiguration mac80211 reports all interfaces that were
+	 * running until reconfiguration was started. Since FW doesn't have any
+	 * vdevs at this point we must not iterate over this interface list.
+	 * This setting will be updated upon add_interface(). */
+	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
+		return;
+
 	rts = min_t(u32, rts, ATH10K_RTS_MAX);
 
 	ar_iter->ret = ath10k_wmi_vdev_set_param(ar_iter->ar, arvif->vdev_id,
@@ -2735,6 +2764,13 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
+	/* During HW reconfiguration mac80211 reports all interfaces that were
+	 * running until reconfiguration was started. Since FW doesn't have any
+	 * vdevs at this point we must not iterate over this interface list.
+	 * This setting will be updated upon add_interface(). */
+	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
+		return;
+
 	frag = clamp_t(u32, frag,
 		       ATH10K_FRAGMT_THRESHOLD_MIN,
 		       ATH10K_FRAGMT_THRESHOLD_MAX);
@@ -2773,6 +2809,7 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct ath10k *ar = hw->priv;
+	bool skip;
 	int ret;
 
 	/* mac80211 doesn't care if we really xmit queued frames or not
@@ -2782,17 +2819,26 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (ar->state == ATH10K_STATE_WEDGED)
+		goto skip;
+
 	ret = wait_event_timeout(ar->htt.empty_tx_wq, ({
 			bool empty;
+
 			spin_lock_bh(&ar->htt.tx_lock);
 			empty = bitmap_empty(ar->htt.used_msdu_ids,
 					     ar->htt.max_num_pending_tx);
 			spin_unlock_bh(&ar->htt.tx_lock);
-			(empty);
+
+			skip = (ar->state == ATH10K_STATE_WEDGED);
+
+			(empty || skip);
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
-	if (ret <= 0)
+
+	if (ret <= 0 || skip)
 		ath10k_warn("tx not flushed\n");
 
+skip:
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -2866,6 +2912,22 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 }
 #endif
 
+static void ath10k_restart_complete(struct ieee80211_hw *hw)
+{
+	struct ath10k *ar = hw->priv;
+
+	mutex_lock(&ar->conf_mutex);
+
+	/* If device failed to restart it will be in a different state, e.g.
+	 * ATH10K_STATE_WEDGED */
+	if (ar->state == ATH10K_STATE_RESTARTED) {
+		ath10k_info("device successfully recovered\n");
+		ar->state = ATH10K_STATE_ON;
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -2886,6 +2948,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_frag_threshold		= ath10k_set_frag_threshold,
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
+	.restart_complete		= ath10k_restart_complete,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 27fc92e..6fce9bf 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -34,6 +34,7 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id);
 void ath10k_reset_scan(unsigned long ptr);
 void ath10k_offchan_tx_purge(struct ath10k *ar);
 void ath10k_offchan_tx_work(struct work_struct *work);
+void ath10k_halt(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bfe8561..c71b488 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -720,6 +720,8 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 1],
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
+
+	ieee80211_queue_work(ar->hw, &ar->restart_work);
 }
 
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b7e7e45..0d25cd7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -27,6 +27,13 @@ void ath10k_wmi_flush_tx(struct ath10k *ar)
 {
 	int ret;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ar->state == ATH10K_STATE_WEDGED) {
+		ath10k_warn("wmi flush skipped - device is wedged anyway\n");
+		return;
+	}
+
 	ret = wait_event_timeout(ar->wmi.wq,
 				 atomic_read(&ar->wmi.pending_tx_count) == 0,
 				 5*HZ);
-- 
1.7.9.5

