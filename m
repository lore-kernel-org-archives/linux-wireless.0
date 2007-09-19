Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36175
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbXISRAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 13:00:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Change loglevel of radio-enable message.
Date: Wed, 19 Sep 2007 18:58:38 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709191858.38634.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also cleanup the code a bit and remove the inline.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-19 18:26:34.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-19 18:47:04.000000000 +0200
@@ -2175,6 +2175,21 @@ static void b43_mgmtframe_txantenna(stru
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL, tmp);
 }
 
+/* Returns TRUE, if the radio is enabled in hardware. */
+static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
+{
+	if (dev->phy.rev >= 3) {
+		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
+		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
+			return 1;
+	} else {
+		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
+			return 1;
+	}
+	return 0;
+}
+
 /* This is the opposite of b43_chip_init() */
 static void b43_chip_exit(struct b43_wldev *dev)
 {
@@ -2214,7 +2229,7 @@ static int b43_chip_init(struct b43_wlde
 	b43_radio_turn_on(dev);
 	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
 	b43dbg(dev->wl, "Radio %s by hardware\n",
-	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
+	       dev->radio_hw_enable ? "enabled" : "disabled");
 
 	b43_write16(dev, 0x03E6, 0x0000);
 	err = b43_phy_init(dev);
@@ -2373,14 +2388,14 @@ static void b43_periodic_every15sec(stru
 
 static void b43_periodic_every1sec(struct b43_wldev *dev)
 {
-	int radio_hw_enable;
+	bool radio_hw_enable;
 
 	/* check if radio hardware enabled status changed */
 	radio_hw_enable = b43_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
-		b43dbg(dev->wl, "Radio hardware status changed to %s\n",
-		       (radio_hw_enable == 0) ? "disabled" : "enabled");
+		b43info(dev->wl, "Radio hardware status changed to %s\n",
+			radio_hw_enable ? "ENABLED" : "DISABLED");
 		b43_leds_update(dev, 0);
 	}
 }
Index: wireless-dev/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.h	2007-09-19 17:15:58.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.h	2007-09-19 18:40:57.000000000 +0200
@@ -96,23 +96,6 @@ static inline int b43_is_ofdm_rate(int r
 	return !b43_is_cck_rate(rate);
 }
 
-static inline int b43_is_hw_radio_enabled(struct b43_wldev *dev)
-{
-	/* function to return state of hardware enable of radio
-	 * returns 0 if radio disabled, 1 if radio enabled
-	 */
-	struct b43_phy *phy = &dev->phy;
-
-	if (phy->rev >= 3)
-		return ((b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
-			 & B43_MMIO_RADIO_HWENABLED_HI_MASK)
-			== 0) ? 1 : 0;
-	else
-		return ((b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
-			 & B43_MMIO_RADIO_HWENABLED_LO_MASK)
-			== 0) ? 0 : 1;
-}
-
 void b43_tsf_read(struct b43_wldev *dev, u64 * tsf);
 void b43_tsf_write(struct b43_wldev *dev, u64 tsf);
 
