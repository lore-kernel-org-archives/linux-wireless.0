Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57478 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZKCXWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 18:22:47 -0500
Received: by yxe17 with SMTP id 17so5897652yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 15:22:52 -0800 (PST)
Message-ID: <4AF0BB45.5000402@lwfinger.net>
Date: Tue, 03 Nov 2009 17:22:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Possible fix for rtl8187: kernel oops when leds enabled
References: <4AE5BD6C.2050303@gmail.com> <4AE5C55B.5070309@lwfinger.net> <4AE5CDCB.8090400@gmail.com>
In-Reply-To: <4AE5CDCB.8090400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rick,

Does this patch fix your problem? I tried to bisect this problem as it
looked like a regression; however, the problem was sometimes a little
flakey. On one boot of a given kernel, it might run for 3-400 cycles
without failing, then fail immediately after rebooting. I suspect that
the random contents of some memory location would control that.

This patch was inspired by the code in p54usb, which does not have the
problem.


Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_

 	/* turn the LED off before exiting */
 	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
-	cancel_delayed_work_sync(&priv->led_off);
-	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
+	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 }
 #endif /* def CONFIG_RTL8187_LED */

Thanks for testing,

Larry






