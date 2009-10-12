Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60089 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZJLMWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:22:13 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 11/16] wl1271: Enable smart reflex
Date: Mon, 12 Oct 2009 15:08:52 +0300
Message-Id: <1255349337-9776-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable and configure smart reflex. This should have a reducing impact on
power consumption.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   72 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   23 +++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    5 ++
 3 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index d5dac57..6c29890 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -998,3 +998,75 @@ out:
 	kfree(rx_conf);
 	return ret;
 }
+
+int wl1271_acx_smart_reflex(struct wl1271 *wl)
+{
+	struct acx_smart_reflex_state *sr_state = NULL;
+	struct acx_smart_reflex_config_params *sr_param = NULL;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx smart reflex");
+
+	sr_param = kzalloc(sizeof(*sr_param), GFP_KERNEL);
+	if (!sr_param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* set cryptic smart reflex parameters - source TI reference code */
+	sr_param->error_table[0].len = 0x07;
+	sr_param->error_table[0].upper_limit = 0x03;
+	sr_param->error_table[0].values[0] = 0x18;
+	sr_param->error_table[0].values[1] = 0x10;
+	sr_param->error_table[0].values[2] = 0x05;
+	sr_param->error_table[0].values[3] = 0xfb;
+	sr_param->error_table[0].values[4] = 0xf0;
+	sr_param->error_table[0].values[5] = 0xe8;
+
+	sr_param->error_table[1].len = 0x07;
+	sr_param->error_table[1].upper_limit = 0x03;
+	sr_param->error_table[1].values[0] = 0x18;
+	sr_param->error_table[1].values[1] = 0x10;
+	sr_param->error_table[1].values[2] = 0x05;
+	sr_param->error_table[1].values[3] = 0xf6;
+	sr_param->error_table[1].values[4] = 0xf0;
+	sr_param->error_table[1].values[5] = 0xe8;
+
+	sr_param->error_table[2].len = 0x07;
+	sr_param->error_table[2].upper_limit = 0x03;
+	sr_param->error_table[2].values[0] = 0x18;
+	sr_param->error_table[2].values[1] = 0x10;
+	sr_param->error_table[2].values[2] = 0x05;
+	sr_param->error_table[2].values[3] = 0xfb;
+	sr_param->error_table[2].values[4] = 0xf0;
+	sr_param->error_table[2].values[5] = 0xe8;
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_PARAMS,
+				   sr_param, sizeof(*sr_param));
+	if (ret < 0) {
+		wl1271_warning("failed to set smart reflex params: %d", ret);
+		goto out;
+	}
+
+	sr_state = kzalloc(sizeof(*sr_state), GFP_KERNEL);
+	if (!sr_state) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* enable smart reflex */
+	sr_state->enable = 1;
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_STATE,
+				   sr_state, sizeof(*sr_state));
+	if (ret < 0) {
+		wl1271_warning("failed to set smart reflex params: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(sr_state);
+	kfree(sr_param);
+	return ret;
+
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 07256d2..0c704af 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -445,6 +445,25 @@ struct acx_bt_wlan_coex {
 	u8 pad[3];
 } __attribute__ ((packed));
 
+struct acx_smart_reflex_state {
+	struct acx_header header;
+
+	u8 enable;
+	u8 padding[3];
+};
+
+struct smart_reflex_err_table {
+	u8 len;
+	s8 upper_limit;
+	s8 values[14];
+};
+
+struct acx_smart_reflex_config_params {
+	struct acx_header header;
+
+	struct smart_reflex_err_table error_table[3];
+};
+
 #define PTA_ANTENNA_TYPE_DEF		  (0)
 #define PTA_BT_HP_MAXTIME_DEF		  (2000)
 #define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
@@ -1184,6 +1203,9 @@ enum {
 	ACX_PEER_HT_CAP             = 0x0057,
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
+	ACX_SET_SMART_REFLEX_DEBUG  = 0x005A,
+	ACX_SET_SMART_REFLEX_STATE  = 0x005B,
+	ACX_SET_SMART_REFLEX_PARAMS = 0x005F,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1233,5 +1255,6 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
+int wl1271_acx_smart_reflex(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index bf4d0e1..f9315f6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -394,6 +394,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* Configure smart reflex */
+	ret = wl1271_acx_smart_reflex(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
-- 
1.5.6.5

