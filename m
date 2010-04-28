Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46519 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0D1GuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 02:50:22 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] wl1271: fix a bunch of sparse warnings
Date: Wed, 28 Apr 2010 09:50:02 +0300
Message-Id: <1272437402-28801-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
References: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of sparse warnings in some rate settings (missing cpu_to_le32) were
fixed.  Changed the conf_sg_settings struct from le to native endianess.  The
values are converted to le when copying them to the acx command instead.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 ++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_conf.h |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 2ad086e..e19e2f8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -590,7 +590,7 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 
 	/* BT-WLAN coext parameters */
 	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
-		param->params[i] = c->params[i];
+		param->params[i] = cpu_to_le32(c->params[i]);
 	param->param_idx = CONF_SG_PARAMS_ALL;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 8087dc1..acb1d9e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -351,7 +351,7 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 static int wl1271_boot_run_firmware(struct wl1271 *wl)
 {
 	int loop, ret;
-	u32 chip_id, interrupt;
+	u32 chip_id, intr;
 
 	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
@@ -368,15 +368,15 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		interrupt = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 
-		if (interrupt == 0xffffffff) {
+		if (intr == 0xffffffff) {
 			wl1271_error("error reading hardware complete "
 				     "init indication");
 			return -EIO;
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
-		else if (interrupt & WL1271_ACX_INTR_INIT_COMPLETE) {
+		else if (intr & WL1271_ACX_INTR_INIT_COMPLETE) {
 			wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
 				       WL1271_ACX_INTR_INIT_COMPLETE);
 			break;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 61fb774..62c11af 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -318,7 +318,7 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->rx_config_options = cpu_to_le32(wl->rx_config);
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
-	join->basic_rate_set = wl->basic_rate_set;
+	join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
 
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
@@ -615,7 +615,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	params->params.scan_options = cpu_to_le16(scan_options);
 
 	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = rate;
+	params->params.tx_rate = cpu_to_le32(rate);
 	params->params.tid_trigger = 0;
 	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index c44307c..d046d04 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -401,7 +401,7 @@ enum {
 };
 
 struct conf_sg_settings {
-	__le32 params[CONF_SG_PARAMS_MAX];
+	u32 params[CONF_SG_PARAMS_MAX];
 	u8 state;
 };
 
-- 
1.6.3.3

