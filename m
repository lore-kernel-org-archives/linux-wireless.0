Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab1ESMdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 08:33:46 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so743998eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 05:33:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	Julian Calaby <julian.calaby@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: use new pointers path to access ssb_device in SSB specific places
Date: Thu, 19 May 2011 15:11:26 +0200
Message-Id: <1305810687-4567-3-git-send-email-zajec5@gmail.com> (sfid-20110519_143350_465297_22586CE2)
In-Reply-To: <1305810687-4567-1-git-send-email-zajec5@gmail.com>
References: <1305810687-4567-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index bb82ddf..99411da 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1146,6 +1146,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 
 static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 {
+	struct ssb_device *sdev = dev->dev->sdev;
 	u32 tmslow;
 
 	flags |= B43_TMSLOW_PHYCLKEN;
@@ -1156,15 +1157,15 @@ static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 	msleep(2);		/* Wait for the PLL to turn on. */
 
 	/* Now take the PHY out of Reset again */
-	tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
+	tmslow = ssb_read32(sdev, SSB_TMSLOW);
 	tmslow |= SSB_TMSLOW_FGC;
 	tmslow &= ~B43_TMSLOW_PHYRESET;
-	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
-	ssb_read32(dev->sdev, SSB_TMSLOW);	/* flush */
+	ssb_write32(sdev, SSB_TMSLOW, tmslow);
+	ssb_read32(sdev, SSB_TMSLOW);	/* flush */
 	msleep(1);
 	tmslow &= ~SSB_TMSLOW_FGC;
-	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
-	ssb_read32(dev->sdev, SSB_TMSLOW);	/* flush */
+	ssb_write32(sdev, SSB_TMSLOW, tmslow);
+	ssb_read32(sdev, SSB_TMSLOW);	/* flush */
 	msleep(1);
 }
 
@@ -2157,7 +2158,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
 		if ((rev >= 5) && (rev <= 10)) {
-			tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
+			tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
 			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 				filename = "a0g1initvals5";
 			else
@@ -2202,7 +2203,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
 		if ((rev >= 5) && (rev <= 10)) {
-			tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
+			tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
 			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 				filename = "a0g1bsinitvals5";
 			else
@@ -2566,7 +2567,7 @@ out:
  */
 static struct ssb_device *b43_ssb_gpio_dev(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 	return (bus->chipco.dev ? bus->chipco.dev : bus->pcicore.dev);
@@ -4231,16 +4232,21 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus;
 	u32 tmp;
 
+	if (dev->dev->bus_type != B43_BUS_SSB)
+		return;
+
+	bus = dev->dev->sdev->bus;
+
 	if ((bus->chip_id == 0x4311 && bus->chip_rev == 2) ||
 	    (bus->chip_id == 0x4312)) {
-		tmp = ssb_read32(dev->sdev, SSB_IMCFGLO);
+		tmp = ssb_read32(dev->dev->sdev, SSB_IMCFGLO);
 		tmp &= ~SSB_IMCFGLO_REQTO;
 		tmp &= ~SSB_IMCFGLO_SERTO;
 		tmp |= 0x3;
-		ssb_write32(dev->sdev, SSB_IMCFGLO, tmp);
+		ssb_write32(dev->dev->sdev, SSB_IMCFGLO, tmp);
 		ssb_commit_settings(bus);
 	}
 }
-- 
1.7.3.4

