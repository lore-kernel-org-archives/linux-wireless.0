Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37665 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab0I0Iix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:53 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8clXu013190
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:51 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 22/25] wl1271: Add hardware recovery mechanism
Date: Mon, 27 Sep 2010 11:37:46 +0300
Message-Id: <1285576669-8070-23-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

There is some probability of hardware failures, which currently go largely
undetected. Attempt to recover from these failures by shutting down the
hardware, and requesting mac80211 to reconfigure it.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 +++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    5 ++++-
 drivers/net/wireless/wl12xx/wl1271_main.c |   28 +++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_ps.c   |    3 ++-
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 55ec656..b5369a6 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -410,6 +410,9 @@ struct wl1271 {
 	/* The target interrupt mask */
 	struct work_struct irq_work;
 
+	/* Hardware recovery work */
+	struct work_struct recovery_work;
+
 	/* The mbox event mask */
 	u32 event_mask;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 06b14f2..170b5a8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -94,6 +94,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	status = le16_to_cpu(cmd->status);
 	if (status != CMD_STATUS_SUCCESS) {
 		wl1271_error("command execute failure %d", status);
+		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 		ret = -EIO;
 	}
 
@@ -182,8 +183,10 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 	timeout = jiffies + msecs_to_jiffies(WL1271_EVENT_TIMEOUT);
 
 	do {
-		if (time_after(jiffies, timeout))
+		if (time_after(jiffies, timeout)) {
+			ieee80211_queue_work(wl->hw, &wl->recovery_work);
 			return -ETIMEDOUT;
+		}
 
 		msleep(1);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 00da982..6e98c75 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -235,6 +235,9 @@ static struct conf_drv_settings default_conf = {
 	}
 };
 
+static void __wl1271_op_remove_interface(struct wl1271 *wl);
+
+
 static void wl1271_device_release(struct device *dev)
 {
 
@@ -612,6 +615,26 @@ out:
 	return ret;
 }
 
+static void wl1271_recovery_work(struct work_struct *work)
+{
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, recovery_work);
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state != WL1271_STATE_ON)
+		goto out;
+
+	wl1271_info("Hardware recovery in progress.");
+
+	/* reboot the chipset */
+	__wl1271_op_remove_interface(wl);
+	ieee80211_restart_hw(wl->hw);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wl1271_fw_wakeup(struct wl1271 *wl)
 {
 	u32 elp_reg;
@@ -635,6 +658,7 @@ static int wl1271_setup(struct wl1271 *wl)
 	INIT_WORK(&wl->irq_work, wl1271_irq_work);
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
+	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 
 	return 0;
 }
@@ -793,11 +817,11 @@ out:
 	mutex_unlock(&wl->mutex);
 
 	cancel_work_sync(&wl->irq_work);
+	cancel_work_sync(&wl->recovery_work);
 
 	return ret;
 }
 
-
 static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
@@ -1046,6 +1070,8 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	WARN_ON(wl->vif != vif);
 	__wl1271_op_remove_interface(wl);
 	mutex_unlock(&wl->mutex);
+
+	cancel_work_sync(&wl->recovery_work);
 }
 
 static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 150dc67..e3c332e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -64,7 +64,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	    test_bit(WL1271_FLAG_IDLE, &wl->flags)) {
 		cancel_delayed_work(&wl->elp_work);
 		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
-					msecs_to_jiffies(ELP_ENTRY_DELAY));
+					     msecs_to_jiffies(ELP_ENTRY_DELAY));
 	}
 }
 
@@ -99,6 +99,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 			&compl, msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
 		if (ret == 0) {
 			wl1271_error("ELP wakeup timeout!");
+			ieee80211_queue_work(wl->hw, &wl->recovery_work);
 			ret = -ETIMEDOUT;
 			goto err;
 		} else if (ret < 0) {
-- 
1.6.3.3

