Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60206 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3CLNpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:44 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CDjiFc009753
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:44 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CDjiV7017501
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:44 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Victor Goldenshtein <victorg@ti.com>
Subject: [PATCH 09/13] wl18xx: print chip info during boot
Date: Tue, 12 Mar 2013 15:44:20 +0200
Message-ID: <1363095864-24422-10-git-send-email-coelho@ti.com> (sfid-20130312_144555_023471_DF84C6B2)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Print board type, PG with metal and ROM versions.
This might help debugging HW related issues.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   24 +++++++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h  |   29 +++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b670776..9fa692d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1145,6 +1145,7 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 {
 	u32 fuse;
+	s8 rom = 0, metal = 0, pg_ver = 0, rdl_ver = 0;
 	int ret;
 
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
@@ -1155,8 +1156,29 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	if (ret < 0)
 		goto out;
 
+	pg_ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
+	rom = (fuse & WL18XX_ROM_VER_MASK) >> WL18XX_ROM_VER_OFFSET;
+
+	if (rom <= 0xE)
+		metal = (fuse & WL18XX_METAL_VER_MASK) >>
+			WL18XX_METAL_VER_OFFSET;
+	else
+		metal = (fuse & WL18XX_NEW_METAL_VER_MASK) >>
+			WL18XX_NEW_METAL_VER_OFFSET;
+
+	ret = wlcore_read32(wl, WL18XX_REG_FUSE_DATA_2_3, &fuse);
+	if (ret < 0)
+		goto out;
+
+	rdl_ver = (fuse & WL18XX_RDL_VER_MASK) >> WL18XX_RDL_VER_OFFSET;
+	if (rdl_ver > RDL_MAX)
+		rdl_ver = RDL_NONE;
+
+	wl1271_info("wl18xx HW: RDL %d, %s, PG %x.%x (ROM %x)",
+		    rdl_ver, rdl_names[rdl_ver], pg_ver, metal, rom);
+
 	if (ver)
-		*ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
+		*ver = pg_ver;
 
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 937b71d..6306e04 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -131,6 +131,16 @@
 #define WL18XX_REG_FUSE_DATA_1_3	0xA0260C
 #define WL18XX_PG_VER_MASK		0x70
 #define WL18XX_PG_VER_OFFSET		4
+#define WL18XX_ROM_VER_MASK		0x3
+#define WL18XX_ROM_VER_OFFSET		0
+#define WL18XX_METAL_VER_MASK		0xC
+#define WL18XX_METAL_VER_OFFSET		2
+#define WL18XX_NEW_METAL_VER_MASK	0x180
+#define WL18XX_NEW_METAL_VER_OFFSET	7
+
+#define WL18XX_REG_FUSE_DATA_2_3	0xA02614
+#define WL18XX_RDL_VER_MASK		0x1f00
+#define WL18XX_RDL_VER_OFFSET		8
 
 #define WL18XX_REG_FUSE_BD_ADDR_1	0xA02602
 #define WL18XX_REG_FUSE_BD_ADDR_2	0xA02606
@@ -188,4 +198,23 @@ enum {
 	NUM_BOARD_TYPES,
 };
 
+enum {
+	RDL_NONE	= 0,
+	RDL_1_HP	= 1,
+	RDL_2_SP	= 2,
+	RDL_3_HP	= 3,
+	RDL_4_SP	= 4,
+
+	_RDL_LAST,
+	RDL_MAX = _RDL_LAST - 1,
+};
+
+static const char * const rdl_names[] = {
+	[RDL_NONE]	= "",
+	[RDL_1_HP]	= "1853 SISO",
+	[RDL_2_SP]	= "1857 MIMO",
+	[RDL_3_HP]	= "1893 SISO",
+	[RDL_4_SP]	= "1897 MIMO",
+};
+
 #endif /* __REG_H__ */
-- 
1.7.10.4

