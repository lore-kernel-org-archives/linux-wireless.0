Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:45108 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZGLUY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 16:24:59 -0400
Message-ID: <4A5A46AA.5070605@lwfinger.net>
Date: Sun, 12 Jul 2009 15:25:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <larry.finger@gmail.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [Bisected][Regression] Oops/panic when rmmoding rtl8187 on SMP
 since 	commit "rtl8187: Implement TX/RX blink for LED"
References: <69e28c910907121311g2011c960g141bd35891c8ea25@mail.gmail.com>
In-Reply-To: <69e28c910907121311g2011c960g141bd35891c8ea25@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020404050809010401030402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020404050809010401030402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Gábor Stefanik wrote:
> I'm getting a kernel oops/panic when unloading rtl8187. Bisect lead me
> to commit "rtl8187: Implement TX/RX blink for LED", confirmed by local
> backout.
> My card is an RTL8187LvB, "Customer ID 0x00" (P5K Premium integrated
> WiFi, made by Azurewave).

Does this patch fix it?


Larry
---


Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -212,6 +212,7 @@ void rtl8187_leds_exit(struct ieee80211_
 	/* turn the LED off before exiting */
 	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
 }
 #endif /* def CONFIG_RTL8187_LED */


--------------020404050809010401030402
Content-Type: text/plain;
 name="rtl8187_fix_led_exit"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtl8187_fix_led_exit"

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -212,6 +212,7 @@ void rtl8187_leds_exit(struct ieee80211_
 	/* turn the LED off before exiting */
 	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
 }
 #endif /* def CONFIG_RTL8187_LED */


--------------020404050809010401030402--
