Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44321 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbZGMVNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 17:13:01 -0400
Date: Mon, 13 Jul 2009 16:13:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: netrolller.3d@gmail.com
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT V2] rtl8187: Fix for kernel oops when unloading with
 LEDs enabled
Message-ID: <4a5ba36c.cr8bCiN6RbA/iczD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
may oops when the module is unloaded as the workqueue for led_on was
not being cancelled.

Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
---
V2 - Do not create a new workqueue.

Gábor,

I hope this version of the patch fixes your problem. On my system
I ran more than 20 rmmod/insmod cycles without a problem.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -208,11 +208,12 @@ void rtl8187_leds_exit(struct ieee80211_
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	rtl8187_unregister_led(&priv->led_tx);
 	/* turn the LED off before exiting */
 	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
+	rtl8187_unregister_led(&priv->led_tx);
 }
 #endif /* def CONFIG_RTL8187_LED */
 
