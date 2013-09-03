Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48503 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3ICOef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:35 -0400
Received: by mail-wg0-f52.google.com with SMTP id m14so3335460wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/12] wl18xx: print new RDL versions during boot
Date: Tue,  3 Sep 2013 17:34:07 +0300
Message-Id: <1378218848-7853-11-git-send-email-eliad@wizery.com> (sfid-20130903_163440_170043_242570FC)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
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
 drivers/net/wireless/ti/wl18xx/main.c | 40 +++++++++++++++++++++++++++++------
 drivers/net/wireless/ti/wl18xx/reg.h  | 20 +++++++++---------
 2 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b47eb62..aef0c91 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1228,16 +1228,46 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	}
 }
 
+static const char *wl18xx_rdl_name(enum wl18xx_rdl_num rdl_num)
+{
+	switch (rdl_num) {
+	case RDL_1_HP:
+	    return "183xH";
+	case RDL_2_SP:
+	    return "183x or 180x";
+	case RDL_3_HP:
+	    return "187xH";
+	case RDL_4_SP:
+	    return "187x";
+	case RDL_5_SP:
+	    return "RDL11 - Not Supported";
+	case RDL_6_SP:
+	    return "180xD";
+	case RDL_7_SP:
+	    return "RDL13 - Not Supported (1893Q)";
+	case RDL_8_SP:
+	    return "18xxQ";
+	default:
+	    return "UNTRIMMED";
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
@@ -1245,7 +1275,7 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	pg_ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
 	rom = (fuse & WL18XX_ROM_VER_MASK) >> WL18XX_ROM_VER_OFFSET;
 
-	if (rom <= 0xE)
+	if ((rom <= 0xE) && (package_type == WL18XX_PACKAGE_TYPE_WSP))
 		metal = (fuse & WL18XX_METAL_VER_MASK) >>
 			WL18XX_METAL_VER_OFFSET;
 	else
@@ -1257,11 +1287,9 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
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

