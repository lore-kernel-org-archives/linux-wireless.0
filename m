Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:55559 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3IIJY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:24:59 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so4080089wes.27
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:57 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/13] wlcore: fwlog dynamic mem_block control
Date: Mon,  9 Sep 2013 12:24:36 +0300
Message-Id: <1378718684-14430-5-git-send-email-eliad@wizery.com> (sfid-20130909_112504_056997_6D345A80)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

number of fwlog mem_blocks can be configured using module param.
this is a fw debug feature: in case a large fw log data is busrted during
a short period of time, the memory get filled and data is lost.
this allows us to dynamicly set the fw log mem_block usage, although
configuring more mem_block for logger comes at the expense of TP.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/conf.h |  5 ++++-
 drivers/net/wireless/ti/wlcore/main.c | 16 ++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 2b96ff8..40995c4 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1274,6 +1274,9 @@ struct conf_rx_streaming_settings {
 	u8 always;
 } __packed;
 
+#define CONF_FWLOG_MIN_MEM_BLOCKS	2
+#define CONF_FWLOG_MAX_MEM_BLOCKS	16
+
 struct conf_fwlog {
 	/* Continuous or on-demand */
 	u8 mode;
@@ -1281,7 +1284,7 @@ struct conf_fwlog {
 	/*
 	 * Number of memory blocks dedicated for the FW logger
 	 *
-	 * Range: 1-3, or 0 to disable the FW logger
+	 * Range: 2-16, or 0 to disable the FW logger
 	 */
 	u8 mem_blocks;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index dbf3315..ebb1076 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -44,6 +44,7 @@
 #define WL1271_BOOT_RETRIES 3
 
 static char *fwlog_param;
+static int fwlog_mem_blocks = -1;
 static int bug_on_recovery = -1;
 static int no_recovery     = -1;
 
@@ -291,6 +292,18 @@ static void wlcore_adjust_conf(struct wl1271 *wl)
 {
 	/* Adjust settings according to optional module parameters */
 
+	/* Firmware Logger params */
+	if (fwlog_mem_blocks != -1) {
+		if (fwlog_mem_blocks >= CONF_FWLOG_MIN_MEM_BLOCKS &&
+		    fwlog_mem_blocks <= CONF_FWLOG_MAX_MEM_BLOCKS) {
+			wl->conf.fwlog.mem_blocks = fwlog_mem_blocks;
+		} else {
+			wl1271_error(
+				"Illegal fwlog_mem_blocks=%d using default %d",
+				fwlog_mem_blocks, wl->conf.fwlog.mem_blocks);
+		}
+	}
+
 	if (fwlog_param) {
 		if (!strcmp(fwlog_param, "continuous")) {
 			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
@@ -6161,6 +6174,9 @@ module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(fwlog,
 		 "FW logger options: continuous, ondemand, dbgpins or disable");
 
+module_param(fwlog_mem_blocks, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(fwlog_mem_blocks, "fwlog mem_blocks");
+
 module_param(bug_on_recovery, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
 
-- 
1.8.3.rc1.35.g9b79519

