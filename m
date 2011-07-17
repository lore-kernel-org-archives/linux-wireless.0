Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39394 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1GQIE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 04:04:28 -0400
Received: by fxd18 with SMTP id 18so4870963fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 01:04:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: handle alternative SPROM location
Date: Sun, 17 Jul 2011 10:43:05 +0200
Message-Id: <1310892185-4225-1-git-send-email-zajec5@gmail.com> (sfid-20110717_100437_049398_0FE55F86)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cards do not use additional 0x30 offset for SPROM locations. We do
not know the real condition for it yet, make it BCM4331 specific now
now.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c                        |   12 +++++++++---
 include/linux/bcma/bcma_driver_chipcommon.h |    3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 52917e5..8b5b785 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -20,12 +20,12 @@
  * R/W ops.
  **************************************************/
 
-static void bcma_sprom_read(struct bcma_bus *bus, u16 *sprom)
+static void bcma_sprom_read(struct bcma_bus *bus, u16 offset, u16 *sprom)
 {
 	int i;
 	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
 		sprom[i] = bcma_read16(bus->drv_cc.core,
-				       BCMA_CC_SPROM + (i * 2));
+				       offset + (i * 2));
 }
 
 /**************************************************
@@ -137,6 +137,7 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 
 int bcma_sprom_get(struct bcma_bus *bus)
 {
+	u16 offset;
 	u16 *sprom;
 	int err = 0;
 
@@ -151,7 +152,12 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!sprom)
 		return -ENOMEM;
 
-	bcma_sprom_read(bus, sprom);
+	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
+	 * According to brcm80211 this applies to cards with PCIe rev >= 6
+	 * TODO: understand this condition and use it */
+	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
+		BCMA_CC_SPROM_PCIE6;
+	bcma_sprom_read(bus, offset, sprom);
 
 	err = bcma_sprom_valid(sprom);
 	if (err)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 6e7b8b5..a0f6846 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -236,7 +236,8 @@
 #define BCMA_CC_REGCTL_DATA		0x065C
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
-#define BCMA_CC_SPROM			0x0830 /* SPROM beginning */
+#define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
+#define BCMA_CC_SPROM_PCIE6		0x0830 /* SPROM beginning on PCIe rev >= 6 */
 
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
-- 
1.7.3.4

