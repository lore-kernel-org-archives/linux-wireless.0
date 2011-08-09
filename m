Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1HIJN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:57 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/40] wl12xx: wl12xx-fw-3 - change max/default template size
Date: Tue,  9 Aug 2011 12:13:26 +0300
Message-Id: <1312881233-9366-14-git-send-email-eliad@wizery.com> (sfid-20110809_111401_041649_A2D92A04)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The max template size was increased in the new fw.
However, we should use the max size only when needed, as it
consumes some of the chip's memory.

Thus, by default initialize the templates to the default size.
Initialize to the maximum size only when required.

Use WL1271_CMD_TEMPL_DFLT_SIZE instead of some of the
predefined structs, as some of them didn't account
for additional IEs that might be added to the template.

Delete structs defintions not used after these changes.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.h          |    3 ++-
 drivers/net/wireless/wl12xx/init.c         |   18 +++++++-----------
 drivers/net/wireless/wl12xx/main.c         |    2 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   25 -------------------------
 4 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index b948677..3734244 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -169,13 +169,14 @@ enum cmd_templ {
 
 	CMD_TEMPL_MAX = 0xff
 };
 
 /* unit ms */
 #define WL1271_COMMAND_TIMEOUT     2000
-#define WL1271_CMD_TEMPL_MAX_SIZE  252
+#define WL1271_CMD_TEMPL_DFLT_SIZE 252
+#define WL1271_CMD_TEMPL_MAX_SIZE  548
 #define WL1271_EVENT_TIMEOUT       750
 
 struct wl1271_cmd_header {
 	__le16 id;
 	__le16 status;
 	/* payload */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 0fdaba9..c733a63 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -36,19 +36,19 @@
 int wl1271_sta_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
-				      WL1271_CMD_TEMPL_MAX_SIZE,
+				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-				      NULL, WL1271_CMD_TEMPL_MAX_SIZE, 0,
+				      NULL, WL1271_CMD_TEMPL_DFLT_SIZE, 0,
 				      WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template),
@@ -67,21 +67,19 @@ int wl1271_sta_init_templates_config(struct wl1271 *wl)
 				      (struct wl12xx_qos_null_data_template),
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE, NULL,
-				      sizeof
-				      (struct wl12xx_probe_resp_template),
+				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON, NULL,
-				      sizeof
-				      (struct wl12xx_beacon_template),
+				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP, NULL,
 				      sizeof
@@ -89,13 +87,13 @@ int wl1271_sta_init_templates_config(struct wl1271 *wl)
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
-					      WL1271_CMD_TEMPL_MAX_SIZE, i,
+					      WL1271_CMD_TEMPL_DFLT_SIZE, i,
 					      WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
 			return ret;
 	}
 
 	return 0;
@@ -188,21 +186,19 @@ static int wl1271_ap_init_templates_config(struct wl1271 *wl)
 
 	/*
 	 * Put very large empty placeholders for all templates. These
 	 * reserve memory for later.
 	 */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
-				      sizeof
-				      (struct wl12xx_probe_resp_template),
+				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_BEACON, NULL,
-				      sizeof
-				      (struct wl12xx_beacon_template),
+				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP, NULL,
 				      sizeof
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d254f2b..491c904f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4244,13 +4244,13 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	/*
 	 * Maximum length of elements in scanning probe request templates
 	 * should be the maximum length possible for a template, without
 	 * the IEEE80211 header of the template
 	 */
-	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
+	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
 			sizeof(struct ieee80211_header);
 
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
 		     ARRAY_SIZE(wl1271_channels_5ghz) >
 		     WL1271_MAX_CHANNELS);
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 18fe542..209aa8c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -102,24 +102,12 @@ struct wl12xx_ie_country {
 	struct country_triplet triplets[MAX_COUNTRY_TRIPLETS];
 } __packed;
 
 
 /* Templates */
 
-struct wl12xx_beacon_template {
-	struct ieee80211_header header;
-	__le32 time_stamp[2];
-	__le16 beacon_interval;
-	__le16 capability;
-	struct wl12xx_ie_ssid ssid;
-	struct wl12xx_ie_rates rates;
-	struct wl12xx_ie_rates ext_rates;
-	struct wl12xx_ie_ds_params ds_params;
-	struct wl12xx_ie_country country;
-} __packed;
-
 struct wl12xx_null_data_template {
 	struct ieee80211_header header;
 } __packed;
 
 struct wl12xx_ps_poll_template {
 	__le16 fc;
@@ -143,25 +131,12 @@ struct wl12xx_arp_rsp_template {
 	u8 sender_hw[ETH_ALEN];
 	__be32 sender_ip;
 	u8 target_hw[ETH_ALEN];
 	__be32 target_ip;
 } __packed;
 
-
-struct wl12xx_probe_resp_template {
-	struct ieee80211_header header;
-	__le32 time_stamp[2];
-	__le16 beacon_interval;
-	__le16 capability;
-	struct wl12xx_ie_ssid ssid;
-	struct wl12xx_ie_rates rates;
-	struct wl12xx_ie_rates ext_rates;
-	struct wl12xx_ie_ds_params ds_params;
-	struct wl12xx_ie_country country;
-} __packed;
-
 struct wl12xx_disconn_template {
 	struct ieee80211_header header;
 	__le16 disconn_reason;
 } __packed;
 
 #endif
-- 
1.7.6.401.g6a319

