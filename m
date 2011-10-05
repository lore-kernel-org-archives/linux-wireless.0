Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35968 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1JEJ5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:57:16 -0400
Received: by wyg34 with SMTP id 34so1496754wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:57:15 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 21/29] wl12xx: move beacon_int into wlvif
Date: Wed,  5 Oct 2011 11:55:58 +0200
Message-Id: <1317808566-18857-22-git-send-email-eliad@wizery.com> (sfid-20111005_121655_680808_2C93537E)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move beacon_int into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |    6 +++---
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/main.c    |    5 +++--
 drivers/net/wireless/wl12xx/wl12xx.h  |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index c2066a4..911f720 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -573,7 +573,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
-	cmd->sta.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->sta.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
 	cmd->sta.ssid_len = wlvif->ssid_len;
 	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
@@ -684,7 +684,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.global_hlid = wlvif->ap.global_hlid;
 	cmd->ap.broadcast_hlid = wlvif->ap.bcast_hlid;
 	cmd->ap.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
-	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->ap.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	cmd->channel = wl->channel;
@@ -787,7 +787,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
-	cmd->ibss.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->ibss.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ibss.dtim_interval = bss_conf->dtim_period;
 	cmd->ibss.ssid_type = WL12XX_SSID_TYPE_ANY;
 	cmd->ibss.ssid_len = wlvif->ssid_len;
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index d8d8568..439db1f 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -351,7 +351,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
-	DRIVER_STATE_PRINT_INT(beacon_int);
 	DRIVER_STATE_PRINT_INT(psm_entry_retry);
 	DRIVER_STATE_PRINT_INT(ps_poll_failures);
 	DRIVER_STATE_PRINT_INT(power_level);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1bdb78d..54c146a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1900,6 +1900,8 @@ static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
+	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
+
 	return 0;
 }
 
@@ -3281,7 +3283,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		wl1271_debug(DEBUG_MASTER, "beacon interval updated: %d",
 			bss_conf->beacon_int);
 
-		wl->beacon_int = bss_conf->beacon_int;
+		wlvif->beacon_int = bss_conf->beacon_int;
 	}
 
 	if ((changed & BSS_CHANGED_BEACON)) {
@@ -4848,7 +4850,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	}
 
 	wl->channel = WL1271_DEFAULT_CHANNEL;
-	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
 	wl->rx_counter = 0;
 	wl->psm_entry_retry = 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 567b09d..3646410 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -502,9 +502,6 @@ struct wl1271 {
 	/* The current band */
 	enum ieee80211_band band;
 
-	/* Beaconing interval (needed for ad-hoc) */
-	u32 beacon_int;
-
 	/* Default key (for WEP) */
 	u32 default_key;
 
@@ -644,6 +641,9 @@ struct wl12xx_vif {
 	/* probe-req template for the current AP */
 	struct sk_buff *probereq;
 
+	/* Beaconing interval (needed for ad-hoc) */
+	u32 beacon_int;
+
 	/* Our association ID */
 	u16 aid;
 
-- 
1.7.6.401.g6a319

