Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2K0GpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:23 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:22 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/20] wlcore: fwlog dynamic mem_block control
Date: Tue, 27 Nov 2012 08:44:50 +0200
Message-Id: <1353998701-18171-10-git-send-email-arik@wizery.com> (sfid-20121127_074618_453550_938AE3CE)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
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
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/conf.h |    5 ++++-
 drivers/net/wireless/ti/wlcore/main.c |   16 ++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index b64d6b5..b3894ef 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1208,6 +1208,9 @@ struct conf_rx_streaming_settings {
 	u8 always;
 } __packed;
 
+#define CONF_FWLOG_MIN_MEM_BLOCKS       2
+#define CONF_FWLOG_MAX_MEM_BLOCKS	16
+
 struct conf_fwlog {
 	/* Continuous or on-demand */
 	u8 mode;
@@ -1215,7 +1218,7 @@ struct conf_fwlog {
 	/*
 	 * Number of memory blocks dedicated for the FW logger
 	 *
-	 * Range: 1-3, or 0 to disable the FW logger
+	 * Range: 2-16, or 0 to disable the FW logger
 	 */
 	u8 mem_blocks;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b659efd..8932cca 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -56,6 +56,7 @@
 #define WL1271_BOOT_RETRIES 3
 
 static char *fwlog_param;
+static int fwlog_mem_blocks = -1;
 static int bug_on_recovery = -1;
 static int no_recovery     = -1;
 
@@ -307,6 +308,18 @@ static void wlcore_adjust_conf(struct wl1271 *wl)
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
 	/* Firmware Log Settings */
 	if (fwlog_param) {
 		if (!strcmp(fwlog_param, "continuous")) {
@@ -6024,6 +6037,9 @@ module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(fwlog,
 		 "FW logger options: continuous, ondemand, dbgpins or disable");
 
+module_param(fwlog_mem_blocks, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(fwlog_mem_blocks, "fwlog mem_blocks");
+
 module_param(bug_on_recovery, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
 
-- 
1.7.9.5

