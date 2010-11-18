Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0KRLch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:32:37 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:32:36 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/18] wl1271: Add AP related configuration to conf_drv_settings
Date: Thu, 18 Nov 2010 13:32:14 +0200
Message-Id: <1290079951-16793-2-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate class configuration has been split up for AP and STA modes.
Template related configuration likewise separated.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    2 +-
 drivers/net/wireless/wl12xx/cmd.c  |    4 +-
 drivers/net/wireless/wl12xx/conf.h |   26 +++++++++++++++++++-
 drivers/net/wireless/wl12xx/main.c |   45 ++++++++++++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 7cbaeb6..4f1cb84 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -754,7 +754,7 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 int wl1271_acx_rate_policies(struct wl1271 *wl)
 {
 	struct acx_rate_policy *acx;
-	struct conf_tx_rate_class *c = &wl->conf.tx.rc_conf;
+	struct conf_tx_rate_class *c = &wl->conf.tx.sta_rc_conf;
 	int idx = 0;
 	int ret = 0;
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f3d0541..40f15c1 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -490,8 +490,8 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 	cmd->len = cpu_to_le16(buf_len);
 	cmd->template_type = template_id;
 	cmd->enabled_rates = cpu_to_le32(rates);
-	cmd->short_retry_limit = wl->conf.tx.rc_conf.short_retry_limit;
-	cmd->long_retry_limit = wl->conf.tx.rc_conf.long_retry_limit;
+	cmd->short_retry_limit = wl->conf.tx.tmpl_short_retry_limit;
+	cmd->long_retry_limit = wl->conf.tx.tmpl_long_retry_limit;
 	cmd->index = index;
 
 	if (buf)
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a16b361..47094f0 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -636,9 +636,9 @@ struct conf_tx_settings {
 
 	/*
 	 * Configuration for rate classes for TX (currently only one
-	 * rate class supported.)
+	 * rate class supported). Used in non-AP mode.
 	 */
-	struct conf_tx_rate_class rc_conf;
+	struct conf_tx_rate_class sta_rc_conf;
 
 	/*
 	 * Configuration for access categories for TX rate control.
@@ -647,6 +647,22 @@ struct conf_tx_settings {
 	struct conf_tx_ac_category ac_conf[CONF_TX_MAX_AC_COUNT];
 
 	/*
+	 * Configuration for rate classes in AP-mode. These rate classes
+	 * are for the AC TX queues
+	 */
+	struct conf_tx_rate_class ap_rc_conf[CONF_TX_MAX_AC_COUNT];
+
+	/*
+	 * Management TX rate class for AP-mode.
+	 */
+	struct conf_tx_rate_class ap_mgmt_conf;
+
+	/*
+	 * Broadcast TX rate class for AP-mode.
+	 */
+	struct conf_tx_rate_class ap_bcst_conf;
+
+	/*
 	 * Configuration for TID parameters.
 	 */
 	u8 tid_conf_count;
@@ -687,6 +703,12 @@ struct conf_tx_settings {
 	 * Range: CONF_HW_BIT_RATE_* bit mask
 	 */
 	u32 basic_rate_5;
+
+	/*
+	 * TX retry limits for templates
+	 */
+	u8 tmpl_short_retry_limit;
+	u8 tmpl_long_retry_limit;
 };
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 31f0e2f..1bb2575 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -116,11 +116,11 @@ static struct conf_drv_settings default_conf = {
 	},
 	.tx = {
 		.tx_energy_detection         = 0,
-		.rc_conf                     = {
+		.sta_rc_conf                 = {
 			.enabled_rates       = 0,
 			.short_retry_limit   = 10,
 			.long_retry_limit    = 10,
-			.aflags              = 0
+			.aflags              = 0,
 		},
 		.ac_conf_count               = 4,
 		.ac_conf                     = {
@@ -153,6 +153,45 @@ static struct conf_drv_settings default_conf = {
 				.tx_op_limit = 1504,
 			},
 		},
+		.ap_rc_conf                  = {
+			[0] = {
+				.enabled_rates = 0x1EFF,
+				.short_retry_limit = 10,
+				.long_retry_limit = 10,
+				.aflags      = 0,
+			},
+			[1] = {
+				.enabled_rates = 0x1EFF,
+				.short_retry_limit = 10,
+				.long_retry_limit = 10,
+				.aflags      = 0,
+			},
+			[2] = {
+				.enabled_rates = 0x1EFF,
+				.short_retry_limit = 10,
+				.long_retry_limit = 10,
+				.aflags      = 0,
+			},
+			[3] = {
+				.enabled_rates = 0x1EFF,
+				.short_retry_limit = 10,
+				.long_retry_limit = 10,
+				.aflags      = 0,
+			},
+		},
+		.ap_mgmt_conf = {
+			.enabled_rates       = 0x7,
+			.short_retry_limit   = 10,
+			.long_retry_limit    = 10,
+			.aflags              = 0,
+		},
+		.ap_bcst_conf = {
+			.enabled_rates       = 0x1,
+			.short_retry_limit   = 10,
+			.long_retry_limit    = 10,
+			.aflags              = 0,
+		},
+
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -193,6 +232,8 @@ static struct conf_drv_settings default_conf = {
 		.tx_compl_threshold          = 4,
 		.basic_rate                  = CONF_HW_BIT_RATE_1MBPS,
 		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
+		.tmpl_short_retry_limit      = 10,
+		.tmpl_long_retry_limit       = 10,
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
-- 
1.7.1

