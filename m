Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49039 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbYDMW5s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 18:57:48 -0400
Date: Mon, 14 Apr 2008 00:57:03 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev@lists.berlios.de
Subject: [PATCH] b43legacy: fix TBTT and PU timings
Message-ID: <20080414005703.4970dee9@polimi.it> (sfid-20080413_235754_484114_5F9B2CB6)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some timings for pre-TBTT and synthetic PU.
The patch by Michael Buesch has been ported to b43legacy.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John, this is for 2.6.26.
---
Index: bcm-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- bcm-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ bcm-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -97,6 +97,7 @@
 #define B43legacy_MMIO_RADIO_HWENABLED_LO	0x49A
 #define B43legacy_MMIO_GPIO_CONTROL	0x49C
 #define B43legacy_MMIO_GPIO_MASK		0x49E
+#define B43legacy_MMIO_TSF_CFP_PRETBTT	0x612
 #define B43legacy_MMIO_TSF_0		0x632 /* core rev < 3 only */
 #define B43legacy_MMIO_TSF_1		0x634 /* core rev < 3 only */
 #define B43legacy_MMIO_TSF_2		0x636 /* core rev < 3 only */
@@ -149,6 +150,8 @@
 #define B43legacy_SHM_SH_UCODEPATCH	0x0002 /* Microcode patchlevel */
 #define B43legacy_SHM_SH_UCODEDATE	0x0004 /* Microcode date */
 #define B43legacy_SHM_SH_UCODETIME	0x0006 /* Microcode time */
+#define B43legacy_SHM_SH_SPUWKUP	0x0094 /* pre-wakeup for synth PU in us */
+#define B43legacy_SHM_SH_PRETBTT	0x0096 /* pre-TBTT in us */
 
 #define B43legacy_UCODEFLAGS_OFFSET     0x005E
 
Index: bcm-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- bcm-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ bcm-testing/drivers/net/wireless/b43legacy/main.c
@@ -3007,6 +3007,34 @@ static void b43legacy_set_retry_limits(s
 	b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS, 0x0007, long_retry);
 }
 
+static void b43legacy_set_synth_pu_delay(struct b43legacy_wldev *dev,
+					  bool idle) {
+	u16 pu_delay = 1050;
+
+	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS) || idle)
+		pu_delay = 500;
+	if ((dev->phy.radio_ver == 0x2050) && (dev->phy.radio_rev == 8))
+		pu_delay = max(pu_delay, (u16)2400);
+
+	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
+			      B43legacy_SHM_SH_SPUWKUP, pu_delay);
+}
+
+/* Set the TSF CFP pre-TargetBeaconTransmissionTime. */
+static void b43legacy_set_pretbtt(struct b43legacy_wldev *dev)
+{
+	u16 pretbtt;
+
+	/* The time value is in microseconds. */
+	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
+		pretbtt = 2;
+	else
+		pretbtt = 250;
+	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
+			      B43legacy_SHM_SH_PRETBTT, pretbtt);
+	b43legacy_write16(dev, B43legacy_MMIO_TSF_CFP_PRETBTT, pretbtt);
+}
+
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev)
@@ -3193,9 +3221,7 @@ static int b43legacy_wireless_core_init(
 	if (err)
 		goto err_chip_exit;
 
-	b43legacy_write16(dev, 0x0612, 0x0050);
-	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, 0x0416, 0x0050);
-	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, 0x0414, 0x01F4);
+	b43legacy_set_synth_pu_delay(dev, 1);
 
 	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
 	b43legacy_upload_card_macaddress(dev);
@@ -3251,6 +3277,8 @@ static int b43legacy_op_add_interface(st
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43legacy_adjust_opmode(dev);
+	b43legacy_set_pretbtt(dev);
+	b43legacy_set_synth_pu_delay(dev, 0);
 	b43legacy_upload_card_macaddress(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 


--
Ciao
Stefano
