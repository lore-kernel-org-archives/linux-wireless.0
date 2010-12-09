Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:60887 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0LIO57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:57:59 -0500
Received: by fxm18 with SMTP id 18so2484006fxm.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:57:57 -0800 (PST)
From: Guy Eilam <guy@wizery.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [PATCH] wl1271: fixed problem with WPS IEs in probe requests
Date: Thu,  9 Dec 2010 16:54:59 +0200
Message-Id: <1291906499-21141-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inclusion of a WPS IE in probe requests caused a problem
in the driver due to the maximum size of the probe request
template and the max_scan_ie_len values at initialization.

Increased the size of probe request template
to the maximum size allowed by the firmware.
Struct wl12xx_probe_req_template, which was only used
for calculating the max size of the probe request template,
is no longer used and needed.

max_scan_ie_len is used for validating the size of
additional IEs in scan requests.
Initialized the max_scan_ie_len field to the maximum size
of the probe request template minus the ieee80211 header size.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c         |    6 ++----
 drivers/net/wireless/wl12xx/main.c         |    7 +++++++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    8 --------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 8a4e80d..68db4da 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -53,18 +53,16 @@ static int wl1271_init_hwenc_config(struct wl1271 *wl)
 int wl1271_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
-	size_t size;
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
-				      sizeof(struct wl12xx_probe_req_template),
+				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	size = sizeof(struct wl12xx_probe_req_template);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-				      NULL, size, 0,
+				      NULL, WL1271_CMD_TEMPL_MAX_SIZE, 0,
 				      WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7fecefe..81c8d66 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2654,6 +2654,13 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
+	/*
+	 * Maximum length of elements in scanning probe request templates
+	 * should be the maximum length possible for a template, without
+	 * the IEEE80211 header of the template
+	 */
+	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
+			sizeof(struct ieee80211_header);
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
 	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 1846280..00c9627 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -133,14 +133,6 @@ struct wl12xx_qos_null_data_template {
 	__le16 qos_ctl;
 } __packed;
 
-struct wl12xx_probe_req_template {
-	struct ieee80211_header header;
-	struct wl12xx_ie_ssid ssid;
-	struct wl12xx_ie_rates rates;
-	struct wl12xx_ie_rates ext_rates;
-} __packed;
-
-
 struct wl12xx_probe_resp_template {
 	struct ieee80211_header header;
 	__le32 time_stamp[2];
-- 
1.7.1

