Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1EEKIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 06:08:16 -0400
Received: by eyx24 with SMTP id 24so617784eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 03:08:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: drop invalid IMCFGLO workaround
Date: Thu,  5 May 2011 12:45:52 +0200
Message-Id: <1304592352-5042-1-git-send-email-zajec5@gmail.com> (sfid-20110505_120820_630124_09FE1EC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were performing it on wrong core, it was outdated and is already
implemented in ssb.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5af40d9..f907df0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4213,33 +4213,7 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 {
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
+	/* TODO: implement 80211 core workaround here */
 }
 
 static void b43_set_synth_pu_delay(struct b43_wldev *dev, bool idle)
-- 
1.7.3.4

