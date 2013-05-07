Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52726 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758470Ab3EGIbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 04:31:33 -0400
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r478VWFZ019906
	for <linux-wireless@vger.kernel.org>; Tue, 7 May 2013 03:31:32 -0500
Received: from DLEE70.ent.ti.com (dlee70.ent.ti.com [157.170.170.113])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id r478VW2o022918
	for <linux-wireless@vger.kernel.org>; Tue, 7 May 2013 03:31:32 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH v2] wl18xx: FDSP Code RAM Corruption fix
Date: Tue, 7 May 2013 11:30:09 +0300
Message-ID: <1367915409-22082-1-git-send-email-coelho@ti.com> (sfid-20130507_103138_611725_8BA78288)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

In PG2.0 there is an issue where PHY's FDSP Code RAM sometimes gets
corrupted when exiting from ELP mode. This issue is related to FDSP
Code RAM clock implementation.

PG2.1 introduces a HW fix for this issue that requires the driver to
change the FDSP Code Ram clock settings (mux it to ATGP clock instead
of its own clock).

This workaround uses PHY_FPGA_SPARE_1 register and is relevant to WL8
PG2.1 devices.

The fix is also backward compatible with older PG2.0 devices where the
register PHY_FPGA_SPARE_1 is not used and not connected.

The fix is done in the wl18xx_pre_upload function (must be performed
before uploading the FW code) and includes the following steps:

1. Disable FDSP clock
2. Set ATPG clock toward FDSP Code RAM rather than its own clock.
3. Re-enable FDSP clock

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

This replaces a patch that was part of a series that Arik sent a while
ago.  Just did some clean-ups and tested with PG2.1.


 drivers/net/wireless/ti/wl18xx/main.c |   36 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/reg.h  |   15 ++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9fa692d..ae85ae4 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -594,8 +594,8 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
 	},
 	[PART_PHY_INIT] = {
-		.mem  = { .start = 0x80926000,
-			  .size = sizeof(struct wl18xx_mac_and_phy_params) },
+		.mem  = { .start = WL18XX_PHY_INIT_MEM_ADDR,
+			  .size  = WL18XX_PHY_INIT_MEM_SIZE },
 		.reg  = { .start = 0x00000000, .size = 0x00000000 },
 		.mem2 = { .start = 0x00000000, .size = 0x00000000 },
 		.mem3 = { .start = 0x00000000, .size = 0x00000000 },
@@ -799,6 +799,9 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	u32 tmp;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(struct wl18xx_mac_and_phy_params) >
+		WL18XX_PHY_INIT_MEM_SIZE);
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 	if (ret < 0)
 		goto out;
@@ -815,6 +818,35 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	ret = wlcore_read32(wl, WL18XX_SCR_PAD2, &tmp);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Workaround for FDSP code RAM corruption (needed for PG2.1
+	 * and newer; for older chips it's a NOP).  Change FDSP clock
+	 * settings so that it's muxed to the ATGP clock instead of
+	 * its own clock.
+	 */
+
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	if (ret < 0)
+		goto out;
+
+	/* disable FDSP clock */
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CLK_120_DISABLE);
+	if (ret < 0)
+		goto out;
+
+	/* set ATPG clock toward FDSP Code RAM rather than its own clock */
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CODERAM_FUNC_CLK_SEL);
+	if (ret < 0)
+		goto out;
+
+	/* re-enable FDSP clock */
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CLK_120_ENABLE);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 6306e04..05dd8ba 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -38,6 +38,9 @@
 #define WL18XX_REG_BOOT_PART_SIZE  0x00014578
 
 #define WL18XX_PHY_INIT_MEM_ADDR   0x80926000
+#define WL18XX_PHY_END_MEM_ADDR	   0x8093CA44
+#define WL18XX_PHY_INIT_MEM_SIZE \
+	(WL18XX_PHY_END_MEM_ADDR - WL18XX_PHY_INIT_MEM_ADDR)
 
 #define WL18XX_SDIO_WSPI_BASE		(WL18XX_REGISTERS_BASE)
 #define WL18XX_REG_CONFIG_BASE		(WL18XX_REGISTERS_BASE + 0x02000)
@@ -217,4 +220,16 @@ static const char * const rdl_names[] = {
 	[RDL_4_SP]	= "1897 MIMO",
 };
 
+/* FPGA_SPARE_1 register - used to change the PHY ATPG clock at boot time */
+#define WL18XX_PHY_FPGA_SPARE_1		0x8093CA40
+
+/* command to disable FDSP clock */
+#define MEM_FDSP_CLK_120_DISABLE        0x80000000
+
+/* command to set ATPG clock toward FDSP Code RAM rather than its own clock */
+#define MEM_FDSP_CODERAM_FUNC_CLK_SEL	0xC0000000
+
+/* command to re-enable FDSP clock */
+#define MEM_FDSP_CLK_120_ENABLE		0x40000000
+
 #endif /* __REG_H__ */
-- 
1.7.10.4

