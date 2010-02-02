Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab0BBQIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 11:08:21 -0500
Date: Tue, 02 Feb 2010 10:08:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix regression from commit c7ab5ef
Message-ID: <4b684df3.V5ikfWDIHGqzoqeC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit c7ab5ef9bcd281135c21b4732c9be779585181be entitled "b43: implement
short slot and basic rate handling" reduced the transmit throughput for
my BCM4311 device from 18 Mb/s to 0.7 Mb/s. The basic rate handling
portion is OK, the problem is in the short slot handling.

Prior to this change, the short slot enable/disable routines were never
called. Experimentation showed that the critical part was changing the
value at offset 0x0010 in the shared memory. This is supposed to contain
the 802.11 Slot Time in usec, but if it is changed from its initial value
of zero, performance is destroyed. On the other hand, changing the value
in the MMIO register corresponding to the Interframe Slot Time increased
performance from 18 to 22 Mb/s. A BCM4306/3 also shows dramatic
improvement of the transmit rate from 5.3 to 19.0 Mb/s.

Other changes in the patch include removal of the magic number for the
MMIO register, and allowing the slot time to be set for any PHY operating
in the 2.4 GHz band. Previously, the routine was executed only for G PHYs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org> [Any stable version back through 2.6.28]
---

John,

Although late in the cycle, this is 2.6.33 material, and should be applied
to kernels back to and including 2.6.28.

Thanks,

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -637,10 +637,17 @@ static void b43_upload_card_macaddress(s
 static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
 {
 	/* slot_time is in usec. */
-	if (dev->phy.type != B43_PHYTYPE_G)
+	/* This test used to exit for all but a G PHY. */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		return;
-	b43_write16(dev, 0x684, 510 + slot_time);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	b43_write16(dev, B43_MMIO_IFSSLOT, 510 + slot_time);
+	/* Shared memory location 0x0010 is the slot time and should be
+	 * set to slot_time; however, this register is initially 0 and changing
+	 * the value adversely affects the transmit rate for BCM4311
+	 * devices. Until this behavior is unterstood, delete this step
+	 *
+	 * b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	 */
 }
 
 static void b43_short_slot_timing_enable(struct b43_wldev *dev)
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing/drivers/net/wireless/b43/b43.h
@@ -115,6 +115,7 @@
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
+#define B43_MMIO_IFSSLOT		0x684	/* Interframe slot time */
 #define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
 #define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
