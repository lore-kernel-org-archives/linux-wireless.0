Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951AbXHOOzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:55:20 -0400
Message-Id: <20070815145043.551508000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/20] mac80211: remove unused ioctls (1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls

 * PRISM2_PARAM_WIFI_WME_NOACK_TEST
 * PRISM2_PARAM_HOST_ENCRYPT
 * PRISM2_PARAM_HOST_DECRYPT
 * PRISM2_PARAM_ANTENNA_MODE
 * PRISM2_PARAM_STAT_TIME
 * PRISM2_PARAM_SCAN_FLAGS

are not used by hostapd or wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |    3 --
 net/mac80211/hostapd_ioctl.h   |    6 ----
 net/mac80211/ieee80211.c       |   42 -------------------------------
 net/mac80211/ieee80211_i.h     |    7 -----
 net/mac80211/ieee80211_ioctl.c |   54 -----------------------------------------
 net/mac80211/ieee80211_sta.c   |   37 ----------------------------
 net/mac80211/wme.c             |    3 --
 7 files changed, 152 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:04:46.766516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:07:46.456516958 +0200
@@ -28,8 +28,6 @@ enum {
 	PRISM2_PARAM_BEACON_INT = 3,
 	PRISM2_PARAM_AP_BRIDGE_PACKETS = 10,
 	PRISM2_PARAM_DTIM_PERIOD = 11,
-	PRISM2_PARAM_HOST_ENCRYPT = 17,
-	PRISM2_PARAM_HOST_DECRYPT = 18,
 	PRISM2_PARAM_IEEE_802_1X = 23,
 
 	/* Instant802 additions */
@@ -38,19 +36,15 @@ enum {
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_RADIO_ENABLED = 1010,
-	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
-	PRISM2_PARAM_STAT_TIME = 1016,
 	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
 	PRISM2_PARAM_TX_POWER_REDUCTION = 1022,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
 	PRISM2_PARAM_KEY_INDEX = 1025,
 	PRISM2_PARAM_DEFAULT_WEP_ONLY = 1026,
-	PRISM2_PARAM_WIFI_WME_NOACK_TEST = 1033,
 	PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS = 1034,
-	PRISM2_PARAM_SCAN_FLAGS = 1035,
 	PRISM2_PARAM_HW_MODES = 1036,
 	PRISM2_PARAM_CREATE_IBSS = 1037,
 	PRISM2_PARAM_WMM_ENABLED = 1038,
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 14:04:47.366516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 14:07:46.456516958 +0200
@@ -553,10 +553,6 @@ struct ieee80211_local {
 	struct list_head sta_bss_list;
 	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
 	spinlock_t sta_bss_lock;
-#define IEEE80211_SCAN_MATCH_SSID BIT(0)
-#define IEEE80211_SCAN_WPA_ONLY BIT(1)
-#define IEEE80211_SCAN_EXTRA_INFO BIT(2)
-	int scan_flags;
 
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 #define WPA_TRIGGER_FAIL_TX_MIC BIT(0)
@@ -590,8 +586,6 @@ struct ieee80211_local {
 
 	u32 channel_use;
 	u32 channel_use_raw;
-	u32 stat_time;
-	struct timer_list stat_timer;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct work_struct sta_debugfs_add;
@@ -642,7 +636,6 @@ struct ieee80211_local {
 				     * even when there are no associated STAs
 				     */
 
-	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	unsigned int enabled_modes; /* bitfield of allowed modes;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:04:46.796516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:07:46.476516958 +0200
@@ -1792,7 +1792,6 @@ static int ieee80211_ioctl_siwscan(struc
 				   struct iw_request_info *info,
 				   struct iw_point *data, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u8 *ssid = NULL;
 	size_t ssid_len = 0;
@@ -1803,16 +1802,7 @@ static int ieee80211_ioctl_siwscan(struc
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.sta.ssid;
-			ssid_len = sdata->u.sta.ssid_len;
-		}
-		break;
 	case IEEE80211_IF_TYPE_AP:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.ap.ssid;
-			ssid_len = sdata->u.ap.ssid_len;
-		}
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -2145,12 +2135,6 @@ static int ieee80211_ioctl_prism2_param(
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
@@ -2199,15 +2183,6 @@ static int ieee80211_ioctl_prism2_param(
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
@@ -2231,12 +2206,6 @@ static int ieee80211_ioctl_prism2_param(
 		ret = ieee80211_ioctl_set_radio_enabled(dev, value);
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
@@ -2278,18 +2247,10 @@ static int ieee80211_ioctl_prism2_param(
 		ret = ieee80211_ioctl_default_wep_only(local, value);
 		break;
 
-	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
-		local->wifi_wme_noack_test = value;
-		break;
-
 	case PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS:
 		local->allow_broadcast_always = value;
 		break;
 
-	case PRISM2_PARAM_SCAN_FLAGS:
-		local->scan_flags = value;
-		break;
-
 	case PRISM2_PARAM_MIXED_CELL:
 		if (sdata->type != IEEE80211_IF_TYPE_STA &&
 		    sdata->type != IEEE80211_IF_TYPE_IBSS)
@@ -2389,9 +2350,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = sdata->short_preamble;
 		break;
 
-	case PRISM2_PARAM_STAT_TIME:
-		*param = local->stat_time;
-		break;
 	case PRISM2_PARAM_SHORT_SLOT_TIME:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME);
 		break;
@@ -2400,10 +2358,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->next_mode;
 		break;
 
-	case PRISM2_PARAM_ANTENNA_MODE:
-		*param = local->hw.conf.antenna_mode;
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SSID_HIDDEN);
 		break;
@@ -2443,18 +2397,10 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->default_wep_only;
 		break;
 
-	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
-		*param = local->wifi_wme_noack_test;
-		break;
-
 	case PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS:
 		*param = local->allow_broadcast_always;
 		break;
 
-	case PRISM2_PARAM_SCAN_FLAGS:
-		*param = local->scan_flags;
-		break;
-
 	case PRISM2_PARAM_HW_MODES:
 		*param = local->enabled_modes;
 		break;
--- wireless-dev.orig/net/mac80211/wme.c	2007-08-15 14:04:46.996516958 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-08-15 14:07:46.476516958 +0200
@@ -192,9 +192,6 @@ static int wme_qdiscop_enqueue(struct sk
 	if (WLAN_FC_IS_QOS_DATA(fc)) {
 		u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
 		u8 qos_hdr = skb->priority & QOS_CONTROL_TAG1D_MASK;
-		if (local->wifi_wme_noack_test)
-			qos_hdr |= QOS_CONTROL_ACK_POLICY_NOACK <<
-					QOS_CONTROL_ACK_POLICY_SHIFT;
 		/* qos header is 2 bytes, second reserved */
 		*p = qos_hdr;
 		p++;
--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:07:04.636516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:07:46.476516958 +0200
@@ -300,9 +300,6 @@ struct ieee80211_conf {
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
-	int antenna_def;
-	int antenna_mode;
-
 	/* Following five fields are used for IEEE 802.11H */
 	unsigned int radar_detect;
 	unsigned int spect_mgmt;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 14:07:04.636516958 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-15 14:07:46.486516958 +0200
@@ -779,42 +779,6 @@ struct dev_mc_list *ieee80211_get_mc_lis
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
@@ -1253,9 +1217,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	INIT_LIST_HEAD(&local->sub_if_list);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
-	init_timer(&local->stat_timer);
-	local->stat_timer.function = ieee80211_stat_refresh;
-	local->stat_timer.data = (unsigned long) local;
 	ieee80211_rx_bss_list_init(mdev);
 
 	sta_info_init(local);
@@ -1455,9 +1416,6 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
-	if (local->stat_time)
-		del_timer_sync(&local->stat_timer);
-
 	ieee80211_rx_bss_list_deinit(local->mdev);
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-15 14:04:46.906516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-15 14:07:46.486516958 +0200
@@ -3819,15 +3819,6 @@ ieee80211_sta_scan_result(struct net_dev
 	if (!(local->enabled_modes & (1 << bss->hw_mode)))
 		return current_ev;
 
-	if (local->scan_flags & IEEE80211_SCAN_WPA_ONLY &&
-	    !bss->wpa_ie && !bss->rsn_ie)
-		return current_ev;
-
-	if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID &&
-	    (local->scan_ssid_len != bss->ssid_len ||
-	     memcmp(local->scan_ssid, bss->ssid, bss->ssid_len) != 0))
-		return current_ev;
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -3931,34 +3922,6 @@ ieee80211_sta_scan_result(struct net_dev
 		}
 	}
 
-	do {
-		char *buf;
-
-		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
-			break;
-
-		buf = kmalloc(100, GFP_ATOMIC);
-		if (!buf)
-			break;
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "bcn_int=%d", bss->beacon_int);
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-						  buf);
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "capab=0x%04x", bss->capability);
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-						  buf);
-
-		kfree(buf);
-		break;
-	} while (0);
-
 	return current_ev;
 }
 

-- 

