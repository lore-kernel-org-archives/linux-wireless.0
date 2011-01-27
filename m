Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40599 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1A0Tyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 14:54:40 -0500
Received: by eye27 with SMTP id 27so1187741eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 11:54:39 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] wl12xx: mcp2.5 - add config_ps acx
Date: Thu, 27 Jan 2011 21:54:38 +0200
Message-Id: <1296158081-16398-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1296158081-16398-1-git-send-email-eliad@wizery.com>
References: <1296158081-16398-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mcp2.5 uses this acx to configure the fw only once, rather than
passing the params in every enter psm command.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   11 +++++++++++
 drivers/net/wireless/wl12xx/conf.h |    8 ++++++++
 drivers/net/wireless/wl12xx/main.c |    1 +
 4 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index afdc601..84d94b2 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1476,3 +1476,33 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_config_ps(struct wl1271 *wl)
+{
+	struct wl1271_acx_config_ps *config_ps;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx config ps");
+
+	config_ps = kzalloc(sizeof(*config_ps), GFP_KERNEL);
+	if (!config_ps) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	config_ps->exit_retries = wl->conf.conn.psm_exit_retries;
+	config_ps->enter_retries = wl->conf.conn.psm_entry_retries;
+	config_ps->null_data_rate = cpu_to_le32(wl->basic_rate);
+
+	ret = wl1271_cmd_configure(wl, ACX_CONFIG_PS, config_ps,
+				   sizeof(*config_ps));
+
+	if (ret < 0) {
+		wl1271_warning("acx config ps failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(config_ps);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index c683801..ee67635 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1136,6 +1136,15 @@ struct wl1271_acx_max_tx_retry {
 	u8 padding_1[2];
 } __packed;
 
+struct wl1271_acx_config_ps {
+	struct acx_header header;
+
+	u8 exit_retries;
+	u8 enter_retries;
+	u8 padding[2];
+	__le32 null_data_rate;
+}__packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1200,6 +1209,7 @@ enum {
 	DOT11_RTS_THRESHOLD         = 0x1013,
 	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
 	ACX_PM_CONFIG               = 0x1016,
+	ACX_CONFIG_PS               = 0x1017,
 
 	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
 
@@ -1269,5 +1279,6 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_config_ps(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index fd1dac9..c81aecd 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -960,6 +960,14 @@ struct conf_conn_settings {
 	u8 psm_entry_retries;
 
 	/*
+	 * Specifies the maximum number of times to try PSM exit if it fails
+	 * (if sending the appropriate null-func message fails.)
+	 *
+	 * Range 0 - 255
+	 */
+	u8 psm_exit_retries;
+
+	/*
 	 * Specifies the maximum number of times to try transmit the PSM entry
 	 * null-func frame for each PSM entry attempt
 	 *
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dfab21e..ec82dd0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -256,6 +256,7 @@ static struct conf_drv_settings default_conf = {
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
 		.psm_entry_retries           = 5,
+		.psm_exit_retries            = 255,
 		.psm_entry_nullfunc_retries  = 3,
 		.psm_entry_hangover_period   = 1,
 		.keep_alive_interval         = 55000,
-- 
1.7.0.4

