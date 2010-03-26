Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0CZFjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 01:39:21 -0400
Date: Fri, 26 Mar 2010 00:39:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V4] ssb: Implement virtual SPROM
Message-ID: <4bac487c.j3EXBzCzHYNAd+Ky%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
from the SPROM could be included in the kernel; however, this presents
a problem in the generation of a unique, reproducible MAC address. The
solution is to initialize the address to a known, workable value. Thus,
the device will work without any further code. For an address that is
preserved across reloads or reboots, a set of udev routines has been
prepared that detect the special address and assign a random value that
is preserved in a second udev rule file. The random address should be
unique except for the case where a given box has more than one of these
cards. This case is handles by adding the DEVPATH to the recognition rules.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

It has been a long path, but this solution satisfies all the criticisms
that have been posted.

I suspect it is a little to invasive for 2.6.34. In addition, it fixes
a bug, but not a regression. As to introducing a regression, that could
only happen if ssb_is_sprom_available() returns false for some device
that does have an SPROM.

Larry
---

V2 - make virtual SPROM loading asynchronous.
V3 - eliminate the need for a special external utility
   - set for unique MAC address even if a box has more than one of these
     devices
V4 - handle the requirements without any "firmware" routines.

Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -613,6 +613,67 @@ static int sprom_extract(struct ssb_bus
 	return 0;
 }
 
+static void ssb_get_vsprom(struct ssb_sprom *sprom)
+{
+	/* Get values that would have been extracted from SPROM.
+	 * If sprom_extract_r8() is changed, this section must be
+	 * changed as well. For any device with 5GHz capability,
+	 * some variables will have to be changed.
+	 */
+	sprom->revision = 8;
+	sprom->boardflags_lo = 0x0A01;
+	sprom->boardflags_hi = 0x0006;
+	sprom->boardflags2_lo = 0x0000;
+	sprom->boardflags2_hi = 0x0000;
+	sprom->ant_available_a = 0x00;
+	sprom->ant_available_bg = 0x03;
+	sprom->maxpwr_bg = 0x4A;
+	sprom->itssi_bg = 0x3E;
+	sprom->maxpwr_a = 0xFF;
+	sprom->itssi_a = 0xFF;
+	sprom->maxpwr_ah = 0xFF;
+	sprom->maxpwr_al = 0xFF;
+	sprom->gpio0 = 0x83;
+	sprom->gpio1 = 0xFF;
+	sprom->gpio2 = 0xFF;
+	sprom->gpio3 = 0xFF;
+	sprom->tri2g = 0x6C;
+	sprom->tri5g = 0x00;
+	sprom->tri5gl = 0xFF;
+	sprom->tri5gh = 0xFF;
+	sprom->rxpo2g = 0xFA;
+	sprom->rxpo5g = 0xFF;
+	sprom->rssismf2g = 0x0F;
+	sprom->rssismc2g = 0x00;
+	sprom->rssisav2g = 0x00;
+	sprom->bxa2g = 0x00;
+	sprom->rssismf5g = 0x0F;
+	sprom->rssismc5g = 0x0F;
+	sprom->rssisav5g = 0x07;
+	sprom->bxa5g = 0x03;
+	sprom->pa0b0 = 0x1a57;
+	sprom->pa0b1 = 0xF98A;
+	sprom->pa0b2 = 0xFE91;
+	sprom->pa1b0 = 0xFFFF;
+	sprom->pa1b1 = 0xFFFF;
+	sprom->pa1b2 = 0xFFFF;
+	sprom->pa1lob0 = 0xFFFF;
+	sprom->pa1lob1 = 0xFFFF;
+	sprom->pa1lob2 = 0xFFFF;
+	sprom->pa1hib0 = 0xFFFF;
+	sprom->pa1hib1 = 0xFFFF;
+	sprom->pa1hib2 = 0xFFFF;
+	sprom->cck2gpo = 0xFFFF;
+	sprom->ofdm2gpo = 0x00000002;
+	sprom->ofdm5glpo = 0xFFFFFFFF;
+	sprom->ofdm5gpo = 0xFFFFFFFF;
+	sprom->ofdm5ghpo = 0xFFFFFFFF;
+	/* assign a dummy, but usable, MAC address */
+	memset(sprom->il0mac, 0x82, 6);
+	memset(sprom->et0mac, 0xFF, 6);
+	memset(sprom->et1mac, 0xFF, 6);
+}
+
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
@@ -621,8 +682,9 @@ static int ssb_pci_sprom_get(struct ssb_
 	u16 *buf;
 
 	if (!ssb_is_sprom_available(bus)) {
-		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
-		return -ENODEV;
+		/* This device has no SPROM. Get values from a real SPROM */
+		ssb_get_vsprom(sprom);
+		return 0;
 	}
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4395,6 +4395,7 @@ static int b43_op_add_interface(struct i
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
 	int err = -EOPNOTSUPP;
+	u8 test_addr[] = {0x82, 0x82, 0x82, 0x82, 0x82, 0x82};
 
 	/* TODO: allow WDS/AP devices to coexist */
 
@@ -4417,6 +4418,19 @@ static int b43_op_add_interface(struct i
 	wl->if_type = vif->type;
 	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
+	/* Check if address given when device has no SPROM is still present */
+	if (compare_ether_addr(wl->mac_addr, test_addr) == 0) {
+		printk(KERN_INFO "b43: **************************\n");
+		printk(KERN_INFO "     The hardware address matches the one "
+				       "assigned for devices\n");
+		printk(KERN_INFO "     with no SPROM. To ensure that your address"
+				       " is unique go to\n");
+		printk(KERN_INFO "     http://wireless.kernel.org/en/users/"
+				       "Drivers/b43");
+		printk(KERN_INFO "     to download and install the necessary"
+				       " udev rules.\n");
+		printk(KERN_INFO "     **************************\n");
+	}
 	b43_adjust_opmode(dev);
 	b43_set_pretbtt(dev);
 	b43_set_synth_pu_delay(dev, 0);
