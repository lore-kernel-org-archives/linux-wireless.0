Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51212 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2KZQGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:20 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so2144136wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:20 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Yair Shapira <yair.shapira@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/11] wlcore/wl18xx/wl12xx: add recovery settings to conf
Date: Mon, 26 Nov 2012 18:05:50 +0200
Message-Id: <1353945950-3899-12-git-send-email-arik@wizery.com> (sfid-20121126_170630_051425_C9FB3587)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

add support for recovery settings including bug_on_recovery and
no_recovery options.

These options can now be set using wl18xx-conf.bin file and wlconf
tool.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    4 ++++
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++++
 drivers/net/wireless/ti/wlcore/conf.h |   11 ++++++++++-
 drivers/net/wireless/ti/wlcore/main.c |   21 +++++++++++++++------
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index dafcdf6..d997cdc 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -370,6 +370,10 @@ static struct wlcore_conf wl12xx_conf = {
 		.increase_time              = 1,
 		.window_size                = 16,
 	},
+	.recovery = {
+		.bug_on_recovery	    = 0,
+		.no_recovery		    = 0,
+	},
 };
 
 static struct wl12xx_priv_conf wl12xx_default_priv_conf = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9d2fa91..e71e2cf 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -492,6 +492,10 @@ static struct wlcore_conf wl18xx_conf = {
 		.increase_time              = 1,
 		.window_size                = 16,
 	},
+	.recovery = {
+		.bug_on_recovery	    = 0,
+		.no_recovery		    = 0,
+	},
 };
 
 static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index e0695e9..b64d6b5 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1265,12 +1265,20 @@ struct conf_hangover_settings {
 	u8 window_size;
 } __packed;
 
+struct conf_recovery_settings {
+	/* BUG() on fw recovery */
+	u8 bug_on_recovery;
+
+	/* Prevent HW recovery. FW will remain stuck. */
+	u8 no_recovery;
+} __packed;
+
 /*
  * The conf version consists of 4 bytes.  The two MSB are the wlcore
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0003 << 16)
+#define WLCORE_CONF_VERSION	(0x0004 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
@@ -1298,6 +1306,7 @@ struct wlcore_conf {
 	struct conf_fwlog fwlog;
 	struct conf_rate_policy_settings rate;
 	struct conf_hangover_settings hangover;
+	struct conf_recovery_settings recovery;
 } __packed;
 
 struct wlcore_conf_file {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a48a36c..56f20d6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -56,8 +56,8 @@
 #define WL1271_BOOT_RETRIES 3
 
 static char *fwlog_param;
-static bool bug_on_recovery;
-static bool no_recovery;
+static int bug_on_recovery = -1;
+static int no_recovery     = -1;
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 struct ieee80211_vif *vif,
@@ -306,6 +306,8 @@ out:
 static void wlcore_adjust_conf(struct wl1271 *wl)
 {
 	/* Adjust settings according to optional module parameters */
+
+	/* Firmware Log Settings */
 	if (fwlog_param) {
 		if (!strcmp(fwlog_param, "continuous")) {
 			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
@@ -321,6 +323,13 @@ static void wlcore_adjust_conf(struct wl1271 *wl)
 			wl1271_error("Unknown fwlog parameter %s", fwlog_param);
 		}
 	}
+
+	/* Recovery Settings */
+	if (bug_on_recovery != -1)
+		wl->conf.recovery.bug_on_recovery = (u8) bug_on_recovery;
+
+	if (no_recovery != -1)
+		wl->conf.recovery.no_recovery = (u8) no_recovery;
 }
 
 static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
@@ -903,10 +912,10 @@ static void wl1271_recovery_work(struct work_struct *work)
 		wlcore_print_recovery(wl);
 	}
 
-	BUG_ON(bug_on_recovery &&
+	BUG_ON(wl->conf.recovery.bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
 
-	if (no_recovery) {
+	if (wl->conf.recovery.no_recovery) {
 		wl1271_info("No recovery (chosen on module load). Fw will remain stuck.");
 		goto out_unlock;
 	}
@@ -6013,10 +6022,10 @@ module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(fwlog,
 		 "FW logger options: continuous, ondemand, dbgpins or disable");
 
-module_param(bug_on_recovery, bool, S_IRUSR | S_IWUSR);
+module_param(bug_on_recovery, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
 
-module_param(no_recovery, bool, S_IRUSR | S_IWUSR);
+module_param(no_recovery, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(no_recovery, "Prevent HW recovery. FW will remain stuck.");
 
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

