Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60543 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbZLKNl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:57 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 29/31] wl1271: Add support for acx_pm_config
Date: Fri, 11 Dec 2009 15:41:08 +0200
Message-Id: <1260538870-32297-30-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This acx configures host clock parameters in correspondence with the clock
request line - the settling time of the clock, and whether fast wake-up is
supported.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    9 +++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |   17 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    5 +++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++++
 5 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 0ea1a48..0b34348 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1118,3 +1118,31 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_pm_config(struct wl1271 *wl)
+{
+	struct wl1271_acx_pm_config *acx = NULL;
+	struct  conf_pm_config_settings *c = &wl->conf.pm_config;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx pm config");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->host_clk_settling_time = cpu_to_le32(c->host_clk_settling_time);
+	acx->host_fast_wakeup_support = c->host_fast_wakeup_support;
+
+	ret = wl1271_cmd_configure(wl, ACX_PM_CONFIG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx pm config failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index b6a473f..1bb63af 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -961,6 +961,13 @@ struct wl1271_acx_arp_filter {
 			       used. */
 } __attribute__((packed));
 
+struct wl1271_acx_pm_config {
+	struct acx_header header;
+
+	__le32 host_clk_settling_time;
+	u8 host_fast_wakeup_support;
+	u8 padding[3];
+} __attribute__ ((packed));
 
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
@@ -1025,6 +1032,7 @@ enum {
 	DOT11_RX_DOT11_MODE         = 0x1012,
 	DOT11_RTS_THRESHOLD         = 0x1013,
 	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
+	ACX_PM_CONFIG               = 0x1016,
 
 	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
 
@@ -1073,5 +1081,6 @@ int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
 int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
 			     u8 version);
+int wl1271_acx_pm_config(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 5d1b5b6..1993d63 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -904,6 +904,22 @@ struct conf_itrim_settings {
 	u32 timeout;
 };
 
+struct conf_pm_config_settings {
+	/*
+	 * Host clock settling time
+	 *
+	 * Range: 0 - 30000 us
+	 */
+	u32 host_clk_settling_time;
+
+	/*
+	 * Host fast wakeup support
+	 *
+	 * Range: true, false
+	 */
+	bool host_fast_wakeup_support;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -911,6 +927,7 @@ struct conf_drv_settings {
 	struct conf_conn_settings conn;
 	struct conf_init_settings init;
 	struct conf_itrim_settings itrim;
+	struct conf_pm_config_settings pm_config;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 3b4ed07..c9848ee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -303,6 +303,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* configure PM */
+	ret = wl1271_acx_pm_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 90a60c1..7e6b500 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -321,6 +321,10 @@ static struct conf_drv_settings default_conf = {
 	.itrim = {
 		.enable = false,
 		.timeout = 50000,
+	},
+	.pm_config = {
+		.host_clk_settling_time = 5000,
+		.host_fast_wakeup_support = false
 	}
 };
 
-- 
1.6.3.3

