Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZGNUy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 16:54:59 -0400
Date: Tue, 14 Jul 2009 15:55:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
Message-ID: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
may oops when the module is unloaded as the workqueue for led_on was
not being cancelled.

This patch fixes the problem reported in
http://marc.info/?l=linux-wireless&m=124742957615781&w=2.

Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
---

V2 - Do not create a new workqueue.

John,

This patch is 2.6.31 material. To the best of my knowledge, a formal bug
report was never filed; however, it was reported in the reference given above.

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
 
