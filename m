Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab1JEJzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:42 -0400
Received: by bkbzt4 with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:41 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/29] wl12xx: disable AP-mode-specific quirks
Date: Wed,  5 Oct 2011 11:55:38 +0200
Message-Id: <1317808566-18857-2-git-send-email-eliad@wizery.com> (sfid-20111005_115545_577285_8524AE32)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current wl12xx fw supports both STA and AP
mode, and we no longer use AP-mode-specific quirks.

WL12XX_QUIRK_END_OF_TRANSACTION is still used for
certain HWs, while WL12XX_QUIRK_LPD_MODE is not
used anymore.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c   |    3 ---
 drivers/net/wireless/wl12xx/cmd.c    |    5 -----
 drivers/net/wireless/wl12xx/main.c   |    8 --------
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ------
 4 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 6d5664b..e5b7009 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -769,9 +769,6 @@ int wl1271_load_firmware(struct wl1271 *wl)
 		clk |= (wl->ref_clock << 1) << 4;
 	}
 
-	if (wl->quirks & WL12XX_QUIRK_LPD_MODE)
-		clk |= SCRATCH_ENABLE_LPD;
-
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 287fe95..53eb858 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -134,11 +134,6 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	/* Override the REF CLK from the NVS with the one from platform data */
 	gen_parms->general_params.ref_clock = wl->ref_clock;
 
-	/* LPD mode enable (bits 6-7) in WL1271 AP mode only */
-	if (wl->quirks & WL12XX_QUIRK_LPD_MODE)
-		gen_parms->general_params.general_settings |=
-			GENERAL_SETTINGS_DRPW_LPD;
-
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 60e2869..0aac62f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1333,14 +1333,6 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
-		/*
-		 * 'end-of-transaction flag' and 'LPD mode flag'
-		 * should be set in wl127x AP mode only
-		 */
-		if (wl->bss_type == BSS_TYPE_AP_BSS)
-			wl->quirks |= (WL12XX_QUIRK_END_OF_TRANSACTION |
-				       WL12XX_QUIRK_LPD_MODE);
-
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 997f532..781ab3a 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -671,12 +671,6 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 /* WL128X requires aggregated packets to be aligned to the SDIO block size */
 #define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
 
-/*
- * WL127X AP mode requires Low Power DRPw (LPD) enable to reduce power
- * consumption
- */
-#define WL12XX_QUIRK_LPD_MODE                   BIT(3)
-
 /* Older firmwares did not implement the FW logger over bus feature */
 #define WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
 
-- 
1.7.6.401.g6a319

