Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46524 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1HYQDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:03:24 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so1794291wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 09:03:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] wl12xx: add config_hangover command
Date: Thu, 25 Aug 2011 19:04:29 +0300
Message-Id: <1314288270-22380-4-git-send-email-eliad@wizery.com> (sfid-20110825_180327_400663_4F423EC8)
In-Reply-To: <1314288270-22380-1-git-send-email-eliad@wizery.com>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add wl12xx_acx_config_hangover() and respective conf values.
This command configures how long the chip will stay awake
after it was configured to enter psm.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   40 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   18 ++++++++++++++++
 drivers/net/wireless/wl12xx/conf.h |   23 +++++++++++++-------
 drivers/net/wireless/wl12xx/init.c |    5 ++++
 drivers/net/wireless/wl12xx/main.c |   14 +++++++++++-
 5 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index f2838ae..a325dba 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1687,3 +1687,43 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl12xx_acx_config_hangover(struct wl1271 *wl)
+{
+	struct wl12xx_acx_config_hangover *acx;
+	struct conf_hangover_settings *conf = &wl->conf.hangover;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx config hangover");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->recover_time = cpu_to_le32(conf->recover_time);
+	acx->hangover_period = conf->hangover_period;
+	acx->dynamic_mode = conf->dynamic_mode;
+	acx->early_termination_mode = conf->early_termination_mode;
+	acx->max_period = conf->max_period;
+	acx->min_period = conf->min_period;
+	acx->increase_delta = conf->increase_delta;
+	acx->decrease_delta = conf->decrease_delta;
+	acx->quiet_time = conf->quiet_time;
+	acx->increase_delta = conf->increase_time;
+	acx->window_size = acx->window_size;
+
+	ret = wl1271_cmd_configure(wl, ACX_CONFIG_HANGOVER, acx,
+				   sizeof(*acx));
+
+	if (ret < 0) {
+		wl1271_warning("acx config hangover failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 758c596..556ee4e 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1144,6 +1144,23 @@ struct wl12xx_acx_set_rate_mgmt_params {
 	u8 padding2[2];
 } __packed;
 
+struct wl12xx_acx_config_hangover {
+	struct acx_header header;
+
+	__le32 recover_time;
+	u8 hangover_period;
+	u8 dynamic_mode;
+	u8 early_termination_mode;
+	u8 max_period;
+	u8 min_period;
+	u8 increase_delta;
+	u8 decrease_delta;
+	u8 quiet_time;
+	u8 increase_time;
+	u8 window_size;
+	u8 padding[2];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1281,5 +1298,6 @@ int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
+int wl12xx_acx_config_hangover(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 82f205c..45428a2 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -916,14 +916,6 @@ struct conf_conn_settings {
 	u8 psm_entry_nullfunc_retries;
 
 	/*
-	 * Specifies the time to linger in active mode after successfully
-	 * transmitting the PSM entry null-func frame.
-	 *
-	 * Range 0 - 255 TU's
-	 */
-	u8 psm_entry_hangover_period;
-
-	/*
 	 *
 	 * Specifies the interval of the connection keep-alive null-func
 	 * frame in ms.
@@ -1236,6 +1228,20 @@ struct conf_rate_policy_settings {
 	u8 rate_retry_policy[ACX_RATE_MGMT_NUM_OF_RATES];
 };
 
+struct conf_hangover_settings {
+	u32 recover_time;
+	u8 hangover_period;
+	u8 dynamic_mode;
+	u8 early_termination_mode;
+	u8 max_period;
+	u8 min_period;
+	u8 increase_delta;
+	u8 decrease_delta;
+	u8 quiet_time;
+	u8 increase_time;
+	u8 window_size;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1254,6 +1260,7 @@ struct conf_drv_settings {
 	struct conf_rx_streaming_settings rx_streaming;
 	struct conf_fwlog fwlog;
 	struct conf_rate_policy_settings rate;
+	struct conf_hangover_settings hangover;
 	u8 hci_io_ds;
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b13bebe..09515f5 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -707,6 +707,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* configure hangover */
+	ret = wl12xx_acx_config_hangover(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8aff8d4..f1fd991 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -239,7 +239,6 @@ static struct conf_drv_settings default_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.psm_entry_hangover_period   = 1,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 	},
@@ -359,6 +358,19 @@ static struct conf_drv_settings default_conf = {
 			0x00, 0x00, 0x00,
 		},
 	},
+	.hangover = {
+		.recover_time               = 0,
+		.hangover_period            = 20,
+		.dynamic_mode               = 1,
+		.early_termination_mode     = 1,
+		.max_period                 = 20,
+		.min_period                 = 1,
+		.increase_delta             = 1,
+		.decrease_delta             = 2,
+		.quiet_time                 = 4,
+		.increase_time              = 1,
+		.window_size                = 16,
+	},
 };
 
 static char *fwlog_param;
-- 
1.7.6.401.g6a319

