Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52893 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3EMUIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 16:08:05 -0400
Received: by mail-ee0-f49.google.com with SMTP id d17so3883126eek.22
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 13:08:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] bcma: prepare for supporting more SPROM sizes
Date: Mon, 13 May 2013 22:07:52 +0200
Message-Id: <1368475673-27587-2-git-send-email-zajec5@gmail.com> (sfid-20130513_220811_845533_AE756F17)
In-Reply-To: <1368475673-27587-1-git-send-email-zajec5@gmail.com>
References: <1368475673-27587-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 5386cdd..c96f71c 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -502,7 +502,6 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 	case BCMA_CHIP_ID_BCM4331:
 		present = chip_status & BCMA_CC_CHIPST_4331_OTP_PRESENT;
 		break;
-
 	case BCMA_CHIP_ID_BCM43224:
 	case BCMA_CHIP_ID_BCM43225:
 		/* for these chips OTP is always available */
@@ -550,7 +549,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 {
 	u16 offset = BCMA_CC_SPROM;
 	u16 *sprom;
-	int err = 0;
+	size_t sprom_sizes[] = { SSB_SPROMSIZE_WORDS_R4, };
+	int i, err = 0;
 
 	if (!bus->drv_cc.core)
 		return -EOPNOTSUPP;
@@ -579,32 +579,37 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		}
 	}
 
-	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
-			GFP_KERNEL);
-	if (!sprom)
-		return -ENOMEM;
-
 	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
 	    bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
 	bcma_debug(bus, "SPROM offset 0x%x\n", offset);
-	bcma_sprom_read(bus, offset, sprom, SSB_SPROMSIZE_WORDS_R4);
+	for (i = 0; i < ARRAY_SIZE(sprom_sizes); i++) {
+		size_t words = sprom_sizes[i];
+
+		sprom = kcalloc(words, sizeof(u16), GFP_KERNEL);
+		if (!sprom)
+			return -ENOMEM;
+
+		bcma_sprom_read(bus, offset, sprom, words);
+		err = bcma_sprom_valid(sprom, words);
+		if (!err)
+			break;
+
+		kfree(sprom);
+	}
 
 	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
 	    bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
-	err = bcma_sprom_valid(sprom, SSB_SPROMSIZE_WORDS_R4);
 	if (err) {
-		bcma_warn(bus, "invalid sprom read from the PCIe card, try to use fallback sprom\n");
+		bcma_warn(bus, "Invalid SPROM read from the PCIe card, trying to use fallback SPROM\n");
 		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
-		goto out;
+	} else {
+		bcma_sprom_extract_r8(bus, sprom);
+		kfree(sprom);
 	}
 
-	bcma_sprom_extract_r8(bus, sprom);
-
-out:
-	kfree(sprom);
 	return err;
 }
-- 
1.7.10.4

