Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42560 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab2K0A0Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 19:26:16 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 05/15] watchdog: bcm47xx_wdt.c: add hard timer
Date: Tue, 27 Nov 2012 01:25:15 +0100
Message-Id: <1353975925-32056-6-git-send-email-hauke@hauke-m.de> (sfid-20121127_012620_849731_D0A2B540)
In-Reply-To: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
References: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The more recent devices have a watchdog timer which could be configured
for over 2 hours and not just 2 seconds like the first generation
devices. For those devices do not use the extra software timer, but
directly program the time into the register. This will automatically be
used if the timer supports more than a minute.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/watchdog/bcm47xx_wdt.c |   69 ++++++++++++++++++++++++++++++++++++----
 include/linux/bcm47xx_wdt.h    |    1 +
 2 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index f188097..9cb69ad 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -31,6 +31,7 @@
 
 #define WDT_DEFAULT_TIME	30	/* seconds */
 #define WDT_SOFTTIMER_MAX	255	/* seconds */
+#define WDT_SOFTTIMER_THRESHOLD	60	/* seconds */
 
 static int timeout = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -49,6 +50,53 @@ static inline struct bcm47xx_wdt *bcm47xx_wdt_get(struct watchdog_device *wdd)
 	return container_of(wdd, struct bcm47xx_wdt, wdd);
 }
 
+static int bcm47xx_wdt_hard_keepalive(struct watchdog_device *wdd)
+{
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	wdt->timer_set_ms(wdt, wdd->timeout * 1000);
+
+	return 0;
+}
+
+static int bcm47xx_wdt_hard_start(struct watchdog_device *wdd)
+{
+	return 0;
+}
+
+static int bcm47xx_wdt_hard_stop(struct watchdog_device *wdd)
+{
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	wdt->timer_set(wdt, 0);
+
+	return 0;
+}
+
+static int bcm47xx_wdt_hard_set_timeout(struct watchdog_device *wdd,
+					unsigned int new_time)
+{
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+	u32 max_timer = wdt->max_timer_ms;
+
+	if (new_time < 1 || new_time > max_timer / 1000) {
+		pr_warn("timeout value must be 1<=x<=%d, using %d\n",
+			max_timer / 1000, new_time);
+		return -EINVAL;
+	}
+
+	wdd->timeout = new_time;
+	return 0;
+}
+
+static struct watchdog_ops bcm47xx_wdt_hard_ops = {
+	.owner		= THIS_MODULE,
+	.start		= bcm47xx_wdt_hard_start,
+	.stop		= bcm47xx_wdt_hard_stop,
+	.ping		= bcm47xx_wdt_hard_keepalive,
+	.set_timeout	= bcm47xx_wdt_hard_set_timeout,
+};
+
 static void bcm47xx_wdt_soft_timer_tick(unsigned long data)
 {
 	struct bcm47xx_wdt *wdt = (struct bcm47xx_wdt *)data;
@@ -133,15 +181,22 @@ static struct watchdog_ops bcm47xx_wdt_soft_ops = {
 static int __devinit bcm47xx_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
+	bool soft;
 	struct bcm47xx_wdt *wdt = dev_get_platdata(&pdev->dev);
 
 	if (!wdt)
 		return -ENXIO;
 
-	setup_timer(&wdt->soft_timer, bcm47xx_wdt_soft_timer_tick,
-		    (long unsigned int)wdt);
+	soft = wdt->max_timer_ms < WDT_SOFTTIMER_THRESHOLD * 1000;
+
+	if (soft) {
+		wdt->wdd.ops = &bcm47xx_wdt_soft_ops;
+		setup_timer(&wdt->soft_timer, bcm47xx_wdt_soft_timer_tick,
+			    (long unsigned int)wdt);
+	} else {
+		wdt->wdd.ops = &bcm47xx_wdt_hard_ops;
+	}
 
-	wdt->wdd.ops = &bcm47xx_wdt_soft_ops;
 	wdt->wdd.info = &bcm47xx_wdt_info;
 	wdt->wdd.timeout = WDT_DEFAULT_TIME;
 	ret = wdt->wdd.ops->set_timeout(&wdt->wdd, timeout);
@@ -159,14 +214,16 @@ static int __devinit bcm47xx_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_notifier;
 
-	pr_info("BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
-		timeout, nowayout ? ", nowayout" : "");
+	dev_info(&pdev->dev, "BCM47xx Watchdog Timer enabled (%d seconds%s%s)\n",
+		timeout, nowayout ? ", nowayout" : "",
+		soft ? ", Software Timer" : "");
 	return 0;
 
 err_notifier:
 	unregister_reboot_notifier(&wdt->notifier);
 err_timer:
-	del_timer_sync(&wdt->soft_timer);
+	if (soft)
+		del_timer_sync(&wdt->soft_timer);
 
 	return ret;
 }
diff --git a/include/linux/bcm47xx_wdt.h b/include/linux/bcm47xx_wdt.h
index b94ac0e..b708786 100644
--- a/include/linux/bcm47xx_wdt.h
+++ b/include/linux/bcm47xx_wdt.h
@@ -10,6 +10,7 @@
 struct bcm47xx_wdt {
 	u32 (*timer_set)(struct bcm47xx_wdt *, u32);
 	u32 (*timer_set_ms)(struct bcm47xx_wdt *, u32);
+	u32 max_timer_ms;
 
 	void *driver_data;
 
-- 
1.7.10.4

