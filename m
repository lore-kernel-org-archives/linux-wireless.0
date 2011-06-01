Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37706 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1FAW3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 18:29:49 -0400
Received: by ewy4 with SMTP id 4so91128ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 15:29:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: do not use SSB specific flags when calling core reset function
Date: Thu,  2 Jun 2011 01:07:12 +0200
Message-Id: <1306969632-8451-1-git-send-email-zajec5@gmail.com> (sfid-20110602_002953_019169_D8BD6505)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luckily the only flag we use when calling core reset is GMODE one.
Thanks to that we can just switch to single bool and make function calls
bus generic.

Tested on my BCM4312 (LP-PHY) and early tested with BCM43224.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  |   25 +++++++++++--------------
 drivers/net/wireless/b43/main.h  |    2 +-
 drivers/net/wireless/b43/phy_g.c |    2 +-
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 659bc31..1b9d3cc 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1144,11 +1144,14 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	}
 }
 
-static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
+static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	struct ssb_device *sdev = dev->dev->sdev;
 	u32 tmslow;
+	u32 flags = 0;
 
+	if (gmode)
+		flags |= B43_TMSLOW_GMODE;
 	flags |= B43_TMSLOW_PHYCLKEN;
 	flags |= B43_TMSLOW_PHYRESET;
 	if (dev->phy.type == B43_PHYTYPE_N)
@@ -1169,11 +1172,11 @@ static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 	msleep(1);
 }
 
-void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
+void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	u32 macctl;
 
-	b43_ssb_wireless_core_reset(dev, flags);
+	b43_ssb_wireless_core_reset(dev, gmode);
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
 	 * This protects against very early setup where we don't know the
@@ -1184,7 +1187,7 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
 	macctl &= ~B43_MACCTL_GMODE;
-	if (flags & B43_TMSLOW_GMODE)
+	if (gmode)
 		macctl |= B43_MACCTL_GMODE;
 	macctl |= B43_MACCTL_IHR_ENABLED;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
@@ -4328,17 +4331,14 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	int err;
 	u64 hf;
-	u32 tmp;
 
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
 
 	err = b43_bus_powerup(dev, 0);
 	if (err)
 		goto out;
-	if (!b43_device_is_enabled(dev)) {
-		tmp = phy->gmode ? B43_TMSLOW_GMODE : 0;
-		b43_wireless_core_reset(dev, tmp);
-	}
+	if (!b43_device_is_enabled(dev))
+		b43_wireless_core_reset(dev, phy->gmode);
 
 	/* Reset all data structures. */
 	setup_struct_wldev_for_init(dev);
@@ -4747,7 +4747,6 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
 	int err;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
-	u32 tmp;
 
 	/* Do NOT do any device initialization here.
 	 * Do it in wireless_core_init() instead.
@@ -4773,8 +4772,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 
 	dev->phy.gmode = have_2ghz_phy;
 	dev->phy.radio_on = 1;
-	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
-	b43_wireless_core_reset(dev, tmp);
+	b43_wireless_core_reset(dev, dev->phy.gmode);
 
 	err = b43_phy_versioning(dev);
 	if (err)
@@ -4822,8 +4820,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		goto err_powerdown;
 
 	dev->phy.gmode = have_2ghz_phy;
-	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
-	b43_wireless_core_reset(dev, tmp);
+	b43_wireless_core_reset(dev, dev->phy.gmode);
 
 	err = b43_validate_chipaccess(dev);
 	if (err)
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index a0d327f..e4ebce9 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -121,7 +121,7 @@ void b43_hf_write(struct b43_wldev *dev, u64 value);
 
 void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on);
 
-void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
+void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode);
 
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 684be1f..83532d1 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2535,7 +2535,7 @@ static int b43_gphy_op_prepare_hardware(struct b43_wldev *dev)
 		b43_wireless_core_reset(dev, 0);
 		b43_phy_initg(dev);
 		phy->gmode = 1;
-		b43_wireless_core_reset(dev, B43_TMSLOW_GMODE);
+		b43_wireless_core_reset(dev, 1);
 	}
 
 	return 0;
-- 
1.7.3.4

