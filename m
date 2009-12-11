Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63544 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762614AbZLKLlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:52 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/31] wl1271: implement dco itrim parameters setting
Date: Fri, 11 Dec 2009 13:41:02 +0200
Message-Id: <1260531682-4695-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Newer firmwares require the dco itrim parameters to be set during
initialization.  This patch implements the new ACX function and calls it.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    9 +++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++++
 5 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 59bb95b..1cf57b0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -396,6 +396,35 @@ out:
 	return ret;
 }
 
+int wl1271_acx_dco_itrim_params(struct wl1271 *wl)
+{
+	struct acx_dco_itrim_params *dco;
+	struct conf_itrim_settings *c = &wl->conf.itrim;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx dco itrim parameters");
+
+	dco = kzalloc(sizeof(*dco), GFP_KERNEL);
+	if (!dco) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dco->enable = c->enable;
+	dco->timeout = cpu_to_le32(c->timeout);
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_DCO_ITRIM_PARAMS,
+				   dco, sizeof(*dco));
+	if (ret < 0) {
+		wl1271_warning("failed to set dco itrim parameters: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(dco);
+	return ret;
+}
+
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 {
 	struct acx_beacon_filter_option *beacon_filter = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 2ce0a81..fa5d953 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -434,6 +434,14 @@ struct acx_smart_reflex_config_params {
 	struct smart_reflex_err_table error_table[3];
 } __attribute__ ((packed));
 
+struct acx_dco_itrim_params {
+	struct acx_header header;
+
+	u8 enable;
+	u8 padding[3];
+	__le32 timeout;
+} __attribute__ ((packed));
+
 #define PTA_ANTENNA_TYPE_DEF		  (0)
 #define PTA_BT_HP_MAXTIME_DEF		  (2000)
 #define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
@@ -1029,6 +1037,7 @@ enum {
 	ACX_SET_SMART_REFLEX_DEBUG  = 0x005A,
 	ACX_SET_SMART_REFLEX_STATE  = 0x005B,
 	ACX_SET_SMART_REFLEX_PARAMS = 0x005F,
+	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1056,6 +1065,7 @@ int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 				 void *mc_list, u32 mc_list_len);
 int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
+int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
 int wl1271_acx_conn_monit_params(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index a4bd35b..905d428 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -934,12 +934,21 @@ struct conf_init_settings {
 
 };
 
+struct conf_itrim_settings {
+	/* enable dco itrim */
+	u8 enable;
+
+	/* moderation timeout in microsecs from the last TX */
+	u32 timeout;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
 	struct conf_conn_settings conn;
 	struct conf_init_settings init;
+	struct conf_itrim_settings itrim;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index d72ccc6..39f01d8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -229,6 +229,10 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	ret = wl1271_acx_dco_itrim_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Initialize connection monitoring thresholds */
 	ret = wl1271_acx_conn_monit_params(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4b5ee41..9be9aff 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -338,6 +338,10 @@ static struct conf_drv_settings default_conf = {
 			.degraded_low_to_normal_threshold_5 = 0x00,
 			.degraded_normal_to_high_threshold_5 = 0x00
 		}
+	},
+	.itrim = {
+		.enable = false,
+		.timeout = 50000,
 	}
 };
 
-- 
1.6.3.3

