Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60522 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbZLKNlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:55 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 18/31] wl1271: Remove smart reflex ACX
Date: Fri, 11 Dec 2009 15:40:57 +0200
Message-Id: <1260538870-32297-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove the smart-reflex ACX - the associated parameters are now configured
in the radio parameters config.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   53 -----------------------------
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   21 -----------
 drivers/net/wireless/wl12xx/wl1271_conf.h |   39 ---------------------
 drivers/net/wireless/wl12xx/wl1271_init.c |    5 ---
 drivers/net/wireless/wl12xx/wl1271_main.c |   24 -------------
 5 files changed, 0 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index a38a967..ea6427a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1041,59 +1041,6 @@ out:
 	return ret;
 }
 
-int wl1271_acx_smart_reflex(struct wl1271 *wl)
-{
-	struct acx_smart_reflex_state *sr_state = NULL;
-	struct acx_smart_reflex_config_params *sr_param = NULL;
-	int i, ret;
-
-	wl1271_debug(DEBUG_ACX, "acx smart reflex");
-
-	sr_param = kzalloc(sizeof(*sr_param), GFP_KERNEL);
-	if (!sr_param) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	for (i = 0; i < CONF_SR_ERR_TBL_COUNT; i++) {
-		struct conf_mart_reflex_err_table *e =
-			&(wl->conf.init.sr_err_tbl[i]);
-
-		sr_param->error_table[i].len = e->len;
-		sr_param->error_table[i].upper_limit = e->upper_limit;
-		memcpy(sr_param->error_table[i].values, e->values, e->len);
-	}
-
-	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_PARAMS,
-				   sr_param, sizeof(*sr_param));
-	if (ret < 0) {
-		wl1271_warning("failed to set smart reflex params: %d", ret);
-		goto out;
-	}
-
-	sr_state = kzalloc(sizeof(*sr_state), GFP_KERNEL);
-	if (!sr_state) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* enable smart reflex */
-	sr_state->enable = wl->conf.init.sr_enable;
-
-	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_STATE,
-				   sr_state, sizeof(*sr_state));
-	if (ret < 0) {
-		wl1271_warning("failed to set smart reflex params: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(sr_state);
-	kfree(sr_param);
-	return ret;
-
-}
-
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable)
 {
 	struct wl1271_acx_bet_enable *acx = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index dcd64b7..6640ebf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -415,25 +415,6 @@ struct acx_bt_wlan_coex {
 	u8 pad[3];
 } __attribute__ ((packed));
 
-struct acx_smart_reflex_state {
-	struct acx_header header;
-
-	u8 enable;
-	u8 padding[3];
-} __attribute__ ((packed));
-
-struct smart_reflex_err_table {
-	u8 len;
-	s8 upper_limit;
-	s8 values[14];
-} __attribute__ ((packed));
-
-struct acx_smart_reflex_config_params {
-	struct acx_header header;
-
-	struct smart_reflex_err_table error_table[3];
-} __attribute__ ((packed));
-
 struct acx_dco_itrim_params {
 	struct acx_header header;
 
@@ -1035,8 +1016,6 @@ enum {
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_SMART_REFLEX_DEBUG  = 0x005A,
-	ACX_SET_SMART_REFLEX_STATE  = 0x005B,
-	ACX_SET_SMART_REFLEX_PARAMS = 0x005F,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 905d428..c87ae56 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -722,31 +722,6 @@ struct conf_conn_settings {
 	u8 psm_entry_retries;
 };
 
-#define CONF_SR_ERR_TBL_MAX_VALUES   14
-
-struct conf_mart_reflex_err_table {
-	/*
-	 * Length of the error table values table.
-	 *
-	 * Range: 0 - CONF_SR_ERR_TBL_MAX_VALUES
-	 */
-	u8 len;
-
-	/*
-	 * Smart Reflex error table upper limit.
-	 *
-	 * Range: s8
-	 */
-	s8 upper_limit;
-
-	/*
-	 * Smart Reflex error table values.
-	 *
-	 * Range: s8
-	 */
-	s8 values[CONF_SR_ERR_TBL_MAX_VALUES];
-};
-
 enum {
 	CONF_REF_CLK_19_2_E,
 	CONF_REF_CLK_26_E,
@@ -907,22 +882,8 @@ struct conf_radio_parms {
 	u8  degraded_normal_to_high_threshold_5;
 };
 
-#define CONF_SR_ERR_TBL_COUNT        3
-
 struct conf_init_settings {
 	/*
-	 * Configure Smart Reflex error table values.
-	 */
-	struct conf_mart_reflex_err_table sr_err_tbl[CONF_SR_ERR_TBL_COUNT];
-
-	/*
-	 * Smart Reflex enable flag.
-	 *
-	 * Range: 1 - Smart Reflex enabled, 0 - Smart Reflex disabled
-	 */
-	u8 sr_enable;
-
-	/*
 	 * Configure general parameters.
 	 */
 	struct conf_general_parms genparam;
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index bdd4a96..7bfd6c6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -303,11 +303,6 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Configure smart reflex */
-	ret = wl1271_acx_smart_reflex(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b0f4c6e..5a6e4d4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -226,30 +226,6 @@ static struct conf_drv_settings default_conf = {
 		.psm_entry_retries           = 3
 	},
 	.init = {
-		.sr_err_tbl = {
-			[0] = {
-				.len         = 7,
-				.upper_limit = 0x03,
-				.values      = {
-					0x18, 0x10, 0x05, 0xfb, 0xf0, 0xe8,
-					0x00 }
-			},
-			[1] = {
-				.len         = 7,
-				.upper_limit = 0x03,
-				.values      = {
-					0x18, 0x10, 0x05, 0xf6, 0xf0, 0xe8,
-					0x00 }
-			},
-			[2] = {
-				.len         = 7,
-				.upper_limit = 0x03,
-				.values      = {
-					0x18, 0x10, 0x05, 0xfb, 0xf0, 0xe8,
-					0x00 }
-			}
-		},
-		.sr_enable                   = 1,
 		.genparam                    = {
 			.ref_clk             = CONF_REF_CLK_38_4_E,
 			.settling_time       = 5,
-- 
1.6.3.3

