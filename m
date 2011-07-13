Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab1GMIlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:37 -0400
Message-Id: <20110713084034.911957622@sipsolutions.net> (sfid-20110713_104145_459743_1BD8294C)
Date: Wed, 13 Jul 2011 10:39:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] wl1251: remove wext dependencies
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This driver uses IW_ESSID_MAX_SIZE when it should
be using IEEE80211_MAX_SSID_LEN instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/wl1251/cmd.h          |    2 +-
 drivers/net/wireless/wl1251/wl12xx_80211.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/wl1251/cmd.h	2011-07-13 10:22:47.000000000 +0200
+++ b/drivers/net/wireless/wl1251/cmd.h	2011-07-13 10:22:50.000000000 +0200
@@ -269,7 +269,7 @@ struct cmd_join {
 	u8 bss_type;
 	u8 channel;
 	u8 ssid_len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ctrl; /* JOIN_CMD_CTRL_* */
 	u8 tx_mgt_frame_rate; /* OBSOLETE */
 	u8 tx_mgt_frame_mod;  /* OBSOLETE */
--- a/drivers/net/wireless/wl1251/wl12xx_80211.h	2011-07-13 10:22:47.000000000 +0200
+++ b/drivers/net/wireless/wl1251/wl12xx_80211.h	2011-07-13 10:22:50.000000000 +0200
@@ -76,7 +76,7 @@ struct wl12xx_ie_header {
 
 struct wl12xx_ie_ssid {
 	struct wl12xx_ie_header header;
-	char ssid[IW_ESSID_MAX_SIZE];
+	char ssid[IEEE80211_MAX_SSID_LEN];
 } __packed;
 
 struct wl12xx_ie_rates {


