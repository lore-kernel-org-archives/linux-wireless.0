Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcFIOdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 10:33:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Kamal Mostafa <kamal@canonical.com>,
	kernel-team@lists.ubuntu.com
Subject: [4.2.y-ckt stable] Patch "ath9k: Add a module parameter to invert LED polarity." has been added to the 4.2.y-ckt tree
Date: Thu,  9 Jun 2016 07:33:32 -0700
Message-Id: <1465482812-19874-1-git-send-email-kamal@canonical.com> (sfid-20160609_163342_001513_AD918419)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a note to let you know that I have just added a patch titled

    ath9k: Add a module parameter to invert LED polarity.

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    https://git.launchpad.net/~canonical-kernel/linux/+git/linux-stable-ckt/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt12.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From 3ed74d9334a27b8c8bac6c721c3f484a9a2694a8 Mon Sep 17 00:00:00 2001
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Date: Mon, 11 Apr 2016 04:48:54 +0200
Subject: ath9k: Add a module parameter to invert LED polarity.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fc6dc52..6a571d8 100644
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
@@ -600,6 +604,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		return ret;

+	if (ath9k_led_active_high != -1)
+		ah->config.led_active_high = ath9k_led_active_high == 1;
+
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *
--
2.7.4

