Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:29442 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755593Ab3JNCKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 22:10:37 -0400
Date: Mon, 14 Oct 2013 10:05:45 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH v4] rt2x00: rt2800lib: remove duplicate rf_vals for RF3053
Message-ID: <20131014020544.GA17649@ns.kevlo.org> (sfid-20131014_041043_829573_4E6A9F9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lready have rf_vals_3x with same values.  Hence rf_vals_3053 is removed
in this patch.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v1:
 - update comment of rf_vals_3x to indicate that it also supports RF3053
 - add Paul's Acked-by tag
---
Changes since v2:
 - the previous patch was malformed
 - add Stanislaw's Acked-by tag
---
Changes since v3:
 - fix whitespace error
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a114cab..c755309 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7248,7 +7248,7 @@ static const struct rf_channel rf_vals[] = {
 
 /*
  * RF value list for rt3xxx
- * Supports: 2.4 GHz (all) & 5.2 GHz (RF3052)
+ * Supports: 2.4 GHz (all) & 5.2 GHz (RF3052 & RF3053)
  */
 static const struct rf_channel rf_vals_3x[] = {
 	{1,  241, 2, 2 },
@@ -7444,72 +7444,6 @@ static const struct rf_channel rf_vals_5592_xtal40[] = {
 	{196, 83, 0, 12, 1},
 };
 
-static const struct rf_channel rf_vals_3053[] = {
-	/* Channel, N, R, K */
-	{1, 241, 2, 2},
-	{2, 241, 2, 7},
-	{3, 242, 2, 2},
-	{4, 242, 2, 7},
-	{5, 243, 2, 2},
-	{6, 243, 2, 7},
-	{7, 244, 2, 2},
-	{8, 244, 2, 7},
-	{9, 245, 2, 2},
-	{10, 245, 2, 7},
-	{11, 246, 2, 2},
-	{12, 246, 2, 7},
-	{13, 247, 2, 2},
-	{14, 248, 2, 4},
-
-	{36, 0x56, 0, 4},
-	{38, 0x56, 0, 6},
-	{40, 0x56, 0, 8},
-	{44, 0x57, 0, 0},
-	{46, 0x57, 0, 2},
-	{48, 0x57, 0, 4},
-	{52, 0x57, 0, 8},
-	{54, 0x57, 0, 10},
-	{56, 0x58, 0, 0},
-	{60, 0x58, 0, 4},
-	{62, 0x58, 0, 6},
-	{64, 0x58, 0, 8},
-
-	{100, 0x5B, 0, 8},
-	{102, 0x5B, 0, 10},
-	{104, 0x5C, 0, 0},
-	{108, 0x5C, 0, 4},
-	{110, 0x5C, 0, 6},
-	{112, 0x5C, 0, 8},
-
-	/* NOTE: Channel 114 has been removed intentionally.
-	 * The EEPROM contains no TX power values for that,
-	 * and it is disabled in the vendor driver as well.
-	 */
-
-	{116, 0x5D, 0, 0},
-	{118, 0x5D, 0, 2},
-	{120, 0x5D, 0, 4},
-	{124, 0x5D, 0, 8},
-	{126, 0x5D, 0, 10},
-	{128, 0x5E, 0, 0},
-	{132, 0x5E, 0, 4},
-	{134, 0x5E, 0, 6},
-	{136, 0x5E, 0, 8},
-	{140, 0x5F, 0, 0},
-
-	{149, 0x5F, 0, 9},
-	{151, 0x5F, 0, 11},
-	{153, 0x60, 0, 1},
-	{157, 0x60, 0, 5},
-	{159, 0x60, 0, 7},
-	{161, 0x60, 0, 9},
-	{165, 0x61, 0, 1},
-	{167, 0x61, 0, 3},
-	{169, 0x61, 0, 5},
-	{171, 0x61, 0, 7},
-	{173, 0x61, 0, 9},
-};
-
 static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
@@ -7599,14 +7533,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF5392)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
-	} else if (rt2x00_rf(rt2x00dev, RF3052)) {
+	} else if (rt2x00_rf(rt2x00dev, RF3052) ||
+		   rt2x00_rf(rt2x00dev, RF3053)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
 		spec->channels = rf_vals_3x;
-	} else if (rt2x00_rf(rt2x00dev, RF3053)) {
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
-		spec->num_channels = ARRAY_SIZE(rf_vals_3053);
-		spec->channels = rf_vals_3053;
 	} else if (rt2x00_rf(rt2x00dev, RF5592)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 
