Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25299 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388425AbeGXIuG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:06 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 14/19] wil6210: support Talyn specific board file
Date: Tue, 24 Jul 2018 10:44:35 +0300
Message-Id: <1532418280-5849-15-git-send-email-merez@codeaurora.org> (sfid-20180724_094517_508417_DE5252AB)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW file name for Talyn device can be different from the default name.
In such a case use a corresponding board file name.
If such a board file is not present FW download procedure will fail.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/fw.c       |  3 +++
 drivers/net/wireless/ath/wil6210/main.c     | 35 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++++
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
index 540fc20..3e2bbbc 100644
--- a/drivers/net/wireless/ath/wil6210/fw.c
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2014-2015,2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -22,6 +23,8 @@
 MODULE_FIRMWARE(WIL_FW_NAME_DEFAULT);
 MODULE_FIRMWARE(WIL_FW_NAME_SPARROW_PLUS);
 MODULE_FIRMWARE(WIL_BOARD_FILE_NAME);
+MODULE_FIRMWARE(WIL_FW_NAME_TALYN);
+MODULE_FIRMWARE(WIL_BRD_NAME_TALYN);
 
 static
 void wil_memset_toio_32(volatile void __iomem *dst, u32 val,
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7dcbd46..64de679 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -28,6 +28,7 @@
 #define WAIT_FOR_HALP_VOTE_MS 100
 #define WAIT_FOR_SCAN_ABORT_MS 1000
 #define WIL_DEFAULT_NUM_RX_STATUS_RINGS 1
+#define WIL_BOARD_FILE_MAX_NAMELEN 128
 
 bool debug_fw; /* = false; */
 module_param(debug_fw, bool, 0444);
@@ -1161,6 +1162,28 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 	le32_to_cpus(&r->head);
 }
 
+/* construct actual board file name to use */
+void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len)
+{
+	const char *board_file;
+	const char *wil_talyn_fw_name = ftm_mode ? WIL_FW_NAME_FTM_TALYN :
+			      WIL_FW_NAME_TALYN;
+
+	if (wil->board_file) {
+		board_file = wil->board_file;
+	} else {
+		/* If specific FW file is used for Talyn,
+		 * use specific board file
+		 */
+		if (strcmp(wil->wil_fw_name, wil_talyn_fw_name) == 0)
+			board_file = WIL_BRD_NAME_TALYN;
+		else
+			board_file = WIL_BOARD_FILE_NAME;
+	}
+
+	strlcpy(buf, board_file, len);
+}
+
 static int wil_get_bl_info(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil->main_ndev;
@@ -1532,8 +1555,12 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	wil_set_oob_mode(wil, oob_mode);
 	if (load_fw) {
+		char board_file[WIL_BOARD_FILE_MAX_NAMELEN];
+
+		board_file[0] = '\0';
+		wil_get_board_file(wil, board_file, sizeof(board_file));
 		wil_info(wil, "Use firmware <%s> + board <%s>\n",
-			 wil->wil_fw_name, WIL_BOARD_FILE_NAME);
+			 wil->wil_fw_name, board_file);
 
 		if (!no_flash)
 			wil_bl_prepare_halt(wil);
@@ -1545,11 +1572,9 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		if (rc)
 			goto out;
 		if (wil->brd_file_addr)
-			rc = wil_request_board(wil, WIL_BOARD_FILE_NAME);
+			rc = wil_request_board(wil, board_file);
 		else
-			rc = wil_request_firmware(wil,
-						  WIL_BOARD_FILE_NAME,
-						  true);
+			rc = wil_request_firmware(wil, board_file, true);
 		if (rc)
 			goto out;
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 095c16f..e44b4ad 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -28,7 +28,7 @@
 module_param(n_msi, int, 0444);
 MODULE_PARM_DESC(n_msi, " Use MSI interrupt: 0 - use INTx, 1 - (default) - single, or 3");
 
-static bool ftm_mode;
+bool ftm_mode;
 module_param(ftm_mode, bool, 0444);
 MODULE_PARM_DESC(ftm_mode, " Set factory test mode, default - false");
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b5d8ad2..542075d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -37,6 +37,7 @@
 extern bool rx_large_buf;
 extern bool debug_fw;
 extern bool disable_ap_sme;
+extern bool ftm_mode;
 
 struct wil6210_priv;
 struct wil6210_vif;
@@ -52,6 +53,7 @@
 
 #define WIL_FW_NAME_TALYN "wil6436.fw"
 #define WIL_FW_NAME_FTM_TALYN "wil6436_ftm.fw"
+#define WIL_BRD_NAME_TALYN "wil6436.brd"
 
 #define WIL_BOARD_FILE_NAME "wil6210.brd" /* board & radio parameters */
 
@@ -1101,6 +1103,8 @@ static inline void wil_c(struct wil6210_priv *wil, u32 reg, u32 val)
 	wil_w(wil, reg, wil_r(wil, reg) & ~val);
 }
 
+void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len);
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
-- 
1.9.1
