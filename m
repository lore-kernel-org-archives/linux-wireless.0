Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41257 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0L2Xcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 18:32:32 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4915990ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 15:32:31 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 06/18] wl1271: AP mode - init sequence
Date: Thu, 30 Dec 2010 01:32:01 +0200
Message-Id: <1293665533-7599-7-git-send-email-arik@wizery.com>
In-Reply-To: <1293665533-7599-1-git-send-email-arik@wizery.com>
References: <1293665533-7599-1-git-send-email-arik@wizery.com>
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
 drivers/net/wireless/wl12xx/cmd.h          |    7 +
 drivers/net/wireless/wl12xx/init.c         |  352 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/init.h         |    2 +-
 drivers/net/wireless/wl12xx/main.c         |   32 +--
 drivers/net/wireless/wl12xx/tx.c           |   18 ++
 drivers/net/wireless/wl12xx/tx.h           |    1 +
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    5 +
 7 files changed, 317 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 072bf3c..c9909e0 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -140,6 +140,13 @@ enum cmd_templ {
 				  * For CTS-to-self (FastCTS) mechanism
 				  * for BT/WLAN coexistence (SoftGemini). */
 	CMD_TEMPL_ARP_RSP,
+
+	/* AP-mode specific */
+	CMD_TEMPL_AP_BEACON = 13,
+	CMD_TEMPL_AP_PROBE_RESPONSE,
+	CMD_TEMPL_AP_ARP_RSP,
+	CMD_TEMPL_DEAUTH_AP,
+
 	CMD_TEMPL_MAX = 0xff
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 799c369..bdb6123 100644
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
 
@@ -118,6 +100,132 @@ int wl1271_init_templates_config(struct wl1271 *wl)
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
+				      wl1271_tx_min_rate_get(wl));
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
+				      wl1271_tx_min_rate_get(wl));
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
+				      wl1271_tx_min_rate_get(wl));
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
@@ -145,10 +253,6 @@ int wl1271_init_phy_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_service_period_timeout(wl);
 	if (ret < 0)
 		return ret;
@@ -213,11 +317,150 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
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
+	/* Beacons and broadcast settings */
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
@@ -227,12 +470,12 @@ int wl1271_hw_init(struct wl1271 *wl)
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
 
@@ -259,16 +502,6 @@ int wl1271_hw_init(struct wl1271 *wl)
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
@@ -279,21 +512,11 @@ int wl1271_hw_init(struct wl1271 *wl)
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
@@ -321,23 +544,13 @@ int wl1271_hw_init(struct wl1271 *wl)
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
 
@@ -346,21 +559,12 @@ int wl1271_hw_init(struct wl1271 *wl)
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
index 7762421..3a8bd3f 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -27,7 +27,7 @@
 #include "wl12xx.h"
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
-int wl1271_init_templates_config(struct wl1271 *wl);
+int wl1271_sta_init_templates_config(struct wl1271 *wl);
 int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9785b4c..67f6db4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -434,7 +434,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_init_templates_config(wl);
+	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
 
@@ -1363,24 +1363,6 @@ static void wl1271_set_band_rate(struct wl1271 *wl)
 		wl->basic_rate_set = wl->conf.tx.basic_rate_5;
 }
 
-static u32 wl1271_min_rate_get(struct wl1271 *wl)
-{
-	int i;
-	u32 rate = 0;
-
-	if (!wl->basic_rate_set) {
-		WARN_ON(1);
-		wl->basic_rate_set = wl->conf.tx.basic_rate;
-	}
-
-	for (i = 0; !rate; i++) {
-		if ((wl->basic_rate_set >> i) & 0x1)
-			rate = 1 << i;
-	}
-
-	return rate;
-}
-
 static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
 {
 	int ret;
@@ -1391,7 +1373,7 @@ static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
 			if (ret < 0)
 				goto out;
 		}
-		wl->rate_set = wl1271_min_rate_get(wl);
+		wl->rate_set = wl1271_tx_min_rate_get(wl);
 		wl->sta_rate_set = 0;
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
@@ -1467,7 +1449,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 			wl1271_set_band_rate(wl);
 
-		wl->basic_rate = wl1271_min_rate_get(wl);
+		wl->basic_rate = wl1271_tx_min_rate_get(wl);
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			wl1271_warning("rate policy for update channel "
@@ -1927,7 +1909,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
 						      beacon->data,
 						      beacon->len, 0,
-						      wl1271_min_rate_get(wl));
+						      wl1271_tx_min_rate_get(wl));
 
 			if (ret < 0) {
 				dev_kfree_skb(beacon);
@@ -1943,7 +1925,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 						      CMD_TEMPL_PROBE_RESPONSE,
 						      beacon->data,
 						      beacon->len, 0,
-						      wl1271_min_rate_get(wl));
+						      wl1271_tx_min_rate_get(wl));
 			dev_kfree_skb(beacon);
 			if (ret < 0)
 				goto out_sleep;
@@ -2016,7 +1998,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			rates = bss_conf->basic_rates;
 			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
 									 rates);
-			wl->basic_rate = wl1271_min_rate_get(wl);
+			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
@@ -2070,7 +2052,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
-			wl->basic_rate = wl1271_min_rate_get(wl);
+			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 442a7bd..a93fc47 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -521,3 +521,21 @@ void wl1271_tx_flush(struct wl1271 *wl)
 
 	wl1271_warning("Unable to flush all TX buffers, timed out.");
 }
+
+u32 wl1271_tx_min_rate_get(struct wl1271 *wl)
+{
+	int i;
+	u32 rate = 0;
+
+	if (!wl->basic_rate_set) {
+		WARN_ON(1);
+		wl->basic_rate_set = wl->conf.tx.basic_rate;
+	}
+
+	for (i = 0; !rate; i++) {
+		if ((wl->basic_rate_set >> i) & 0x1)
+			rate = 1 << i;
+	}
+
+	return rate;
+}
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 903e5dc..5ccd22e 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -146,5 +146,6 @@ void wl1271_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
+u32 wl1271_tx_min_rate_get(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index be21032..b230e72 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -160,4 +160,9 @@ struct wl12xx_probe_resp_template {
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

