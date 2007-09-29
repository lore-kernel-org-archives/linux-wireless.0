Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58137
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXI2K0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 06:26:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] z1211: Make the LEDs warning debug-only
Date: Sat, 29 Sep 2007 12:23:20 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200709291223.20926.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This warning triggers now and then with an -ETIMEDOUT error.
Though the LEDs work fine.
Make this warning debug-only, as nobody is really interested
in a LED failure that happens only now and then.
If the LEDs don't work, one can easily enable debugging to see
what's going on.
This reduces dmesg spamming.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-2.6/drivers/net/wireless/z1211/zd_mac.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/z1211/zd_mac.c	2007-09-25 22:51:28.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/z1211/zd_mac.c	2007-09-29 12:19:54.000000000 +0200
@@ -922,7 +922,7 @@ static void link_led_handler(struct work
 	r = zd_chip_control_leds(chip,
 		                 is_associated ? LED_ASSOCIATED : LED_SCANNING);
 	if (r)
-		dev_err(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
+		dev_dbg_f(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
 
 	queue_delayed_work(zd_workqueue, &mac->housekeeping.link_led_work,
 		           LINK_LED_WORK_DELAY);

-- 
Greetings Michael.
