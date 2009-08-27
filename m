Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50845 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZH0VAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:24 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 05/13] wl1271: Implement delayed entry into ELP
Date: Thu, 27 Aug 2009 23:59:59 +0300
Message-Id: <1251406807-31495-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Implement delayed entry into ELP. This will promote the following:
 - Less redundant sleep/wake cycles (better perf)
 - Avoids known firmware issues with going to ELP too fast after an
   operation

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_ps.c   |   46 ++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.h   |    2 +-
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index e575dcc..c455dcb 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -373,6 +373,7 @@ struct wl1271 {
 	bool elp;
 
 	struct completion *elp_compl;
+	struct delayed_work elp_work;
 
 	/* we can be in psm, but not in elp, we have to differentiate */
 	bool psm;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4fb6138..1a5e575 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1227,6 +1227,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	skb_queue_head_init(&wl->tx_queue);
 
 	INIT_WORK(&wl->filter_work, wl1271_filter_work);
+	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->scanning = false;
 	wl->default_key = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 1dc74b0..7a3b53e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -27,25 +27,43 @@
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
-/* Routines to toggle sleep mode while in ELP */
-void wl1271_ps_elp_sleep(struct wl1271 *wl)
+void wl1271_elp_work(struct work_struct *work)
 {
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, elp_work);
+
+	wl1271_debug(DEBUG_PSM, "elp work");
+
+	mutex_lock(&wl->mutex);
+
 	/*
-	 * FIXME: due to a problem in the firmware (causing a firmware
-	 * crash), ELP entry is prevented below. Remove the "true" to
-	 * re-enable ELP entry.
+	 * FIXME: below, by means of the "true", ELP has been disabled for now
+	 * to work around a firmware bug. To be enabled upon receiving a new
+	 * firmware version.
 	 */
 	if (true || wl->elp || !wl->psm)
-		return;
+		goto out;
 
-	/*
-	 * Go to ELP unless there is work already pending - pending work
-	 * will immediately wakeup the chipset anyway.
-	 */
-	if (!work_pending(&wl->irq_work) && !work_pending(&wl->tx_work)) {
-		wl1271_debug(DEBUG_PSM, "chip to elp");
-		wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
-		wl->elp = true;
+	wl1271_debug(DEBUG_PSM, "chip to elp");
+	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+	wl->elp = true;
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+#define ELP_ENTRY_DELAY  5
+
+/* Routines to toggle sleep mode while in ELP */
+void wl1271_ps_elp_sleep(struct wl1271 *wl)
+{
+	if (wl->psm) {
+		cancel_delayed_work(&wl->elp_work);
+		queue_delayed_work(wl->hw->workqueue, &wl->elp_work,
+				   msecs_to_jiffies(ELP_ENTRY_DELAY));
 	}
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.h b/drivers/net/wireless/wl12xx/wl1271_ps.h
index de2bd3c..779653d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.h
@@ -30,6 +30,6 @@
 int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
-
+void wl1271_elp_work(struct work_struct *work);
 
 #endif /* __WL1271_PS_H__ */
-- 
1.5.6.5

