Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63236 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZKQQtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:25 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 04/16] wl1251: Implement delayed entry into ELP mode
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:37 +0200
Message-ID: <20091117164836.2236.55890.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Implement (slightly) delayed entry into ELP. This will cure several
problems:
  - It works around a firmware race condition if ELP is entered too fast
    after commands (resulting in ELP timeout -traces)
  - It will reduce the number of sleep-wake cycles between already
    scheduled events such as interrupts and tx, hence improving
    performance (less delay in switching between RX and TX)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    2 ++
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1251_ps.c   |   34 +++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl1251_ps.h   |    1 +
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index fc2871c..a839466 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -354,6 +354,8 @@ struct wl1251 {
 	/* is firmware in elp mode */
 	bool elp;
 
+	struct delayed_work elp_work;
+
 	/* we can be in psm, but not in elp, we have to differentiate */
 	bool psm;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 900e6e2..b5e3bdb 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1367,6 +1367,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	skb_queue_head_init(&wl->tx_queue);
 
 	INIT_WORK(&wl->filter_work, wl1251_filter_work);
+	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->scanning = false;
 	wl->default_key = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index c3e348a..9931b19 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -28,17 +28,41 @@
 
 #define WL1251_WAKEUP_TIMEOUT 2000
 
-/* Routines to toggle sleep mode while in ELP */
-void wl1251_ps_elp_sleep(struct wl1251 *wl)
+void wl1251_elp_work(struct work_struct *work)
 {
+	struct delayed_work *dwork;
+	struct wl1251 *wl;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1251, elp_work);
+
+	wl1251_debug(DEBUG_PSM, "elp work");
+
+	mutex_lock(&wl->mutex);
+
 	if (wl->elp || !wl->psm)
-		return;
+		goto out;
 
 	wl1251_debug(DEBUG_PSM, "chip to elp");
-
 	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
-
 	wl->elp = true;
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+#define ELP_ENTRY_DELAY  5
+
+/* Routines to toggle sleep mode while in ELP */
+void wl1251_ps_elp_sleep(struct wl1251 *wl)
+{
+	unsigned long delay;
+
+	if (wl->psm) {
+		cancel_delayed_work(&wl->elp_work);
+		delay = msecs_to_jiffies(ELP_ENTRY_DELAY);
+		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work, delay);
+	}
 }
 
 int wl1251_ps_elp_wakeup(struct wl1251 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
index db036fe..c688ac5 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -31,6 +31,7 @@
 int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode);
 void wl1251_ps_elp_sleep(struct wl1251 *wl);
 int wl1251_ps_elp_wakeup(struct wl1251 *wl);
+void wl1251_elp_work(struct work_struct *work);
 
 
 #endif /* __WL1251_PS_H__ */

