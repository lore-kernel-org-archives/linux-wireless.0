Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46680 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2EJJP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:56 -0400
Received: by wibhm4 with SMTP id hm4so231590wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:55 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 39/78] wl18xx: implement hw op to read PG version
Date: Thu, 10 May 2012 12:13:44 +0300
Message-Id: <1336641263-5761-40-git-send-email-arik@wizery.com> (sfid-20120510_112138_528846_35EFE6FB)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read the HW PG version of the 18xx chip from FUSE.

Based on an earlier patch by Luciano Coelho <coelho@ti.com>.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   17 +++++++++++++++--
 drivers/net/wireless/ti/wl18xx/reg.h  |    3 +++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ce13249..9aae0af 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -659,8 +659,6 @@ static void wl18xx_boot_soft_reset(struct wl1271 *wl)
 
 static int wl18xx_pre_boot(struct wl1271 *wl)
 {
-	/* TODO: add hw_pg_ver reading */
-
 	wl18xx_set_clk(wl);
 
 	/* Continue the ELP wake up sequence */
@@ -946,6 +944,20 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	}
 }
 
+static s8 wl18xx_get_pg_ver(struct wl1271 *wl)
+{
+	u32 fuse;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+
+	fuse = wl1271_read32(wl, WL18XX_REG_FUSE_DATA_1_3);
+	fuse = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+
+	return (s8)fuse;
+}
+
 static void wl18xx_conf_init(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
@@ -971,6 +983,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.tx_delayed_compl = NULL,
 	.hw_init	= wl18xx_hw_init,
 	.set_tx_desc_csum = wl18xx_set_tx_desc_csum,
+	.get_pg_ver	= wl18xx_get_pg_ver,
 	.set_rx_csum = wl18xx_set_rx_csum,
 	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 1ea3393..43c480f 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -128,6 +128,9 @@
 #define PLLSH_WCS_PLL_SWALLOW_EN_VAL1	0x1
 #define PLLSH_WCS_PLL_SWALLOW_EN_VAL2	0x12
 
+#define WL18XX_REG_FUSE_DATA_1_3	0xA0260C
+#define WL18XX_PG_VER_MASK		0x70
+#define WL18XX_PG_VER_OFFSET		4
 
 #define WL18XX_CMD_MBOX_ADDRESS		0xB007B4
 
-- 
1.7.9.5

