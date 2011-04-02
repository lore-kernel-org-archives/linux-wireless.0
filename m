Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:51495 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab1DBI0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 04:26:01 -0400
Subject: [PATCH] zd1211rw: rename CR* macros to ZD_CR*
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org
Date: Sat, 02 Apr 2011 11:25:54 +0300
Message-ID: <20110402082554.13951.17460.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With compat-wireless CR* macros in zd_usb.h conflict with CR macros in
include/asm-generic/termbits.h. So rename CR* macros to ZD_CR*.

Conversion was done with using sed and then 'over 80 character line'
checkpatch.pl warnings and comment indents were fixed.

Reported-by: Walter Goldens <goldenstranger@yahoo.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c       |  262 ++++++------
 drivers/net/wireless/zd1211rw/zd_chip.h       |  533 +++++++++++++------------
 drivers/net/wireless/zd1211rw/zd_rf.h         |    2 
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c  |  198 +++++----
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c |  240 ++++++-----
 drivers/net/wireless/zd1211rw/zd_rf_rf2959.c  |   78 ++--
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c  |   86 ++--
 drivers/net/wireless/zd1211rw/zd_usb.c        |    4 
 drivers/net/wireless/zd1211rw/zd_usb.h        |    2 
 9 files changed, 710 insertions(+), 695 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index a73a305..ff306d7 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -557,7 +557,7 @@ int zd_chip_unlock_phy_regs(struct zd_chip *chip)
 	return r;
 }
 
-/* CR157 can be optionally patched by the EEPROM for original ZD1211 */
+/* ZD_CR157 can be optionally patched by the EEPROM for original ZD1211 */
 static int patch_cr157(struct zd_chip *chip)
 {
 	int r;
@@ -571,7 +571,7 @@ static int patch_cr157(struct zd_chip *chip)
 		return r;
 
 	dev_dbg_f(zd_chip_dev(chip), "patching value %x\n", value >> 8);
-	return zd_iowrite32_locked(chip, value >> 8, CR157);
+	return zd_iowrite32_locked(chip, value >> 8, ZD_CR157);
 }
 
 /*
@@ -593,8 +593,8 @@ static int patch_6m_band_edge(struct zd_chip *chip, u8 channel)
 int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel)
 {
 	struct zd_ioreq16 ioreqs[] = {
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR47,  0x1e },
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
+		{ ZD_CR47,  0x1e },
 	};
 
 	/* FIXME: Channel 11 is not the edge for all regulatory domains. */
@@ -608,69 +608,69 @@ int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel)
 static int zd1211_hw_reset_phy(struct zd_chip *chip)
 {
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR0,   0x0a }, { CR1,   0x06 }, { CR2,   0x26 },
-		{ CR3,   0x38 }, { CR4,   0x80 }, { CR9,   0xa0 },
-		{ CR10,  0x81 }, { CR11,  0x00 }, { CR12,  0x7f },
-		{ CR13,  0x8c }, { CR14,  0x80 }, { CR15,  0x3d },
-		{ CR16,  0x20 }, { CR17,  0x1e }, { CR18,  0x0a },
-		{ CR19,  0x48 }, { CR20,  0x0c }, { CR21,  0x0c },
-		{ CR22,  0x23 }, { CR23,  0x90 }, { CR24,  0x14 },
-		{ CR25,  0x40 }, { CR26,  0x10 }, { CR27,  0x19 },
-		{ CR28,  0x7f }, { CR29,  0x80 }, { CR30,  0x4b },
-		{ CR31,  0x60 }, { CR32,  0x43 }, { CR33,  0x08 },
-		{ CR34,  0x06 }, { CR35,  0x0a }, { CR36,  0x00 },
-		{ CR37,  0x00 }, { CR38,  0x38 }, { CR39,  0x0c },
-		{ CR40,  0x84 }, { CR41,  0x2a }, { CR42,  0x80 },
-		{ CR43,  0x10 }, { CR44,  0x12 }, { CR46,  0xff },
-		{ CR47,  0x1E }, { CR48,  0x26 }, { CR49,  0x5b },
-		{ CR64,  0xd0 }, { CR65,  0x04 }, { CR66,  0x58 },
-		{ CR67,  0xc9 }, { CR68,  0x88 }, { CR69,  0x41 },
-		{ CR70,  0x23 }, { CR71,  0x10 }, { CR72,  0xff },
-		{ CR73,  0x32 }, { CR74,  0x30 }, { CR75,  0x65 },
-		{ CR76,  0x41 }, { CR77,  0x1b }, { CR78,  0x30 },
-		{ CR79,  0x68 }, { CR80,  0x64 }, { CR81,  0x64 },
-		{ CR82,  0x00 }, { CR83,  0x00 }, { CR84,  0x00 },
-		{ CR85,  0x02 }, { CR86,  0x00 }, { CR87,  0x00 },
-		{ CR88,  0xff }, { CR89,  0xfc }, { CR90,  0x00 },
-		{ CR91,  0x00 }, { CR92,  0x00 }, { CR93,  0x08 },
-		{ CR94,  0x00 }, { CR95,  0x00 }, { CR96,  0xff },
-		{ CR97,  0xe7 }, { CR98,  0x00 }, { CR99,  0x00 },
-		{ CR100, 0x00 }, { CR101, 0xae }, { CR102, 0x02 },
-		{ CR103, 0x00 }, { CR104, 0x03 }, { CR105, 0x65 },
-		{ CR106, 0x04 }, { CR107, 0x00 }, { CR108, 0x0a },
-		{ CR109, 0xaa }, { CR110, 0xaa }, { CR111, 0x25 },
-		{ CR112, 0x25 }, { CR113, 0x00 }, { CR119, 0x1e },
-		{ CR125, 0x90 }, { CR126, 0x00 }, { CR127, 0x00 },
+		{ ZD_CR0,   0x0a }, { ZD_CR1,   0x06 }, { ZD_CR2,   0x26 },
+		{ ZD_CR3,   0x38 }, { ZD_CR4,   0x80 }, { ZD_CR9,   0xa0 },
+		{ ZD_CR10,  0x81 }, { ZD_CR11,  0x00 }, { ZD_CR12,  0x7f },
+		{ ZD_CR13,  0x8c }, { ZD_CR14,  0x80 }, { ZD_CR15,  0x3d },
+		{ ZD_CR16,  0x20 }, { ZD_CR17,  0x1e }, { ZD_CR18,  0x0a },
+		{ ZD_CR19,  0x48 }, { ZD_CR20,  0x0c }, { ZD_CR21,  0x0c },
+		{ ZD_CR22,  0x23 }, { ZD_CR23,  0x90 }, { ZD_CR24,  0x14 },
+		{ ZD_CR25,  0x40 }, { ZD_CR26,  0x10 }, { ZD_CR27,  0x19 },
+		{ ZD_CR28,  0x7f }, { ZD_CR29,  0x80 }, { ZD_CR30,  0x4b },
+		{ ZD_CR31,  0x60 }, { ZD_CR32,  0x43 }, { ZD_CR33,  0x08 },
+		{ ZD_CR34,  0x06 }, { ZD_CR35,  0x0a }, { ZD_CR36,  0x00 },
+		{ ZD_CR37,  0x00 }, { ZD_CR38,  0x38 }, { ZD_CR39,  0x0c },
+		{ ZD_CR40,  0x84 }, { ZD_CR41,  0x2a }, { ZD_CR42,  0x80 },
+		{ ZD_CR43,  0x10 }, { ZD_CR44,  0x12 }, { ZD_CR46,  0xff },
+		{ ZD_CR47,  0x1E }, { ZD_CR48,  0x26 }, { ZD_CR49,  0x5b },
+		{ ZD_CR64,  0xd0 }, { ZD_CR65,  0x04 }, { ZD_CR66,  0x58 },
+		{ ZD_CR67,  0xc9 }, { ZD_CR68,  0x88 }, { ZD_CR69,  0x41 },
+		{ ZD_CR70,  0x23 }, { ZD_CR71,  0x10 }, { ZD_CR72,  0xff },
+		{ ZD_CR73,  0x32 }, { ZD_CR74,  0x30 }, { ZD_CR75,  0x65 },
+		{ ZD_CR76,  0x41 }, { ZD_CR77,  0x1b }, { ZD_CR78,  0x30 },
+		{ ZD_CR79,  0x68 }, { ZD_CR80,  0x64 }, { ZD_CR81,  0x64 },
+		{ ZD_CR82,  0x00 }, { ZD_CR83,  0x00 }, { ZD_CR84,  0x00 },
+		{ ZD_CR85,  0x02 }, { ZD_CR86,  0x00 }, { ZD_CR87,  0x00 },
+		{ ZD_CR88,  0xff }, { ZD_CR89,  0xfc }, { ZD_CR90,  0x00 },
+		{ ZD_CR91,  0x00 }, { ZD_CR92,  0x00 }, { ZD_CR93,  0x08 },
+		{ ZD_CR94,  0x00 }, { ZD_CR95,  0x00 }, { ZD_CR96,  0xff },
+		{ ZD_CR97,  0xe7 }, { ZD_CR98,  0x00 }, { ZD_CR99,  0x00 },
+		{ ZD_CR100, 0x00 }, { ZD_CR101, 0xae }, { ZD_CR102, 0x02 },
+		{ ZD_CR103, 0x00 }, { ZD_CR104, 0x03 }, { ZD_CR105, 0x65 },
+		{ ZD_CR106, 0x04 }, { ZD_CR107, 0x00 }, { ZD_CR108, 0x0a },
+		{ ZD_CR109, 0xaa }, { ZD_CR110, 0xaa }, { ZD_CR111, 0x25 },
+		{ ZD_CR112, 0x25 }, { ZD_CR113, 0x00 }, { ZD_CR119, 0x1e },
+		{ ZD_CR125, 0x90 }, { ZD_CR126, 0x00 }, { ZD_CR127, 0x00 },
 		{ },
-		{ CR5,   0x00 }, { CR6,   0x00 }, { CR7,   0x00 },
-		{ CR8,   0x00 }, { CR9,   0x20 }, { CR12,  0xf0 },
-		{ CR20,  0x0e }, { CR21,  0x0e }, { CR27,  0x10 },
-		{ CR44,  0x33 }, { CR47,  0x1E }, { CR83,  0x24 },
-		{ CR84,  0x04 }, { CR85,  0x00 }, { CR86,  0x0C },
-		{ CR87,  0x12 }, { CR88,  0x0C }, { CR89,  0x00 },
-		{ CR90,  0x10 }, { CR91,  0x08 }, { CR93,  0x00 },
-		{ CR94,  0x01 }, { CR95,  0x00 }, { CR96,  0x50 },
-		{ CR97,  0x37 }, { CR98,  0x35 }, { CR101, 0x13 },
-		{ CR102, 0x27 }, { CR103, 0x27 }, { CR104, 0x18 },
-		{ CR105, 0x12 }, { CR109, 0x27 }, { CR110, 0x27 },
-		{ CR111, 0x27 }, { CR112, 0x27 }, { CR113, 0x27 },
-		{ CR114, 0x27 }, { CR115, 0x26 }, { CR116, 0x24 },
-		{ CR117, 0xfc }, { CR118, 0xfa }, { CR120, 0x4f },
-		{ CR125, 0xaa }, { CR127, 0x03 }, { CR128, 0x14 },
-		{ CR129, 0x12 }, { CR130, 0x10 }, { CR131, 0x0C },
-		{ CR136, 0xdf }, { CR137, 0x40 }, { CR138, 0xa0 },
-		{ CR139, 0xb0 }, { CR140, 0x99 }, { CR141, 0x82 },
-		{ CR142, 0x54 }, { CR143, 0x1c }, { CR144, 0x6c },
-		{ CR147, 0x07 }, { CR148, 0x4c }, { CR149, 0x50 },
-		{ CR150, 0x0e }, { CR151, 0x18 }, { CR160, 0xfe },
-		{ CR161, 0xee }, { CR162, 0xaa }, { CR163, 0xfa },
-		{ CR164, 0xfa }, { CR165, 0xea }, { CR166, 0xbe },
-		{ CR167, 0xbe }, { CR168, 0x6a }, { CR169, 0xba },
-		{ CR170, 0xba }, { CR171, 0xba },
-		/* Note: CR204 must lead the CR203 */
-		{ CR204, 0x7d },
+		{ ZD_CR5,   0x00 }, { ZD_CR6,   0x00 }, { ZD_CR7,   0x00 },
+		{ ZD_CR8,   0x00 }, { ZD_CR9,   0x20 }, { ZD_CR12,  0xf0 },
+		{ ZD_CR20,  0x0e }, { ZD_CR21,  0x0e }, { ZD_CR27,  0x10 },
+		{ ZD_CR44,  0x33 }, { ZD_CR47,  0x1E }, { ZD_CR83,  0x24 },
+		{ ZD_CR84,  0x04 }, { ZD_CR85,  0x00 }, { ZD_CR86,  0x0C },
+		{ ZD_CR87,  0x12 }, { ZD_CR88,  0x0C }, { ZD_CR89,  0x00 },
+		{ ZD_CR90,  0x10 }, { ZD_CR91,  0x08 }, { ZD_CR93,  0x00 },
+		{ ZD_CR94,  0x01 }, { ZD_CR95,  0x00 }, { ZD_CR96,  0x50 },
+		{ ZD_CR97,  0x37 }, { ZD_CR98,  0x35 }, { ZD_CR101, 0x13 },
+		{ ZD_CR102, 0x27 }, { ZD_CR103, 0x27 }, { ZD_CR104, 0x18 },
+		{ ZD_CR105, 0x12 }, { ZD_CR109, 0x27 }, { ZD_CR110, 0x27 },
+		{ ZD_CR111, 0x27 }, { ZD_CR112, 0x27 }, { ZD_CR113, 0x27 },
+		{ ZD_CR114, 0x27 }, { ZD_CR115, 0x26 }, { ZD_CR116, 0x24 },
+		{ ZD_CR117, 0xfc }, { ZD_CR118, 0xfa }, { ZD_CR120, 0x4f },
+		{ ZD_CR125, 0xaa }, { ZD_CR127, 0x03 }, { ZD_CR128, 0x14 },
+		{ ZD_CR129, 0x12 }, { ZD_CR130, 0x10 }, { ZD_CR131, 0x0C },
+		{ ZD_CR136, 0xdf }, { ZD_CR137, 0x40 }, { ZD_CR138, 0xa0 },
+		{ ZD_CR139, 0xb0 }, { ZD_CR140, 0x99 }, { ZD_CR141, 0x82 },
+		{ ZD_CR142, 0x54 }, { ZD_CR143, 0x1c }, { ZD_CR144, 0x6c },
+		{ ZD_CR147, 0x07 }, { ZD_CR148, 0x4c }, { ZD_CR149, 0x50 },
+		{ ZD_CR150, 0x0e }, { ZD_CR151, 0x18 }, { ZD_CR160, 0xfe },
+		{ ZD_CR161, 0xee }, { ZD_CR162, 0xaa }, { ZD_CR163, 0xfa },
+		{ ZD_CR164, 0xfa }, { ZD_CR165, 0xea }, { ZD_CR166, 0xbe },
+		{ ZD_CR167, 0xbe }, { ZD_CR168, 0x6a }, { ZD_CR169, 0xba },
+		{ ZD_CR170, 0xba }, { ZD_CR171, 0xba },
+		/* Note: ZD_CR204 must lead the ZD_CR203 */
+		{ ZD_CR204, 0x7d },
 		{ },
-		{ CR203, 0x30 },
+		{ ZD_CR203, 0x30 },
 	};
 
 	int r, t;
@@ -697,62 +697,62 @@ out:
 static int zd1211b_hw_reset_phy(struct zd_chip *chip)
 {
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR0,   0x14 }, { CR1,   0x06 }, { CR2,   0x26 },
-		{ CR3,   0x38 }, { CR4,   0x80 }, { CR9,   0xe0 },
-		{ CR10,  0x81 },
-		/* power control { { CR11,  1 << 6 }, */
-		{ CR11,  0x00 },
-		{ CR12,  0xf0 }, { CR13,  0x8c }, { CR14,  0x80 },
-		{ CR15,  0x3d }, { CR16,  0x20 }, { CR17,  0x1e },
-		{ CR18,  0x0a }, { CR19,  0x48 },
-		{ CR20,  0x10 }, /* Org:0x0E, ComTrend:RalLink AP */
-		{ CR21,  0x0e }, { CR22,  0x23 }, { CR23,  0x90 },
-		{ CR24,  0x14 }, { CR25,  0x40 }, { CR26,  0x10 },
-		{ CR27,  0x10 }, { CR28,  0x7f }, { CR29,  0x80 },
-		{ CR30,  0x4b }, /* ASIC/FWT, no jointly decoder */
-		{ CR31,  0x60 }, { CR32,  0x43 }, { CR33,  0x08 },
-		{ CR34,  0x06 }, { CR35,  0x0a }, { CR36,  0x00 },
-		{ CR37,  0x00 }, { CR38,  0x38 }, { CR39,  0x0c },
-		{ CR40,  0x84 }, { CR41,  0x2a }, { CR42,  0x80 },
-		{ CR43,  0x10 }, { CR44,  0x33 }, { CR46,  0xff },
-		{ CR47,  0x1E }, { CR48,  0x26 }, { CR49,  0x5b },
-		{ CR64,  0xd0 }, { CR65,  0x04 }, { CR66,  0x58 },
-		{ CR67,  0xc9 }, { CR68,  0x88 }, { CR69,  0x41 },
-		{ CR70,  0x23 }, { CR71,  0x10 }, { CR72,  0xff },
-		{ CR73,  0x32 }, { CR74,  0x30 }, { CR75,  0x65 },
-		{ CR76,  0x41 }, { CR77,  0x1b }, { CR78,  0x30 },
-		{ CR79,  0xf0 }, { CR80,  0x64 }, { CR81,  0x64 },
-		{ CR82,  0x00 }, { CR83,  0x24 }, { CR84,  0x04 },
-		{ CR85,  0x00 }, { CR86,  0x0c }, { CR87,  0x12 },
-		{ CR88,  0x0c }, { CR89,  0x00 }, { CR90,  0x58 },
-		{ CR91,  0x04 }, { CR92,  0x00 }, { CR93,  0x00 },
-		{ CR94,  0x01 },
-		{ CR95,  0x20 }, /* ZD1211B */
-		{ CR96,  0x50 }, { CR97,  0x37 }, { CR98,  0x35 },
-		{ CR99,  0x00 }, { CR100, 0x01 }, { CR101, 0x13 },
-		{ CR102, 0x27 }, { CR103, 0x27 }, { CR104, 0x18 },
-		{ CR105, 0x12 }, { CR106, 0x04 }, { CR107, 0x00 },
-		{ CR108, 0x0a }, { CR109, 0x27 }, { CR110, 0x27 },
-		{ CR111, 0x27 }, { CR112, 0x27 }, { CR113, 0x27 },
-		{ CR114, 0x27 }, { CR115, 0x26 }, { CR116, 0x24 },
-		{ CR117, 0xfc }, { CR118, 0xfa }, { CR119, 0x1e },
-		{ CR125, 0x90 }, { CR126, 0x00 }, { CR127, 0x00 },
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR131, 0x0c }, { CR136, 0xdf }, { CR137, 0xa0 },
-		{ CR138, 0xa8 }, { CR139, 0xb4 }, { CR140, 0x98 },
-		{ CR141, 0x82 }, { CR142, 0x53 }, { CR143, 0x1c },
-		{ CR144, 0x6c }, { CR147, 0x07 }, { CR148, 0x40 },
-		{ CR149, 0x40 }, /* Org:0x50 ComTrend:RalLink AP */
-		{ CR150, 0x14 }, /* Org:0x0E ComTrend:RalLink AP */
-		{ CR151, 0x18 }, { CR159, 0x70 }, { CR160, 0xfe },
-		{ CR161, 0xee }, { CR162, 0xaa }, { CR163, 0xfa },
-		{ CR164, 0xfa }, { CR165, 0xea }, { CR166, 0xbe },
-		{ CR167, 0xbe }, { CR168, 0x6a }, { CR169, 0xba },
-		{ CR170, 0xba }, { CR171, 0xba },
-		/* Note: CR204 must lead the CR203 */
-		{ CR204, 0x7d },
+		{ ZD_CR0,   0x14 }, { ZD_CR1,   0x06 }, { ZD_CR2,   0x26 },
+		{ ZD_CR3,   0x38 }, { ZD_CR4,   0x80 }, { ZD_CR9,   0xe0 },
+		{ ZD_CR10,  0x81 },
+		/* power control { { ZD_CR11,  1 << 6 }, */
+		{ ZD_CR11,  0x00 },
+		{ ZD_CR12,  0xf0 }, { ZD_CR13,  0x8c }, { ZD_CR14,  0x80 },
+		{ ZD_CR15,  0x3d }, { ZD_CR16,  0x20 }, { ZD_CR17,  0x1e },
+		{ ZD_CR18,  0x0a }, { ZD_CR19,  0x48 },
+		{ ZD_CR20,  0x10 }, /* Org:0x0E, ComTrend:RalLink AP */
+		{ ZD_CR21,  0x0e }, { ZD_CR22,  0x23 }, { ZD_CR23,  0x90 },
+		{ ZD_CR24,  0x14 }, { ZD_CR25,  0x40 }, { ZD_CR26,  0x10 },
+		{ ZD_CR27,  0x10 }, { ZD_CR28,  0x7f }, { ZD_CR29,  0x80 },
+		{ ZD_CR30,  0x4b }, /* ASIC/FWT, no jointly decoder */
+		{ ZD_CR31,  0x60 }, { ZD_CR32,  0x43 }, { ZD_CR33,  0x08 },
+		{ ZD_CR34,  0x06 }, { ZD_CR35,  0x0a }, { ZD_CR36,  0x00 },
+		{ ZD_CR37,  0x00 }, { ZD_CR38,  0x38 }, { ZD_CR39,  0x0c },
+		{ ZD_CR40,  0x84 }, { ZD_CR41,  0x2a }, { ZD_CR42,  0x80 },
+		{ ZD_CR43,  0x10 }, { ZD_CR44,  0x33 }, { ZD_CR46,  0xff },
+		{ ZD_CR47,  0x1E }, { ZD_CR48,  0x26 }, { ZD_CR49,  0x5b },
+		{ ZD_CR64,  0xd0 }, { ZD_CR65,  0x04 }, { ZD_CR66,  0x58 },
+		{ ZD_CR67,  0xc9 }, { ZD_CR68,  0x88 }, { ZD_CR69,  0x41 },
+		{ ZD_CR70,  0x23 }, { ZD_CR71,  0x10 }, { ZD_CR72,  0xff },
+		{ ZD_CR73,  0x32 }, { ZD_CR74,  0x30 }, { ZD_CR75,  0x65 },
+		{ ZD_CR76,  0x41 }, { ZD_CR77,  0x1b }, { ZD_CR78,  0x30 },
+		{ ZD_CR79,  0xf0 }, { ZD_CR80,  0x64 }, { ZD_CR81,  0x64 },
+		{ ZD_CR82,  0x00 }, { ZD_CR83,  0x24 }, { ZD_CR84,  0x04 },
+		{ ZD_CR85,  0x00 }, { ZD_CR86,  0x0c }, { ZD_CR87,  0x12 },
+		{ ZD_CR88,  0x0c }, { ZD_CR89,  0x00 }, { ZD_CR90,  0x58 },
+		{ ZD_CR91,  0x04 }, { ZD_CR92,  0x00 }, { ZD_CR93,  0x00 },
+		{ ZD_CR94,  0x01 },
+		{ ZD_CR95,  0x20 }, /* ZD1211B */
+		{ ZD_CR96,  0x50 }, { ZD_CR97,  0x37 }, { ZD_CR98,  0x35 },
+		{ ZD_CR99,  0x00 }, { ZD_CR100, 0x01 }, { ZD_CR101, 0x13 },
+		{ ZD_CR102, 0x27 }, { ZD_CR103, 0x27 }, { ZD_CR104, 0x18 },
+		{ ZD_CR105, 0x12 }, { ZD_CR106, 0x04 }, { ZD_CR107, 0x00 },
+		{ ZD_CR108, 0x0a }, { ZD_CR109, 0x27 }, { ZD_CR110, 0x27 },
+		{ ZD_CR111, 0x27 }, { ZD_CR112, 0x27 }, { ZD_CR113, 0x27 },
+		{ ZD_CR114, 0x27 }, { ZD_CR115, 0x26 }, { ZD_CR116, 0x24 },
+		{ ZD_CR117, 0xfc }, { ZD_CR118, 0xfa }, { ZD_CR119, 0x1e },
+		{ ZD_CR125, 0x90 }, { ZD_CR126, 0x00 }, { ZD_CR127, 0x00 },
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
+		{ ZD_CR131, 0x0c }, { ZD_CR136, 0xdf }, { ZD_CR137, 0xa0 },
+		{ ZD_CR138, 0xa8 }, { ZD_CR139, 0xb4 }, { ZD_CR140, 0x98 },
+		{ ZD_CR141, 0x82 }, { ZD_CR142, 0x53 }, { ZD_CR143, 0x1c },
+		{ ZD_CR144, 0x6c }, { ZD_CR147, 0x07 }, { ZD_CR148, 0x40 },
+		{ ZD_CR149, 0x40 }, /* Org:0x50 ComTrend:RalLink AP */
+		{ ZD_CR150, 0x14 }, /* Org:0x0E ComTrend:RalLink AP */
+		{ ZD_CR151, 0x18 }, { ZD_CR159, 0x70 }, { ZD_CR160, 0xfe },
+		{ ZD_CR161, 0xee }, { ZD_CR162, 0xaa }, { ZD_CR163, 0xfa },
+		{ ZD_CR164, 0xfa }, { ZD_CR165, 0xea }, { ZD_CR166, 0xbe },
+		{ ZD_CR167, 0xbe }, { ZD_CR168, 0x6a }, { ZD_CR169, 0xba },
+		{ ZD_CR170, 0xba }, { ZD_CR171, 0xba },
+		/* Note: ZD_CR204 must lead the ZD_CR203 */
+		{ ZD_CR204, 0x7d },
 		{},
-		{ CR203, 0x30 },
+		{ ZD_CR203, 0x30 },
 	};
 
 	int r, t;
@@ -1200,24 +1200,24 @@ out:
 static int update_pwr_int(struct zd_chip *chip, u8 channel)
 {
 	u8 value = chip->pwr_int_values[channel - 1];
-	return zd_iowrite16_locked(chip, value, CR31);
+	return zd_iowrite16_locked(chip, value, ZD_CR31);
 }
 
 static int update_pwr_cal(struct zd_chip *chip, u8 channel)
 {
 	u8 value = chip->pwr_cal_values[channel-1];
-	return zd_iowrite16_locked(chip, value, CR68);
+	return zd_iowrite16_locked(chip, value, ZD_CR68);
 }
 
 static int update_ofdm_cal(struct zd_chip *chip, u8 channel)
 {
 	struct zd_ioreq16 ioreqs[3];
 
-	ioreqs[0].addr = CR67;
+	ioreqs[0].addr = ZD_CR67;
 	ioreqs[0].value = chip->ofdm_cal_values[OFDM_36M_INDEX][channel-1];
-	ioreqs[1].addr = CR66;
+	ioreqs[1].addr = ZD_CR66;
 	ioreqs[1].value = chip->ofdm_cal_values[OFDM_48M_INDEX][channel-1];
-	ioreqs[2].addr = CR65;
+	ioreqs[2].addr = ZD_CR65;
 	ioreqs[2].value = chip->ofdm_cal_values[OFDM_54M_INDEX][channel-1];
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -1236,9 +1236,9 @@ static int update_channel_integration_and_calibration(struct zd_chip *chip,
 		return r;
 	if (zd_chip_is_zd1211b(chip)) {
 		static const struct zd_ioreq16 ioreqs[] = {
-			{ CR69, 0x28 },
+			{ ZD_CR69, 0x28 },
 			{},
-			{ CR69, 0x2a },
+			{ ZD_CR69, 0x2a },
 		};
 
 		r = update_ofdm_cal(chip, channel);
@@ -1269,7 +1269,7 @@ static int patch_cck_gain(struct zd_chip *chip)
 	if (r)
 		return r;
 	dev_dbg_f(zd_chip_dev(chip), "patching value %x\n", value & 0xff);
-	return zd_iowrite16_locked(chip, value & 0xff, CR47);
+	return zd_iowrite16_locked(chip, value & 0xff, ZD_CR47);
 }
 
 int zd_chip_set_channel(struct zd_chip *chip, u8 channel)
@@ -1505,9 +1505,9 @@ int zd_rfwritev_locked(struct zd_chip *chip,
 int zd_rfwrite_cr_locked(struct zd_chip *chip, u32 value)
 {
 	const struct zd_ioreq16 ioreqs[] = {
-		{ CR244, (value >> 16) & 0xff },
-		{ CR243, (value >>  8) & 0xff },
-		{ CR242,  value        & 0xff },
+		{ ZD_CR244, (value >> 16) & 0xff },
+		{ ZD_CR243, (value >>  8) & 0xff },
+		{ ZD_CR242,  value        & 0xff },
 	};
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 14e4402..4be7c3b 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -61,277 +61,288 @@ enum {
 #define FWRAW_DATA(offset) ((zd_addr_t)(FW_START + (offset)))
 
 /* 8-bit hardware registers */
-#define CR0   CTL_REG(0x0000)
-#define CR1   CTL_REG(0x0004)
-#define CR2   CTL_REG(0x0008)
-#define CR3   CTL_REG(0x000C)
+#define ZD_CR0   CTL_REG(0x0000)
+#define ZD_CR1   CTL_REG(0x0004)
+#define ZD_CR2   CTL_REG(0x0008)
+#define ZD_CR3   CTL_REG(0x000C)
 
-#define CR5   CTL_REG(0x0010)
+#define ZD_CR5   CTL_REG(0x0010)
 /*	bit 5: if set short preamble used
  *	bit 6: filter band - Japan channel 14 on, else off
  */
-#define CR6   CTL_REG(0x0014)
-#define CR7   CTL_REG(0x0018)
-#define CR8   CTL_REG(0x001C)
+#define ZD_CR6   CTL_REG(0x0014)
+#define ZD_CR7   CTL_REG(0x0018)
+#define ZD_CR8   CTL_REG(0x001C)
 
-#define CR4   CTL_REG(0x0020)
+#define ZD_CR4   CTL_REG(0x0020)
 
-#define CR9   CTL_REG(0x0024)
-/*	bit 2: antenna switch (together with CR10) */
-#define CR10  CTL_REG(0x0028)
-/*	bit 1: antenna switch (together with CR9)
- *	RF2959 controls with CR11 radion on and off
+#define ZD_CR9   CTL_REG(0x0024)
+/*	bit 2: antenna switch (together with ZD_CR10) */
+#define ZD_CR10  CTL_REG(0x0028)
+/*	bit 1: antenna switch (together with ZD_CR9)
+ *	RF2959 controls with ZD_CR11 radion on and off
  */
-#define CR11  CTL_REG(0x002C)
+#define ZD_CR11  CTL_REG(0x002C)
 /*	bit 6:  TX power control for OFDM
- *	RF2959 controls with CR10 radio on and off
+ *	RF2959 controls with ZD_CR10 radio on and off
  */
-#define CR12  CTL_REG(0x0030)
-#define CR13  CTL_REG(0x0034)
-#define CR14  CTL_REG(0x0038)
-#define CR15  CTL_REG(0x003C)
-#define CR16  CTL_REG(0x0040)
-#define CR17  CTL_REG(0x0044)
-#define CR18  CTL_REG(0x0048)
-#define CR19  CTL_REG(0x004C)
-#define CR20  CTL_REG(0x0050)
-#define CR21  CTL_REG(0x0054)
-#define CR22  CTL_REG(0x0058)
-#define CR23  CTL_REG(0x005C)
-#define CR24  CTL_REG(0x0060)	/* CCA threshold */
-#define CR25  CTL_REG(0x0064)
-#define CR26  CTL_REG(0x0068)
-#define CR27  CTL_REG(0x006C)
-#define CR28  CTL_REG(0x0070)
-#define CR29  CTL_REG(0x0074)
-#define CR30  CTL_REG(0x0078)
-#define CR31  CTL_REG(0x007C)	/* TX power control for RF in CCK mode */
-#define CR32  CTL_REG(0x0080)
-#define CR33  CTL_REG(0x0084)
-#define CR34  CTL_REG(0x0088)
-#define CR35  CTL_REG(0x008C)
-#define CR36  CTL_REG(0x0090)
-#define CR37  CTL_REG(0x0094)
-#define CR38  CTL_REG(0x0098)
-#define CR39  CTL_REG(0x009C)
-#define CR40  CTL_REG(0x00A0)
-#define CR41  CTL_REG(0x00A4)
-#define CR42  CTL_REG(0x00A8)
-#define CR43  CTL_REG(0x00AC)
-#define CR44  CTL_REG(0x00B0)
-#define CR45  CTL_REG(0x00B4)
-#define CR46  CTL_REG(0x00B8)
-#define CR47  CTL_REG(0x00BC)	/* CCK baseband gain
-	                         * (patch value might be in EEPROM)
-				 */
-#define CR48  CTL_REG(0x00C0)
-#define CR49  CTL_REG(0x00C4)
-#define CR50  CTL_REG(0x00C8)
-#define CR51  CTL_REG(0x00CC)	/* TX power control for RF in 6-36M modes */
-#define CR52  CTL_REG(0x00D0)	/* TX power control for RF in 48M mode */
-#define CR53  CTL_REG(0x00D4)	/* TX power control for RF in 54M mode */
-#define CR54  CTL_REG(0x00D8)
-#define CR55  CTL_REG(0x00DC)
-#define CR56  CTL_REG(0x00E0)
-#define CR57  CTL_REG(0x00E4)
-#define CR58  CTL_REG(0x00E8)
-#define CR59  CTL_REG(0x00EC)
-#define CR60  CTL_REG(0x00F0)
-#define CR61  CTL_REG(0x00F4)
-#define CR62  CTL_REG(0x00F8)
-#define CR63  CTL_REG(0x00FC)
-#define CR64  CTL_REG(0x0100)
-#define CR65  CTL_REG(0x0104) /* OFDM 54M calibration */
-#define CR66  CTL_REG(0x0108) /* OFDM 48M calibration */
-#define CR67  CTL_REG(0x010C) /* OFDM 36M calibration */
-#define CR68  CTL_REG(0x0110) /* CCK calibration */
-#define CR69  CTL_REG(0x0114)
-#define CR70  CTL_REG(0x0118)
-#define CR71  CTL_REG(0x011C)
-#define CR72  CTL_REG(0x0120)
-#define CR73  CTL_REG(0x0124)
-#define CR74  CTL_REG(0x0128)
-#define CR75  CTL_REG(0x012C)
-#define CR76  CTL_REG(0x0130)
-#define CR77  CTL_REG(0x0134)
-#define CR78  CTL_REG(0x0138)
-#define CR79  CTL_REG(0x013C)
-#define CR80  CTL_REG(0x0140)
-#define CR81  CTL_REG(0x0144)
-#define CR82  CTL_REG(0x0148)
-#define CR83  CTL_REG(0x014C)
-#define CR84  CTL_REG(0x0150)
-#define CR85  CTL_REG(0x0154)
-#define CR86  CTL_REG(0x0158)
-#define CR87  CTL_REG(0x015C)
-#define CR88  CTL_REG(0x0160)
-#define CR89  CTL_REG(0x0164)
-#define CR90  CTL_REG(0x0168)
-#define CR91  CTL_REG(0x016C)
-#define CR92  CTL_REG(0x0170)
-#define CR93  CTL_REG(0x0174)
-#define CR94  CTL_REG(0x0178)
-#define CR95  CTL_REG(0x017C)
-#define CR96  CTL_REG(0x0180)
-#define CR97  CTL_REG(0x0184)
-#define CR98  CTL_REG(0x0188)
-#define CR99  CTL_REG(0x018C)
-#define CR100 CTL_REG(0x0190)
-#define CR101 CTL_REG(0x0194)
-#define CR102 CTL_REG(0x0198)
-#define CR103 CTL_REG(0x019C)
-#define CR104 CTL_REG(0x01A0)
-#define CR105 CTL_REG(0x01A4)
-#define CR106 CTL_REG(0x01A8)
-#define CR107 CTL_REG(0x01AC)
-#define CR108 CTL_REG(0x01B0)
-#define CR109 CTL_REG(0x01B4)
-#define CR110 CTL_REG(0x01B8)
-#define CR111 CTL_REG(0x01BC)
-#define CR112 CTL_REG(0x01C0)
-#define CR113 CTL_REG(0x01C4)
-#define CR114 CTL_REG(0x01C8)
-#define CR115 CTL_REG(0x01CC)
-#define CR116 CTL_REG(0x01D0)
-#define CR117 CTL_REG(0x01D4)
-#define CR118 CTL_REG(0x01D8)
-#define CR119 CTL_REG(0x01DC)
-#define CR120 CTL_REG(0x01E0)
-#define CR121 CTL_REG(0x01E4)
-#define CR122 CTL_REG(0x01E8)
-#define CR123 CTL_REG(0x01EC)
-#define CR124 CTL_REG(0x01F0)
-#define CR125 CTL_REG(0x01F4)
-#define CR126 CTL_REG(0x01F8)
-#define CR127 CTL_REG(0x01FC)
-#define CR128 CTL_REG(0x0200)
-#define CR129 CTL_REG(0x0204)
-#define CR130 CTL_REG(0x0208)
-#define CR131 CTL_REG(0x020C)
-#define CR132 CTL_REG(0x0210)
-#define CR133 CTL_REG(0x0214)
-#define CR134 CTL_REG(0x0218)
-#define CR135 CTL_REG(0x021C)
-#define CR136 CTL_REG(0x0220)
-#define CR137 CTL_REG(0x0224)
-#define CR138 CTL_REG(0x0228)
-#define CR139 CTL_REG(0x022C)
-#define CR140 CTL_REG(0x0230)
-#define CR141 CTL_REG(0x0234)
-#define CR142 CTL_REG(0x0238)
-#define CR143 CTL_REG(0x023C)
-#define CR144 CTL_REG(0x0240)
-#define CR145 CTL_REG(0x0244)
-#define CR146 CTL_REG(0x0248)
-#define CR147 CTL_REG(0x024C)
-#define CR148 CTL_REG(0x0250)
-#define CR149 CTL_REG(0x0254)
-#define CR150 CTL_REG(0x0258)
-#define CR151 CTL_REG(0x025C)
-#define CR152 CTL_REG(0x0260)
-#define CR153 CTL_REG(0x0264)
-#define CR154 CTL_REG(0x0268)
-#define CR155 CTL_REG(0x026C)
-#define CR156 CTL_REG(0x0270)
-#define CR157 CTL_REG(0x0274)
-#define CR158 CTL_REG(0x0278)
-#define CR159 CTL_REG(0x027C)
-#define CR160 CTL_REG(0x0280)
-#define CR161 CTL_REG(0x0284)
-#define CR162 CTL_REG(0x0288)
-#define CR163 CTL_REG(0x028C)
-#define CR164 CTL_REG(0x0290)
-#define CR165 CTL_REG(0x0294)
-#define CR166 CTL_REG(0x0298)
-#define CR167 CTL_REG(0x029C)
-#define CR168 CTL_REG(0x02A0)
-#define CR169 CTL_REG(0x02A4)
-#define CR170 CTL_REG(0x02A8)
-#define CR171 CTL_REG(0x02AC)
-#define CR172 CTL_REG(0x02B0)
-#define CR173 CTL_REG(0x02B4)
-#define CR174 CTL_REG(0x02B8)
-#define CR175 CTL_REG(0x02BC)
-#define CR176 CTL_REG(0x02C0)
-#define CR177 CTL_REG(0x02C4)
-#define CR178 CTL_REG(0x02C8)
-#define CR179 CTL_REG(0x02CC)
-#define CR180 CTL_REG(0x02D0)
-#define CR181 CTL_REG(0x02D4)
-#define CR182 CTL_REG(0x02D8)
-#define CR183 CTL_REG(0x02DC)
-#define CR184 CTL_REG(0x02E0)
-#define CR185 CTL_REG(0x02E4)
-#define CR186 CTL_REG(0x02E8)
-#define CR187 CTL_REG(0x02EC)
-#define CR188 CTL_REG(0x02F0)
-#define CR189 CTL_REG(0x02F4)
-#define CR190 CTL_REG(0x02F8)
-#define CR191 CTL_REG(0x02FC)
-#define CR192 CTL_REG(0x0300)
-#define CR193 CTL_REG(0x0304)
-#define CR194 CTL_REG(0x0308)
-#define CR195 CTL_REG(0x030C)
-#define CR196 CTL_REG(0x0310)
-#define CR197 CTL_REG(0x0314)
-#define CR198 CTL_REG(0x0318)
-#define CR199 CTL_REG(0x031C)
-#define CR200 CTL_REG(0x0320)
-#define CR201 CTL_REG(0x0324)
-#define CR202 CTL_REG(0x0328)
-#define CR203 CTL_REG(0x032C)	/* I2C bus template value & flash control */
-#define CR204 CTL_REG(0x0330)
-#define CR205 CTL_REG(0x0334)
-#define CR206 CTL_REG(0x0338)
-#define CR207 CTL_REG(0x033C)
-#define CR208 CTL_REG(0x0340)
-#define CR209 CTL_REG(0x0344)
-#define CR210 CTL_REG(0x0348)
-#define CR211 CTL_REG(0x034C)
-#define CR212 CTL_REG(0x0350)
-#define CR213 CTL_REG(0x0354)
-#define CR214 CTL_REG(0x0358)
-#define CR215 CTL_REG(0x035C)
-#define CR216 CTL_REG(0x0360)
-#define CR217 CTL_REG(0x0364)
-#define CR218 CTL_REG(0x0368)
-#define CR219 CTL_REG(0x036C)
-#define CR220 CTL_REG(0x0370)
-#define CR221 CTL_REG(0x0374)
-#define CR222 CTL_REG(0x0378)
-#define CR223 CTL_REG(0x037C)
-#define CR224 CTL_REG(0x0380)
-#define CR225 CTL_REG(0x0384)
-#define CR226 CTL_REG(0x0388)
-#define CR227 CTL_REG(0x038C)
-#define CR228 CTL_REG(0x0390)
-#define CR229 CTL_REG(0x0394)
-#define CR230 CTL_REG(0x0398)
-#define CR231 CTL_REG(0x039C)
-#define CR232 CTL_REG(0x03A0)
-#define CR233 CTL_REG(0x03A4)
-#define CR234 CTL_REG(0x03A8)
-#define CR235 CTL_REG(0x03AC)
-#define CR236 CTL_REG(0x03B0)
-
-#define CR240 CTL_REG(0x03C0)
-/*	bit 7:  host-controlled RF register writes
- * CR241-CR245: for hardware controlled writing of RF bits, not needed for
- *              USB
+#define ZD_CR12  CTL_REG(0x0030)
+#define ZD_CR13  CTL_REG(0x0034)
+#define ZD_CR14  CTL_REG(0x0038)
+#define ZD_CR15  CTL_REG(0x003C)
+#define ZD_CR16  CTL_REG(0x0040)
+#define ZD_CR17  CTL_REG(0x0044)
+#define ZD_CR18  CTL_REG(0x0048)
+#define ZD_CR19  CTL_REG(0x004C)
+#define ZD_CR20  CTL_REG(0x0050)
+#define ZD_CR21  CTL_REG(0x0054)
+#define ZD_CR22  CTL_REG(0x0058)
+#define ZD_CR23  CTL_REG(0x005C)
+#define ZD_CR24  CTL_REG(0x0060)	/* CCA threshold */
+#define ZD_CR25  CTL_REG(0x0064)
+#define ZD_CR26  CTL_REG(0x0068)
+#define ZD_CR27  CTL_REG(0x006C)
+#define ZD_CR28  CTL_REG(0x0070)
+#define ZD_CR29  CTL_REG(0x0074)
+#define ZD_CR30  CTL_REG(0x0078)
+#define ZD_CR31  CTL_REG(0x007C)	/* TX power control for RF in
+					 * CCK mode
+					 */
+#define ZD_CR32  CTL_REG(0x0080)
+#define ZD_CR33  CTL_REG(0x0084)
+#define ZD_CR34  CTL_REG(0x0088)
+#define ZD_CR35  CTL_REG(0x008C)
+#define ZD_CR36  CTL_REG(0x0090)
+#define ZD_CR37  CTL_REG(0x0094)
+#define ZD_CR38  CTL_REG(0x0098)
+#define ZD_CR39  CTL_REG(0x009C)
+#define ZD_CR40  CTL_REG(0x00A0)
+#define ZD_CR41  CTL_REG(0x00A4)
+#define ZD_CR42  CTL_REG(0x00A8)
+#define ZD_CR43  CTL_REG(0x00AC)
+#define ZD_CR44  CTL_REG(0x00B0)
+#define ZD_CR45  CTL_REG(0x00B4)
+#define ZD_CR46  CTL_REG(0x00B8)
+#define ZD_CR47  CTL_REG(0x00BC)	/* CCK baseband gain
+					 * (patch value might be in EEPROM)
+					 */
+#define ZD_CR48  CTL_REG(0x00C0)
+#define ZD_CR49  CTL_REG(0x00C4)
+#define ZD_CR50  CTL_REG(0x00C8)
+#define ZD_CR51  CTL_REG(0x00CC)	/* TX power control for RF in
+					 * 6-36M modes
+					 */
+#define ZD_CR52  CTL_REG(0x00D0)	/* TX power control for RF in
+					 * 48M mode
+					 */
+#define ZD_CR53  CTL_REG(0x00D4)	/* TX power control for RF in
+					 * 54M mode
+					 */
+#define ZD_CR54  CTL_REG(0x00D8)
+#define ZD_CR55  CTL_REG(0x00DC)
+#define ZD_CR56  CTL_REG(0x00E0)
+#define ZD_CR57  CTL_REG(0x00E4)
+#define ZD_CR58  CTL_REG(0x00E8)
+#define ZD_CR59  CTL_REG(0x00EC)
+#define ZD_CR60  CTL_REG(0x00F0)
+#define ZD_CR61  CTL_REG(0x00F4)
+#define ZD_CR62  CTL_REG(0x00F8)
+#define ZD_CR63  CTL_REG(0x00FC)
+#define ZD_CR64  CTL_REG(0x0100)
+#define ZD_CR65  CTL_REG(0x0104) /* OFDM 54M calibration */
+#define ZD_CR66  CTL_REG(0x0108) /* OFDM 48M calibration */
+#define ZD_CR67  CTL_REG(0x010C) /* OFDM 36M calibration */
+#define ZD_CR68  CTL_REG(0x0110) /* CCK calibration */
+#define ZD_CR69  CTL_REG(0x0114)
+#define ZD_CR70  CTL_REG(0x0118)
+#define ZD_CR71  CTL_REG(0x011C)
+#define ZD_CR72  CTL_REG(0x0120)
+#define ZD_CR73  CTL_REG(0x0124)
+#define ZD_CR74  CTL_REG(0x0128)
+#define ZD_CR75  CTL_REG(0x012C)
+#define ZD_CR76  CTL_REG(0x0130)
+#define ZD_CR77  CTL_REG(0x0134)
+#define ZD_CR78  CTL_REG(0x0138)
+#define ZD_CR79  CTL_REG(0x013C)
+#define ZD_CR80  CTL_REG(0x0140)
+#define ZD_CR81  CTL_REG(0x0144)
+#define ZD_CR82  CTL_REG(0x0148)
+#define ZD_CR83  CTL_REG(0x014C)
+#define ZD_CR84  CTL_REG(0x0150)
+#define ZD_CR85  CTL_REG(0x0154)
+#define ZD_CR86  CTL_REG(0x0158)
+#define ZD_CR87  CTL_REG(0x015C)
+#define ZD_CR88  CTL_REG(0x0160)
+#define ZD_CR89  CTL_REG(0x0164)
+#define ZD_CR90  CTL_REG(0x0168)
+#define ZD_CR91  CTL_REG(0x016C)
+#define ZD_CR92  CTL_REG(0x0170)
+#define ZD_CR93  CTL_REG(0x0174)
+#define ZD_CR94  CTL_REG(0x0178)
+#define ZD_CR95  CTL_REG(0x017C)
+#define ZD_CR96  CTL_REG(0x0180)
+#define ZD_CR97  CTL_REG(0x0184)
+#define ZD_CR98  CTL_REG(0x0188)
+#define ZD_CR99  CTL_REG(0x018C)
+#define ZD_CR100 CTL_REG(0x0190)
+#define ZD_CR101 CTL_REG(0x0194)
+#define ZD_CR102 CTL_REG(0x0198)
+#define ZD_CR103 CTL_REG(0x019C)
+#define ZD_CR104 CTL_REG(0x01A0)
+#define ZD_CR105 CTL_REG(0x01A4)
+#define ZD_CR106 CTL_REG(0x01A8)
+#define ZD_CR107 CTL_REG(0x01AC)
+#define ZD_CR108 CTL_REG(0x01B0)
+#define ZD_CR109 CTL_REG(0x01B4)
+#define ZD_CR110 CTL_REG(0x01B8)
+#define ZD_CR111 CTL_REG(0x01BC)
+#define ZD_CR112 CTL_REG(0x01C0)
+#define ZD_CR113 CTL_REG(0x01C4)
+#define ZD_CR114 CTL_REG(0x01C8)
+#define ZD_CR115 CTL_REG(0x01CC)
+#define ZD_CR116 CTL_REG(0x01D0)
+#define ZD_CR117 CTL_REG(0x01D4)
+#define ZD_CR118 CTL_REG(0x01D8)
+#define ZD_CR119 CTL_REG(0x01DC)
+#define ZD_CR120 CTL_REG(0x01E0)
+#define ZD_CR121 CTL_REG(0x01E4)
+#define ZD_CR122 CTL_REG(0x01E8)
+#define ZD_CR123 CTL_REG(0x01EC)
+#define ZD_CR124 CTL_REG(0x01F0)
+#define ZD_CR125 CTL_REG(0x01F4)
+#define ZD_CR126 CTL_REG(0x01F8)
+#define ZD_CR127 CTL_REG(0x01FC)
+#define ZD_CR128 CTL_REG(0x0200)
+#define ZD_CR129 CTL_REG(0x0204)
+#define ZD_CR130 CTL_REG(0x0208)
+#define ZD_CR131 CTL_REG(0x020C)
+#define ZD_CR132 CTL_REG(0x0210)
+#define ZD_CR133 CTL_REG(0x0214)
+#define ZD_CR134 CTL_REG(0x0218)
+#define ZD_CR135 CTL_REG(0x021C)
+#define ZD_CR136 CTL_REG(0x0220)
+#define ZD_CR137 CTL_REG(0x0224)
+#define ZD_CR138 CTL_REG(0x0228)
+#define ZD_CR139 CTL_REG(0x022C)
+#define ZD_CR140 CTL_REG(0x0230)
+#define ZD_CR141 CTL_REG(0x0234)
+#define ZD_CR142 CTL_REG(0x0238)
+#define ZD_CR143 CTL_REG(0x023C)
+#define ZD_CR144 CTL_REG(0x0240)
+#define ZD_CR145 CTL_REG(0x0244)
+#define ZD_CR146 CTL_REG(0x0248)
+#define ZD_CR147 CTL_REG(0x024C)
+#define ZD_CR148 CTL_REG(0x0250)
+#define ZD_CR149 CTL_REG(0x0254)
+#define ZD_CR150 CTL_REG(0x0258)
+#define ZD_CR151 CTL_REG(0x025C)
+#define ZD_CR152 CTL_REG(0x0260)
+#define ZD_CR153 CTL_REG(0x0264)
+#define ZD_CR154 CTL_REG(0x0268)
+#define ZD_CR155 CTL_REG(0x026C)
+#define ZD_CR156 CTL_REG(0x0270)
+#define ZD_CR157 CTL_REG(0x0274)
+#define ZD_CR158 CTL_REG(0x0278)
+#define ZD_CR159 CTL_REG(0x027C)
+#define ZD_CR160 CTL_REG(0x0280)
+#define ZD_CR161 CTL_REG(0x0284)
+#define ZD_CR162 CTL_REG(0x0288)
+#define ZD_CR163 CTL_REG(0x028C)
+#define ZD_CR164 CTL_REG(0x0290)
+#define ZD_CR165 CTL_REG(0x0294)
+#define ZD_CR166 CTL_REG(0x0298)
+#define ZD_CR167 CTL_REG(0x029C)
+#define ZD_CR168 CTL_REG(0x02A0)
+#define ZD_CR169 CTL_REG(0x02A4)
+#define ZD_CR170 CTL_REG(0x02A8)
+#define ZD_CR171 CTL_REG(0x02AC)
+#define ZD_CR172 CTL_REG(0x02B0)
+#define ZD_CR173 CTL_REG(0x02B4)
+#define ZD_CR174 CTL_REG(0x02B8)
+#define ZD_CR175 CTL_REG(0x02BC)
+#define ZD_CR176 CTL_REG(0x02C0)
+#define ZD_CR177 CTL_REG(0x02C4)
+#define ZD_CR178 CTL_REG(0x02C8)
+#define ZD_CR179 CTL_REG(0x02CC)
+#define ZD_CR180 CTL_REG(0x02D0)
+#define ZD_CR181 CTL_REG(0x02D4)
+#define ZD_CR182 CTL_REG(0x02D8)
+#define ZD_CR183 CTL_REG(0x02DC)
+#define ZD_CR184 CTL_REG(0x02E0)
+#define ZD_CR185 CTL_REG(0x02E4)
+#define ZD_CR186 CTL_REG(0x02E8)
+#define ZD_CR187 CTL_REG(0x02EC)
+#define ZD_CR188 CTL_REG(0x02F0)
+#define ZD_CR189 CTL_REG(0x02F4)
+#define ZD_CR190 CTL_REG(0x02F8)
+#define ZD_CR191 CTL_REG(0x02FC)
+#define ZD_CR192 CTL_REG(0x0300)
+#define ZD_CR193 CTL_REG(0x0304)
+#define ZD_CR194 CTL_REG(0x0308)
+#define ZD_CR195 CTL_REG(0x030C)
+#define ZD_CR196 CTL_REG(0x0310)
+#define ZD_CR197 CTL_REG(0x0314)
+#define ZD_CR198 CTL_REG(0x0318)
+#define ZD_CR199 CTL_REG(0x031C)
+#define ZD_CR200 CTL_REG(0x0320)
+#define ZD_CR201 CTL_REG(0x0324)
+#define ZD_CR202 CTL_REG(0x0328)
+#define ZD_CR203 CTL_REG(0x032C)	/* I2C bus template value & flash
+					 * control
+					 */
+#define ZD_CR204 CTL_REG(0x0330)
+#define ZD_CR205 CTL_REG(0x0334)
+#define ZD_CR206 CTL_REG(0x0338)
+#define ZD_CR207 CTL_REG(0x033C)
+#define ZD_CR208 CTL_REG(0x0340)
+#define ZD_CR209 CTL_REG(0x0344)
+#define ZD_CR210 CTL_REG(0x0348)
+#define ZD_CR211 CTL_REG(0x034C)
+#define ZD_CR212 CTL_REG(0x0350)
+#define ZD_CR213 CTL_REG(0x0354)
+#define ZD_CR214 CTL_REG(0x0358)
+#define ZD_CR215 CTL_REG(0x035C)
+#define ZD_CR216 CTL_REG(0x0360)
+#define ZD_CR217 CTL_REG(0x0364)
+#define ZD_CR218 CTL_REG(0x0368)
+#define ZD_CR219 CTL_REG(0x036C)
+#define ZD_CR220 CTL_REG(0x0370)
+#define ZD_CR221 CTL_REG(0x0374)
+#define ZD_CR222 CTL_REG(0x0378)
+#define ZD_CR223 CTL_REG(0x037C)
+#define ZD_CR224 CTL_REG(0x0380)
+#define ZD_CR225 CTL_REG(0x0384)
+#define ZD_CR226 CTL_REG(0x0388)
+#define ZD_CR227 CTL_REG(0x038C)
+#define ZD_CR228 CTL_REG(0x0390)
+#define ZD_CR229 CTL_REG(0x0394)
+#define ZD_CR230 CTL_REG(0x0398)
+#define ZD_CR231 CTL_REG(0x039C)
+#define ZD_CR232 CTL_REG(0x03A0)
+#define ZD_CR233 CTL_REG(0x03A4)
+#define ZD_CR234 CTL_REG(0x03A8)
+#define ZD_CR235 CTL_REG(0x03AC)
+#define ZD_CR236 CTL_REG(0x03B0)
+
+#define ZD_CR240 CTL_REG(0x03C0)
+/*             bit 7: host-controlled RF register writes
+ * ZD_CR241-ZD_CR245: for hardware controlled writing of RF bits, not needed for
+ *                    USB
  */
-#define CR241 CTL_REG(0x03C4)
-#define CR242 CTL_REG(0x03C8)
-#define CR243 CTL_REG(0x03CC)
-#define CR244 CTL_REG(0x03D0)
-#define CR245 CTL_REG(0x03D4)
-
-#define CR251 CTL_REG(0x03EC)	/* only used for activation and deactivation of
-				 * Airoha RFs AL2230 and AL7230B
-				 */
-#define CR252 CTL_REG(0x03F0)
-#define CR253 CTL_REG(0x03F4)
-#define CR254 CTL_REG(0x03F8)
-#define CR255 CTL_REG(0x03FC)
+#define ZD_CR241 CTL_REG(0x03C4)
+#define ZD_CR242 CTL_REG(0x03C8)
+#define ZD_CR243 CTL_REG(0x03CC)
+#define ZD_CR244 CTL_REG(0x03D0)
+#define ZD_CR245 CTL_REG(0x03D4)
+
+#define ZD_CR251 CTL_REG(0x03EC)	/* only used for activation and
+					 * deactivation of Airoha RFs AL2230
+					 * and AL7230B
+					 */
+#define ZD_CR252 CTL_REG(0x03F0)
+#define ZD_CR253 CTL_REG(0x03F4)
+#define ZD_CR254 CTL_REG(0x03F8)
+#define ZD_CR255 CTL_REG(0x03FC)
 
 #define CR_MAX_PHY_REG 255
 
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.h b/drivers/net/wireless/zd1211rw/zd_rf.h
index 79dc103..725b7c9 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.h
+++ b/drivers/net/wireless/zd1211rw/zd_rf.h
@@ -55,7 +55,7 @@ struct zd_rf {
 	 * defaults to 1 (yes) */
 	u8 update_channel_int:1;
 
-	/* whether CR47 should be patched from the EEPROM, if the appropriate
+	/* whether ZD_CR47 should be patched from the EEPROM, if the appropriate
 	 * flag is set in the POD. The vendor driver suggests that this should
 	 * be done for all RF's, but a bug in their code prevents but their
 	 * HW_OverWritePhyRegFromE2P() routine from ever taking effect. */
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
index 74a8f7a..12babcb 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
@@ -61,31 +61,31 @@ static const u32 zd1211b_al2230_table[][3] = {
 };
 
 static const struct zd_ioreq16 zd1211b_ioreqs_shared_1[] = {
-	{ CR240, 0x57 }, { CR9,   0xe0 },
+	{ ZD_CR240, 0x57 }, { ZD_CR9,   0xe0 },
 };
 
 static const struct zd_ioreq16 ioreqs_init_al2230s[] = {
-	{ CR47,   0x1e }, /* MARK_002 */
-	{ CR106,  0x22 },
-	{ CR107,  0x2a }, /* MARK_002 */
-	{ CR109,  0x13 }, /* MARK_002 */
-	{ CR118,  0xf8 }, /* MARK_002 */
-	{ CR119,  0x12 }, { CR122,  0xe0 },
-	{ CR128,  0x10 }, /* MARK_001 from 0xe->0x10 */
-	{ CR129,  0x0e }, /* MARK_001 from 0xd->0x0e */
-	{ CR130,  0x10 }, /* MARK_001 from 0xb->0x0d */
+	{ ZD_CR47,   0x1e }, /* MARK_002 */
+	{ ZD_CR106,  0x22 },
+	{ ZD_CR107,  0x2a }, /* MARK_002 */
+	{ ZD_CR109,  0x13 }, /* MARK_002 */
+	{ ZD_CR118,  0xf8 }, /* MARK_002 */
+	{ ZD_CR119,  0x12 }, { ZD_CR122,  0xe0 },
+	{ ZD_CR128,  0x10 }, /* MARK_001 from 0xe->0x10 */
+	{ ZD_CR129,  0x0e }, /* MARK_001 from 0xd->0x0e */
+	{ ZD_CR130,  0x10 }, /* MARK_001 from 0xb->0x0d */
 };
 
 static int zd1211b_al2230_finalize_rf(struct zd_chip *chip)
 {
 	int r;
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR80,  0x30 }, { CR81,  0x30 }, { CR79,  0x58 },
-		{ CR12,  0xf0 }, { CR77,  0x1b }, { CR78,  0x58 },
-		{ CR203, 0x06 },
+		{ ZD_CR80,  0x30 }, { ZD_CR81,  0x30 }, { ZD_CR79,  0x58 },
+		{ ZD_CR12,  0xf0 }, { ZD_CR77,  0x1b }, { ZD_CR78,  0x58 },
+		{ ZD_CR203, 0x06 },
 		{ },
 
-		{ CR240, 0x80 },
+		{ ZD_CR240, 0x80 },
 	};
 
 	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -94,12 +94,12 @@ static int zd1211b_al2230_finalize_rf(struct zd_chip *chip)
 
 	/* related to antenna selection? */
 	if (chip->new_phy_layout) {
-		r = zd_iowrite16_locked(chip, 0xe1, CR9);
+		r = zd_iowrite16_locked(chip, 0xe1, ZD_CR9);
 		if (r)
 			return r;
 	}
 
-	return zd_iowrite16_locked(chip, 0x06, CR203);
+	return zd_iowrite16_locked(chip, 0x06, ZD_CR203);
 }
 
 static int zd1211_al2230_init_hw(struct zd_rf *rf)
@@ -108,40 +108,40 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs_init[] = {
-		{ CR15,   0x20 }, { CR23,   0x40 }, { CR24,  0x20 },
-		{ CR26,   0x11 }, { CR28,   0x3e }, { CR29,  0x00 },
-		{ CR44,   0x33 }, { CR106,  0x2a }, { CR107, 0x1a },
-		{ CR109,  0x09 }, { CR110,  0x27 }, { CR111, 0x2b },
-		{ CR112,  0x2b }, { CR119,  0x0a }, { CR10,  0x89 },
+		{ ZD_CR15,   0x20 }, { ZD_CR23,   0x40 }, { ZD_CR24,  0x20 },
+		{ ZD_CR26,   0x11 }, { ZD_CR28,   0x3e }, { ZD_CR29,  0x00 },
+		{ ZD_CR44,   0x33 }, { ZD_CR106,  0x2a }, { ZD_CR107, 0x1a },
+		{ ZD_CR109,  0x09 }, { ZD_CR110,  0x27 }, { ZD_CR111, 0x2b },
+		{ ZD_CR112,  0x2b }, { ZD_CR119,  0x0a }, { ZD_CR10,  0x89 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR17,   0x28 },
-		{ CR26,   0x93 }, { CR34,   0x30 },
+		{ ZD_CR17,   0x28 },
+		{ ZD_CR26,   0x93 }, { ZD_CR34,   0x30 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR35,   0x3e },
-		{ CR41,   0x24 }, { CR44,   0x32 },
+		{ ZD_CR35,   0x3e },
+		{ ZD_CR41,   0x24 }, { ZD_CR44,   0x32 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR46,   0x96 },
-		{ CR47,   0x1e }, { CR79,   0x58 }, { CR80,  0x30 },
-		{ CR81,   0x30 }, { CR87,   0x0a }, { CR89,  0x04 },
-		{ CR92,   0x0a }, { CR99,   0x28 }, { CR100, 0x00 },
-		{ CR101,  0x13 }, { CR102,  0x27 }, { CR106, 0x24 },
-		{ CR107,  0x2a }, { CR109,  0x09 }, { CR110, 0x13 },
-		{ CR111,  0x1f }, { CR112,  0x1f }, { CR113, 0x27 },
-		{ CR114,  0x27 },
+		{ ZD_CR46,   0x96 },
+		{ ZD_CR47,   0x1e }, { ZD_CR79,   0x58 }, { ZD_CR80,  0x30 },
+		{ ZD_CR81,   0x30 }, { ZD_CR87,   0x0a }, { ZD_CR89,  0x04 },
+		{ ZD_CR92,   0x0a }, { ZD_CR99,   0x28 }, { ZD_CR100, 0x00 },
+		{ ZD_CR101,  0x13 }, { ZD_CR102,  0x27 }, { ZD_CR106, 0x24 },
+		{ ZD_CR107,  0x2a }, { ZD_CR109,  0x09 }, { ZD_CR110, 0x13 },
+		{ ZD_CR111,  0x1f }, { ZD_CR112,  0x1f }, { ZD_CR113, 0x27 },
+		{ ZD_CR114,  0x27 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR115,  0x24 },
-		{ CR116,  0x24 }, { CR117,  0xf4 }, { CR118, 0xfc },
-		{ CR119,  0x10 }, { CR120,  0x4f }, { CR121, 0x77 },
-		{ CR122,  0xe0 }, { CR137,  0x88 }, { CR252, 0xff },
-		{ CR253,  0xff },
+		{ ZD_CR115,  0x24 },
+		{ ZD_CR116,  0x24 }, { ZD_CR117,  0xf4 }, { ZD_CR118, 0xfc },
+		{ ZD_CR119,  0x10 }, { ZD_CR120,  0x4f }, { ZD_CR121, 0x77 },
+		{ ZD_CR122,  0xe0 }, { ZD_CR137,  0x88 }, { ZD_CR252, 0xff },
+		{ ZD_CR253,  0xff },
 	};
 
 	static const struct zd_ioreq16 ioreqs_pll[] = {
 		/* shdnb(PLL_ON)=0 */
-		{ CR251,  0x2f },
+		{ ZD_CR251,  0x2f },
 		/* shdnb(PLL_ON)=1 */
-		{ CR251,  0x3f },
-		{ CR138,  0x28 }, { CR203,  0x06 },
+		{ ZD_CR251,  0x3f },
+		{ ZD_CR138,  0x28 }, { ZD_CR203,  0x06 },
 	};
 
 	static const u32 rv1[] = {
@@ -161,7 +161,7 @@ static int zd1211_al2230_init_hw(struct zd_rf *rf)
 		0x0805b6,
 		0x011687,
 		0x000688,
-		0x0403b9, /* external control TX power (CR31) */
+		0x0403b9, /* external control TX power (ZD_CR31) */
 		0x00dbba,
 		0x00099b,
 		0x0bdffc,
@@ -221,52 +221,54 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs1[] = {
-		{ CR10,  0x89 }, { CR15,  0x20 },
-		{ CR17,  0x2B }, /* for newest(3rd cut) AL2230 */
-		{ CR23,  0x40 }, { CR24,  0x20 }, { CR26,  0x93 },
-		{ CR28,  0x3e }, { CR29,  0x00 },
-		{ CR33,  0x28 }, /* 5621 */
-		{ CR34,  0x30 },
-		{ CR35,  0x3e }, /* for newest(3rd cut) AL2230 */
-		{ CR41,  0x24 }, { CR44,  0x32 },
-		{ CR46,  0x99 }, /* for newest(3rd cut) AL2230 */
-		{ CR47,  0x1e },
+		{ ZD_CR10,  0x89 }, { ZD_CR15,  0x20 },
+		{ ZD_CR17,  0x2B }, /* for newest(3rd cut) AL2230 */
+		{ ZD_CR23,  0x40 }, { ZD_CR24,  0x20 }, { ZD_CR26,  0x93 },
+		{ ZD_CR28,  0x3e }, { ZD_CR29,  0x00 },
+		{ ZD_CR33,  0x28 }, /* 5621 */
+		{ ZD_CR34,  0x30 },
+		{ ZD_CR35,  0x3e }, /* for newest(3rd cut) AL2230 */
+		{ ZD_CR41,  0x24 }, { ZD_CR44,  0x32 },
+		{ ZD_CR46,  0x99 }, /* for newest(3rd cut) AL2230 */
+		{ ZD_CR47,  0x1e },
 
 		/* ZD1211B 05.06.10 */
-		{ CR48,  0x06 }, { CR49,  0xf9 }, { CR51,  0x01 },
-		{ CR52,  0x80 }, { CR53,  0x7e }, { CR65,  0x00 },
-		{ CR66,  0x00 }, { CR67,  0x00 }, { CR68,  0x00 },
-		{ CR69,  0x28 },
-
-		{ CR79,  0x58 }, { CR80,  0x30 }, { CR81,  0x30 },
-		{ CR87,  0x0a }, { CR89,  0x04 },
-		{ CR91,  0x00 }, /* 5621 */
-		{ CR92,  0x0a },
-		{ CR98,  0x8d }, /* 4804,  for 1212 new algorithm */
-		{ CR99,  0x00 }, /* 5621 */
-		{ CR101, 0x13 }, { CR102, 0x27 },
-		{ CR106, 0x24 }, /* for newest(3rd cut) AL2230 */
-		{ CR107, 0x2a },
-		{ CR109, 0x13 }, /* 4804, for 1212 new algorithm */
-		{ CR110, 0x1f }, /* 4804, for 1212 new algorithm */
-		{ CR111, 0x1f }, { CR112, 0x1f }, { CR113, 0x27 },
-		{ CR114, 0x27 },
-		{ CR115, 0x26 }, /* 24->26 at 4902 for newest(3rd cut) AL2230 */
-		{ CR116, 0x24 },
-		{ CR117, 0xfa }, /* for 1211b */
-		{ CR118, 0xfa }, /* for 1211b */
-		{ CR119, 0x10 },
-		{ CR120, 0x4f },
-		{ CR121, 0x6c }, /* for 1211b */
-		{ CR122, 0xfc }, /* E0->FC at 4902 */
-		{ CR123, 0x57 }, /* 5623 */
-		{ CR125, 0xad }, /* 4804, for 1212 new algorithm */
-		{ CR126, 0x6c }, /* 5614 */
-		{ CR127, 0x03 }, /* 4804, for 1212 new algorithm */
-		{ CR137, 0x50 }, /* 5614 */
-		{ CR138, 0xa8 },
-		{ CR144, 0xac }, /* 5621 */
-		{ CR150, 0x0d }, { CR252, 0x34 }, { CR253, 0x34 },
+		{ ZD_CR48,  0x06 }, { ZD_CR49,  0xf9 }, { ZD_CR51,  0x01 },
+		{ ZD_CR52,  0x80 }, { ZD_CR53,  0x7e }, { ZD_CR65,  0x00 },
+		{ ZD_CR66,  0x00 }, { ZD_CR67,  0x00 }, { ZD_CR68,  0x00 },
+		{ ZD_CR69,  0x28 },
+
+		{ ZD_CR79,  0x58 }, { ZD_CR80,  0x30 }, { ZD_CR81,  0x30 },
+		{ ZD_CR87,  0x0a }, { ZD_CR89,  0x04 },
+		{ ZD_CR91,  0x00 }, /* 5621 */
+		{ ZD_CR92,  0x0a },
+		{ ZD_CR98,  0x8d }, /* 4804,  for 1212 new algorithm */
+		{ ZD_CR99,  0x00 }, /* 5621 */
+		{ ZD_CR101, 0x13 }, { ZD_CR102, 0x27 },
+		{ ZD_CR106, 0x24 }, /* for newest(3rd cut) AL2230 */
+		{ ZD_CR107, 0x2a },
+		{ ZD_CR109, 0x13 }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR110, 0x1f }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR111, 0x1f }, { ZD_CR112, 0x1f }, { ZD_CR113, 0x27 },
+		{ ZD_CR114, 0x27 },
+		{ ZD_CR115, 0x26 }, /* 24->26 at 4902 for newest(3rd cut)
+				     * AL2230
+				     */
+		{ ZD_CR116, 0x24 },
+		{ ZD_CR117, 0xfa }, /* for 1211b */
+		{ ZD_CR118, 0xfa }, /* for 1211b */
+		{ ZD_CR119, 0x10 },
+		{ ZD_CR120, 0x4f },
+		{ ZD_CR121, 0x6c }, /* for 1211b */
+		{ ZD_CR122, 0xfc }, /* E0->FC at 4902 */
+		{ ZD_CR123, 0x57 }, /* 5623 */
+		{ ZD_CR125, 0xad }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR126, 0x6c }, /* 5614 */
+		{ ZD_CR127, 0x03 }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR137, 0x50 }, /* 5614 */
+		{ ZD_CR138, 0xa8 },
+		{ ZD_CR144, 0xac }, /* 5621 */
+		{ ZD_CR150, 0x0d }, { ZD_CR252, 0x34 }, { ZD_CR253, 0x34 },
 	};
 
 	static const u32 rv1[] = {
@@ -284,7 +286,7 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 		0x6da010, /* Reg6 update for MP versio */
 		0xe36280, /* Modified by jxiao for Bor-Chin on 2004/08/02 */
 		0x116000,
-		0x9dc020, /* External control TX power (CR31) */
+		0x9dc020, /* External control TX power (ZD_CR31) */
 		0x5ddb00, /* RegA update for MP version */
 		0xd99000, /* RegB update for MP version */
 		0x3ffbd0, /* RegC update for MP version */
@@ -295,8 +297,8 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 	};
 
 	static const struct zd_ioreq16 ioreqs2[] = {
-		{ CR251, 0x2f }, /* shdnb(PLL_ON)=0 */
-		{ CR251, 0x7f }, /* shdnb(PLL_ON)=1 */
+		{ ZD_CR251, 0x2f }, /* shdnb(PLL_ON)=0 */
+		{ ZD_CR251, 0x7f }, /* shdnb(PLL_ON)=1 */
 	};
 
 	static const u32 rv3[] = {
@@ -308,7 +310,7 @@ static int zd1211b_al2230_init_hw(struct zd_rf *rf)
 
 	static const struct zd_ioreq16 ioreqs3[] = {
 		/* related to 6M band edge patching, happens unconditionally */
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
 	};
 
 	r = zd_iowrite16a_locked(chip, zd1211b_ioreqs_shared_1,
@@ -361,8 +363,8 @@ static int zd1211_al2230_set_channel(struct zd_rf *rf, u8 channel)
 	const u32 *rv = zd1211_al2230_table[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR138, 0x28 },
-		{ CR203, 0x06 },
+		{ ZD_CR138, 0x28 },
+		{ ZD_CR203, 0x06 },
 	};
 
 	r = zd_rfwritev_locked(chip, rv, 3, RF_RV_BITS);
@@ -393,8 +395,8 @@ static int zd1211_al2230_switch_radio_on(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x00 },
-		{ CR251, 0x3f },
+		{ ZD_CR11,  0x00 },
+		{ ZD_CR251, 0x3f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -404,8 +406,8 @@ static int zd1211b_al2230_switch_radio_on(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x00 },
-		{ CR251, 0x7f },
+		{ ZD_CR11,  0x00 },
+		{ ZD_CR251, 0x7f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -415,8 +417,8 @@ static int al2230_switch_radio_off(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x04 },
-		{ CR251, 0x2f },
+		{ ZD_CR11,  0x04 },
+		{ ZD_CR251, 0x2f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
index 65095d6..385c670 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
@@ -68,19 +68,19 @@ static const u32 rv_init2[] = {
 };
 
 static const struct zd_ioreq16 ioreqs_sw[] = {
-	{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-	{ CR38,  0x38 }, { CR136, 0xdf },
+	{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
+	{ ZD_CR38,  0x38 }, { ZD_CR136, 0xdf },
 };
 
 static int zd1211b_al7230b_finalize(struct zd_chip *chip)
 {
 	int r;
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR80,  0x30 }, { CR81,  0x30 }, { CR79,  0x58 },
-		{ CR12,  0xf0 }, { CR77,  0x1b }, { CR78,  0x58 },
-		{ CR203, 0x04 },
+		{ ZD_CR80,  0x30 }, { ZD_CR81,  0x30 }, { ZD_CR79,  0x58 },
+		{ ZD_CR12,  0xf0 }, { ZD_CR77,  0x1b }, { ZD_CR78,  0x58 },
+		{ ZD_CR203, 0x04 },
 		{ },
-		{ CR240, 0x80 },
+		{ ZD_CR240, 0x80 },
 	};
 
 	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -89,12 +89,12 @@ static int zd1211b_al7230b_finalize(struct zd_chip *chip)
 
 	if (chip->new_phy_layout) {
 		/* antenna selection? */
-		r = zd_iowrite16_locked(chip, 0xe5, CR9);
+		r = zd_iowrite16_locked(chip, 0xe5, ZD_CR9);
 		if (r)
 			return r;
 	}
 
-	return zd_iowrite16_locked(chip, 0x04, CR203);
+	return zd_iowrite16_locked(chip, 0x04, ZD_CR203);
 }
 
 static int zd1211_al7230b_init_hw(struct zd_rf *rf)
@@ -106,66 +106,66 @@ static int zd1211_al7230b_init_hw(struct zd_rf *rf)
 	 * specified */
 	static const struct zd_ioreq16 ioreqs_1[] = {
 		/* This one is 7230-specific, and happens before the rest */
-		{ CR240,  0x57 },
+		{ ZD_CR240,  0x57 },
 		{ },
 
-		{ CR15,   0x20 }, { CR23,   0x40 }, { CR24,  0x20 },
-		{ CR26,   0x11 }, { CR28,   0x3e }, { CR29,  0x00 },
-		{ CR44,   0x33 },
+		{ ZD_CR15,   0x20 }, { ZD_CR23,   0x40 }, { ZD_CR24,  0x20 },
+		{ ZD_CR26,   0x11 }, { ZD_CR28,   0x3e }, { ZD_CR29,  0x00 },
+		{ ZD_CR44,   0x33 },
 		/* This value is different for 7230 (was: 0x2a) */
-		{ CR106,  0x22 },
-		{ CR107,  0x1a }, { CR109,  0x09 }, { CR110,  0x27 },
-		{ CR111,  0x2b }, { CR112,  0x2b }, { CR119,  0x0a },
+		{ ZD_CR106,  0x22 },
+		{ ZD_CR107,  0x1a }, { ZD_CR109,  0x09 }, { ZD_CR110,  0x27 },
+		{ ZD_CR111,  0x2b }, { ZD_CR112,  0x2b }, { ZD_CR119,  0x0a },
 		/* This happened further down in AL2230,
 		 * and the value changed (was: 0xe0) */
-		{ CR122,  0xfc },
-		{ CR10,   0x89 },
+		{ ZD_CR122,  0xfc },
+		{ ZD_CR10,   0x89 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR17,   0x28 },
-		{ CR26,   0x93 }, { CR34,   0x30 },
+		{ ZD_CR17,   0x28 },
+		{ ZD_CR26,   0x93 }, { ZD_CR34,   0x30 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR35,   0x3e },
-		{ CR41,   0x24 }, { CR44,   0x32 },
+		{ ZD_CR35,   0x3e },
+		{ ZD_CR41,   0x24 }, { ZD_CR44,   0x32 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR46,   0x96 },
-		{ CR47,   0x1e }, { CR79,   0x58 }, { CR80,  0x30 },
-		{ CR81,   0x30 }, { CR87,   0x0a }, { CR89,  0x04 },
-		{ CR92,   0x0a }, { CR99,   0x28 },
+		{ ZD_CR46,   0x96 },
+		{ ZD_CR47,   0x1e }, { ZD_CR79,   0x58 }, { ZD_CR80,  0x30 },
+		{ ZD_CR81,   0x30 }, { ZD_CR87,   0x0a }, { ZD_CR89,  0x04 },
+		{ ZD_CR92,   0x0a }, { ZD_CR99,   0x28 },
 		/* This value is different for 7230 (was: 0x00) */
-		{ CR100,  0x02 },
-		{ CR101,  0x13 }, { CR102,  0x27 },
+		{ ZD_CR100,  0x02 },
+		{ ZD_CR101,  0x13 }, { ZD_CR102,  0x27 },
 		/* This value is different for 7230 (was: 0x24) */
-		{ CR106,  0x22 },
+		{ ZD_CR106,  0x22 },
 		/* This value is different for 7230 (was: 0x2a) */
-		{ CR107,  0x3f },
-		{ CR109,  0x09 },
+		{ ZD_CR107,  0x3f },
+		{ ZD_CR109,  0x09 },
 		/* This value is different for 7230 (was: 0x13) */
-		{ CR110,  0x1f },
-		{ CR111,  0x1f }, { CR112,  0x1f }, { CR113, 0x27 },
-		{ CR114,  0x27 },
+		{ ZD_CR110,  0x1f },
+		{ ZD_CR111,  0x1f }, { ZD_CR112,  0x1f }, { ZD_CR113, 0x27 },
+		{ ZD_CR114,  0x27 },
 		/* for newest (3rd cut) AL2300 */
-		{ CR115,  0x24 },
+		{ ZD_CR115,  0x24 },
 		/* This value is different for 7230 (was: 0x24) */
-		{ CR116,  0x3f },
+		{ ZD_CR116,  0x3f },
 		/* This value is different for 7230 (was: 0xf4) */
-		{ CR117,  0xfa },
-		{ CR118,  0xfc }, { CR119,  0x10 }, { CR120, 0x4f },
-		{ CR121,  0x77 }, { CR137,  0x88 },
+		{ ZD_CR117,  0xfa },
+		{ ZD_CR118,  0xfc }, { ZD_CR119,  0x10 }, { ZD_CR120, 0x4f },
+		{ ZD_CR121,  0x77 }, { ZD_CR137,  0x88 },
 		/* This one is 7230-specific */
-		{ CR138,  0xa8 },
+		{ ZD_CR138,  0xa8 },
 		/* This value is different for 7230 (was: 0xff) */
-		{ CR252,  0x34 },
+		{ ZD_CR252,  0x34 },
 		/* This value is different for 7230 (was: 0xff) */
-		{ CR253,  0x34 },
+		{ ZD_CR253,  0x34 },
 
 		/* PLL_OFF */
-		{ CR251, 0x2f },
+		{ ZD_CR251, 0x2f },
 	};
 
 	static const struct zd_ioreq16 ioreqs_2[] = {
-		{ CR251, 0x3f }, /* PLL_ON */
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR38,  0x38 }, { CR136, 0xdf },
+		{ ZD_CR251, 0x3f }, /* PLL_ON */
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
+		{ ZD_CR38,  0x38 }, { ZD_CR136, 0xdf },
 	};
 
 	r = zd_iowrite16a_locked(chip, ioreqs_1, ARRAY_SIZE(ioreqs_1));
@@ -192,10 +192,10 @@ static int zd1211_al7230b_init_hw(struct zd_rf *rf)
 	if (r)
 		return r;
 
-	r = zd_iowrite16_locked(chip, 0x06, CR203);
+	r = zd_iowrite16_locked(chip, 0x06, ZD_CR203);
 	if (r)
 		return r;
-	r = zd_iowrite16_locked(chip, 0x80, CR240);
+	r = zd_iowrite16_locked(chip, 0x80, ZD_CR240);
 	if (r)
 		return r;
 
@@ -208,79 +208,79 @@ static int zd1211b_al7230b_init_hw(struct zd_rf *rf)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs_1[] = {
-		{ CR240, 0x57 }, { CR9,   0x9 },
+		{ ZD_CR240, 0x57 }, { ZD_CR9,   0x9 },
 		{ },
-		{ CR10,  0x8b }, { CR15,  0x20 },
-		{ CR17,  0x2B }, /* for newest (3rd cut) AL2230 */
-		{ CR20,  0x10 }, /* 4N25->Stone Request */
-		{ CR23,  0x40 }, { CR24,  0x20 }, { CR26,  0x93 },
-		{ CR28,  0x3e }, { CR29,  0x00 },
-		{ CR33,  0x28 }, /* 5613 */
-		{ CR34,  0x30 },
-		{ CR35,  0x3e }, /* for newest (3rd cut) AL2230 */
-		{ CR41,  0x24 }, { CR44,  0x32 },
-		{ CR46,  0x99 }, /* for newest (3rd cut) AL2230 */
-		{ CR47,  0x1e },
+		{ ZD_CR10,  0x8b }, { ZD_CR15,  0x20 },
+		{ ZD_CR17,  0x2B }, /* for newest (3rd cut) AL2230 */
+		{ ZD_CR20,  0x10 }, /* 4N25->Stone Request */
+		{ ZD_CR23,  0x40 }, { ZD_CR24,  0x20 }, { ZD_CR26,  0x93 },
+		{ ZD_CR28,  0x3e }, { ZD_CR29,  0x00 },
+		{ ZD_CR33,  0x28 }, /* 5613 */
+		{ ZD_CR34,  0x30 },
+		{ ZD_CR35,  0x3e }, /* for newest (3rd cut) AL2230 */
+		{ ZD_CR41,  0x24 }, { ZD_CR44,  0x32 },
+		{ ZD_CR46,  0x99 }, /* for newest (3rd cut) AL2230 */
+		{ ZD_CR47,  0x1e },
 
 		/* ZD1215 5610 */
-		{ CR48,  0x00 }, { CR49,  0x00 }, { CR51,  0x01 },
-		{ CR52,  0x80 }, { CR53,  0x7e }, { CR65,  0x00 },
-		{ CR66,  0x00 }, { CR67,  0x00 }, { CR68,  0x00 },
-		{ CR69,  0x28 },
-
-		{ CR79,  0x58 }, { CR80,  0x30 }, { CR81,  0x30 },
-		{ CR87,  0x0A }, { CR89,  0x04 },
-		{ CR90,  0x58 }, /* 5112 */
-		{ CR91,  0x00 }, /* 5613 */
-		{ CR92,  0x0a },
-		{ CR98,  0x8d }, /* 4804, for 1212 new algorithm */
-		{ CR99,  0x00 }, { CR100, 0x02 }, { CR101, 0x13 },
-		{ CR102, 0x27 },
-		{ CR106, 0x20 }, /* change to 0x24 for AL7230B */
-		{ CR109, 0x13 }, /* 4804, for 1212 new algorithm */
-		{ CR112, 0x1f },
+		{ ZD_CR48,  0x00 }, { ZD_CR49,  0x00 }, { ZD_CR51,  0x01 },
+		{ ZD_CR52,  0x80 }, { ZD_CR53,  0x7e }, { ZD_CR65,  0x00 },
+		{ ZD_CR66,  0x00 }, { ZD_CR67,  0x00 }, { ZD_CR68,  0x00 },
+		{ ZD_CR69,  0x28 },
+
+		{ ZD_CR79,  0x58 }, { ZD_CR80,  0x30 }, { ZD_CR81,  0x30 },
+		{ ZD_CR87,  0x0A }, { ZD_CR89,  0x04 },
+		{ ZD_CR90,  0x58 }, /* 5112 */
+		{ ZD_CR91,  0x00 }, /* 5613 */
+		{ ZD_CR92,  0x0a },
+		{ ZD_CR98,  0x8d }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR99,  0x00 }, { ZD_CR100, 0x02 }, { ZD_CR101, 0x13 },
+		{ ZD_CR102, 0x27 },
+		{ ZD_CR106, 0x20 }, /* change to 0x24 for AL7230B */
+		{ ZD_CR109, 0x13 }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR112, 0x1f },
 	};
 
 	static const struct zd_ioreq16 ioreqs_new_phy[] = {
-		{ CR107, 0x28 },
-		{ CR110, 0x1f }, /* 5127, 0x13->0x1f */
-		{ CR111, 0x1f }, /* 0x13 to 0x1f for AL7230B */
-		{ CR116, 0x2a }, { CR118, 0xfa }, { CR119, 0x12 },
-		{ CR121, 0x6c }, /* 5613 */
+		{ ZD_CR107, 0x28 },
+		{ ZD_CR110, 0x1f }, /* 5127, 0x13->0x1f */
+		{ ZD_CR111, 0x1f }, /* 0x13 to 0x1f for AL7230B */
+		{ ZD_CR116, 0x2a }, { ZD_CR118, 0xfa }, { ZD_CR119, 0x12 },
+		{ ZD_CR121, 0x6c }, /* 5613 */
 	};
 
 	static const struct zd_ioreq16 ioreqs_old_phy[] = {
-		{ CR107, 0x24 },
-		{ CR110, 0x13 }, /* 5127, 0x13->0x1f */
-		{ CR111, 0x13 }, /* 0x13 to 0x1f for AL7230B */
-		{ CR116, 0x24 }, { CR118, 0xfc }, { CR119, 0x11 },
-		{ CR121, 0x6a }, /* 5613 */
+		{ ZD_CR107, 0x24 },
+		{ ZD_CR110, 0x13 }, /* 5127, 0x13->0x1f */
+		{ ZD_CR111, 0x13 }, /* 0x13 to 0x1f for AL7230B */
+		{ ZD_CR116, 0x24 }, { ZD_CR118, 0xfc }, { ZD_CR119, 0x11 },
+		{ ZD_CR121, 0x6a }, /* 5613 */
 	};
 
 	static const struct zd_ioreq16 ioreqs_2[] = {
-		{ CR113, 0x27 }, { CR114, 0x27 }, { CR115, 0x24 },
-		{ CR117, 0xfa }, { CR120, 0x4f },
-		{ CR122, 0xfc }, /* E0->FCh at 4901 */
-		{ CR123, 0x57 }, /* 5613 */
-		{ CR125, 0xad }, /* 4804, for 1212 new algorithm */
-		{ CR126, 0x6c }, /* 5613 */
-		{ CR127, 0x03 }, /* 4804, for 1212 new algorithm */
-		{ CR130, 0x10 },
-		{ CR131, 0x00 }, /* 5112 */
-		{ CR137, 0x50 }, /* 5613 */
-		{ CR138, 0xa8 }, /* 5112 */
-		{ CR144, 0xac }, /* 5613 */
-		{ CR148, 0x40 }, /* 5112 */
-		{ CR149, 0x40 }, /* 4O07, 50->40 */
-		{ CR150, 0x1a }, /* 5112, 0C->1A */
-		{ CR252, 0x34 }, { CR253, 0x34 },
-		{ CR251, 0x2f }, /* PLL_OFF */
+		{ ZD_CR113, 0x27 }, { ZD_CR114, 0x27 }, { ZD_CR115, 0x24 },
+		{ ZD_CR117, 0xfa }, { ZD_CR120, 0x4f },
+		{ ZD_CR122, 0xfc }, /* E0->FCh at 4901 */
+		{ ZD_CR123, 0x57 }, /* 5613 */
+		{ ZD_CR125, 0xad }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR126, 0x6c }, /* 5613 */
+		{ ZD_CR127, 0x03 }, /* 4804, for 1212 new algorithm */
+		{ ZD_CR130, 0x10 },
+		{ ZD_CR131, 0x00 }, /* 5112 */
+		{ ZD_CR137, 0x50 }, /* 5613 */
+		{ ZD_CR138, 0xa8 }, /* 5112 */
+		{ ZD_CR144, 0xac }, /* 5613 */
+		{ ZD_CR148, 0x40 }, /* 5112 */
+		{ ZD_CR149, 0x40 }, /* 4O07, 50->40 */
+		{ ZD_CR150, 0x1a }, /* 5112, 0C->1A */
+		{ ZD_CR252, 0x34 }, { ZD_CR253, 0x34 },
+		{ ZD_CR251, 0x2f }, /* PLL_OFF */
 	};
 
 	static const struct zd_ioreq16 ioreqs_3[] = {
-		{ CR251, 0x7f }, /* PLL_ON */
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR38,  0x38 }, { CR136, 0xdf },
+		{ ZD_CR251, 0x7f }, /* PLL_ON */
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 }, { ZD_CR130, 0x10 },
+		{ ZD_CR38,  0x38 }, { ZD_CR136, 0xdf },
 	};
 
 	r = zd_iowrite16a_locked(chip, ioreqs_1, ARRAY_SIZE(ioreqs_1));
@@ -331,16 +331,16 @@ static int zd1211_al7230b_set_channel(struct zd_rf *rf, u8 channel)
 
 	static const struct zd_ioreq16 ioreqs[] = {
 		/* PLL_ON */
-		{ CR251, 0x3f },
-		{ CR203, 0x06 }, { CR240, 0x08 },
+		{ ZD_CR251, 0x3f },
+		{ ZD_CR203, 0x06 }, { ZD_CR240, 0x08 },
 	};
 
-	r = zd_iowrite16_locked(chip, 0x57, CR240);
+	r = zd_iowrite16_locked(chip, 0x57, ZD_CR240);
 	if (r)
 		return r;
 
 	/* PLL_OFF */
-	r = zd_iowrite16_locked(chip, 0x2f, CR251);
+	r = zd_iowrite16_locked(chip, 0x2f, ZD_CR251);
 	if (r)
 		return r;
 
@@ -376,15 +376,15 @@ static int zd1211b_al7230b_set_channel(struct zd_rf *rf, u8 channel)
 	const u32 *rv = chan_rv[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
-	r = zd_iowrite16_locked(chip, 0x57, CR240);
+	r = zd_iowrite16_locked(chip, 0x57, ZD_CR240);
 	if (r)
 		return r;
-	r = zd_iowrite16_locked(chip, 0xe4, CR9);
+	r = zd_iowrite16_locked(chip, 0xe4, ZD_CR9);
 	if (r)
 		return r;
 
 	/* PLL_OFF */
-	r = zd_iowrite16_locked(chip, 0x2f, CR251);
+	r = zd_iowrite16_locked(chip, 0x2f, ZD_CR251);
 	if (r)
 		return r;
 	r = zd_rfwritev_cr_locked(chip, std_rv, ARRAY_SIZE(std_rv));
@@ -410,7 +410,7 @@ static int zd1211b_al7230b_set_channel(struct zd_rf *rf, u8 channel)
 	if (r)
 		return r;
 
-	r = zd_iowrite16_locked(chip, 0x7f, CR251);
+	r = zd_iowrite16_locked(chip, 0x7f, ZD_CR251);
 	if (r)
 		return r;
 
@@ -421,8 +421,8 @@ static int zd1211_al7230b_switch_radio_on(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x00 },
-		{ CR251, 0x3f },
+		{ ZD_CR11,  0x00 },
+		{ ZD_CR251, 0x3f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -432,8 +432,8 @@ static int zd1211b_al7230b_switch_radio_on(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x00 },
-		{ CR251, 0x7f },
+		{ ZD_CR11,  0x00 },
+		{ ZD_CR251, 0x7f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -443,8 +443,8 @@ static int al7230b_switch_radio_off(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x04 },
-		{ CR251, 0x2f },
+		{ ZD_CR11,  0x04 },
+		{ ZD_CR251, 0x2f },
 	};
 
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
@@ -456,7 +456,7 @@ static int zd1211b_al7230b_patch_6m(struct zd_rf *rf, u8 channel)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	struct zd_ioreq16 ioreqs[] = {
-		{ CR128, 0x14 }, { CR129, 0x12 },
+		{ ZD_CR128, 0x14 }, { ZD_CR129, 0x12 },
 	};
 
 	/* FIXME: Channel 11 is not the edge for all regulatory domains. */
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
index 0597d86..0325426 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
@@ -152,44 +152,44 @@ static int rf2959_init_hw(struct zd_rf *rf)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR2,   0x1E }, { CR9,   0x20 }, { CR10,  0x89 },
-		{ CR11,  0x00 }, { CR15,  0xD0 }, { CR17,  0x68 },
-		{ CR19,  0x4a }, { CR20,  0x0c }, { CR21,  0x0E },
-		{ CR23,  0x48 },
+		{ ZD_CR2,   0x1E }, { ZD_CR9,   0x20 }, { ZD_CR10,  0x89 },
+		{ ZD_CR11,  0x00 }, { ZD_CR15,  0xD0 }, { ZD_CR17,  0x68 },
+		{ ZD_CR19,  0x4a }, { ZD_CR20,  0x0c }, { ZD_CR21,  0x0E },
+		{ ZD_CR23,  0x48 },
 		/* normal size for cca threshold */
-		{ CR24,  0x14 },
-		/* { CR24,  0x20 }, */
-		{ CR26,  0x90 }, { CR27,  0x30 }, { CR29,  0x20 },
-		{ CR31,  0xb2 }, { CR32,  0x43 }, { CR33,  0x28 },
-		{ CR38,  0x30 }, { CR34,  0x0f }, { CR35,  0xF0 },
-		{ CR41,  0x2a }, { CR46,  0x7F }, { CR47,  0x1E },
-		{ CR51,  0xc5 }, { CR52,  0xc5 }, { CR53,  0xc5 },
-		{ CR79,  0x58 }, { CR80,  0x30 }, { CR81,  0x30 },
-		{ CR82,  0x00 }, { CR83,  0x24 }, { CR84,  0x04 },
-		{ CR85,  0x00 }, { CR86,  0x10 }, { CR87,  0x2A },
-		{ CR88,  0x10 }, { CR89,  0x24 }, { CR90,  0x18 },
-		/* { CR91,  0x18 }, */
+		{ ZD_CR24,  0x14 },
+		/* { ZD_CR24,  0x20 }, */
+		{ ZD_CR26,  0x90 }, { ZD_CR27,  0x30 }, { ZD_CR29,  0x20 },
+		{ ZD_CR31,  0xb2 }, { ZD_CR32,  0x43 }, { ZD_CR33,  0x28 },
+		{ ZD_CR38,  0x30 }, { ZD_CR34,  0x0f }, { ZD_CR35,  0xF0 },
+		{ ZD_CR41,  0x2a }, { ZD_CR46,  0x7F }, { ZD_CR47,  0x1E },
+		{ ZD_CR51,  0xc5 }, { ZD_CR52,  0xc5 }, { ZD_CR53,  0xc5 },
+		{ ZD_CR79,  0x58 }, { ZD_CR80,  0x30 }, { ZD_CR81,  0x30 },
+		{ ZD_CR82,  0x00 }, { ZD_CR83,  0x24 }, { ZD_CR84,  0x04 },
+		{ ZD_CR85,  0x00 }, { ZD_CR86,  0x10 }, { ZD_CR87,  0x2A },
+		{ ZD_CR88,  0x10 }, { ZD_CR89,  0x24 }, { ZD_CR90,  0x18 },
+		/* { ZD_CR91,  0x18 }, */
 		/* should solve continous CTS frame problems */
-		{ CR91,  0x00 },
-		{ CR92,  0x0a }, { CR93,  0x00 }, { CR94,  0x01 },
-		{ CR95,  0x00 }, { CR96,  0x40 }, { CR97,  0x37 },
-		{ CR98,  0x05 }, { CR99,  0x28 }, { CR100, 0x00 },
-		{ CR101, 0x13 }, { CR102, 0x27 }, { CR103, 0x27 },
-		{ CR104, 0x18 }, { CR105, 0x12 },
+		{ ZD_CR91,  0x00 },
+		{ ZD_CR92,  0x0a }, { ZD_CR93,  0x00 }, { ZD_CR94,  0x01 },
+		{ ZD_CR95,  0x00 }, { ZD_CR96,  0x40 }, { ZD_CR97,  0x37 },
+		{ ZD_CR98,  0x05 }, { ZD_CR99,  0x28 }, { ZD_CR100, 0x00 },
+		{ ZD_CR101, 0x13 }, { ZD_CR102, 0x27 }, { ZD_CR103, 0x27 },
+		{ ZD_CR104, 0x18 }, { ZD_CR105, 0x12 },
 		/* normal size */
-		{ CR106, 0x1a },
-		/* { CR106, 0x22 }, */
-		{ CR107, 0x24 }, { CR108, 0x0a }, { CR109, 0x13 },
-		{ CR110, 0x2F }, { CR111, 0x27 }, { CR112, 0x27 },
-		{ CR113, 0x27 }, { CR114, 0x27 }, { CR115, 0x40 },
-		{ CR116, 0x40 }, { CR117, 0xF0 }, { CR118, 0xF0 },
-		{ CR119, 0x16 },
+		{ ZD_CR106, 0x1a },
+		/* { ZD_CR106, 0x22 }, */
+		{ ZD_CR107, 0x24 }, { ZD_CR108, 0x0a }, { ZD_CR109, 0x13 },
+		{ ZD_CR110, 0x2F }, { ZD_CR111, 0x27 }, { ZD_CR112, 0x27 },
+		{ ZD_CR113, 0x27 }, { ZD_CR114, 0x27 }, { ZD_CR115, 0x40 },
+		{ ZD_CR116, 0x40 }, { ZD_CR117, 0xF0 }, { ZD_CR118, 0xF0 },
+		{ ZD_CR119, 0x16 },
 		/* no TX continuation */
-		{ CR122, 0x00 },
-		/* { CR122, 0xff }, */
-		{ CR127, 0x03 }, { CR131, 0x08 }, { CR138, 0x28 },
-		{ CR148, 0x44 }, { CR150, 0x10 }, { CR169, 0xBB },
-		{ CR170, 0xBB },
+		{ ZD_CR122, 0x00 },
+		/* { ZD_CR122, 0xff }, */
+		{ ZD_CR127, 0x03 }, { ZD_CR131, 0x08 }, { ZD_CR138, 0x28 },
+		{ ZD_CR148, 0x44 }, { ZD_CR150, 0x10 }, { ZD_CR169, 0xBB },
+		{ ZD_CR170, 0xBB },
 	};
 
 	static const u32 rv[] = {
@@ -210,7 +210,7 @@ static int rf2959_init_hw(struct zd_rf *rf)
 		 */
 		0x294128, /* internal power */
 		/* 0x28252c, */ /* External control TX power */
-		/* CR31_CCK, CR51_6-36M, CR52_48M, CR53_54M */
+		/* ZD_CR31_CCK, ZD_CR51_6-36M, ZD_CR52_48M, ZD_CR53_54M */
 		0x2c0000,
 		0x300000,
 		0x340000,  /* REG13(0xD) */
@@ -245,8 +245,8 @@ static int rf2959_set_channel(struct zd_rf *rf, u8 channel)
 static int rf2959_switch_radio_on(struct zd_rf *rf)
 {
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR10, 0x89 },
-		{ CR11, 0x00 },
+		{ ZD_CR10, 0x89 },
+		{ ZD_CR11, 0x00 },
 	};
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
@@ -256,8 +256,8 @@ static int rf2959_switch_radio_on(struct zd_rf *rf)
 static int rf2959_switch_radio_off(struct zd_rf *rf)
 {
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR10, 0x15 },
-		{ CR11, 0x81 },
+		{ ZD_CR10, 0x15 },
+		{ ZD_CR11, 0x81 },
 	};
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
index 9e74eb1..860b0af 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -314,42 +314,44 @@ static int uw2453_init_hw(struct zd_rf *rf)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR10,  0x89 }, { CR15,  0x20 },
-		{ CR17,  0x28 }, /* 6112 no change */
-		{ CR23,  0x38 }, { CR24,  0x20 }, { CR26,  0x93 },
-		{ CR27,  0x15 }, { CR28,  0x3e }, { CR29,  0x00 },
-		{ CR33,  0x28 }, { CR34,  0x30 },
-		{ CR35,  0x43 }, /* 6112 3e->43 */
-		{ CR41,  0x24 }, { CR44,  0x32 },
-		{ CR46,  0x92 }, /* 6112 96->92 */
-		{ CR47,  0x1e },
-		{ CR48,  0x04 }, /* 5602 Roger */
-		{ CR49,  0xfa }, { CR79,  0x58 }, { CR80,  0x30 },
-		{ CR81,  0x30 }, { CR87,  0x0a }, { CR89,  0x04 },
-		{ CR91,  0x00 }, { CR92,  0x0a }, { CR98,  0x8d },
-		{ CR99,  0x28 }, { CR100, 0x02 },
-		{ CR101, 0x09 }, /* 6112 13->1f 6220 1f->13 6407 13->9 */
-		{ CR102, 0x27 },
-		{ CR106, 0x1c }, /* 5d07 5112 1f->1c 6220 1c->1f 6221 1f->1c */
-		{ CR107, 0x1c }, /* 6220 1c->1a 5221 1a->1c */
-		{ CR109, 0x13 },
-		{ CR110, 0x1f }, /* 6112 13->1f 6221 1f->13 6407 13->0x09 */
-		{ CR111, 0x13 }, { CR112, 0x1f }, { CR113, 0x27 },
-		{ CR114, 0x23 }, /* 6221 27->23 */
-		{ CR115, 0x24 }, /* 6112 24->1c 6220 1c->24 */
-		{ CR116, 0x24 }, /* 6220 1c->24 */
-		{ CR117, 0xfa }, /* 6112 fa->f8 6220 f8->f4 6220 f4->fa */
-		{ CR118, 0xf0 }, /* 5d07 6112 f0->f2 6220 f2->f0 */
-		{ CR119, 0x1a }, /* 6112 1a->10 6220 10->14 6220 14->1a */
-		{ CR120, 0x4f },
-		{ CR121, 0x1f }, /* 6220 4f->1f */
-		{ CR122, 0xf0 }, { CR123, 0x57 }, { CR125, 0xad },
-		{ CR126, 0x6c }, { CR127, 0x03 },
-		{ CR128, 0x14 }, /* 6302 12->11 */
-		{ CR129, 0x12 }, /* 6301 10->0f */
-		{ CR130, 0x10 }, { CR137, 0x50 }, { CR138, 0xa8 },
-		{ CR144, 0xac }, { CR146, 0x20 }, { CR252, 0xff },
-		{ CR253, 0xff },
+		{ ZD_CR10,  0x89 }, { ZD_CR15,  0x20 },
+		{ ZD_CR17,  0x28 }, /* 6112 no change */
+		{ ZD_CR23,  0x38 }, { ZD_CR24,  0x20 }, { ZD_CR26,  0x93 },
+		{ ZD_CR27,  0x15 }, { ZD_CR28,  0x3e }, { ZD_CR29,  0x00 },
+		{ ZD_CR33,  0x28 }, { ZD_CR34,  0x30 },
+		{ ZD_CR35,  0x43 }, /* 6112 3e->43 */
+		{ ZD_CR41,  0x24 }, { ZD_CR44,  0x32 },
+		{ ZD_CR46,  0x92 }, /* 6112 96->92 */
+		{ ZD_CR47,  0x1e },
+		{ ZD_CR48,  0x04 }, /* 5602 Roger */
+		{ ZD_CR49,  0xfa }, { ZD_CR79,  0x58 }, { ZD_CR80,  0x30 },
+		{ ZD_CR81,  0x30 }, { ZD_CR87,  0x0a }, { ZD_CR89,  0x04 },
+		{ ZD_CR91,  0x00 }, { ZD_CR92,  0x0a }, { ZD_CR98,  0x8d },
+		{ ZD_CR99,  0x28 }, { ZD_CR100, 0x02 },
+		{ ZD_CR101, 0x09 }, /* 6112 13->1f 6220 1f->13 6407 13->9 */
+		{ ZD_CR102, 0x27 },
+		{ ZD_CR106, 0x1c }, /* 5d07 5112 1f->1c 6220 1c->1f
+				     * 6221 1f->1c
+				     */
+		{ ZD_CR107, 0x1c }, /* 6220 1c->1a 5221 1a->1c */
+		{ ZD_CR109, 0x13 },
+		{ ZD_CR110, 0x1f }, /* 6112 13->1f 6221 1f->13 6407 13->0x09 */
+		{ ZD_CR111, 0x13 }, { ZD_CR112, 0x1f }, { ZD_CR113, 0x27 },
+		{ ZD_CR114, 0x23 }, /* 6221 27->23 */
+		{ ZD_CR115, 0x24 }, /* 6112 24->1c 6220 1c->24 */
+		{ ZD_CR116, 0x24 }, /* 6220 1c->24 */
+		{ ZD_CR117, 0xfa }, /* 6112 fa->f8 6220 f8->f4 6220 f4->fa */
+		{ ZD_CR118, 0xf0 }, /* 5d07 6112 f0->f2 6220 f2->f0 */
+		{ ZD_CR119, 0x1a }, /* 6112 1a->10 6220 10->14 6220 14->1a */
+		{ ZD_CR120, 0x4f },
+		{ ZD_CR121, 0x1f }, /* 6220 4f->1f */
+		{ ZD_CR122, 0xf0 }, { ZD_CR123, 0x57 }, { ZD_CR125, 0xad },
+		{ ZD_CR126, 0x6c }, { ZD_CR127, 0x03 },
+		{ ZD_CR128, 0x14 }, /* 6302 12->11 */
+		{ ZD_CR129, 0x12 }, /* 6301 10->0f */
+		{ ZD_CR130, 0x10 }, { ZD_CR137, 0x50 }, { ZD_CR138, 0xa8 },
+		{ ZD_CR144, 0xac }, { ZD_CR146, 0x20 }, { ZD_CR252, 0xff },
+		{ ZD_CR253, 0xff },
 	};
 
 	static const u32 rv[] = {
@@ -433,7 +435,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
 	 * the one that produced a lock. */
 	UW2453_PRIV(rf)->config = found_config + 1;
 
-	return zd_iowrite16_locked(chip, 0x06, CR203);
+	return zd_iowrite16_locked(chip, 0x06, ZD_CR203);
 }
 
 static int uw2453_set_channel(struct zd_rf *rf, u8 channel)
@@ -445,8 +447,8 @@ static int uw2453_set_channel(struct zd_rf *rf, u8 channel)
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR80,  0x30 }, { CR81,  0x30 }, { CR79,  0x58 },
-		{ CR12,  0xf0 }, { CR77,  0x1b }, { CR78,  0x58 },
+		{ ZD_CR80,  0x30 }, { ZD_CR81,  0x30 }, { ZD_CR79,  0x58 },
+		{ ZD_CR12,  0xf0 }, { ZD_CR77,  0x1b }, { ZD_CR78,  0x58 },
 	};
 
 	r = uw2453_synth_set_channel(chip, channel, autocal);
@@ -474,7 +476,7 @@ static int uw2453_set_channel(struct zd_rf *rf, u8 channel)
 	if (r)
 		return r;
 
-	return zd_iowrite16_locked(chip, 0x06, CR203);
+	return zd_iowrite16_locked(chip, 0x06, ZD_CR203);
 }
 
 static int uw2453_switch_radio_on(struct zd_rf *rf)
@@ -482,7 +484,7 @@ static int uw2453_switch_radio_on(struct zd_rf *rf)
 	int r;
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x00 }, { CR251, 0x3f },
+		{ ZD_CR11,  0x00 }, { ZD_CR251, 0x3f },
 	};
 
 	/* enter RXTX mode */
@@ -501,7 +503,7 @@ static int uw2453_switch_radio_off(struct zd_rf *rf)
 	int r;
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
-		{ CR11,  0x04 }, { CR251, 0x2f },
+		{ ZD_CR11,  0x04 }, { ZD_CR251, 0x2f },
 	};
 
 	/* enter IDLE mode */
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 58236e6..c9c1362 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1877,10 +1877,10 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 
 	dev_dbg_f(zd_usb_dev(usb), "value %#09x bits %d\n", value, bits);
 
-	r = zd_usb_ioread16(usb, &bit_value_template, CR203);
+	r = zd_usb_ioread16(usb, &bit_value_template, ZD_CR203);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error %d: Couldn't read CR203\n", r);
+			"error %d: Couldn't read ZD_CR203\n", r);
 		return r;
 	}
 	bit_value_template &= ~(RF_IF_LE|RF_CLK|RF_DATA);
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index b3df2c8..3924258 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -109,7 +109,7 @@ struct usb_req_rfwrite {
 	__le16 bits;
 	/* RF2595: 24 */
 	__le16 bit_values[0];
-	/* (CR203 & ~(RF_IF_LE | RF_CLK | RF_DATA)) | (bit ? RF_DATA : 0) */
+	/* (ZD_CR203 & ~(RF_IF_LE | RF_CLK | RF_DATA)) | (bit ? RF_DATA : 0) */
 } __packed;
 
 /* USB interrupt */

