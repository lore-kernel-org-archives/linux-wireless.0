Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44549 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2D2AFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/8] ssb: remove rev from boardinfo
Date: Sun, 29 Apr 2012 02:04:06 +0200
Message-Id: <1335657853-23925-2-git-send-email-hauke@hauke-m.de> (sfid-20120429_020522_883833_2E39EBD0)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the rev contained the revision read from the pci config
space and was used as board_rev in the wireless drivers. This is wrong
the board_rev is only fetched from the sprom accordingly to the open
source part of the Broadcom SDK and brcmsmac. This patch removes the
rev from the boardinfo structure and uses the board_rev attribute from
sprom instead. This attribute is filled by PCI, PCMCIA, SDIO and SoC
code.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/setup.c              |    2 --
 drivers/net/wireless/b43/bus.c         |    2 +-
 drivers/net/wireless/b43/main.c        |    4 ++--
 drivers/net/wireless/b43legacy/main.c  |    2 +-
 drivers/net/wireless/b43legacy/phy.c   |    4 ++--
 drivers/net/wireless/b43legacy/radio.c |   10 +++++-----
 drivers/ssb/pci.c                      |    1 -
 include/linux/ssb/ssb.h                |    1 -
 8 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 19780aa..d9278a8 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -115,8 +115,6 @@ static int bcm47xx_get_invariants(struct ssb_bus *bus,
 		iv->boardinfo.vendor = SSB_BOARDVENDOR_BCM;
 	if (nvram_getenv("boardtype", buf, sizeof(buf)) >= 0)
 		iv->boardinfo.type = (u16)simple_strtoul(buf, NULL, 0);
-	if (nvram_getenv("boardrev", buf, sizeof(buf)) >= 0)
-		iv->boardinfo.rev = (u16)simple_strtoul(buf, NULL, 0);
 
 	bcm47xx_fill_sprom(&iv->sprom, NULL);
 
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 424692d..8f3c0a8 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -210,7 +210,7 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 
 	dev->board_vendor = sdev->bus->boardinfo.vendor;
 	dev->board_type = sdev->bus->boardinfo.type;
-	dev->board_rev = sdev->bus->boardinfo.rev;
+	dev->board_rev = sdev->bus->sprom.board_rev;
 
 	dev->chip_id = sdev->bus->chip_id;
 	dev->chip_rev = sdev->bus->chip_rev;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 617afc8..5a39b22 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5243,10 +5243,10 @@ static void b43_sprom_fixup(struct ssb_bus *bus)
 
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
-	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
+	    bus->chip_id == 0x4301 && bus->sprom.board_rev == 0x74)
 		bus->sprom.boardflags_lo |= B43_BFL_BTCOEXIST;
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
-	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
+	    bus->boardinfo.type == 0x4E && bus->sprom.board_rev > 0x40)
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
 		pdev = bus->host_pci;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1be214b..85f58f9 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3781,7 +3781,7 @@ static void b43legacy_sprom_fixup(struct ssb_bus *bus)
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E &&
-	    bus->boardinfo.rev > 0x40)
+	    bus->sprom.board_rev > 0x40)
 		bus->sprom.boardflags_lo |= B43legacy_BFL_PACTRL;
 }
 
diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 9503341..995c7d0 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -408,7 +408,7 @@ static void b43legacy_phy_setupg(struct b43legacy_wldev *dev)
 
 		if (is_bcm_board_vendor(dev) &&
 		    (dev->dev->bus->boardinfo.type == 0x0416) &&
-		    (dev->dev->bus->boardinfo.rev == 0x0017))
+		    (dev->dev->bus->sprom.board_rev == 0x0017))
 			return;
 
 		b43legacy_ilt_write(dev, 0x5001, 0x0002);
@@ -424,7 +424,7 @@ static void b43legacy_phy_setupg(struct b43legacy_wldev *dev)
 
 		if (is_bcm_board_vendor(dev) &&
 		    (dev->dev->bus->boardinfo.type == 0x0416) &&
-		    (dev->dev->bus->boardinfo.rev == 0x0017))
+		    (dev->dev->bus->sprom.board_rev == 0x0017))
 			return;
 
 		b43legacy_ilt_write(dev, 0x0401, 0x0002);
diff --git a/drivers/net/wireless/b43legacy/radio.c b/drivers/net/wireless/b43legacy/radio.c
index fcbafcd..8961776 100644
--- a/drivers/net/wireless/b43legacy/radio.c
+++ b/drivers/net/wireless/b43legacy/radio.c
@@ -1998,7 +1998,7 @@ u16 b43legacy_default_radio_attenuation(struct b43legacy_wldev *dev)
 			if (phy->type == B43legacy_PHYTYPE_G) {
 				if (is_bcm_board_vendor(dev) &&
 				    dev->dev->bus->boardinfo.type == 0x421 &&
-				    dev->dev->bus->boardinfo.rev >= 30)
+				    dev->dev->bus->sprom.board_rev >= 30)
 					att = 3;
 				else if (is_bcm_board_vendor(dev) &&
 					 dev->dev->bus->boardinfo.type == 0x416)
@@ -2008,7 +2008,7 @@ u16 b43legacy_default_radio_attenuation(struct b43legacy_wldev *dev)
 			} else {
 				if (is_bcm_board_vendor(dev) &&
 				    dev->dev->bus->boardinfo.type == 0x421 &&
-				    dev->dev->bus->boardinfo.rev >= 30)
+				    dev->dev->bus->sprom.board_rev >= 30)
 					att = 7;
 				else
 					att = 6;
@@ -2018,7 +2018,7 @@ u16 b43legacy_default_radio_attenuation(struct b43legacy_wldev *dev)
 			if (phy->type == B43legacy_PHYTYPE_G) {
 				if (is_bcm_board_vendor(dev) &&
 				    dev->dev->bus->boardinfo.type == 0x421 &&
-				    dev->dev->bus->boardinfo.rev >= 30)
+				    dev->dev->bus->sprom.board_rev >= 30)
 					att = 3;
 				else if (is_bcm_board_vendor(dev) &&
 					 dev->dev->bus->boardinfo.type ==
@@ -2052,9 +2052,9 @@ u16 b43legacy_default_radio_attenuation(struct b43legacy_wldev *dev)
 	}
 	if (is_bcm_board_vendor(dev) &&
 	    dev->dev->bus->boardinfo.type == 0x421) {
-		if (dev->dev->bus->boardinfo.rev < 0x43)
+		if (dev->dev->bus->sprom.board_rev < 0x43)
 			att = 2;
-		else if (dev->dev->bus->boardinfo.rev < 0x51)
+		else if (dev->dev->bus->sprom.board_rev < 0x51)
 			att = 3;
 	}
 	if (att == 0xFFFF)
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index ed41244..113208e 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -784,7 +784,6 @@ static void ssb_pci_get_boardinfo(struct ssb_bus *bus,
 {
 	bi->vendor = bus->host_pci->subsystem_vendor;
 	bi->type = bus->host_pci->subsystem_device;
-	bi->rev = bus->host_pci->revision;
 }
 
 int ssb_pci_get_invariants(struct ssb_bus *bus,
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index d276831..bc14bd7 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -188,7 +188,6 @@ struct ssb_sprom {
 struct ssb_boardinfo {
 	u16 vendor;
 	u16 type;
-	u8  rev;
 };
 
 
-- 
1.7.9.5

