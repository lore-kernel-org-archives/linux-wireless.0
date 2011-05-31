Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37924 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab1EaHvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 03:51:39 -0400
Received: by mail-ww0-f42.google.com with SMTP id 4so2280348wwk.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 00:51:38 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Add Support for Low Power DRPw (LPD) Mode
Date: Tue, 31 May 2011 10:51:27 +0300
Message-Id: <1306828287-31802-1-git-send-email-shahar_levi@ti.com> (sfid-20110531_095143_378764_F97E55FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Low Power DRPw (LPD) mode contains several optimizations
that designed to reduce the solution's consumption. The
purpose is to save current consumption in RX and Listen mode.

LPD setting apply only for wl127x AP mode (not wl128x)

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---

 drivers/net/wireless/wl12xx/boot.c |    5 +++++
 drivers/net/wireless/wl12xx/boot.h |    3 +++
 drivers/net/wireless/wl12xx/cmd.c  |    5 +++++
 drivers/net/wireless/wl12xx/conf.h |   10 ++++++++++
 drivers/net/wireless/wl12xx/main.c |    7 +++++++
 5 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b07f8b7..9d46965 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -748,6 +748,11 @@ int wl1271_load_firmware(struct wl1271 *wl)
 		clk |= (wl->ref_clock << 1) << 4;
 	}
 
+	if ((wl->conf.boot.lpd) &&
+	    (wl->bss_type == BSS_TYPE_AP_BSS) &&
+	    (wl->chip.id != CHIP_ID_1283_PG20))
+		clk |= DRPW_SET_SCRATCH;
+
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index e8f8255..abf525e 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -74,6 +74,9 @@ struct wl1271_static_data {
 #define FREF_CLK_POLARITY_BITS 0xfffff8ff
 #define CLK_REQ_OUTN_SEL       0x700
 
+#define DRPW_SET_INI_FILE    0xc0
+#define DRPW_SET_SCRATCH     BIT(25)
+
 /* PLL configuration algorithm for wl128x */
 #define SYS_CLK_CFG_REG              0x2200
 /* Bit[0]   -  0-TCXO,  1-FREF */
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b3a4f58..46036da 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -36,6 +36,7 @@
 #include "cmd.h"
 #include "event.h"
 #include "tx.h"
+#include "boot.h"
 
 #define WL1271_CMD_FAST_POLL_COUNT       50
 
@@ -134,6 +135,10 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	/* Override the REF CLK from the NVS with the one from platform data */
 	gen_parms->general_params.ref_clock = wl->ref_clock;
 
+	if ((wl->conf.boot.lpd) && (wl->bss_type == BSS_TYPE_AP_BSS))
+		gen_parms->general_params.general_settings |=
+			DRPW_SET_INI_FILE;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 510c2f7..0922689 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1274,6 +1274,15 @@ struct conf_rx_streaming_settings {
 	u8 always;
 };
 
+struct conf_boot_setting {
+	/*
+	 * The Low Power DRPw (LPD) mode contains several optimizations that
+	 * designed to reduce the solution's consumption. The purpose is to save
+	 * current consumption in RX and Listen mode.
+	 */
+	bool lpd;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1290,6 +1299,7 @@ struct conf_drv_settings {
 	struct conf_memory_settings mem_wl128x;
 	struct conf_fm_coex fm_coex;
 	struct conf_rx_streaming_settings rx_streaming;
+	struct conf_boot_setting boot;
 	u8 hci_io_ds;
 };
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..b129967 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -367,6 +367,13 @@ static struct conf_drv_settings default_conf = {
 		.interval                      = 20,
 		.always                        = 0,
 	},
+	.boot = {
+		/*
+		 * Low Power DRP setting apply only for wl127x AP mode
+		 *(not wl128x)
+		 */
+		.lpd                          = true,
+	},
 	.hci_io_ds = HCI_IO_DS_6MA,
 };
 
-- 
1.7.1

