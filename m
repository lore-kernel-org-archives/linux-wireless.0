Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1FFL5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:57:20 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2719203wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:57:20 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/3] wl12xx: Avoid recovery while one is already in progress
Date: Mon,  6 Jun 2011 14:57:05 +0300
Message-Id: <1307361426-7573-2-git-send-email-ido@wizery.com> (sfid-20110606_135723_503416_F1C3B2DA)
In-Reply-To: <1307361426-7573-1-git-send-email-ido@wizery.com>
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During recovery work commands sent to the FW could fail and schedule
additional recovery work. Since the chip is going to be powered off,
avoid recursive recoveries.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c      |    4 ++--
 drivers/net/wireless/wl12xx/debugfs.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c     |   14 +++++++++++++-
 drivers/net/wireless/wl12xx/ps.c       |    2 +-
 drivers/net/wireless/wl12xx/scan.c     |    2 +-
 drivers/net/wireless/wl12xx/testmode.c |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h   |    2 ++
 7 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b3a4f58..0754eb1 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -105,7 +105,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 fail:
 	WARN_ON(1);
-	ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	wl12xx_queue_recovery_work(wl);
 	return ret;
 }
 
@@ -351,7 +351,7 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 
 	ret = wl1271_cmd_wait_for_event_or_timeout(wl, mask);
 	if (ret != 0) {
-		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+		wl12xx_queue_recovery_work(wl);
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index c3f19463..da21270 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -306,7 +306,7 @@ static ssize_t start_recovery_write(struct file *file,
 	struct wl1271 *wl = file->private_data;
 
 	mutex_lock(&wl->mutex);
-	ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	wl12xx_queue_recovery_work(wl);
 	mutex_unlock(&wl->mutex);
 
 	return count;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ab435c7..e3b7ffd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -924,7 +924,7 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
 			wl1271_error("watchdog interrupt received! "
 				     "starting recovery.");
-			ieee80211_queue_work(wl->hw, &wl->recovery_work);
+			wl12xx_queue_recovery_work(wl);
 
 			/* restarting the chip. ignore any other interrupt. */
 			goto out;
@@ -1086,6 +1086,12 @@ out:
 	return ret;
 }
 
+void wl12xx_queue_recovery_work(struct wl1271 *wl)
+{
+	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+}
+
 static void wl1271_recovery_work(struct work_struct *work)
 {
 	struct wl1271 *wl =
@@ -1096,6 +1102,9 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (wl->state != WL1271_STATE_ON)
 		goto out;
 
+	/* Avoid a recursive recovery */
+	set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
+
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
@@ -1112,6 +1121,9 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	/* reboot the chipset */
 	__wl1271_op_remove_interface(wl, false);
+
+	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
+
 	ieee80211_restart_hw(wl->hw);
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index d3e377d..0020eb3 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -118,7 +118,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 			&compl, msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
 		if (ret == 0) {
 			wl1271_error("ELP wakeup timeout!");
-			ieee80211_queue_work(wl->hw, &wl->recovery_work);
+			wl12xx_queue_recovery_work(wl);
 			ret = -ETIMEDOUT;
 			goto err;
 		} else if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f37e5a3..2f706d7 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -62,7 +62,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
-		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+		wl12xx_queue_recovery_work(wl);
 	}
 
 out:
diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index da351d7..5d5e1ef 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -260,7 +260,7 @@ static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
 {
 	wl1271_debug(DEBUG_TESTMODE, "testmode cmd recover");
 
-	ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	wl12xx_queue_recovery_work(wl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..b966a37 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -361,6 +361,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_PENDING_WORK,
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RX_STREAMING_STARTED,
+	WL1271_FLAG_RECOVERY_IN_PROGRESS,
 };
 
 struct wl1271_link {
@@ -609,6 +610,7 @@ struct wl1271_station {
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl);
+void wl12xx_queue_recovery_work(struct wl1271 *wl);
 
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
-- 
1.7.4.1

