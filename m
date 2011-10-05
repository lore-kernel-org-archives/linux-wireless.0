Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1JEJ4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:18 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/29] wl12xx: start reworking the init sequence
Date: Wed,  5 Oct 2011 11:55:40 +0200
Message-Id: <1317808566-18857-4-git-send-email-eliad@wizery.com> (sfid-20111005_115624_064951_8E429548)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split the init sequence into common commands (non role-specific)
and role-specific commands.

We still need to call the common commands only on add_interface()
(rather than on start()) as the fw must get the mac address
when uploading the nvs.

Future patches will refactor the init sequence further more.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c |  306 +++++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/init.h |    5 +-
 drivers/net/wireless/wl12xx/main.c |    8 +-
 3 files changed, 171 insertions(+), 148 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 4692a91..ff5c5f4 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -33,7 +33,7 @@
 #include "tx.h"
 #include "io.h"
 
-int wl1271_sta_init_templates_config(struct wl1271 *wl)
+int wl1271_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
 
@@ -88,6 +88,29 @@ int wl1271_sta_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Put very large empty placeholders for all templates. These
+	 * reserve memory for later.
+	 */
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
+				      WL1271_CMD_TEMPL_MAX_SIZE,
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_BEACON, NULL,
+				      WL1271_CMD_TEMPL_MAX_SIZE,
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
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
 					      WL1271_CMD_TEMPL_DFLT_SIZE, i,
@@ -185,68 +208,32 @@ out:
 	return ret;
 }
 
-static int wl1271_ap_init_templates_config(struct wl1271 *wl)
+static int wl12xx_init_rx_config(struct wl1271 *wl)
 {
 	int ret;
 
-	/*
-	 * Put very large empty placeholders for all templates. These
-	 * reserve memory for later.
-	 */
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
-				      WL1271_CMD_TEMPL_MAX_SIZE,
-				      0, WL1271_RATE_AUTOMATIC);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_BEACON, NULL,
-				      WL1271_CMD_TEMPL_MAX_SIZE,
-				      0, WL1271_RATE_AUTOMATIC);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP, NULL,
-				      sizeof
-				      (struct wl12xx_disconn_template),
-				      0, WL1271_RATE_AUTOMATIC);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
-				      sizeof(struct wl12xx_null_data_template),
-				      0, WL1271_RATE_AUTOMATIC);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
-				      sizeof
-				      (struct wl12xx_qos_null_data_template),
-				      0, WL1271_RATE_AUTOMATIC);
+	ret = wl1271_acx_rx_msdu_life_time(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static int wl12xx_init_rx_config(struct wl1271 *wl)
+int wl1271_init_phy_config(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_acx_rx_msdu_life_time(wl);
+	ret = wl1271_acx_pd_threshold(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl1271_init_phy_config(struct wl1271 *wl)
+static int wl12xx_init_phy_vif_config(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_acx_pd_threshold(wl);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_slot(wl, DEFAULT_SLOT_TIME);
 	if (ret < 0)
 		return ret;
@@ -329,6 +316,7 @@ static int wl12xx_init_fwlog(struct wl1271 *wl)
 	return 0;
 }
 
+/* generic sta initialization (non vif-specific) */
 static int wl1271_sta_hw_init(struct wl1271 *wl)
 {
 	int ret;
@@ -344,57 +332,20 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_sta_init_templates_config(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
-	if (ret < 0)
-		return ret;
-
-	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl, false);
-	if (ret < 0)
-		return ret;
-
-	/* Beacon filtering */
-	ret = wl1271_init_beacon_filter(wl);
-	if (ret < 0)
-		return ret;
-
 	/* FM WLAN coexistence */
 	ret = wl1271_acx_fm_coex(wl);
 	if (ret < 0)
 		return ret;
 
-	/* Beacons and broadcast settings */
-	ret = wl1271_init_beacon_broadcast(wl);
-	if (ret < 0)
-		return ret;
-
 	/* Configure for ELP power saving */
 	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
 	if (ret < 0)
 		return ret;
 
-	/* Configure rssi/snr averaging weights */
-	ret = wl1271_acx_rssi_snr_avg_weights(wl);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_sta_rate_policies(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_mem_cfg(wl);
-	if (ret < 0)
-		return ret;
-
-	/* Configure the FW logger */
-	ret = wl12xx_init_fwlog(wl);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
@@ -418,14 +369,11 @@ static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
 	return 0;
 }
 
+/* generic ap initialization (non vif-specific) */
 static int wl1271_ap_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_ap_init_templates_config(wl);
-	if (ret < 0)
-		return ret;
-
 	/* Configure for power always on */
 	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
 	if (ret < 0)
@@ -435,19 +383,6 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_ap_max_tx_retry(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_mem_cfg(wl);
-	if (ret < 0)
-		return ret;
-
-	/* initialize Tx power */
-	ret = wl1271_acx_tx_power(wl, wl->power_level);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
@@ -578,14 +513,133 @@ out:
 	return ret;
 }
 
+/* vif-specifc initialization */
+int wl12xx_init_sta_role(struct wl1271 *wl, struct ieee80211_vif *vif)
+{
+	int ret;
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
+	/* Beacons and broadcast settings */
+	ret = wl1271_init_beacon_broadcast(wl);
+	if (ret < 0)
+		return ret;
 
-int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif)
+	/* Configure rssi/snr averaging weights */
+	ret = wl1271_acx_rssi_snr_avg_weights(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* vif-specific intialization */
+int wl12xx_init_ap_role(struct wl1271 *wl, struct ieee80211_vif *vif)
+{
+	int ret;
+
+	ret = wl1271_acx_ap_max_tx_retry(wl);
+	if (ret < 0)
+		return ret;
+
+	/* initialize Tx power */
+	ret = wl1271_acx_tx_power(wl, wl->power_level);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
-	int ret, i;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
+	int ret, i;
+
+	/* Mode specific init */
+	if (is_ap) {
+		ret = wl1271_ap_hw_init(wl);
+		if (ret < 0)
+			return ret;
+
+		ret = wl12xx_init_ap_role(wl, vif);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = wl1271_sta_hw_init(wl);
+		if (ret < 0)
+			return ret;
+
+		ret = wl12xx_init_sta_role(wl, vif);
+		if (ret < 0)
+			return ret;
+	}
+
+	wl12xx_init_phy_vif_config(wl);
+
+	/* Default TID/AC configuration */
+	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
+	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		conf_ac = &wl->conf.tx.ac_conf[i];
+		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+					conf_ac->cw_max, conf_ac->aifsn,
+					conf_ac->tx_op_limit);
+		if (ret < 0)
+			return ret;
+
+		conf_tid = &wl->conf.tx.tid_conf[i];
+		ret = wl1271_acx_tid_cfg(wl,
+					 conf_tid->queue_id,
+					 conf_tid->channel_type,
+					 conf_tid->tsid,
+					 conf_tid->ps_scheme,
+					 conf_tid->ack_policy,
+					 conf_tid->apsd_conf[0],
+					 conf_tid->apsd_conf[1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Configure HW encryption */
+	ret = wl1271_acx_feature_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Mode specific init - post mem init */
+	if (is_ap)
+		ret = wl1271_ap_hw_init_post_mem(wl, vif);
+	else
+		ret = wl1271_sta_hw_init_post_mem(wl);
+
+	if (ret < 0)
+		return ret;
+
+	/* Configure initiator BA sessions policies */
+	ret = wl1271_set_ba_policies(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl1271_hw_init(struct wl1271 *wl)
+{
+	int ret;
+
 	if (wl->chip.id == CHIP_ID_1283_PG20)
 		ret = wl128x_cmd_general_parms(wl);
 	else
@@ -605,12 +659,17 @@ int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif)
 	if (ret < 0)
 		return ret;
 
-	/* Mode specific init */
-	if (is_ap)
-		ret = wl1271_ap_hw_init(wl);
-	else
-		ret = wl1271_sta_hw_init(wl);
+	/* Init templates */
+	ret = wl1271_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
 
+	ret = wl12xx_acx_mem_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Configure the FW logger */
+	ret = wl12xx_init_fwlog(wl);
 	if (ret < 0)
 		return ret;
 
@@ -658,61 +717,20 @@ int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Default TID/AC configuration */
-	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
-	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
-		conf_ac = &wl->conf.tx.ac_conf[i];
-		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
-					conf_ac->cw_max, conf_ac->aifsn,
-					conf_ac->tx_op_limit);
-		if (ret < 0)
-			goto out_free_memmap;
-
-		conf_tid = &wl->conf.tx.tid_conf[i];
-		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
-					 conf_tid->channel_type,
-					 conf_tid->tsid,
-					 conf_tid->ps_scheme,
-					 conf_tid->ack_policy,
-					 conf_tid->apsd_conf[0],
-					 conf_tid->apsd_conf[1]);
-		if (ret < 0)
-			goto out_free_memmap;
-	}
-
 	/* Enable data path */
 	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Configure HW encryption */
-	ret = wl1271_acx_feature_cfg(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* configure PM */
 	ret = wl1271_acx_pm_config(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Mode specific init - post mem init */
-	if (is_ap)
-		ret = wl1271_ap_hw_init_post_mem(wl, vif);
-	else
-		ret = wl1271_sta_hw_init_post_mem(wl);
-
-	if (ret < 0)
-		goto out_free_memmap;
-
 	ret = wl12xx_acx_set_rate_mgmt_params(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Configure initiator BA sessions policies */
-	ret = wl1271_set_ba_policies(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	/* configure hangover */
 	ret = wl12xx_acx_config_hangover(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index b1f97bc..64320c0 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -27,12 +27,13 @@
 #include "wl12xx.h"
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
-int wl1271_sta_init_templates_config(struct wl1271 *wl);
+int wl1271_init_templates_config(struct wl1271 *wl);
 int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
-int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif);
+int wl1271_hw_init(struct wl1271 *wl);
+int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl1271_init_ap_rates(struct wl1271 *wl);
 int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d676794..28f47e0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -676,7 +676,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_sta_init_templates_config(wl);
+	ret = wl1271_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
 
@@ -1919,6 +1919,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto power_off;
 
+		ret = wl1271_hw_init(wl);
+		if (ret < 0)
+			goto irq_disable;
+
 		if (wl->bss_type == BSS_TYPE_STA_BSS ||
 		    wl->bss_type == BSS_TYPE_IBSS) {
 			/*
@@ -1939,7 +1943,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto irq_disable;
 
-		ret = wl1271_hw_init(wl, vif);
+		ret = wl1271_init_vif_specific(wl, vif);
 		if (ret < 0)
 			goto irq_disable;
 
-- 
1.7.6.401.g6a319

