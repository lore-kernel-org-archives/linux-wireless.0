Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0AaWDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 17:03:33 -0500
Date: Sun, 31 Jan 2010 16:03:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] b43: Fix regression from commit c7ab5ef
Message-ID: <4b65fe2d.tW61Y0okWmOLTL3e%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had planned to address the issues reported in the thread "BCM4311/02
ABG disconnects on 2.6.32"; however, when I installed my BCM4311/2 card,
I found that the transmit rate as measured using program tcpperf was
greatly reduced from what I had seen when it was last in the machine.
With bisection, mainline commit number c7ab5ef9b was the problem. This
patch was part of the 2.6.28 merge, thus this problem has existed for
some time.

The patch changes basic rate handling and implements short slot handling.
The rate handling is OK - only the short slot changes were affecting
the performance. Further investigation showed that the original code
never called the routines that enable/disable short slot treatment,
but the revised code does. From the specs, changing this parameter
involves writing new values into a location in MMIO space and one in
the shared memory. Experimentation showed that writing the new value
to shared memory was the culprit. Changing the value in MMIO space
actually helped performance in some cases.

Tests on all my G PHY devices are summarized below. My AP is a Linksys
WRT54G V5 running the latest version of standard firmware, and with
combined 802.11b/g mode enabled. Transmit tests use program tcpperf
with a fast computer in my network as the tcpperf server. It is connected
to the AP/router with a 100 Mb/s wired connection. The results for all
my devices as as follows:

                         Transmit throughput in Mb/s
Device        Before c7ab5ef   After c7ab5ef  With this patch

BCM4306/3       unknown          5.3             19.0
BCM4318/2       unknown         18.3             18.3
BCM4311/2       18.3             0.7             22.1
BCM4312/1       N/A*            12.2             12.2

* LP PHY that was not supported until 2.6.32.

I have no idea what causes some devices to be unaffected, while others
are greatly improved. Please test to see if your device is adversely
affested.

Thanks,

Larry

--- Proposed commit message below. ---

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
improvement of the transmit rate.

Other changes in the patch include removal of the magic number for the
MMIO register, and allowing the slot time to be set for any PHY operating
in the 2.4 GHz band. Previously, the routine was executed only for G PHYs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org> [Any stable version back through 2.6.28]
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
