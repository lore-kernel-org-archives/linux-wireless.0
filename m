Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40383 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab0JEOJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 10:09:07 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o95E97o9025317
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 09:09:07 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id o95E95p5010483
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 09:09:06 -0500 (CDT)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl1271: ref_clock cosmetic changes
Date: Tue,  5 Oct 2010 16:09:05 +0200
Message-Id: <1286287745-24966-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cosmetic cleanup for ref_clock code while configured by board.

Signed-off-by: Gery Kahn <geryk@ti.com>
---
v2: added enum for wl12xx boards reference clock

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
index 4f902e1..bebb8ef 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -24,6 +24,14 @@
 #ifndef _LINUX_WL12XX_H
 #define _LINUX_WL12XX_H
 
+/* The board reference clock values */
+enum {
+	WL12XX_REFCLOCK_19 = 0,	/* 19.2 MHz */
+	WL12XX_REFCLOCK_26 = 1,	/* 26 MHz */
+	WL12XX_REFCLOCK_38 = 2,	/* 38.4 MHz */
+	WL12XX_REFCLOCK_54 = 3,	/* 54 MHz */
+};
+
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
-- 
1.7.0.4

