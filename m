Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42538 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab2K0A0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 19:26:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 03/15] watchdog: bcm47xx_wdt.c: rename ops methods
Date: Tue, 27 Nov 2012 01:25:13 +0100
Message-Id: <1353975925-32056-4-git-send-email-hauke@hauke-m.de> (sfid-20121127_012614_884662_0A2DABAD)
In-Reply-To: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
References: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the methods registered to struct watchdog_ops bcm47xx_wdt_ops in
order to add an other struct watchdog_ops using different ops in the
next patch.
Also rename WDT_MAX_TIME to WDT_SOFTTIMER_MAX.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/watchdog/bcm47xx_wdt.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index cf1191b..ed10762 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -30,7 +30,7 @@
 #define DRV_NAME		"bcm47xx_wdt"
 
 #define WDT_DEFAULT_TIME	30	/* seconds */
-#define WDT_MAX_TIME		255	/* seconds */
+#define WDT_SOFTTIMER_MAX	255	/* seconds */
 
 static int wdt_time = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -49,7 +49,7 @@ static inline struct bcm47xx_wdt *bcm47xx_wdt_get(struct watchdog_device *wdd)
 	return container_of(wdd, struct bcm47xx_wdt, wdd);
 }
 
-static void bcm47xx_timer_tick(unsigned long data)
+static void bcm47xx_wdt_soft_timer_tick(unsigned long data)
 {
 	struct bcm47xx_wdt *wdt = (struct bcm47xx_wdt *)data;
 	u32 next_tick = min(wdt->wdd.timeout * 1000, wdt->max_timer_ms);
@@ -62,7 +62,7 @@ static void bcm47xx_timer_tick(unsigned long data)
 	}
 }
 
-static int bcm47xx_wdt_keepalive(struct watchdog_device *wdd)
+static int bcm47xx_wdt_soft_keepalive(struct watchdog_device *wdd)
 {
 	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
 
@@ -71,17 +71,17 @@ static int bcm47xx_wdt_keepalive(struct watchdog_device *wdd)
 	return 0;
 }
 
-static int bcm47xx_wdt_start(struct watchdog_device *wdd)
+static int bcm47xx_wdt_soft_start(struct watchdog_device *wdd)
 {
 	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
 
-	bcm47xx_wdt_keepalive(wdd);
-	bcm47xx_timer_tick((unsigned long)wdt);
+	bcm47xx_wdt_soft_keepalive(wdd);
+	bcm47xx_wdt_soft_timer_tick((unsigned long)wdt);
 
 	return 0;
 }
 
-static int bcm47xx_wdt_stop(struct watchdog_device *wdd)
+static int bcm47xx_wdt_soft_stop(struct watchdog_device *wdd)
 {
 	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
 
@@ -91,12 +91,12 @@ static int bcm47xx_wdt_stop(struct watchdog_device *wdd)
 	return 0;
 }
 
-static int bcm47xx_wdt_set_timeout(struct watchdog_device *wdd,
-				   unsigned int new_time)
+static int bcm47xx_wdt_soft_set_timeout(struct watchdog_device *wdd,
+					unsigned int new_time)
 {
-	if (new_time < 1 || new_time > WDT_MAX_TIME) {
+	if (new_time < 1 || new_time > WDT_SOFTTIMER_MAX) {
 		pr_warn("timeout value must be 1<=x<=%d, using %d\n",
-			WDT_MAX_TIME, new_time);
+			WDT_SOFTTIMER_MAX, new_time);
 		return -EINVAL;
 	}
 
@@ -122,12 +122,12 @@ static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct watchdog_ops bcm47xx_wdt_ops = {
+static struct watchdog_ops bcm47xx_wdt_soft_ops = {
 	.owner		= THIS_MODULE,
-	.start		= bcm47xx_wdt_start,
-	.stop		= bcm47xx_wdt_stop,
-	.ping		= bcm47xx_wdt_keepalive,
-	.set_timeout	= bcm47xx_wdt_set_timeout,
+	.start		= bcm47xx_wdt_soft_start,
+	.stop		= bcm47xx_wdt_soft_stop,
+	.ping		= bcm47xx_wdt_soft_keepalive,
+	.set_timeout	= bcm47xx_wdt_soft_set_timeout,
 };
 
 static int __devinit bcm47xx_wdt_probe(struct platform_device *pdev)
@@ -138,10 +138,10 @@ static int __devinit bcm47xx_wdt_probe(struct platform_device *pdev)
 	if (!wdt)
 		return -ENXIO;
 
-	setup_timer(&wdt->soft_timer, bcm47xx_timer_tick,
+	setup_timer(&wdt->soft_timer, bcm47xx_wdt_soft_timer_tick,
 		    (long unsigned int)wdt);
 
-	wdt->wdd.ops = &bcm47xx_wdt_ops;
+	wdt->wdd.ops = &bcm47xx_wdt_soft_ops;
 	wdt->wdd.info = &bcm47xx_wdt_info;
 	wdt->wdd.timeout = WDT_DEFAULT_TIME;
 	ret = wdt->wdd.ops->set_timeout(&wdt->wdd, timeout);
-- 
1.7.10.4

