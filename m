Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43377 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab0JEM0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 08:26:22 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o95CQLMw022929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 07:26:22 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id o95CQKX0027215
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 07:26:21 -0500 (CDT)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ref_clock cosmetic changes
Date: Tue,  5 Oct 2010 14:26:19 +0200
Message-Id: <1286281579-23838-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gery Kahn <geryk@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   10 ++++------
 include/linux/wl12xx.h                    |    8 ++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index b910212..5b19072 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -471,20 +471,19 @@ int wl1271_boot(struct wl1271 *wl)
 {
 	int ret = 0;
 	u32 tmp, clk, pause;
-	int ref_clock = wl->ref_clock;
 
 	wl1271_boot_hw_version(wl);
 
-	if (ref_clock == 0 || ref_clock == 2 || ref_clock == 4)
+	if (wl->ref_clock == 0 || wl->ref_clock == 2 || wl->ref_clock == 4)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
-	else if (ref_clock == 1 || ref_clock == 3)
+	else if (wl->ref_clock == 1 || wl->ref_clock == 3)
 		/* ref clk: 26/52 */
 		clk = 0x5;
 	else
 		return -EINVAL;
 
-	if (ref_clock != 0) {
+	if (wl->ref_clock != 0) {
 		u16 val;
 		/* Set clock type (open drain) */
 		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
@@ -529,8 +528,7 @@ int wl1271_boot(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
-	/* 2 */
-	clk |= (ref_clock << 1) << 4;
+	clk |= (wl->ref_clock << 1) << 4;
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 4f902e1..3092980 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -24,6 +24,14 @@
 #ifndef _LINUX_WL12XX_H
 #define _LINUX_WL12XX_H
 
+/*
+ * The board reference clock values:
+ * 0 = 19.2 MHz
+ * 1 = 26 MHz
+ * 2 = 38.4 MHz
+ * 3 = 54 MHz
+ */
+
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
-- 
1.7.0.4

