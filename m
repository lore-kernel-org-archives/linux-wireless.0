Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60336 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYDENDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 09:03:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix beacon BH update
Date: Sat, 5 Apr 2008 15:02:09 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804051502.09379.mb@bu3sch.de> (sfid-20080405_140311_477518_B8DA28A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes beacon updating in the bottomhalf.
In case the device is busy, we will defer to later in the IRQ handler.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.26 in addition to the beacon patch I sent yesterday.


 drivers/net/wireless/b43/main.c |   98 +++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 41 deletions(-)

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-05 14:09:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-05 14:48:01.000000000 +0200
@@ -1445,28 +1445,76 @@ static void b43_write_probe_resp_templat
 	b43_write_template_common(dev, probe_resp_data,
 				  size, ram_offset, shm_size_offset,
 				  rate->hw_value);
 	kfree(probe_resp_data);
 }
 
+static void handle_irq_beacon(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+	u32 cmd, beacon0_valid, beacon1_valid;
+
+	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
+		return;
+
+	/* This is the bottom half of the asynchronous beacon update. */
+
+	/* Ignore interrupt in the future. */
+	dev->irq_savedstate &= ~B43_IRQ_BEACON;
+
+	cmd = b43_read32(dev, B43_MMIO_MACCMD);
+	beacon0_valid = (cmd & B43_MACCMD_BEACON0_VALID);
+	beacon1_valid = (cmd & B43_MACCMD_BEACON1_VALID);
+
+	/* Schedule interrupt manually, if busy. */
+	if (beacon0_valid && beacon1_valid) {
+		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_BEACON);
+		dev->irq_savedstate |= B43_IRQ_BEACON;
+		return;
+	}
+
+	if (!beacon0_valid) {
+		if (!wl->beacon0_uploaded) {
+			b43_write_beacon_template(dev, 0x68, 0x18,
+						  B43_CCK_RATE_1MB);
+			b43_write_probe_resp_template(dev, 0x268, 0x4A,
+						      &__b43_ratetable[3]);
+			wl->beacon0_uploaded = 1;
+		}
+		cmd = b43_read32(dev, B43_MMIO_MACCMD);
+		cmd |= B43_MACCMD_BEACON0_VALID;
+		b43_write32(dev, B43_MMIO_MACCMD, cmd);
+	} else if (!beacon1_valid) {
+		if (!wl->beacon1_uploaded) {
+			b43_write_beacon_template(dev, 0x468, 0x1A,
+						  B43_CCK_RATE_1MB);
+			wl->beacon1_uploaded = 1;
+		}
+		cmd = b43_read32(dev, B43_MMIO_MACCMD);
+		cmd |= B43_MACCMD_BEACON1_VALID;
+		b43_write32(dev, B43_MMIO_MACCMD, cmd);
+	}
+}
+
 static void b43_beacon_update_trigger_work(struct work_struct *work)
 {
 	struct b43_wl *wl = container_of(work, struct b43_wl,
 					 beacon_update_trigger);
 	struct b43_wldev *dev;
 
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
-		/* Force the microcode to trigger the
-		 * beacon update bottom-half IRQ. */
 		spin_lock_irq(&wl->irq_lock);
-		b43_write32(dev, B43_MMIO_MACCMD,
-			    b43_read32(dev, B43_MMIO_MACCMD)
-			    | B43_MACCMD_BEACON0_VALID
-			    | B43_MACCMD_BEACON1_VALID);
+		/* update beacon right away or defer to irq */
+		dev->irq_savedstate = b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);
+		handle_irq_beacon(dev);
+		/* The handler might have updated the IRQ mask. */
+		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK,
+			    dev->irq_savedstate);
+		mmiowb();
 		spin_unlock_irq(&wl->irq_lock);
 	}
 	mutex_unlock(&wl->mutex);
 }
 
 /* Asynchronously update the packet templates in template RAM.
@@ -1517,47 +1565,12 @@ static void b43_set_beacon_int(struct b4
 		b43_write16(dev, 0x610, beacon_int);
 	}
 	b43_time_unlock(dev);
 	b43dbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
-static void handle_irq_beacon(struct b43_wldev *dev)
-{
-	struct b43_wl *wl = dev->wl;
-	u32 cmd, beacon0_valid, beacon1_valid;
-
-	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
-		return;
-
-	/* This is the bottom half of the asynchronous beacon update. */
-
-	cmd = b43_read32(dev, B43_MMIO_MACCMD);
-	beacon0_valid = (cmd & B43_MACCMD_BEACON0_VALID);
-	beacon1_valid = (cmd & B43_MACCMD_BEACON1_VALID);
-	cmd &= ~(B43_MACCMD_BEACON0_VALID | B43_MACCMD_BEACON1_VALID);
-
-	if (!beacon0_valid) {
-		if (!wl->beacon0_uploaded) {
-			b43_write_beacon_template(dev, 0x68, 0x18,
-						  B43_CCK_RATE_1MB);
-			b43_write_probe_resp_template(dev, 0x268, 0x4A,
-						      &__b43_ratetable[3]);
-			wl->beacon0_uploaded = 1;
-		}
-		cmd |= B43_MACCMD_BEACON0_VALID;
-	} else if (!beacon1_valid) {
-		if (!wl->beacon1_uploaded) {
-			b43_write_beacon_template(dev, 0x468, 0x1A,
-						  B43_CCK_RATE_1MB);
-			wl->beacon1_uploaded = 1;
-		}
-		cmd |= B43_MACCMD_BEACON1_VALID;
-	}
-	b43_write32(dev, B43_MMIO_MACCMD, cmd);
-}
-
 static void handle_irq_ucode_debug(struct b43_wldev *dev)
 {
 	//TODO
 }
 
 /* Interrupt handler bottom-half */
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-05 14:41:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-05 14:45:06.000000000 +0200
@@ -408,13 +408,12 @@ enum {
 #define B43_IRQ_TX_OK			0x20000000
 #define B43_IRQ_PHY_G_CHANGED		0x40000000
 #define B43_IRQ_TIMEOUT			0x80000000
 
 #define B43_IRQ_ALL			0xFFFFFFFF
 #define B43_IRQ_MASKTEMPLATE		(B43_IRQ_MAC_SUSPENDED | \
-					 B43_IRQ_BEACON | \
 					 B43_IRQ_TBTT_INDI | \
 					 B43_IRQ_ATIM_END | \
 					 B43_IRQ_PMQ | \
 					 B43_IRQ_MAC_TXERR | \
 					 B43_IRQ_PHY_TXERR | \
 					 B43_IRQ_DMA | \
