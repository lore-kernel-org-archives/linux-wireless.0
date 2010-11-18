Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0KRLcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:32:47 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:32:46 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/18] wl1271: AP mode - init sequence
Date: Thu, 18 Nov 2010 13:32:19 +0200
Message-Id: <1290079951-16793-7-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split HW init sequence into AP/STA specific parts

The AP specific init sequence includes configuration of templates, rate
classes, power mode, etc. Also unmask AP specific events in the event mbox.

Separate the differences between AP and STA init into mode
specific functions called from wl1271_hw_init. The first is called after
radio configuration and the second after memory configuration.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.h          |    5 +
 drivers/net/wireless/wl12xx/init.c         |  352 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/init.h         |    5 +-
 drivers/net/wireless/wl12xx/main.c         |    4 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    5 +
 5 files changed, 294 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 47366ff..e8e0610 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -136,6 +136,11 @@ enum cmd_templ {
 	CMD_TEMPL_CTS,           /*
 				  * For CTS-to-self (FastCTS) mechanism
 				  * for BT/WLAN coexistence (SoftGemini). */
+	CMD_TEMPL_AP_BEACON,
+	CMD_TEMPL_AP_PROBE_RESPONSE,
+	CMD_TEMPL_ARP_RSP,
+	CMD_TEMPL_DEAUTH_AP,
+
 	CMD_TEMPL_MAX = 0xff
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index a4196f5..d543464 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -30,27 +30,9 @@
 #include "acx.h"
 #include "cmd.h"
 #include "reg.h"
+#include "tx.h"
 
-static int wl1271_init_hwenc_config(struct wl1271 *wl)
-{
-	int ret;
-
-	ret = wl1271_acx_feature_cfg(wl);
-	if (ret < 0) {
-		wl1271_warning("couldn't set feature config");
-		return ret;
-	}
-
-	ret = wl1271_cmd_set_sta_default_wep_key(wl, wl->default_key);
-	if (ret < 0) {
-		wl1271_warning("couldn't set default key");
-		return ret;
-	}
-
-	return 0;
-}
-
-int wl1271_init_templates_config(struct wl1271 *wl)
+int wl1271_sta_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
 	size_t size;
@@ -113,6 +95,132 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	return 0;
 }
 
+static int wl1271_ap_init_deauth_template(struct wl1271 *wl)
+{
+	struct wl12xx_disconn_template *tmpl;
+	int ret;
+
+	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
+	if (!tmpl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	tmpl->header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					     IEEE80211_STYPE_DEAUTH);
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP,
+				      tmpl, sizeof(*tmpl), 0,
+				      wl1271_min_rate_get(wl));
+
+out:
+	kfree(tmpl);
+	return ret;
+}
+
+static int wl1271_ap_init_null_template(struct wl1271 *wl)
+{
+	struct ieee80211_hdr_3addr *nullfunc;
+	int ret;
+
+	nullfunc = kzalloc(sizeof(*nullfunc), GFP_KERNEL);
+	if (!nullfunc) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	nullfunc->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					      IEEE80211_STYPE_NULLFUNC |
+					      IEEE80211_FCTL_FROMDS);
+
+	/* nullfunc->addr1 is filled by FW */
+
+	memcpy(nullfunc->addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, wl->mac_addr, ETH_ALEN);
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, nullfunc,
+				      sizeof(*nullfunc), 0,
+				      wl1271_min_rate_get(wl));
+
+out:
+	kfree(nullfunc);
+	return ret;
+}
+
+static int wl1271_ap_init_qos_null_template(struct wl1271 *wl)
+{
+	struct ieee80211_qos_hdr *qosnull;
+	int ret;
+
+	qosnull = kzalloc(sizeof(*qosnull), GFP_KERNEL);
+	if (!qosnull) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	qosnull->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					     IEEE80211_STYPE_QOS_NULLFUNC |
+					     IEEE80211_FCTL_FROMDS);
+
+	/* qosnull->addr1 is filled by FW */
+
+	memcpy(qosnull->addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(qosnull->addr3, wl->mac_addr, ETH_ALEN);
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, qosnull,
+				      sizeof(*qosnull), 0,
+				      wl1271_min_rate_get(wl));
+
+out:
+	kfree(qosnull);
+	return ret;
+}
+
+static int wl1271_ap_init_templates_config(struct wl1271 *wl)
+{
+	int ret;
+
+	/*
+	 * Put very large empty placeholders for all templates. These
+	 * reserve memory for later.
+	 */
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
+				      sizeof
+				      (struct wl12xx_probe_resp_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_BEACON, NULL,
+				      sizeof
+				      (struct wl12xx_beacon_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP, NULL,
+				      sizeof
+				      (struct wl12xx_disconn_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
+				      sizeof(struct wl12xx_null_data_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
+				      sizeof
+				      (struct wl12xx_qos_null_data_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
 {
 	int ret;
@@ -140,10 +248,6 @@ int wl1271_init_phy_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_service_period_timeout(wl);
 	if (ret < 0)
 		return ret;
@@ -208,11 +312,150 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
+static int wl1271_sta_hw_init(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_cmd_ext_radio_parms(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_sta_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Initialize connection monitoring thresholds */
+	ret = wl1271_acx_conn_monit_params(wl, false);
+	if (ret < 0)
+		return ret;
+
+	/* Beacon filtering */
+	ret = wl1271_init_beacon_filter(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Bluetooth WLAN coexistence */
+	ret = wl1271_init_pta(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Beacons and boradcast settings */
+	ret = wl1271_init_beacon_broadcast(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Configure for ELP power saving */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+	if (ret < 0)
+		return ret;
+
+	/* Configure rssi/snr averaging weights */
+	ret = wl1271_acx_rssi_snr_avg_weights(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_sta_rate_policies(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
+{
+	int ret, i;
+
+	ret = wl1271_cmd_set_sta_default_wep_key(wl, wl->default_key);
+	if (ret < 0) {
+		wl1271_warning("couldn't set default key");
+		return ret;
+	}
+
+	/* disable all keep-alive templates */
+	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
+		ret = wl1271_acx_keep_alive_config(wl, i,
+						   ACX_KEEP_ALIVE_TPL_INVALID);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* disable the keep-alive feature */
+	ret = wl1271_acx_keep_alive_mode(wl, false);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_ap_hw_init(struct wl1271 *wl)
+{
+	int ret, i;
+
+	ret = wl1271_ap_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Configure for power always on */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+	if (ret < 0)
+		return ret;
+
+	/* Configure initial TX rate classes */
+	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
+		ret = wl1271_acx_ap_rate_policy(wl,
+				&wl->conf.tx.ap_rc_conf[i], i);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = wl1271_acx_ap_rate_policy(wl,
+					&wl->conf.tx.ap_mgmt_conf,
+					ACX_TX_AP_MODE_MGMT_RATE);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_ap_rate_policy(wl,
+					&wl->conf.tx.ap_bcst_conf,
+					ACX_TX_AP_MODE_BCST_RATE);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_max_tx_retry(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_ap_init_deauth_template(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_ap_init_null_template(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_ap_init_qos_null_template(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
 	int ret, i;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
 	ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0)
@@ -222,12 +465,12 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_ext_radio_parms(wl);
-	if (ret < 0)
-		return ret;
+	/* Mode specific init */
+	if (is_ap)
+		ret = wl1271_ap_hw_init(wl);
+	else
+		ret = wl1271_sta_hw_init(wl);
 
-	/* Template settings */
-	ret = wl1271_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
 
@@ -254,16 +497,6 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl, false);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Beacon filtering */
-	ret = wl1271_init_beacon_filter(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* Configure TX patch complete interrupt behavior */
 	ret = wl1271_acx_tx_config_options(wl);
 	if (ret < 0)
@@ -274,21 +507,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Bluetooth WLAN coexistence */
-	ret = wl1271_init_pta(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* Energy detection */
 	ret = wl1271_init_energy_detection(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Beacons and boradcast settings */
-	ret = wl1271_init_beacon_broadcast(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* Default fragmentation threshold */
 	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
 	if (ret < 0)
@@ -316,23 +539,13 @@ int wl1271_hw_init(struct wl1271 *wl)
 			goto out_free_memmap;
 	}
 
-	/* Configure TX rate classes */
-	ret = wl1271_acx_sta_rate_policies(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* Enable data path */
 	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Configure for ELP power saving */
-	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* Configure HW encryption */
-	ret = wl1271_init_hwenc_config(wl);
+	ret = wl1271_acx_feature_cfg(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
@@ -341,21 +554,12 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* disable all keep-alive templates */
-	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
-		ret = wl1271_acx_keep_alive_config(wl, i,
-						   ACX_KEEP_ALIVE_TPL_INVALID);
-		if (ret < 0)
-			goto out_free_memmap;
-	}
+	/* Mode specific init - post mem init */
+	if (is_ap)
+		ret = wl1271_ap_hw_init_post_mem(wl);
+	else
+		ret = wl1271_sta_hw_init_post_mem(wl);
 
-	/* disable the keep-alive feature */
-	ret = wl1271_acx_keep_alive_mode(wl, false);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Configure rssi/snr averaging weights */
-	ret = wl1271_acx_rssi_snr_avg_weights(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 7762421..4d37210 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -27,10 +27,13 @@
 #include "wl12xx.h"
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
-int wl1271_init_templates_config(struct wl1271 *wl);
+int wl1271_sta_init_templates_config(struct wl1271 *wl);
 int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
 
+/* Functions from wl1271_main.c */
+u32 wl1271_min_rate_get(struct wl1271 *wl);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0d507f5..1c6f399 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -433,7 +433,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_init_templates_config(wl);
+	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
 
@@ -1343,7 +1343,7 @@ static void wl1271_set_band_rate(struct wl1271 *wl)
 		wl->basic_rate_set = wl->conf.tx.basic_rate_5;
 }
 
-static u32 wl1271_min_rate_get(struct wl1271 *wl)
+u32 wl1271_min_rate_get(struct wl1271 *wl)
 {
 	int i;
 	u32 rate = 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 1846280..5683c71 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -153,4 +153,9 @@ struct wl12xx_probe_resp_template {
 	struct wl12xx_ie_country country;
 } __packed;
 
+struct wl12xx_disconn_template {
+	struct ieee80211_header header;
+	__le16 disconn_reason;
+} __packed;
+
 #endif
-- 
1.7.1

