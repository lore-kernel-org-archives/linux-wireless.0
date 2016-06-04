Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbcFDTa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 15:30:57 -0400
Subject: Patch "ath9k: Add a module parameter to invert LED polarity." has been added to the 4.6-stable tree
To: linux-wireless@vittgam.net, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com, gregkh@linuxfoundation.org,
	kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	linuxbugs@vittgam.net
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sat, 04 Jun 2016 12:30:54 -0700
Message-ID: <1465068654118110@kroah.com> (sfid-20160604_213112_795044_EB344740)
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    ath9k: Add a module parameter to invert LED polarity.

to the 4.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ath9k-add-a-module-parameter-to-invert-led-polarity.patch
and it can be found in the queue-4.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From cd84042ce9040ad038e958bc67a46fcfc015c736 Mon Sep 17 00:00:00 2001
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Date: Mon, 11 Apr 2016 04:48:54 +0200
Subject: ath9k: Add a module parameter to invert LED polarity.

From: Vittorio Gambaletta (VittGam) <linux-wireless@vittgam.net>

commit cd84042ce9040ad038e958bc67a46fcfc015c736 upstream.

The LED can be active high instead of active low on some hardware.

Add the led_active_high module parameter. It defaults to -1 to obey
platform data as before.

Setting the parameter to 1 or 0 will force the LED respectively
active high or active low.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/init.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -49,6 +49,10 @@ int ath9k_led_blink;
 module_param_named(blink, ath9k_led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
+static int ath9k_led_active_high = -1;
+module_param_named(led_active_high, ath9k_led_active_high, int, 0444);
+MODULE_PARM_DESC(led_active_high, "Invert LED polarity");
+
 static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
@@ -600,6 +604,9 @@ static int ath9k_init_softc(u16 devid, s
 	if (ret)
 		return ret;
 
+	if (ath9k_led_active_high != -1)
+		ah->config.led_active_high = ath9k_led_active_high == 1;
+
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *


Patches currently in stable-queue which might be from linux-wireless@vittgam.net are

queue-4.6/ath9k-add-a-module-parameter-to-invert-led-polarity.patch
queue-4.6/ath9k-fix-led-polarity-for-some-mini-pci-ar9220-mb92-cards.patch
