Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbZGMPno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 11:43:44 -0400
Date: Mon, 13 Jul 2009 10:43:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: netrolller.3d@gmail.com
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
Message-ID: <4a5b563e.AuhPXmHA0dUFYtzx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
may oops when the module is unloaded as the workqueue for led_on was
not being cancelled. To prevent interference between cfg80211 and rtl8187,
a separate workqueue has also been established.

Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
---

Gábor,

I hope this version of the patch fixes your problem. On my system
I ran more than 20 rmmod/insmod cycles without a problem.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -108,11 +108,11 @@ static void rtl8187_led_brightness_set(s
 	struct rtl8187_priv *priv = hw->priv;
 
 	if (brightness == LED_OFF) {
-		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
+		queue_delayed_work(priv->workqueue, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
-		queue_delayed_work(hw->workqueue, &priv->led_on, HZ / 20);
+		queue_delayed_work(priv->workqueue, &priv->led_on, HZ / 20);
 	} else
-		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
+		queue_delayed_work(priv->workqueue, &priv->led_on, 0);
 }
 
 static int rtl8187_register_led(struct ieee80211_hw *dev,
@@ -193,7 +193,7 @@ void rtl8187_leds_init(struct ieee80211_
 	err = rtl8187_register_led(dev, &priv->led_rx, name,
 			 ieee80211_get_rx_led_name(dev), ledpin);
 	if (!err) {
-		queue_delayed_work(dev->workqueue, &priv->led_on, 0);
+		queue_delayed_work(priv->workqueue, &priv->led_on, 0);
 		return;
 	}
 	/* registration of RX LED failed - unregister TX */
@@ -208,11 +208,12 @@ void rtl8187_leds_exit(struct ieee80211_
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	rtl8187_unregister_led(&priv->led_tx);
 	/* turn the LED off before exiting */
-	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
+	queue_delayed_work(priv->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
+	rtl8187_unregister_led(&priv->led_tx);
 }
 #endif /* def CONFIG_RTL8187_LED */
 
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -104,6 +104,7 @@ struct rtl8187_priv {
 	struct delayed_work work;
 	struct ieee80211_hw *dev;
 #ifdef CONFIG_RTL8187_LEDS
+	struct workqueue_struct *workqueue;
 	struct rtl8187_led led_tx;
 	struct rtl8187_led led_rx;
 	struct delayed_work led_on;
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1507,6 +1507,12 @@ static int __devinit rtl8187_probe(struc
 #ifdef CONFIG_RTL8187_LEDS
 	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
 	reg &= 0xFF;
+	priv->workqueue =
+		 create_singlethread_workqueue(wiphy_name(dev->wiphy));
+	if (!priv->workqueue) {
+		err = -ENOMEM;
+		goto err_free_dmabuf;
+	}
 	rtl8187_leds_init(dev, reg);
 #endif
 
