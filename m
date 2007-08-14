Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbXHNLpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:45:20 -0400
Message-Id: <20070814092442.648842000@sipsolutions.net>
References: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 04/13] mac80211: remove unused ioctls (3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls

 * PRISM2_PARAM_HW_MODES
 * PRISM2_PARAM_CREATE_IBSS
 * PRISM2_PARAM_WMM_ENABLED
 * PRISM2_PARAM_MIXED_CELL
 * PRISM2_PARAM_KEY_MGMT

are not used by hostapd or wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    5 --
 net/mac80211/ieee80211.c       |    2 -
 net/mac80211/ieee80211_i.h     |    4 --
 net/mac80211/ieee80211_iface.c |    2 -
 net/mac80211/ieee80211_ioctl.c |   71 +----------------------------------------
 net/mac80211/ieee80211_sta.c   |   37 +++++++++------------
 6 files changed, 19 insertions(+), 102 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-14 11:11:16.834229604 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-14 11:12:07.624229604 +0200
@@ -39,11 +39,6 @@ enum {
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
-	PRISM2_PARAM_HW_MODES = 1036,
-	PRISM2_PARAM_CREATE_IBSS = 1037,
-	PRISM2_PARAM_WMM_ENABLED = 1038,
-	PRISM2_PARAM_MIXED_CELL = 1039,
-	PRISM2_PARAM_KEY_MGMT = 1040,
 	PRISM2_PARAM_RADAR_DETECT = 1043,
 	PRISM2_PARAM_SPECTRUM_MGMT = 1044,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-14 11:11:16.864229604 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-14 11:11:29.824229604 +0200
@@ -1000,8 +1000,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
 
-	local->enabled_modes = (unsigned int) -1;
-
 	INIT_LIST_HEAD(&local->modes_list);
 
 	rwlock_init(&local->sub_if_lock);
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-14 11:11:16.924229604 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-14 11:12:04.234229604 +0200
@@ -263,8 +263,6 @@ struct ieee80211_if_sta {
 	unsigned int authenticated:1;
 	unsigned int associated:1;
 	unsigned int probereq_poll:1;
-	unsigned int create_ibss:1;
-	unsigned int mixed_cell:1;
 	unsigned int wmm_enabled:1;
 	unsigned int ht_enabled:1;
 	unsigned int auto_ssid_sel:1;
@@ -624,8 +622,6 @@ struct ieee80211_local {
 				*/
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
-	unsigned int enabled_modes; /* bitfield of allowed modes;
-				      * (1 << MODE_*) */
 	unsigned int hw_modes; /* bitfield of supported hardware modes;
 				* (1 << MODE_*) */
 
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-14 11:11:16.944229604 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-14 11:12:07.624229604 +0200
@@ -1456,9 +1456,8 @@ static int ieee80211_ioctl_giwrange(stru
 	list_for_each_entry(mode, &local->modes_list, list) {
 		int i = 0;
 
-		if (!(local->enabled_modes & (1 << mode->mode)) ||
-		    (local->hw_modes & local->enabled_modes &
-		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+		if ((local->hw_modes & (1 << MODE_IEEE80211G) &&
+		    mode->mode == MODE_IEEE80211B))
 			continue;
 
 		while (i < mode->num_channels && c < IW_MAX_FREQUENCIES) {
@@ -1567,8 +1566,6 @@ int ieee80211_set_channel(struct ieee802
 	int ret = -EINVAL;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
-		if (!(local->enabled_modes & (1 << mode->mode)))
-			continue;
 		for (c = 0; c < mode->num_channels; c++) {
 			struct ieee80211_channel *chan = &mode->channels[c];
 			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
@@ -2209,38 +2206,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->key_tx_rx_threshold = value;
 		break;
 
-	case PRISM2_PARAM_MIXED_CELL:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			sdata->u.sta.mixed_cell = !!value;
-		break;
-
-	case PRISM2_PARAM_KEY_MGMT:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			ret = -EINVAL;
-		else
-			sdata->u.sta.key_mgmt = value;
-		break;
-
-	case PRISM2_PARAM_HW_MODES:
-		local->enabled_modes = value;
-		break;
-
-	case PRISM2_PARAM_CREATE_IBSS:
-		if (sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			sdata->u.sta.create_ibss = !!value;
-		break;
-	case PRISM2_PARAM_WMM_ENABLED:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			sdata->u.sta.wmm_enabled = !!value;
-		break;
 	case PRISM2_PARAM_RADAR_DETECT:
 		local->hw.conf.radar_detect = value;
 		break;
@@ -2318,38 +2283,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->key_tx_rx_threshold;
 		break;
 
-	case PRISM2_PARAM_HW_MODES:
-		*param = local->enabled_modes;
-		break;
-
-	case PRISM2_PARAM_CREATE_IBSS:
-		if (sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!sdata->u.sta.create_ibss;
-		break;
-
-	case PRISM2_PARAM_MIXED_CELL:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!sdata->u.sta.mixed_cell;
-		break;
-
-	case PRISM2_PARAM_KEY_MGMT:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			ret = -EINVAL;
-		else
-			*param = sdata->u.sta.key_mgmt;
-		break;
-	case PRISM2_PARAM_WMM_ENABLED:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!sdata->u.sta.wmm_enabled;
-		break;
 	case PRISM2_PARAM_USER_SPACE_MLME:
 		*param = local->user_space_mlme;
 		break;
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-14 11:11:17.004229604 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-14 11:12:04.244229604 +0200
@@ -672,7 +672,7 @@ static void ieee80211_send_assoc(struct 
 		memcpy(pos, ifsta->extra_ie, ifsta->extra_ie_len);
 	}
 
-	if (wmm && ifsta->wmm_enabled) {
+	if (wmm) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
@@ -1167,8 +1167,7 @@ static int ieee80211_privacy_mismatch(st
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
 
-	if (!ifsta || ifsta->mixed_cell ||
-	    ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
+	if (!ifsta || ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
 		return 0;
 
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
@@ -1761,7 +1760,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta, local);
 
-	if (elems.wmm_param && ifsta->wmm_enabled) {
+	if (elems.wmm_param) {
 		sta->flags |= WLAN_STA_WME;
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
@@ -2444,7 +2443,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (elems.erp_info && elems.erp_info_len >= 1)
 		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);
 
-	if (elems.wmm_param && ifsta->wmm_enabled) {
+	if (elems.wmm_param) {
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
 	}
@@ -3421,15 +3420,16 @@ static int ieee80211_sta_find_ibss(struc
 
 		if (time_after(jiffies, ifsta->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if (ifsta->create_ibss &&
-			    local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)
+			if (local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)
 				return ieee80211_sta_create_ibss(dev, ifsta);
-			if (ifsta->create_ibss) {
-				printk(KERN_DEBUG "%s: IBSS not allowed on the"
-				       " configured channel %d (%d MHz)\n",
-				       dev->name, local->hw.conf.channel,
-				       local->hw.conf.freq);
-			}
+			/*
+			 * I suspect the if (create_ibss) test here should have been
+			 * inverted but this patch series is janitorial.
+			 */
+			printk(KERN_DEBUG "%s: IBSS not allowed on the"
+			       " configured channel %d (%d MHz)\n",
+			       dev->name, local->hw.conf.channel,
+			       local->hw.conf.freq);
 
 			/* No IBSS found - decrease scan interval and continue
 			 * scanning. */
@@ -3627,8 +3627,8 @@ void ieee80211_sta_scan_work(struct work
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_channel *chan;
-	int skip;
 	unsigned long next_delay = 0;
+	int skip;
 
 	if (!local->sta_scanning)
 		return;
@@ -3641,13 +3641,13 @@ void ieee80211_sta_scan_work(struct work
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
-		skip = !(local->enabled_modes & (1 << mode->mode));
 		chan = &mode->channels[local->scan_channel_idx];
+		skip = 0;
 		if (!(chan->flag & IEEE80211_CHAN_W_SCAN) ||
 		    (sdata->type == IEEE80211_IF_TYPE_IBSS &&
 		     !(chan->flag & IEEE80211_CHAN_W_IBSS)) ||
-		    (local->hw_modes & local->enabled_modes &
-		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+		    (local->hw_modes & (1 << MODE_IEEE80211G) &&
+		     mode->mode == MODE_IEEE80211B))
 			skip = 1;
 
 		if (!skip) {
@@ -3815,9 +3815,6 @@ ieee80211_sta_scan_result(struct net_dev
 		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
 		return current_ev;
 
-	if (!(local->enabled_modes & (1 << bss->hw_mode)))
-		return current_ev;
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-14 11:02:54.324229604 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-14 11:12:02.134229604 +0200
@@ -138,8 +138,6 @@ void ieee80211_if_set_type(struct net_de
 		ifsta->capab = WLAN_CAPABILITY_ESS;
 		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
 			IEEE80211_AUTH_ALG_SHARED_KEY;
-		ifsta->create_ibss = 1;
-		ifsta->wmm_enabled = 1;
 		ifsta->ht_enabled = 1;
 		ifsta->auto_channel_sel = 1;
 		ifsta->auto_bssid_sel = 1;

-- 

