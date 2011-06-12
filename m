Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46825 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab1FLHeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 03:34:50 -0400
Received: by wwf26 with SMTP id 26so3552015wwf.8
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 00:34:48 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>
Subject: [PATCH v2] wl12xx: Add Support for Low Power DRPw (LPD) Mode
Date: Sun, 12 Jun 2011 10:34:43 +0300
Message-Id: <1307864083-32551-1-git-send-email-shahar_levi@ti.com> (sfid-20110612_093457_690389_FB654684)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Low Power DRPw (LPD) mode contains several optimizations
that designed to reduce power consumption. The purpose
is to save current consumption in RX and Listen mode.

LPD setting apply only for wl127x AP mode (not wl128x)

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Changes from v1:
- Remove from configuration parameters and set it as a quirk flag
- DRPW_SET_INI_FILE & DRPW_SET_SCRATCH to
  GENERAL_SETTINGS_DRPW_LPD&SCRATCH_ENABLE_LPD
- Move defines to ini.h

 drivers/net/wireless/wl12xx/boot.c   |    3 +++
 drivers/net/wireless/wl12xx/cmd.c    |    5 +++++
 drivers/net/wireless/wl12xx/ini.h    |    3 +++
 drivers/net/wireless/wl12xx/main.c   |    9 +++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++++++
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b07f8b7..fd35c21 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -748,6 +748,9 @@ int wl1271_load_firmware(struct wl1271 *wl)label:mcs.pst-utiles-cisco
 		clk |= (wl->ref_clock << 1) << 4;
 	}
 
+	if (wl->quirks & WL12XX_QUIRK_LPD_MODE)
+		clk |= SCRATCH_ENABLE_LPD;
+
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b3a4f58..cdcb324 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -134,6 +134,11 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	/* Override the REF CLK from the NVS with the one from platform data */
 	gen_parms->general_params.ref_clock = wl->ref_clock;
 
+	/* LPD mode enable (bits 6-7) in WL1271 AP mode only */
+	if (wl->quirks & WL12XX_QUIRK_LPD_MODE)
+		gen_parms->general_params.general_settings |=
+			GENERAL_SETTINGS_DRPW_LPD;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
diff --git a/drivers/net/wireless/wl12xx/ini.h b/drivers/net/wireless/wl12xx/ini.h
index 1420c84..4cf9ecc 100644
--- a/drivers/net/wireless/wl12xx/ini.h
+++ b/drivers/net/wireless/wl12xx/ini.h
@@ -24,6 +24,9 @@
 #ifndef __INI_H__
 #define __INI_H__
 
+#define GENERAL_SETTINGS_DRPW_LPD 0xc0
+#define SCRATCH_ENABLE_LPD        BIT(25)
+
 #define WL1271_INI_MAX_SMART_REFLEX_PARAM 16
 
 struct wl1271_ini_general_params {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..4897191 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1190,9 +1190,13 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
-		/* end-of-transaction flag should be set in wl127x AP mode */
+		/*
+		 * 'end-of-transaction flag' and 'LPD mode flag'
+		 * should be set in wl127x AP mode only
+		 */
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
-			wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
+			wl->quirks |= (WL12XX_QUIRK_END_OF_TRANSACTION |
+				       WL12XX_QUIRK_LPD_MODE);
 
 		ret = wl1271_setup(wl);
 		if (ret < 0)
@@ -1205,6 +1209,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
+
 		if (wl1271_set_block_size(wl))
 			wl->quirks |= WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT;
 		break;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..bb59cf8 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -644,4 +644,10 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl);
 /* WL128X requires aggregated packets to be aligned to the SDIO block size */
 #define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
 
+/*
+ * WL127X AP mode requires Low Power DRPw (LPD) enable to reduce power
+ * consumption
+ */
+#define WL12XX_QUIRK_LPD_MODE                   BIT(3)
+
 #endif
-- 
1.7.1

