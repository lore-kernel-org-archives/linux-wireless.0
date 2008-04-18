Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57183 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYDRSyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 14:54:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Workaround invalid bluetooth settings
Date: Fri, 18 Apr 2008 20:51:41 +0200
Cc: "Stefanik =?utf-8?q?G=C3=A1bor?=" <netrolller.3d@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"kala mazoo" <myheadblewoff@hotmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <BAY107-W16EB5E320C48AEF9114BD6A0E40@phx.gbl> <4808E8AD.8040900@lwfinger.net> <69e28c910804181141u711e4f74g5b91ed17bd4273e0@mail.gmail.com>
In-Reply-To: <69e28c910804181141u711e4f74g5b91ed17bd4273e0@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200804182051.42468.mb@bu3sch.de> (sfid-20080418_195451_123854_CABF0862)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a workaround for invalid bluetooth SPROM settings
on ASUS PCI cards.
This will stop the microcode from poking with the BT GPIO line.
This fixes data transmission on this device, as the BT GPIO line
is used for something TX related on this device
(probably the power amplifier or the radio).
This also adds a modparam knob to help debugging this in the future,
as more devices with this bug may show up.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is 2.6.26 stuff.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-18 19:54:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-18 20:51:13.000000000 +0200
@@ -81,12 +81,16 @@ module_param_named(nohwcrypt, modparam_n
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 int b43_modparam_qos = 1;
 module_param_named(qos, b43_modparam_qos, int, 0444);
 MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
 
+static int modparam_btcoex = 1;
+module_param_named(btcoex, modparam_btcoex, int, 0444);
+MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistance (default on)");
+
 
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
@@ -3705,28 +3709,32 @@ static void setup_struct_wldev_for_init(
 
 static void b43_bluetooth_coext_enable(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
 	u32 hf;
 
+	if (!modparam_btcoex)
+		return;
 	if (!(sprom->boardflags_lo & B43_BFL_BTCOEXIST))
 		return;
 	if (dev->phy.type != B43_PHYTYPE_B && !dev->phy.gmode)
 		return;
 
 	hf = b43_hf_read(dev);
 	if (sprom->boardflags_lo & B43_BFL_BTCMOD)
 		hf |= B43_HF_BTCOEXALT;
 	else
 		hf |= B43_HF_BTCOEX;
 	b43_hf_write(dev, hf);
-	//TODO
 }
 
 static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
-{				//TODO
+{
+	if (!modparam_btcoex)
+		return;
+	//TODO
 }
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 {
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 	struct ssb_bus *bus = dev->dev->bus;
@@ -4413,19 +4421,29 @@ static int b43_one_core_attach(struct ss
 	kfree(wldev);
 	return err;
 }
 
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
+	struct pci_dev *pdev;
+
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
 	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
 		bus->sprom.boardflags_lo |= B43_BFL_BTCOEXIST;
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
+	if (bus->bustype == SSB_BUSTYPE_PCI) {
+		pdev = bus->host_pci;
+		if (pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
+		    pdev->device == 0x4318 &&
+		    pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK &&
+		    pdev->subsystem_device == 0x100F)
+			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
+	}
 }
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)
 {
 	struct ieee80211_hw *hw = wl->hw;
 
