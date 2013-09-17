Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42508 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IQPlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:47 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so2792769ead.7
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:46 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 10/11] wl18xx: print new RDL versions during boot
Date: Tue, 17 Sep 2013 18:41:29 +0300
Message-Id: <1379432490-22157-10-git-send-email-eliad@wizery.com> (sfid-20130917_174156_270673_9A60278B)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Extract and print info for the new RDL 5, 6, 7 and 8.
Replace const struct with function which translates
the RDL number to string.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2: split UNTRIMMED/UNKNOWN

 drivers/net/wireless/ti/wl18xx/main.c | 42 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wl18xx/reg.h  | 20 ++++++++---------
 2 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b47eb62..d0daca1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1228,16 +1228,48 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	}
 }
 
+static const char *wl18xx_rdl_name(enum wl18xx_rdl_num rdl_num)
+{
+	switch (rdl_num) {
+	case RDL_1_HP:
+		return "183xH";
+	case RDL_2_SP:
+		return "183x or 180x";
+	case RDL_3_HP:
+		return "187xH";
+	case RDL_4_SP:
+		return "187x";
+	case RDL_5_SP:
+		return "RDL11 - Not Supported";
+	case RDL_6_SP:
+		return "180xD";
+	case RDL_7_SP:
+		return "RDL13 - Not Supported (1893Q)";
+	case RDL_8_SP:
+		return "18xxQ";
+	case RDL_NONE:
+		return "UNTRIMMED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 {
 	u32 fuse;
-	s8 rom = 0, metal = 0, pg_ver = 0, rdl_ver = 0;
+	s8 rom = 0, metal = 0, pg_ver = 0, rdl_ver = 0, package_type = 0;
 	int ret;
 
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 	if (ret < 0)
 		goto out;
 
+	ret = wlcore_read32(wl, WL18XX_REG_FUSE_DATA_2_3, &fuse);
+	if (ret < 0)
+		goto out;
+
+	package_type = (fuse >> WL18XX_PACKAGE_TYPE_OFFSET) & 1;
+
 	ret = wlcore_read32(wl, WL18XX_REG_FUSE_DATA_1_3, &fuse);
 	if (ret < 0)
 		goto out;
@@ -1245,7 +1277,7 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	pg_ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
 	rom = (fuse & WL18XX_ROM_VER_MASK) >> WL18XX_ROM_VER_OFFSET;
 
-	if (rom <= 0xE)
+	if ((rom <= 0xE) && (package_type == WL18XX_PACKAGE_TYPE_WSP))
 		metal = (fuse & WL18XX_METAL_VER_MASK) >>
 			WL18XX_METAL_VER_OFFSET;
 	else
@@ -1257,11 +1289,9 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 		goto out;
 
 	rdl_ver = (fuse & WL18XX_RDL_VER_MASK) >> WL18XX_RDL_VER_OFFSET;
-	if (rdl_ver > RDL_MAX)
-		rdl_ver = RDL_NONE;
 
-	wl1271_info("wl18xx HW: RDL %d, %s, PG %x.%x (ROM %x)",
-		    rdl_ver, rdl_names[rdl_ver], pg_ver, metal, rom);
+	wl1271_info("wl18xx HW: %s, PG %d.%d (ROM 0x%x)",
+		    wl18xx_rdl_name(rdl_ver), pg_ver, metal, rom);
 
 	if (ver)
 		*ver = pg_ver;
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 88de3f2..a433a75 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -147,13 +147,16 @@
 #define WL18XX_REG_FUSE_DATA_1_3	0xA0260C
 #define WL18XX_PG_VER_MASK		0x70
 #define WL18XX_PG_VER_OFFSET		4
-#define WL18XX_ROM_VER_MASK		0x3
-#define WL18XX_ROM_VER_OFFSET		0
+#define WL18XX_ROM_VER_MASK		0x3e00
+#define WL18XX_ROM_VER_OFFSET		9
 #define WL18XX_METAL_VER_MASK		0xC
 #define WL18XX_METAL_VER_OFFSET		2
 #define WL18XX_NEW_METAL_VER_MASK	0x180
 #define WL18XX_NEW_METAL_VER_OFFSET	7
 
+#define WL18XX_PACKAGE_TYPE_OFFSET	13
+#define WL18XX_PACKAGE_TYPE_WSP		0
+
 #define WL18XX_REG_FUSE_DATA_2_3	0xA02614
 #define WL18XX_RDL_VER_MASK		0x1f00
 #define WL18XX_RDL_VER_OFFSET		8
@@ -214,24 +217,21 @@ enum {
 	NUM_BOARD_TYPES,
 };
 
-enum {
+enum wl18xx_rdl_num {
 	RDL_NONE	= 0,
 	RDL_1_HP	= 1,
 	RDL_2_SP	= 2,
 	RDL_3_HP	= 3,
 	RDL_4_SP	= 4,
+	RDL_5_SP	= 0x11,
+	RDL_6_SP	= 0x12,
+	RDL_7_SP	= 0x13,
+	RDL_8_SP	= 0x14,
 
 	_RDL_LAST,
 	RDL_MAX = _RDL_LAST - 1,
 };
 
-static const char * const rdl_names[] = {
-	[RDL_NONE]	= "",
-	[RDL_1_HP]	= "1853 SISO",
-	[RDL_2_SP]	= "1857 MIMO",
-	[RDL_3_HP]	= "1893 SISO",
-	[RDL_4_SP]	= "1897 MIMO",
-};
 
 /* FPGA_SPARE_1 register - used to change the PHY ATPG clock at boot time */
 #define WL18XX_PHY_FPGA_SPARE_1		0x8093CA40
-- 
1.8.3.rc1.35.g9b79519

