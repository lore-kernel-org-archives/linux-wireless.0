Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward12.mail.yandex.net ([95.108.130.94]:33103 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZK3Rbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:38 -0500
From: =?koi8-r?B?9MjByiDrydLJzMw=?= <tkhai@yandex.ru>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH]rtl8187:fixed kernel panic on module unload
MIME-Version: 1.0
Message-Id: <63741259601663@webmail119.yandex.ru>
Date: Mon, 30 Nov 2009 20:21:03 +0300
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tkhai Kirill <tkhai@yandex.ru>

rtl8187: fix kernel panic on module unload (BUG in rtl8187_leds_exit())
	Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
---
The function rtl8187_leds_exit must not return until all LED's works
in device workqueue have completed or cancelled. Otherwise, we can get
the folowing:
	wq = create_singlethread_workqueue("phyX");

	INIT_DELAYED_WORK(&work, work_func);
	queue_delayed_work(wq, &work, HZ/20);

	destroy_workqueue(wq);

=======>kernel panic
On current vanila driver code (when running on SMP systems), panic happens
almost every time. My patch for version 2.6.31 (and 2.6.31.6 too):

--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c.orig	2009-11-26 22:26:45.000000000 +0300
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c	2009-11-28 18:22:26.659785533 +0300
@@ -36,9 +36,6 @@ static void led_turn_on(struct work_stru
 	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
 		return ;
 
-	/* Skip if the LED is not registered. */
-	if (!led->dev)
-		return;
 	mutex_lock(&priv->conf_mutex);
 	switch (led->ledpin) {
 	case LED_PIN_GPIO0:
@@ -74,9 +71,6 @@ static void led_turn_off(struct work_str
 	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
 		return ;
 
-	/* Skip if the LED is not registered. */
-	if (!led->dev)
-		return;
 	mutex_lock(&priv->conf_mutex);
 	switch (led->ledpin) {
 	case LED_PIN_GPIO0:
@@ -208,12 +202,12 @@ void rtl8187_leds_exit(struct ieee80211_
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	/* turn the LED off before exiting */
-	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
-	cancel_delayed_work_sync(&priv->led_off);
-	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
+	cancel_delayed_work_sync(&priv->led_on);
+	/* turn the LED off before exiting */
+	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
+	flush_workqueue(dev->workqueue);
 }
 #endif /* def CONFIG_RTL8187_LED */
 
