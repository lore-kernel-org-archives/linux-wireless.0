Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55137 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3EMUII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 16:08:08 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so1227406eei.20
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 13:08:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] bcma: support SPROM rev 10
Date: Mon, 13 May 2013 22:07:53 +0200
Message-Id: <1368475673-27587-3-git-send-email-zajec5@gmail.com> (sfid-20130513_220814_372208_CFC10535)
In-Reply-To: <1368475673-27587-1-git-send-email-zajec5@gmail.com>
References: <1368475673-27587-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is pretty much the same as rev 9, there are just 2 extra fields we
know about, but are not used/stored yet anyway.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c         |   16 +++++++++-------
 include/linux/ssb/ssb_regs.h |    1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index c96f71c..de15b4f 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -154,7 +154,8 @@ static int bcma_sprom_check_crc(const u16 *sprom, size_t words)
 	return 0;
 }
 
-static int bcma_sprom_valid(const u16 *sprom, size_t words)
+static int bcma_sprom_valid(struct bcma_bus *bus, const u16 *sprom,
+			    size_t words)
 {
 	u16 revision;
 	int err;
@@ -164,11 +165,14 @@ static int bcma_sprom_valid(const u16 *sprom, size_t words)
 		return err;
 
 	revision = sprom[words - 1] & SSB_SPROM_REVISION_REV;
-	if (revision != 8 && revision != 9) {
+	if (revision != 8 && revision != 9 && revision != 10) {
 		pr_err("Unsupported SPROM revision: %d\n", revision);
 		return -ENOENT;
 	}
 
+	bus->sprom.revision = revision;
+	bcma_debug(bus, "Found SPROM revision %d\n", revision);
+
 	return 0;
 }
 
@@ -208,9 +212,6 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	BUILD_BUG_ON(ARRAY_SIZE(pwr_info_offset) !=
 			ARRAY_SIZE(bus->sprom.core_pwr_info));
 
-	bus->sprom.revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] &
-		SSB_SPROM_REVISION_REV;
-
 	for (i = 0; i < 3; i++) {
 		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
 		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
@@ -549,7 +550,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 {
 	u16 offset = BCMA_CC_SPROM;
 	u16 *sprom;
-	size_t sprom_sizes[] = { SSB_SPROMSIZE_WORDS_R4, };
+	size_t sprom_sizes[] = { SSB_SPROMSIZE_WORDS_R4,
+				 SSB_SPROMSIZE_WORDS_R10, };
 	int i, err = 0;
 
 	if (!bus->drv_cc.core)
@@ -592,7 +594,7 @@ int bcma_sprom_get(struct bcma_bus *bus)
 			return -ENOMEM;
 
 		bcma_sprom_read(bus, offset, sprom, words);
-		err = bcma_sprom_valid(sprom, words);
+		err = bcma_sprom_valid(bus, sprom, words);
 		if (!err)
 			break;
 
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 3a72569..f9f931c 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -172,6 +172,7 @@
 #define SSB_SPROMSIZE_WORDS_R4		220
 #define SSB_SPROMSIZE_BYTES_R123	(SSB_SPROMSIZE_WORDS_R123 * sizeof(u16))
 #define SSB_SPROMSIZE_BYTES_R4		(SSB_SPROMSIZE_WORDS_R4 * sizeof(u16))
+#define SSB_SPROMSIZE_WORDS_R10		230
 #define SSB_SPROM_BASE1			0x1000
 #define SSB_SPROM_BASE31		0x0800
 #define SSB_SPROM_REVISION		0x007E
-- 
1.7.10.4

