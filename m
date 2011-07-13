Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092Ab1GMIle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:34 -0400
Message-Id: <20110713084034.328005382@sipsolutions.net> (sfid-20110713_104138_297844_C6CDE848)
Date: Wed, 13 Jul 2011 10:39:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] wl12xx: remove wext dependencies
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This driver uses IW_ESSID_MAX_SIZE when it should
be using IEEE80211_MAX_SSID_LEN instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/wl12xx/cmd.h          |    4 ++--
 drivers/net/wireless/wl12xx/main.c         |    2 +-
 drivers/net/wireless/wl12xx/scan.h         |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx.h       |    4 ++--
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/wl12xx/cmd.h	2011-07-13 10:22:17.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/cmd.h	2011-07-13 10:22:22.000000000 +0200
@@ -239,7 +239,7 @@ struct wl1271_cmd_join {
 	u8 bss_type;
 	u8 channel;
 	u8 ssid_len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ctrl; /* JOIN_CMD_CTRL_* */
 	u8 reserved[3];
 } __packed;
@@ -528,7 +528,7 @@ struct wl1271_cmd_bss_start {
 	/* wl1271_ssid_type */
 	u8 ssid_type;
 	u8 ssid_len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 padding_1[2];
 
 	/* Basic rate set */
--- a/drivers/net/wireless/wl12xx/main.c	2011-07-13 10:22:17.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/main.c	2011-07-13 10:22:22.000000000 +0200
@@ -1997,7 +1997,7 @@ static void __wl1271_op_remove_interface
 	wl1271_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
+	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
 	wl->ssid_len = 0;
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
--- a/drivers/net/wireless/wl12xx/scan.h	2011-07-13 10:22:17.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/scan.h	2011-07-13 10:22:22.000000000 +0200
@@ -77,7 +77,7 @@ struct basic_scan_params {
 	u8 ssid_len;
 	/* in order to align */
 	u8 padding1[2];
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	/* Band to scan */
 	u8 band;
 	u8 use_ssid_list;
@@ -167,7 +167,7 @@ struct wl1271_cmd_sched_scan_config {
 	u8 filter_type;
 
 	u8 ssid_len;     /* For SCAN_SSID_FILTER_SPECIFIC */
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 
 	u8 n_probe_reqs; /* Number of probes requests per channel */
 
@@ -194,7 +194,7 @@ enum {
 struct wl1271_ssid {
 	u8 type;
 	u8 len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	/* u8 padding[2]; */
 } __packed;
 
--- a/drivers/net/wireless/wl12xx/wl12xx.h	2011-07-13 10:22:17.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/wl12xx.h	2011-07-13 10:22:22.000000000 +0200
@@ -309,7 +309,7 @@ struct wl1271_scan {
 	unsigned long scanned_ch[BITS_TO_LONGS(WL1271_MAX_CHANNELS)];
 	bool failed;
 	u8 state;
-	u8 ssid[IW_ESSID_MAX_SIZE+1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN+1];
 	size_t ssid_len;
 };
 
@@ -415,7 +415,7 @@ struct wl1271 {
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
 	u8 set_bss_type;
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 	int channel;
 
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h	2011-07-13 10:22:17.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h	2011-07-13 10:22:22.000000000 +0200
@@ -77,7 +77,7 @@ struct wl12xx_ie_header {
 
 struct wl12xx_ie_ssid {
 	struct wl12xx_ie_header header;
-	char ssid[IW_ESSID_MAX_SIZE];
+	char ssid[IEEE80211_MAX_SSID_LEN];
 } __packed;
 
 struct wl12xx_ie_rates {


