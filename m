Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30306 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZHDVEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 17:04:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 14:04:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] zd1211rw: make it clear we don't use leds.h LED stuff
Date: Tue, 4 Aug 2009 14:04:17 -0700
Message-ID: <1249419857-25016-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw uses its own LED stuff so let rename its LED
stuff as such.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, this patch is just for my convenience of removing
one patch on compat-wireless which I always have to carry.

 drivers/net/wireless/zd1211rw/zd_chip.c |    6 +++---
 drivers/net/wireless/zd1211rw/zd_chip.h |    6 +++---
 drivers/net/wireless/zd1211rw/zd_mac.c  |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 2c813d8..5e110a2 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1278,11 +1278,11 @@ int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
 	other_led = chip->link_led == LED1 ? LED2 : LED1;
 
 	switch (status) {
-	case LED_OFF:
+	case ZD_LED_OFF:
 		ioreqs[0].value = FW_LINK_OFF;
 		ioreqs[1].value = v[1] & ~(LED1|LED2);
 		break;
-	case LED_SCANNING:
+	case ZD_LED_SCANNING:
 		ioreqs[0].value = FW_LINK_OFF;
 		ioreqs[1].value = v[1] & ~other_led;
 		if (get_seconds() % 3 == 0) {
@@ -1291,7 +1291,7 @@ int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
 			ioreqs[1].value |= chip->link_led;
 		}
 		break;
-	case LED_ASSOCIATED:
+	case ZD_LED_ASSOCIATED:
 		ioreqs[0].value = FW_LINK_TX;
 		ioreqs[1].value = v[1] & ~other_led;
 		ioreqs[1].value |= chip->link_led;
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index ee42751..678c139 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -897,9 +897,9 @@ int zd_chip_lock_phy_regs(struct zd_chip *chip);
 int zd_chip_unlock_phy_regs(struct zd_chip *chip);
 
 enum led_status {
-	LED_OFF = 0,
-	LED_SCANNING = 1,
-	LED_ASSOCIATED = 2,
+	ZD_LED_OFF = 0,
+	ZD_LED_SCANNING = 1,
+	ZD_LED_ASSOCIATED = 2,
 };
 
 int zd_chip_control_leds(struct zd_chip *chip, enum led_status status);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 54abdd0..55b7fbd 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1013,7 +1013,7 @@ static void link_led_handler(struct work_struct *work)
 	spin_unlock_irq(&mac->lock);
 
 	r = zd_chip_control_leds(chip,
-		                 is_associated ? LED_ASSOCIATED : LED_SCANNING);
+		                 is_associated ? ZD_LED_ASSOCIATED : ZD_LED_SCANNING);
 	if (r)
 		dev_dbg_f(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
 
@@ -1038,5 +1038,5 @@ static void housekeeping_disable(struct zd_mac *mac)
 	dev_dbg_f(zd_mac_dev(mac), "\n");
 	cancel_rearming_delayed_workqueue(zd_workqueue,
 		&mac->housekeeping.link_led_work);
-	zd_chip_control_leds(&mac->chip, LED_OFF);
+	zd_chip_control_leds(&mac->chip, ZD_LED_OFF);
 }
-- 
1.6.3.3

