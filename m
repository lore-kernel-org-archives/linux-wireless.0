Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41656 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 03/31] wlcore: Prevent interaction with HW after recovery is queued
Date: Thu, 27 Sep 2012 13:37:41 +0300
Message-Id: <1348742289-6587-4-git-send-email-luca@coelho.fi> (sfid-20120927_124020_211259_5B91E3F4)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

When a function requests to recover, it would normally abort and will
not send any additional commands to the HW. However, other threads may
not be aware of the failure and could try to communicate with the HW
after a recovery was queued, but before the recovery work began.

Fix this by introducing an intermediate state which is set when recovery
is queued, and modify all state checks accordingly.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/debugfs.c  |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c      |    3 ++
 drivers/net/wireless/ti/wlcore/debugfs.c  |   15 +++---
 drivers/net/wireless/ti/wlcore/io.h       |    4 +-
 drivers/net/wireless/ti/wlcore/main.c     |   73 ++++++++++++++---------------
 drivers/net/wireless/ti/wlcore/ps.c       |    2 +-
 drivers/net/wireless/ti/wlcore/scan.c     |    2 +-
 drivers/net/wireless/ti/wlcore/testmode.c |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    7 +--
 11 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 3ce6f10..7f1669c 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -220,7 +220,7 @@ static ssize_t clear_fw_stats_write(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl18xx_acx_clear_statistics(wl);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 20e1bd9..b63995d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -59,6 +59,9 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	u16 status;
 	u16 poll_count = 0;
 
+	if (WARN_ON(unlikely(wl->state == WLCORE_STATE_RESTARTING)))
+		return -EIO;
+
 	cmd = buf;
 	cmd->id = cpu_to_le16(id);
 	cmd->status = 0;
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 80dbc53..3b7e0e8 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -62,11 +62,14 @@ void wl1271_debugfs_update_stats(struct wl1271 *wl)
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	if (wl->state == WL1271_STATE_ON && !wl->plt &&
+	if (!wl->plt &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
 		       msecs_to_jiffies(WL1271_DEBUGFS_STATS_LIFETIME))) {
 		wl1271_acx_statistics(wl, wl->stats.fw_stats);
@@ -286,7 +289,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 
 	wl->conf.conn.dynamic_ps_timeout = value;
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -353,7 +356,7 @@ static ssize_t forced_ps_write(struct file *file,
 
 	wl->conf.conn.forced_ps = value;
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -999,7 +1002,7 @@ static ssize_t sleep_auth_write(struct file *file,
 
 	wl->conf.conn.sta_sleep_auth = value;
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		/* this will show up on "read" in case we are off */
 		wl->sleep_auth = value;
 		goto out;
@@ -1060,7 +1063,7 @@ static ssize_t dev_mem_read(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EFAULT;
 		goto skip_read;
 	}
@@ -1145,7 +1148,7 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EFAULT;
 		goto skip_write;
 	}
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 259149f..f48530f 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -64,7 +64,7 @@ static inline int __must_check wlcore_raw_write(struct wl1271 *wl, int addr,
 		return -EIO;
 
 	ret = wl->if_ops->write(wl->dev, addr, buf, len, fixed);
-	if (ret && wl->state != WL1271_STATE_OFF)
+	if (ret && wl->state != WLCORE_STATE_OFF)
 		set_bit(WL1271_FLAG_IO_FAILED, &wl->flags);
 
 	return ret;
@@ -80,7 +80,7 @@ static inline int __must_check wlcore_raw_read(struct wl1271 *wl, int addr,
 		return -EIO;
 
 	ret = wl->if_ops->read(wl->dev, addr, buf, len, fixed);
-	if (ret && wl->state != WL1271_STATE_OFF)
+	if (ret && wl->state != WLCORE_STATE_OFF)
 		set_bit(WL1271_FLAG_IO_FAILED, &wl->flags);
 
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f421c42..21267c5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -248,7 +248,7 @@ static void wl12xx_tx_watchdog_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	/* Tx went out in the meantime - everything is ok */
@@ -512,7 +512,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -776,6 +776,7 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 
 	/* Avoid a recursive recovery */
 	if (!test_and_set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+		wl->state = WLCORE_STATE_RESTARTING;
 		wlcore_disable_interrupts_nosync(wl);
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
@@ -913,7 +914,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state != WL1271_STATE_ON || wl->plt)
+	if (wl->state == WLCORE_STATE_OFF || wl->plt)
 		goto out_unlock;
 
 	if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
@@ -1081,7 +1082,7 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 
 	wl1271_notice("power up");
 
-	if (wl->state != WL1271_STATE_OFF) {
+	if (wl->state != WLCORE_STATE_OFF) {
 		wl1271_error("cannot go into PLT state because not "
 			     "in off state: %d", wl->state);
 		ret = -EBUSY;
@@ -1102,7 +1103,7 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 		if (ret < 0)
 			goto power_off;
 
-		wl->state = WL1271_STATE_ON;
+		wl->state = WLCORE_STATE_ON;
 		wl1271_notice("firmware booted in PLT mode %s (%s)",
 			      PLT_MODE[plt_mode],
 			      wl->chip.fw_ver_str);
@@ -1171,7 +1172,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	wl1271_power_off(wl);
 	wl->flags = 0;
 	wl->sleep_auth = WL1271_PSM_ILLEGAL;
-	wl->state = WL1271_STATE_OFF;
+	wl->state = WLCORE_STATE_OFF;
 	wl->plt = false;
 	wl->plt_mode = PLT_OFF;
 	wl->rx_counter = 0;
@@ -1833,7 +1834,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 {
 	int i;
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (wl->state == WLCORE_STATE_OFF) {
 		if (test_and_clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 					&wl->flags))
 			wlcore_enable_interrupts(wl);
@@ -1845,7 +1846,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
-	wl->state = WL1271_STATE_OFF;
+	wl->state = WLCORE_STATE_OFF;
 
 	/*
 	 * Use the nosync variant to disable interrupts, so the mutex could be
@@ -2098,7 +2099,7 @@ irq_disable:
 		/* Unlocking the mutex in the middle of handling is
 		   inherently unsafe. In this case we deem it safe to do,
 		   because we need to let any possibly pending IRQ out of
-		   the system (and while we are WL1271_STATE_OFF the IRQ
+		   the system (and while we are WLCORE_STATE_OFF the IRQ
 		   work function will not do anything.) Also, any other
 		   possible concurrent operations will fail due to the
 		   current state, hence the wl1271 struct should be safe. */
@@ -2133,7 +2134,7 @@ power_off:
 	wl1271_debug(DEBUG_MAC80211, "11a is %ssupported",
 		     wl->enable_11a ? "" : "not ");
 
-	wl->state = WL1271_STATE_ON;
+	wl->state = WLCORE_STATE_ON;
 out:
 	return booted;
 }
@@ -2167,7 +2168,7 @@ static bool wl12xx_need_fw_change(struct wl1271 *wl,
 	wl->last_vif_count = vif_count;
 
 	/* no need for fw change if the device is OFF */
-	if (wl->state == WL1271_STATE_OFF)
+	if (wl->state == WLCORE_STATE_OFF)
 		return false;
 
 	/* no need for fw change if a single fw is used */
@@ -2253,7 +2254,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	 * TODO: after the nvs issue will be solved, move this block
 	 * to start(), and make sure here the driver is ON.
 	 */
-	if (wl->state == WL1271_STATE_OFF) {
+	if (wl->state == WLCORE_STATE_OFF) {
 		/*
 		 * we still need this in order to configure the fw
 		 * while uploading the nvs
@@ -2320,7 +2321,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		return;
 
 	/* because of hardware recovery, we may get here twice */
-	if (wl->state != WL1271_STATE_ON)
+	if (wl->state == WLCORE_STATE_OFF)
 		return;
 
 	wl1271_info("down");
@@ -2441,7 +2442,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	wl12xx_get_vif_count(hw, vif, &vif_count);
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF ||
+	if (wl->state == WLCORE_STATE_OFF ||
 	    !test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
 		goto out;
 
@@ -2776,7 +2777,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		wl->power_level = conf->power_level;
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -2810,10 +2811,6 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw,
 {
 	struct wl1271_filter_params *fp;
 	struct netdev_hw_addr *ha;
-	struct wl1271 *wl = hw->priv;
-
-	if (unlikely(wl->state == WL1271_STATE_OFF))
-		return 0;
 
 	fp = kzalloc(sizeof(*fp), GFP_ATOMIC);
 	if (!fp) {
@@ -2862,7 +2859,7 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	*total &= WL1271_SUPPORTED_FILTERS;
 	changed &= WL1271_SUPPORTED_FILTERS;
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -3111,7 +3108,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3225,7 +3222,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		/*
 		 * We cannot return -EBUSY here because cfg80211 will expect
 		 * a call to ieee80211_scan_completed if we do - in this case
@@ -3265,7 +3262,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
@@ -3314,7 +3311,7 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EAGAIN;
 		goto out;
 	}
@@ -3351,7 +3348,7 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -3372,7 +3369,7 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EAGAIN;
 		goto out;
 	}
@@ -3401,7 +3398,7 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EAGAIN;
 		goto out;
 	}
@@ -4177,7 +4174,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
@@ -4261,7 +4258,7 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -4460,7 +4457,7 @@ static int wl12xx_op_sta_state(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -4499,7 +4496,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EAGAIN;
 		goto out;
 	}
@@ -4617,7 +4614,7 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 						    mask->control[i].legacy,
 						    i);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
@@ -4653,12 +4650,14 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		wl12xx_for_each_wlvif_sta(wl, wlvif) {
 			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 			ieee80211_chswitch_done(vif, false);
 		}
 		goto out;
+	} else if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		goto out;
 	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -4693,7 +4692,7 @@ static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	/* packets are considered pending if in the TX queue or the FW */
@@ -4942,7 +4941,7 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 
 	wl->sg_enabled = res;
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -5060,7 +5059,7 @@ static void wl1271_connection_loss_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	/* Call mac80211 connection loss */
@@ -5396,7 +5395,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 
 	spin_lock_init(&wl->wl_lock);
 
-	wl->state = WL1271_STATE_OFF;
+	wl->state = WLCORE_STATE_OFF;
 	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	mutex_init(&wl->mutex);
 	mutex_init(&wl->flush_mutex);
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 46d36fd..e904d68 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -44,7 +44,7 @@ void wl1271_elp_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	/* our work might have been already cancelled */
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index dbeca1b..bc92487 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -46,7 +46,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 49e5ee1..f344276 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -92,7 +92,7 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -164,7 +164,7 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 1a2f31c..4f66e75 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -687,7 +687,7 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 	int bus_ret = 0;
 	u8 hlid;
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state != WLCORE_STATE_ON))
 		return 0;
 
 	while ((skb = wl1271_skb_dequeue(wl, &hlid))) {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0ce7a8e..81790a0 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -153,7 +153,7 @@ struct wl1271 {
 
 	spinlock_t wl_lock;
 
-	enum wl1271_state state;
+	enum wlcore_state state;
 	enum wl12xx_fw_type fw_type;
 	bool plt;
 	enum plt_mode plt_mode;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index c050563..58fbdca 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -85,9 +85,10 @@
 
 #define WL1271_AGGR_BUFFER_SIZE (5 * PAGE_SIZE)
 
-enum wl1271_state {
-	WL1271_STATE_OFF,
-	WL1271_STATE_ON,
+enum wlcore_state {
+	WLCORE_STATE_OFF,
+	WLCORE_STATE_RESTARTING,
+	WLCORE_STATE_ON,
 };
 
 enum wl12xx_fw_type {
-- 
1.7.10.4

