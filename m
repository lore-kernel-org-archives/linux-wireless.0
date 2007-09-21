Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXIUBJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 21:09:57 -0400
Date: Thu, 20 Sep 2007 20:10:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Change the hardware radio enable logic and  cleanup code
Message-ID: <46f319ef.8UBDQAjFjjfCblr5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change cleans up the radio-related messages in several ways.

(1) The state of the rfkill switch is assumed to be on, rather than
    tested. Now, any user without such a switch will not see any
    messages. For devices with such a switch, a message will be
    logged only if the initial state is off, or if the switch is toggled.
(2) The routine for testing the switch state is no longer inline.
(3) The LED handling routine is simplified.
(4) The "Radio turned off" message that has confused some users has been
    changed to "Radio initialized".

This patch is patterned after a similar change to b43 by Michael Buesch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/b43legacy/leds.c  |   12 ++++--------
 drivers/net/wireless/b43legacy/main.c  |   25 ++++++++++++++++++++-----
 drivers/net/wireless/b43legacy/main.h  |   20 --------------------
 drivers/net/wireless/b43legacy/radio.c |    2 +-
 4 files changed, 25 insertions(+), 34 deletions(-)


Index: wireless-dev/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-dev/drivers/net/wireless/b43legacy/leds.c
@@ -182,6 +182,7 @@ void b43legacy_leds_update(struct b43leg
 	unsigned long interval = 0;
 	u16 ledctl;
 	unsigned long flags;
+	bool radio_enabled = (phy->radio_on && dev->radio_hw_enable);
 
 	spin_lock_irqsave(&dev->wl->leds_lock, flags);
 	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
@@ -201,20 +202,15 @@ void b43legacy_leds_update(struct b43leg
 			turn_on = activity;
 			break;
 		case B43legacy_LED_RADIO_ALL:
-			turn_on = phy->radio_on &&
-				  b43legacy_is_hw_radio_enabled(dev);
+			turn_on = radio_enabled;
 			break;
 		case B43legacy_LED_RADIO_A:
 			break;
 		case B43legacy_LED_RADIO_B:
-			turn_on = (phy->radio_on &&
-				   b43legacy_is_hw_radio_enabled(dev) &&
-				   (phy->type == B43legacy_PHYTYPE_B ||
-				    phy->type == B43legacy_PHYTYPE_G));
+			turn_on = radio_enabled;
 			break;
 		case B43legacy_LED_MODE_BG:
-			if (phy->type == B43legacy_PHYTYPE_G &&
-			    b43legacy_is_hw_radio_enabled(dev))
+			if (phy->type == B43legacy_PHYTYPE_G && radio_enabled)
 				turn_on = 1;
 			break;
 		case B43legacy_LED_TRANSFER:
Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -2008,6 +2008,21 @@ static void b43legacy_mgmtframe_txantenn
 			      B43legacy_SHM_SH_PRPHYCTL, tmp);
 }
 
+/* Returns TRUE, if the radio is enabled in hardware. */
+static bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
+{
+	if (dev->phy.rev >= 3) {
+		if (!(b43legacy_read32(dev, B43legacy_MMIO_RADIO_HWENABLED_HI)
+		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
+			return 1;
+	} else {
+		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
+		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
+			return 1;
+	}
+	return 0;
+}
+
 /* This is the opposite of b43legacy_chip_init() */
 static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 {
@@ -2047,9 +2062,6 @@ static int b43legacy_chip_init(struct b4
 	if (err)
 		goto err_gpio_cleanup;
 	b43legacy_radio_turn_on(dev);
-	dev->radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
-	b43legacyinfo(dev->wl, "Radio %s by hardware\n",
-	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
 
 	b43legacy_write16(dev, 0x03E6, 0x0000);
 	err = b43legacy_phy_init(dev);
@@ -2171,14 +2183,14 @@ static void b43legacy_periodic_every15se
 
 static void b43legacy_periodic_every1sec(struct b43legacy_wldev *dev)
 {
-	int radio_hw_enable;
+	bool radio_hw_enable;
 
 	/* check if radio hardware enabled status changed */
 	radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
 		b43legacyinfo(dev->wl, "Radio hardware status changed to %s\n",
-		       (radio_hw_enable == 0) ? "disabled" : "enabled");
+		       (radio_hw_enable) ? "enabled" : "disabled");
 		b43legacy_leds_update(dev, 0);
 	}
 }
@@ -2917,6 +2929,9 @@ static void setup_struct_phy_for_init(st
 
 	/* Flags */
 	phy->locked = 0;
+	/* Assume the radio is enabled. If it's not enabled, the state will
+	 * immediately get fixed on the first periodic work run. */
+	dev->radio_hw_enable = 1;
 
 	phy->savedpctlreg = 0xFFFF;
 	phy->aci_enable = 0;
Index: wireless-dev/drivers/net/wireless/b43legacy/main.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.h
+++ wireless-dev/drivers/net/wireless/b43legacy/main.h
@@ -97,26 +97,6 @@ int b43legacy_is_ofdm_rate(int rate)
 	return !b43legacy_is_cck_rate(rate);
 }
 
-static inline
-int b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
-{
-	/* function to return state of hardware enable of radio
-	 * returns 0 if radio disabled, 1 if radio enabled
-	 */
-	struct b43legacy_phy *phy = &dev->phy;
-
-	if (phy->rev >= 3)
-		return ((b43legacy_read32(dev,
-				B43legacy_MMIO_RADIO_HWENABLED_HI)
-				& B43legacy_MMIO_RADIO_HWENABLED_HI_MASK)
-				== 0) ? 1 : 0;
-	else
-		return ((b43legacy_read16(dev,
-				B43legacy_MMIO_RADIO_HWENABLED_LO)
-				& B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
-				== 0) ? 0 : 1;
-}
-
 void b43legacy_tsf_read(struct b43legacy_wldev *dev, u64 *tsf);
 void b43legacy_tsf_write(struct b43legacy_wldev *dev, u64 tsf);
 
Index: wireless-dev/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-dev/drivers/net/wireless/b43legacy/radio.c
@@ -2107,7 +2107,7 @@ void b43legacy_radio_turn_off(struct b43
 	} else
 		b43legacy_phy_write(dev, 0x0015, 0xAA00);
 	phy->radio_on = 0;
-	b43legacydbg(dev->wl, "Radio turned off\n");
+	b43legacydbg(dev->wl, "Radio initialized\n");
 	b43legacy_leds_update(dev, 0);
 }
 
