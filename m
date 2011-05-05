Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1EEKIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 06:08:23 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so617784eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 03:08:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43legacy: drop invalid IMCFGLO workaround
Date: Thu,  5 May 2011 12:46:04 +0200
Message-Id: <1304592364-5075-1-git-send-email-zajec5@gmail.com> (sfid-20110505_120826_656744_C3B2929C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were performing it on wrong core, it was outdated and is already
implemented in ssb.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43legacy/main.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c7fd73e..2162663 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3104,37 +3104,6 @@ static void setup_struct_wldev_for_init(struct b43legacy_wldev *dev)
 	memset(&dev->noisecalc, 0, sizeof(dev->noisecalc));
 }
 
-static void b43legacy_imcfglo_timeouts_workaround(struct b43legacy_wldev *dev)
-{
-#ifdef CONFIG_SSB_DRIVER_PCICORE
-	struct ssb_bus *bus = dev->dev->bus;
-	u32 tmp;
-
-	if (bus->pcicore.dev &&
-	    bus->pcicore.dev->id.coreid == SSB_DEV_PCI &&
-	    bus->pcicore.dev->id.revision <= 5) {
-		/* IMCFGLO timeouts workaround. */
-		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
-		switch (bus->bustype) {
-		case SSB_BUSTYPE_PCI:
-		case SSB_BUSTYPE_PCMCIA:
-			tmp &= ~SSB_IMCFGLO_REQTO;
-			tmp &= ~SSB_IMCFGLO_SERTO;
-			tmp |= 0x32;
-			break;
-		case SSB_BUSTYPE_SSB:
-			tmp &= ~SSB_IMCFGLO_REQTO;
-			tmp &= ~SSB_IMCFGLO_SERTO;
-			tmp |= 0x53;
-			break;
-		default:
-			break;
-		}
-		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
-	}
-#endif /* CONFIG_SSB_DRIVER_PCICORE */
-}
-
 static void b43legacy_set_synth_pu_delay(struct b43legacy_wldev *dev,
 					  bool idle) {
 	u16 pu_delay = 1050;
@@ -3278,7 +3247,6 @@ static int b43legacy_wireless_core_init(struct b43legacy_wldev *dev)
 	/* Enable IRQ routing to this device. */
 	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->dev);
 
-	b43legacy_imcfglo_timeouts_workaround(dev);
 	prepare_phy_data_for_init(dev);
 	b43legacy_phy_calibrate(dev);
 	err = b43legacy_chip_init(dev);
-- 
1.7.3.4

