Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763219AbXHOO5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:57:37 -0400
Message-Id: <20070815145045.996010000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 10/20] mac80211: remove unused ioctls (5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls
 * PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE
 * PRISM2_HOSTAPD_GET_LOAD_STATS
 * PRISM2_HOSTAPD_GET_TX_STATS
 * PRISM2_HOSTAPD_SCAN_REQ
 * PRISM2_STA_GET_STATE
 * PRISM2_HOSTAPD_FLUSH_IFS

are not used by hostapd or wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |   39 -------------
 net/mac80211/ieee80211_ioctl.c |  120 -----------------------------------------
 2 files changed, 159 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:09:54.916516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:11:26.306516958 +0200
@@ -61,17 +61,11 @@ enum {
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
 	PRISM2_HOSTAPD_ADD_IF = 1006,
 	PRISM2_HOSTAPD_REMOVE_IF = 1007,
-	PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE = 1008,
-	PRISM2_HOSTAPD_GET_LOAD_STATS = 1009,
 	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
 	PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM = 1011,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
 	PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS = 1014,
-	PRISM2_HOSTAPD_GET_TX_STATS = 1016,
-	PRISM2_HOSTAPD_SCAN_REQ = 1019,
-	PRISM2_STA_GET_STATE = 1020,
-	PRISM2_HOSTAPD_FLUSH_IFS = 1021,
 };
 
 #define PRISM2_HOSTAPD_MAX_BUF_SIZE 2048
@@ -154,24 +148,6 @@ struct prism2_hostapd_param {
 			u8 name[IFNAMSIZ];
 			u8 data[0] ALIGNED;
 		} if_info;
-		struct dot11_counters {
-			u32 dot11TransmittedFragmentCount;
-			u32 dot11MulticastTransmittedFrameCount;
-			u32 dot11FailedCount;
-			u32 dot11ReceivedFragmentCount;
-			u32 dot11MulticastReceivedFrameCount;
-			u32 dot11FCSErrorCount;
-			u32 dot11TransmittedFrameCount;
-			u32 dot11WEPUndecryptableCount;
-			u32 dot11ACKFailureCount;
-			u32 dot11RTSFailureCount;
-			u32 dot11RTSSuccessCount;
-		} dot11CountersTable;
-		struct {
-#define LOAD_STATS_CLEAR BIT(1)
-			u32 flags;
-			u32 channel_use;
-		} get_load_stats;
 		struct {
 			char vlan_name[IFNAMSIZ];
 			int vlan_id;
@@ -198,21 +174,6 @@ struct prism2_hostapd_param {
 			u32 burst_time; /* maximum burst time in 0.1 ms, i.e.,
 					 * 10 = 1 ms */
 		} tx_queue_params;
-		struct ieee80211_tx_stats {
-			struct {
-				unsigned int len; /* num packets in queue */
-				unsigned int limit; /* queue len (soft) limit
-						     */
-				unsigned int count; /* total num frames sent */
-			} data[4];
-		} get_tx_stats;
-		struct {
-			u8 ssid_len;
-			u8 ssid[0] ALIGNED;
-		} scan_req;
-		struct {
-			u32 state;
-		} sta_get_state;
 		struct {
 			u8 dummy[80]; /* Make sizeof() this struct large enough
 				       * with some compiler versions. */
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:10:51.536516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:11:26.316516958 +0200
@@ -316,38 +316,6 @@ static int ieee80211_ioctl_remove_sta(st
 }
 
 
-static int ieee80211_ioctl_get_dot11counterstable(struct net_device *dev,
-					struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_low_level_stats stats;
-
-	memset(&stats, 0, sizeof(stats));
-	if (local->ops->get_stats)
-		local->ops->get_stats(local_to_hw(local), &stats);
-	param->u.dot11CountersTable.dot11TransmittedFragmentCount =
-		local->dot11TransmittedFragmentCount;
-	param->u.dot11CountersTable.dot11MulticastTransmittedFrameCount =
-		local->dot11MulticastTransmittedFrameCount;
-	param->u.dot11CountersTable.dot11ReceivedFragmentCount =
-		local->dot11ReceivedFragmentCount;
-	param->u.dot11CountersTable.dot11MulticastReceivedFrameCount =
-		local->dot11MulticastReceivedFrameCount;
-	param->u.dot11CountersTable.dot11TransmittedFrameCount =
-		local->dot11TransmittedFrameCount;
-	param->u.dot11CountersTable.dot11FCSErrorCount =
-		stats.dot11FCSErrorCount;
-	param->u.dot11CountersTable.dot11ACKFailureCount =
-		stats.dot11ACKFailureCount;
-	param->u.dot11CountersTable.dot11RTSFailureCount =
-		stats.dot11RTSFailureCount;
-	param->u.dot11CountersTable.dot11RTSSuccessCount =
-		stats.dot11RTSSuccessCount;
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_get_info_sta(struct net_device *dev,
 					struct prism2_hostapd_param *param)
 {
@@ -995,54 +963,6 @@ static int ieee80211_ioctl_remove_if(str
 	return ieee80211_if_remove(dev, param->u.if_info.name, type);
 }
 
-static int ieee80211_ioctl_scan_req(struct net_device *dev,
-				    struct prism2_hostapd_param *param,
-				    int param_len)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	u8 *pos = param->u.scan_req.ssid;
-	int left = param_len - ((u8 *) pos - (u8 *) param);
-	int len = param->u.scan_req.ssid_len;
-
-	if (local->user_space_mlme)
-		return -EOPNOTSUPP;
-
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
-	if (left < len || len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
-
-	return ieee80211_sta_req_scan(dev, pos, len);
-}
-
-
-static int ieee80211_ioctl_sta_get_state(struct net_device *dev,
-					 struct prism2_hostapd_param *param)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS)
-		return -EINVAL;
-	param->u.sta_get_state.state = sdata->u.sta.state;
-	return 0;
-}
-
-
-static int ieee80211_ioctl_get_load_stats(struct net_device *dev,
-					  struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	param->u.get_load_stats.channel_use = local->channel_use;
-/*	if (param->u.get_load_stats.flags & LOAD_STATS_CLEAR)
-		local->channel_use = 0; */ /* now it's not raw counter */
-
-	return 0;
-}
-
 
 static int ieee80211_ioctl_set_sta_vlan(struct net_device *dev,
 					struct prism2_hostapd_param *param)
@@ -1159,31 +1079,6 @@ ieee80211_ioctl_set_tx_queue_params(stru
 }
 
 
-static int ieee80211_ioctl_get_tx_stats(struct net_device *dev,
-					struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_queue_stats stats;
-	int ret, i;
-
-	if (!local->ops->get_tx_stats)
-		return -EOPNOTSUPP;
-
-	memset(&stats, 0, sizeof(stats));
-	ret = local->ops->get_tx_stats(local_to_hw(local), &stats);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < 4; i++) {
-		param->u.get_tx_stats.data[i].len = stats.data[i].len;
-		param->u.get_tx_stats.data[i].limit = stats.data[i].limit;
-		param->u.get_tx_stats.data[i].count = stats.data[i].count;
-	}
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_set_channel_flag(struct net_device *dev,
 					    struct prism2_hostapd_param *param)
 {
@@ -1278,12 +1173,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_REMOVE_IF:
 		ret = ieee80211_ioctl_remove_if(dev, param);
 		break;
-	case PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE:
-		ret = ieee80211_ioctl_get_dot11counterstable(dev, param);
-		break;
-	case PRISM2_HOSTAPD_GET_LOAD_STATS:
-		ret = ieee80211_ioctl_get_load_stats(dev, param);
-		break;
 	case PRISM2_HOSTAPD_SET_STA_VLAN:
 		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
 		break;
@@ -1300,15 +1189,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS:
 		ret = ieee80211_ioctl_set_tx_queue_params(dev, param);
 		break;
-	case PRISM2_HOSTAPD_GET_TX_STATS:
-		ret = ieee80211_ioctl_get_tx_stats(dev, param);
-		break;
-	case PRISM2_HOSTAPD_SCAN_REQ:
-		ret = ieee80211_ioctl_scan_req(dev, param, p->length);
-		break;
-	case PRISM2_STA_GET_STATE:
-		ret = ieee80211_ioctl_sta_get_state(dev, param);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;

-- 

