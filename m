Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2K0GpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:25 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:24 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/20] wl18xx: FDSP Code RAM Corruption fix
Date: Tue, 27 Nov 2012 08:44:51 +0200
Message-Id: <1353998701-18171-11-git-send-email-arik@wizery.com> (sfid-20121127_074532_174994_6021C98A)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
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
---
 drivers/net/wireless/ti/wl18xx/main.c |   34 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/reg.h  |   20 +++++++++++++++++++
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 4f3c142..8fd13f3 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -559,6 +559,9 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 	},
 };
 
+#define WL18XX_PHY_INIT_MEM_SIZE \
+	(WL18XX_PHY_END_MEM_ADDR - WL18XX_PHY_INIT_MEM_ADDR + 4)
+
 static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 	[PART_TOP_PRCM_ELP_SOC] = {
 		.mem  = { .start = 0x00A02000, .size  = 0x00010000 },
@@ -585,8 +588,8 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
 	},
 	[PART_PHY_INIT] = {
-		.mem  = { .start = 0x80926000,
-			  .size = sizeof(struct wl18xx_mac_and_phy_params) },
+		.mem  = { .start = WL18XX_PHY_INIT_MEM_ADDR,
+			  .size = WL18XX_PHY_INIT_MEM_SIZE },
 		.reg  = { .start = 0x00000000, .size = 0x00000000 },
 		.mem2 = { .start = 0x00000000, .size = 0x00000000 },
 		.mem3 = { .start = 0x00000000, .size = 0x00000000 },
@@ -787,6 +790,9 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	u32 tmp;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(struct wl18xx_mac_and_phy_params) >
+		WL18XX_PHY_INIT_MEM_SIZE);
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 	if (ret < 0)
 		goto out;
@@ -803,6 +809,30 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	ret = wlcore_read32(wl, WL18XX_SCR_PAD2, &tmp);
+	if (ret < 0)
+		goto out;
+
+	/* Set ATPG clock toward FDSP Code RAM rather than its own clock */
+	/* Disable FDSP clock */
+
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CLK_120_DISABLE);
+	if (ret < 0)
+		goto out;
+
+	/* Set ATPG clock toward FDSP Code RAM rather than its own clock */
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CODERAM_FUNC_CLK_SEL);
+	if (ret < 0)
+		goto out;
+
+	/* Re-enable FDSP clock */
+	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
+			     MEM_FDSP_CLK_120_ENABLE);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 937b71d..ed35519 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -188,4 +188,24 @@ enum {
 	NUM_BOARD_TYPES,
 };
 
+/*
+ * The following definitions are used to change the PHY ATPG clock towards
+ * FDSP code RAM. This is done during FW boot before we download the FW.
+ *
+ * This change is required by PG2.1 and has not impact on previous PGs.
+ */
+
+/* FPGA_SPARE_1 register - bits are set as described below */
+#define WL18XX_PHY_FPGA_SPARE_1		0x8093CA40
+#define WL18XX_PHY_END_MEM_ADDR		WL18XX_PHY_FPGA_SPARE_1
+
+/* Bit to disable FDSP clock */
+#define MEM_FDSP_CLK_120_DISABLE        0x80000000
+
+/* Bit to set ATPG clock toward FDSP Code RAM rather than its own clock */
+#define MEM_FDSP_CODERAM_FUNC_CLK_SEL	0xC0000000
+
+/* Bit to re-enable FDSP clock */
+#define MEM_FDSP_CLK_120_ENABLE		0x40000000
+
 #endif /* __REG_H__ */
-- 
1.7.9.5

