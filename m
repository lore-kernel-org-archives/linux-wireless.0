Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940AbXHUPOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:14:31 -0400
Message-Id: <20070821150048.770743000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 20/27] mac80211: remove unused ioctls (1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls

 * PRISM2_PARAM_HOST_ENCRYPT
 * PRISM2_PARAM_HOST_DECRYPT
 * PRISM2_PARAM_ANTENNA_MODE
 * PRISM2_PARAM_STAT_TIME

are not used by hostapd or wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |    3 --
 net/mac80211/hostapd_ioctl.h   |    4 ---
 net/mac80211/ieee80211.c       |   42 -----------------------------------------
 net/mac80211/ieee80211_i.h     |    2 -
 net/mac80211/ieee80211_ioctl.c |   28 ---------------------------
 5 files changed, 79 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 15:42:23.335923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 15:42:24.645923881 +0200
@@ -28,8 +28,6 @@ enum {
 	PRISM2_PARAM_BEACON_INT = 3,
 	PRISM2_PARAM_AP_BRIDGE_PACKETS = 10,
 	PRISM2_PARAM_DTIM_PERIOD = 11,
-	PRISM2_PARAM_HOST_ENCRYPT = 17,
-	PRISM2_PARAM_HOST_DECRYPT = 18,
 	PRISM2_PARAM_IEEE_802_1X = 23,
 
 	/* Instant802 additions */
@@ -37,10 +35,8 @@ enum {
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
-	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
-	PRISM2_PARAM_STAT_TIME = 1016,
 	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
 	PRISM2_PARAM_TX_POWER_REDUCTION = 1022,
 	PRISM2_PARAM_EAPOL = 1023,
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-21 15:42:23.375923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-21 15:42:24.645923881 +0200
@@ -590,8 +590,6 @@ struct ieee80211_local {
 
 	u32 channel_use;
 	u32 channel_use_raw;
-	u32 stat_time;
-	struct timer_list stat_timer;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct work_struct sta_debugfs_add;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:42:23.465923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:42:24.655923881 +0200
@@ -2113,12 +2113,6 @@ static int ieee80211_ioctl_prism2_param(
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (param) {
-	case PRISM2_PARAM_HOST_ENCRYPT:
-	case PRISM2_PARAM_HOST_DECRYPT:
-		/* TODO: implement these; return success now to prevent
-		 * hostapd from aborting */
-		break;
-
 	case PRISM2_PARAM_BEACON_INT:
 		local->hw.conf.beacon_int = value;
 		if (ieee80211_hw_config(local))
@@ -2167,15 +2161,6 @@ static int ieee80211_ioctl_prism2_param(
 		}
 		break;
 
-	case PRISM2_PARAM_STAT_TIME:
-		if (!local->stat_time && value) {
-			local->stat_timer.expires = jiffies + HZ * value / 100;
-			add_timer(&local->stat_timer);
-		} else if (local->stat_time && !value) {
-			del_timer_sync(&local->stat_timer);
-		}
-		local->stat_time = value;
-		break;
 	case PRISM2_PARAM_SHORT_SLOT_TIME:
 		if (value)
 			local->hw.conf.flags |= IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -2195,12 +2180,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->next_mode = value;
 		break;
 
-	case PRISM2_PARAM_ANTENNA_MODE:
-		local->hw.conf.antenna_mode = value;
-		if (ieee80211_hw_config(local))
-			ret = -EINVAL;
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		if ((value < 0) || (value > 1))
 			ret = -EINVAL;
@@ -2353,9 +2332,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = sdata->short_preamble;
 		break;
 
-	case PRISM2_PARAM_STAT_TIME:
-		*param = local->stat_time;
-		break;
 	case PRISM2_PARAM_SHORT_SLOT_TIME:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME);
 		break;
@@ -2364,10 +2340,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->next_mode;
 		break;
 
-	case PRISM2_PARAM_ANTENNA_MODE:
-		*param = local->hw.conf.antenna_mode;
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SSID_HIDDEN);
 		break;
--- wireless-dev.orig/include/net/mac80211.h	2007-08-21 15:42:23.615923881 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-21 15:42:24.655923881 +0200
@@ -302,9 +302,6 @@ struct ieee80211_conf {
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
-	int antenna_def;
-	int antenna_mode;
-
 	/* Following five fields are used for IEEE 802.11H */
 	unsigned int radar_detect;
 	unsigned int spect_mgmt;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-21 15:42:23.505923881 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-21 15:42:24.665923881 +0200
@@ -788,42 +788,6 @@ struct dev_mc_list *ieee80211_get_mc_lis
 }
 EXPORT_SYMBOL(ieee80211_get_mc_list_item);
 
-static void ieee80211_stat_refresh(unsigned long data)
-{
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
-	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
-
-	if (!local->stat_time)
-		return;
-
-	/* go through all stations */
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		sta->channel_use = (sta->channel_use_raw / local->stat_time) /
-			CHAN_UTIL_PER_10MS;
-		sta->channel_use_raw = 0;
-	}
-	read_unlock_bh(&local->sta_lock);
-
-	/* go through all subinterfaces */
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		sdata->channel_use = (sdata->channel_use_raw /
-				      local->stat_time) / CHAN_UTIL_PER_10MS;
-		sdata->channel_use_raw = 0;
-	}
-	read_unlock(&local->sub_if_lock);
-
-	/* hardware interface */
-	local->channel_use = (local->channel_use_raw /
-			      local->stat_time) / CHAN_UTIL_PER_10MS;
-	local->channel_use_raw = 0;
-
-	local->stat_timer.expires = jiffies + HZ * local->stat_time / 100;
-	add_timer(&local->stat_timer);
-}
-
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb,
 				 struct ieee80211_tx_status *status)
@@ -1262,9 +1226,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	INIT_LIST_HEAD(&local->sub_if_list);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
-	init_timer(&local->stat_timer);
-	local->stat_timer.function = ieee80211_stat_refresh;
-	local->stat_timer.data = (unsigned long) local;
 	ieee80211_rx_bss_list_init(mdev);
 
 	sta_info_init(local);
@@ -1463,9 +1424,6 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
-	if (local->stat_time)
-		del_timer_sync(&local->stat_timer);
-
 	ieee80211_rx_bss_list_deinit(local->mdev);
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);

-- 

