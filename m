Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1DRLQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:16:10 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3798215wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:16:10 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/10] wl12xx: AP-mode - overhaul rate policy configuration
Date: Mon, 18 Apr 2011 14:15:25 +0300
Message-Id: <1303125329-27214-6-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the minimal rate configured in the basic rates set as the AP
broadcast and multicast rate. The minimal rate is used to ensure weak
links can still communicate.

When the basic rates contains at least one OFDM rate, configure all
unicast TX rates to OFDM only.

Unify rate configuration on initialization and on change notification
into a single function.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    3 +-
 drivers/net/wireless/wl12xx/conf.h |   22 +++--------
 drivers/net/wireless/wl12xx/init.c |   71 +++++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/init.h |    1 +
 drivers/net/wireless/wl12xx/main.c |   53 ++-------------------------
 5 files changed, 65 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index e9bc995..ebd1cb7 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -841,7 +841,8 @@ int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 	struct acx_ap_rate_policy *acx;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_ACX, "acx ap rate policy");
+	wl1271_debug(DEBUG_ACX, "acx ap rate policy %d rates 0x%x",
+		     idx, c->enabled_rates);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 0c1d0c7..d03e4f9 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -540,6 +540,12 @@ struct conf_rx_settings {
 	CONF_HW_BIT_RATE_36MBPS | CONF_HW_BIT_RATE_48MBPS |      \
 	CONF_HW_BIT_RATE_54MBPS)
 
+#define CONF_TX_OFDM_RATES (CONF_HW_BIT_RATE_6MBPS |             \
+	CONF_HW_BIT_RATE_12MBPS | CONF_HW_BIT_RATE_24MBPS |      \
+	CONF_HW_BIT_RATE_36MBPS | CONF_HW_BIT_RATE_48MBPS |      \
+	CONF_HW_BIT_RATE_54MBPS)
+
+
 /*
  * Default rates for management traffic when operating in AP mode. This
  * should be configured according to the basic rate set of the AP
@@ -698,22 +704,6 @@ struct conf_tx_settings {
 	struct conf_tx_ac_category ac_conf[CONF_TX_MAX_AC_COUNT];
 
 	/*
-	 * Configuration for rate classes in AP-mode. These rate classes
-	 * are for the AC TX queues
-	 */
-	struct conf_tx_rate_class ap_rc_conf[CONF_TX_MAX_AC_COUNT];
-
-	/*
-	 * Management TX rate class for AP-mode.
-	 */
-	struct conf_tx_rate_class ap_mgmt_conf;
-
-	/*
-	 * Broadcast TX rate class for AP-mode.
-	 */
-	struct conf_tx_rate_class ap_bcst_conf;
-
-	/*
 	 * AP-mode - allow this number of TX retries to a station before an
 	 * event is triggered from FW.
 	 */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 645f740..5fc69de 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -408,7 +408,7 @@ static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
 
 static int wl1271_ap_hw_init(struct wl1271 *wl)
 {
-	int ret, i;
+	int ret;
 
 	ret = wl1271_ap_init_templates_config(wl);
 	if (ret < 0)
@@ -419,23 +419,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	/* Configure initial TX rate classes */
-	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
-		ret = wl1271_acx_ap_rate_policy(wl,
-				&wl->conf.tx.ap_rc_conf[i], i);
-		if (ret < 0)
-			return ret;
-	}
-
-	ret = wl1271_acx_ap_rate_policy(wl,
-					&wl->conf.tx.ap_mgmt_conf,
-					ACX_TX_AP_MODE_MGMT_RATE);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_acx_ap_rate_policy(wl,
-					&wl->conf.tx.ap_bcst_conf,
-					ACX_TX_AP_MODE_BCST_RATE);
+	ret = wl1271_init_ap_rates(wl);
 	if (ret < 0)
 		return ret;
 
@@ -477,6 +461,57 @@ static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
 	return 0;
 }
 
+int wl1271_init_ap_rates(struct wl1271 *wl)
+{
+	int i, ret;
+	struct conf_tx_rate_class rc;
+	u32 supported_rates;
+
+	wl1271_debug(DEBUG_AP, "AP basic rate set: 0x%x", wl->basic_rate_set);
+
+	if (wl->basic_rate_set == 0)
+		return -EINVAL;
+
+	rc.enabled_rates = wl->basic_rate_set;
+	rc.long_retry_limit = 10;
+	rc.short_retry_limit = 10;
+	rc.aflags = 0;
+	ret = wl1271_acx_ap_rate_policy(wl, &rc, ACX_TX_AP_MODE_MGMT_RATE);
+	if (ret < 0)
+		return ret;
+
+	/* use the min basic rate for AP broadcast/multicast */
+	rc.enabled_rates = wl1271_tx_min_rate_get(wl);
+	rc.short_retry_limit = 10;
+	rc.long_retry_limit = 10;
+	rc.aflags = 0;
+	ret = wl1271_acx_ap_rate_policy(wl, &rc, ACX_TX_AP_MODE_BCST_RATE);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the basic rates contain OFDM rates, use OFDM only
+	 * rates for unicast TX as well. Else use all supported rates.
+	 */
+	if ((wl->basic_rate_set & CONF_TX_OFDM_RATES))
+		supported_rates = CONF_TX_OFDM_RATES;
+	else
+		supported_rates = CONF_TX_AP_ENABLED_RATES;
+
+	/* configure unicast TX rate classes */
+	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
+		rc.enabled_rates = supported_rates;
+		rc.short_retry_limit = 10;
+		rc.long_retry_limit = 10;
+		rc.aflags = 0;
+		ret = wl1271_acx_ap_rate_policy(wl, &rc, i);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static void wl1271_check_ba_support(struct wl1271 *wl)
 {
 	/* validate FW cose ver x.x.x.50-60.x */
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 4975270..0dd2414 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -33,5 +33,6 @@ int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
+int wl1271_init_ap_rates(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e0c8ca4..c7e2c09 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -209,44 +209,6 @@ static struct conf_drv_settings default_conf = {
 				.tx_op_limit = 1504,
 			},
 		},
-		.ap_rc_conf                  = {
-			[0] = {
-				.enabled_rates = CONF_TX_AP_ENABLED_RATES,
-				.short_retry_limit = 10,
-				.long_retry_limit = 10,
-				.aflags      = 0,
-			},
-			[1] = {
-				.enabled_rates = CONF_TX_AP_ENABLED_RATES,
-				.short_retry_limit = 10,
-				.long_retry_limit = 10,
-				.aflags      = 0,
-			},
-			[2] = {
-				.enabled_rates = CONF_TX_AP_ENABLED_RATES,
-				.short_retry_limit = 10,
-				.long_retry_limit = 10,
-				.aflags      = 0,
-			},
-			[3] = {
-				.enabled_rates = CONF_TX_AP_ENABLED_RATES,
-				.short_retry_limit = 10,
-				.long_retry_limit = 10,
-				.aflags      = 0,
-			},
-		},
-		.ap_mgmt_conf = {
-			.enabled_rates       = CONF_TX_AP_DEFAULT_MGMT_RATES,
-			.short_retry_limit   = 10,
-			.long_retry_limit    = 10,
-			.aflags              = 0,
-		},
-		.ap_bcst_conf = {
-			.enabled_rates       = CONF_HW_BIT_RATE_1MBPS,
-			.short_retry_limit   = 10,
-			.long_retry_limit    = 10,
-			.aflags              = 0,
-		},
 		.ap_max_tx_retries = 100,
 		.tid_conf_count = 4,
 		.tid_conf = {
@@ -2509,22 +2471,13 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 
 	if ((changed & BSS_CHANGED_BASIC_RATES)) {
 		u32 rates = bss_conf->basic_rates;
-		struct conf_tx_rate_class mgmt_rc;
 
 		wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates);
 		wl->basic_rate = wl1271_tx_min_rate_get(wl);
-		wl1271_debug(DEBUG_AP, "basic rates: 0x%x",
-			     wl->basic_rate_set);
-
-		/* update the AP management rate policy with the new rates */
-		mgmt_rc.enabled_rates = wl->basic_rate_set;
-		mgmt_rc.long_retry_limit = 10;
-		mgmt_rc.short_retry_limit = 10;
-		mgmt_rc.aflags = 0;
-		ret = wl1271_acx_ap_rate_policy(wl, &mgmt_rc,
-						ACX_TX_AP_MODE_MGMT_RATE);
+
+		ret = wl1271_init_ap_rates(wl);
 		if (ret < 0) {
-			wl1271_error("AP mgmt policy change failed %d", ret);
+			wl1271_error("AP rate policy change failed %d", ret);
 			goto out;
 		}
 	}
-- 
1.7.1

