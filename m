Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33884 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3EMUID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 16:08:03 -0400
Received: by mail-ea0-f176.google.com with SMTP id h14so3793159eak.7
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 13:08:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] bcma: don't hardcode SPROM length
Date: Mon, 13 May 2013 22:07:51 +0200
Message-Id: <1368475673-27587-1-git-send-email-zajec5@gmail.com> (sfid-20130513_220809_136165_35848E60)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass it as an argument to all functions. This is requires as newer SPROM
revisions have different lengths.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 8934298..5386cdd 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -72,12 +72,12 @@ fail:
  * R/W ops.
  **************************************************/
 
-static void bcma_sprom_read(struct bcma_bus *bus, u16 offset, u16 *sprom)
+static void bcma_sprom_read(struct bcma_bus *bus, u16 offset, u16 *sprom,
+			    size_t words)
 {
 	int i;
-	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
-		sprom[i] = bcma_read16(bus->drv_cc.core,
-				       offset + (i * 2));
+	for (i = 0; i < words; i++)
+		sprom[i] = bcma_read16(bus->drv_cc.core, offset + (i * 2));
 }
 
 /**************************************************
@@ -124,29 +124,29 @@ static inline u8 bcma_crc8(u8 crc, u8 data)
 	return t[crc ^ data];
 }
 
-static u8 bcma_sprom_crc(const u16 *sprom)
+static u8 bcma_sprom_crc(const u16 *sprom, size_t words)
 {
 	int word;
 	u8 crc = 0xFF;
 
-	for (word = 0; word < SSB_SPROMSIZE_WORDS_R4 - 1; word++) {
+	for (word = 0; word < words - 1; word++) {
 		crc = bcma_crc8(crc, sprom[word] & 0x00FF);
 		crc = bcma_crc8(crc, (sprom[word] & 0xFF00) >> 8);
 	}
-	crc = bcma_crc8(crc, sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF);
+	crc = bcma_crc8(crc, sprom[words - 1] & 0x00FF);
 	crc ^= 0xFF;
 
 	return crc;
 }
 
-static int bcma_sprom_check_crc(const u16 *sprom)
+static int bcma_sprom_check_crc(const u16 *sprom, size_t words)
 {
 	u8 crc;
 	u8 expected_crc;
 	u16 tmp;
 
-	crc = bcma_sprom_crc(sprom);
-	tmp = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_CRC;
+	crc = bcma_sprom_crc(sprom, words);
+	tmp = sprom[words - 1] & SSB_SPROM_REVISION_CRC;
 	expected_crc = tmp >> SSB_SPROM_REVISION_CRC_SHIFT;
 	if (crc != expected_crc)
 		return -EPROTO;
@@ -154,16 +154,16 @@ static int bcma_sprom_check_crc(const u16 *sprom)
 	return 0;
 }
 
-static int bcma_sprom_valid(const u16 *sprom)
+static int bcma_sprom_valid(const u16 *sprom, size_t words)
 {
 	u16 revision;
 	int err;
 
-	err = bcma_sprom_check_crc(sprom);
+	err = bcma_sprom_check_crc(sprom, words);
 	if (err)
 		return err;
 
-	revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_REV;
+	revision = sprom[words - 1] & SSB_SPROM_REVISION_REV;
 	if (revision != 8 && revision != 9) {
 		pr_err("Unsupported SPROM revision: %d\n", revision);
 		return -ENOENT;
@@ -589,13 +589,13 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
 	bcma_debug(bus, "SPROM offset 0x%x\n", offset);
-	bcma_sprom_read(bus, offset, sprom);
+	bcma_sprom_read(bus, offset, sprom, SSB_SPROMSIZE_WORDS_R4);
 
 	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
 	    bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
-	err = bcma_sprom_valid(sprom);
+	err = bcma_sprom_valid(sprom, SSB_SPROMSIZE_WORDS_R4);
 	if (err) {
 		bcma_warn(bus, "invalid sprom read from the PCIe card, try to use fallback sprom\n");
 		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
-- 
1.7.10.4

