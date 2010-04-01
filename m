Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51491 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab0DAIjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:39:04 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] wl1271: Configure a higher listen interval to AP upon association
Date: Thu,  1 Apr 2010 11:38:22 +0300
Message-Id: <1270111104-29549-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Increase the fixed listen-interval max value configured to the mac80211 on
driver init. This value will allow a larger value to be configured to the
AP, which means the AP will buffer our frames longer.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_conf.h |    7 +++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 0b34b62..d76ae03 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -977,6 +977,13 @@ struct conf_conn_settings {
 	 * Range: 1000 - 3600000
 	 */
 	u32 keep_alive_interval;
+
+	/*
+	 * Maximum listen interval supported by the driver in units of beacons.
+	 *
+	 * Range: u16
+	 */
+	u8 max_listen_interval;
 };
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 247f407..5c32d8d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -219,7 +219,7 @@ static struct conf_drv_settings default_conf = {
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
-		.listen_interval             = 0,
+		.listen_interval             = 1,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
 		.bcn_filt_ie_count           = 1,
 		.bcn_filt_ie = {
@@ -266,7 +266,8 @@ static struct conf_drv_settings default_conf = {
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
 		.psm_entry_retries           = 3,
-		.keep_alive_interval         = 55000
+		.keep_alive_interval         = 55000,
+		.max_listen_interval         = 20,
 	},
 	.init = {
 		.radioparam = {
@@ -2253,6 +2254,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	/* unit us */
 	/* FIXME: find a proper value */
 	wl->hw->channel_change_time = 10000;
+	wl->hw->max_listen_interval = wl->conf.conn.max_listen_interval;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
-- 
1.6.3.3

