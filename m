Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763026AbXHOO4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:56:50 -0400
Message-Id: <20070815145045.573029000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 09/20] mac80211: remove unused ioctls (4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls
 * PRISM2_PARAM_RADAR_DETECT
 * PRISM2_PARAM_SPECTRUM_MGMT
 * PRISM2_HOSTAPD_MLME
 * PRISM2_HOSTAPD_SET_RADAR_PARAMS
 * PRISM2_HOSTAPD_SET_QUIET_PARAMS

are not used by hostapd or wpa_supplicant,

 * PRISM2_HOSTAPD_WPA_TRIGGER

was not in use any more since the wpa trigger moved into
debugfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h         |   13 --------
 net/mac80211/debugfs.c         |    4 --
 net/mac80211/hostapd_ioctl.h   |   24 --------------
 net/mac80211/ieee80211_i.h     |    1 
 net/mac80211/ieee80211_ioctl.c |   66 -----------------------------------------
 5 files changed, 108 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs.c	2007-08-15 14:08:02.996516958 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-08-15 14:09:54.916516958 +0200
@@ -100,8 +100,6 @@ DEBUGFS_READONLY_FILE(channel, 20, "%d",
 		      local->hw.conf.channel);
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
 		      local->hw.conf.freq);
-DEBUGFS_READONLY_FILE(radar_detect, 20, "%d",
-		      local->hw.conf.radar_detect);
 DEBUGFS_READONLY_FILE(antenna_sel_tx, 20, "%d",
 		      local->hw.conf.antenna_sel_tx);
 DEBUGFS_READONLY_FILE(antenna_sel_rx, 20, "%d",
@@ -332,7 +330,6 @@ void debugfs_hw_add(struct ieee80211_loc
 
 	DEBUGFS_ADD(channel);
 	DEBUGFS_ADD(frequency);
-	DEBUGFS_ADD(radar_detect);
 	DEBUGFS_ADD(antenna_sel_tx);
 	DEBUGFS_ADD(antenna_sel_rx);
 	DEBUGFS_ADD(bridge_packets);
@@ -397,7 +394,6 @@ void debugfs_hw_del(struct ieee80211_loc
 {
 	DEBUGFS_DEL(channel);
 	DEBUGFS_DEL(frequency);
-	DEBUGFS_DEL(radar_detect);
 	DEBUGFS_DEL(antenna_sel_tx);
 	DEBUGFS_DEL(antenna_sel_rx);
 	DEBUGFS_DEL(bridge_packets);
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:08:54.636516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:16:10.676516958 +0200
@@ -39,8 +39,6 @@ enum {
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
-	PRISM2_PARAM_RADAR_DETECT = 1043,
-	PRISM2_PARAM_SPECTRUM_MGMT = 1044,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
 	PRISM2_PARAM_MGMT_IF = 1046,
 };
@@ -56,12 +54,10 @@ enum {
 	PRISM2_SET_ENCRYPTION = 6,
 	PRISM2_GET_ENCRYPTION = 7,
 	PRISM2_HOSTAPD_SET_FLAGS_STA = 8,
-	PRISM2_HOSTAPD_MLME = 13,
 
 	/* Instant802 additions */
 	PRISM2_HOSTAPD_SET_BEACON = 1001,
 	PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
-	PRISM2_HOSTAPD_WPA_TRIGGER = 1004,
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
 	PRISM2_HOSTAPD_ADD_IF = 1006,
 	PRISM2_HOSTAPD_REMOVE_IF = 1007,
@@ -76,8 +72,6 @@ enum {
 	PRISM2_HOSTAPD_SCAN_REQ = 1019,
 	PRISM2_STA_GET_STATE = 1020,
 	PRISM2_HOSTAPD_FLUSH_IFS = 1021,
-	PRISM2_HOSTAPD_SET_RADAR_PARAMS = 1023,
-	PRISM2_HOSTAPD_SET_QUIET_PARAMS = 1024,
 };
 
 #define PRISM2_HOSTAPD_MAX_BUF_SIZE 2048
@@ -220,24 +214,6 @@ struct prism2_hostapd_param {
 			u32 state;
 		} sta_get_state;
 		struct {
-#define MLME_STA_DEAUTH 0
-#define MLME_STA_DISASSOC 1
-			u16 cmd;
-			u16 reason_code;
-		} mlme;
-		struct {
-			u8 radar_firpwr_threshold;
-			u8 radar_rssi_threshold;
-			u8 pulse_height_threshold;
-			u8 pulse_rssi_threshold;
-			u8 pulse_inband_threshold;
-		} radar;
-		struct {
-			unsigned int period;
-			unsigned int offset;
-			unsigned int duration;
-		} quiet;
-		struct {
 			u8 dummy[80]; /* Make sizeof() this struct large enough
 				       * with some compiler versions. */
 		} dummy;
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 14:08:54.646516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 14:14:43.776516958 +0200
@@ -635,7 +635,6 @@ struct ieee80211_local {
 	struct local_debugfsdentries {
 		struct dentry *channel;
 		struct dentry *frequency;
-		struct dentry *radar_detect;
 		struct dentry *antenna_sel_tx;
 		struct dentry *antenna_sel_rx;
 		struct dentry *bridge_packets;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:09:31.376516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:16:10.736516958 +0200
@@ -1031,29 +1031,6 @@ static int ieee80211_ioctl_sta_get_state
 }
 
 
-static int ieee80211_ioctl_mlme(struct net_device *dev,
-				struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
-
-	if (local->user_space_mlme)
-		return -EOPNOTSUPP;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS)
-		return -EINVAL;
-	switch (param->u.mlme.cmd) {
-	case MLME_STA_DEAUTH:
-		return ieee80211_sta_deauthenticate(dev, param->u.mlme.reason_code);
-	case MLME_STA_DISASSOC:
-		return ieee80211_sta_disassociate(dev, param->u.mlme.reason_code);
-	}
-	return 0;
-}
-
-
 static int ieee80211_ioctl_get_load_stats(struct net_device *dev,
 					  struct prism2_hostapd_param *param)
 {
@@ -1240,34 +1217,6 @@ found:
 }
 
 
-static int ieee80211_ioctl_set_quiet_params(struct net_device *dev,
-					    struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
-
-	conf->quiet_duration = param->u.quiet.duration;
-	conf->quiet_offset = param->u.quiet.offset;
-	conf->quiet_period = param->u.quiet.period;
-	return 0;
-}
-
-
-static int ieee80211_ioctl_set_radar_params(struct net_device *dev,
-					    struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
-
-	conf->radar_firpwr_threshold = param->u.radar.radar_firpwr_threshold;
-	conf->radar_rssi_threshold = param->u.radar.radar_rssi_threshold;
-	conf->pulse_height_threshold = param->u.radar.pulse_height_threshold;
-	conf->pulse_rssi_threshold = param->u.radar.pulse_rssi_threshold;
-	conf->pulse_inband_threshold = param->u.radar.pulse_inband_threshold;
-	return 0;
-}
-
-
 static int ieee80211_ioctl_priv_hostapd(struct net_device *dev,
 					struct iw_point *p)
 {
@@ -1360,15 +1309,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_STA_GET_STATE:
 		ret = ieee80211_ioctl_sta_get_state(dev, param);
 		break;
-	case PRISM2_HOSTAPD_MLME:
-		ret = ieee80211_ioctl_mlme(dev, param);
-		break;
-	case PRISM2_HOSTAPD_SET_RADAR_PARAMS:
-		ret = ieee80211_ioctl_set_radar_params(dev, param);
-		break;
-	case PRISM2_HOSTAPD_SET_QUIET_PARAMS:
-		ret = ieee80211_ioctl_set_quiet_params(dev, param);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -2206,12 +2146,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->key_tx_rx_threshold = value;
 		break;
 
-	case PRISM2_PARAM_RADAR_DETECT:
-		local->hw.conf.radar_detect = value;
-		break;
-	case PRISM2_PARAM_SPECTRUM_MGMT:
-		local->hw.conf.spect_mgmt = value;
-		break;
 	case PRISM2_PARAM_MGMT_IF:
 		if (value == 1) {
 			if (!local->apdev)
--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:08:02.996516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:09:54.926516958 +0200
@@ -298,19 +298,6 @@ struct ieee80211_conf {
 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
-
-	/* Following five fields are used for IEEE 802.11H */
-	unsigned int radar_detect;
-	unsigned int spect_mgmt;
-	unsigned int quiet_duration; /* duration of quiet period */
-	unsigned int quiet_offset; /* how far into the beacon is the quiet
-				    * period */
-	unsigned int quiet_period;
-	u8 radar_firpwr_threshold;
-	u8 radar_rssi_threshold;
-	u8 pulse_height_threshold;
-	u8 pulse_rssi_threshold;
-	u8 pulse_inband_threshold;
 };
 
 /**

-- 

