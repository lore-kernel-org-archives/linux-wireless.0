Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXIZPzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:55:05 -0400
Message-Id: <20070926155436.262774000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [patch 7/7] mac80211: make userspace-mlme a per-interface setting
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |    2 +-
 net/mac80211/ieee80211_i.h     |    3 +--
 net/mac80211/ieee80211_ioctl.c |   12 +++++-------
 net/mac80211/rx.c              |    2 +-
 4 files changed, 8 insertions(+), 11 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-26 17:51:21.617337342 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-26 17:51:25.817337342 +0200
@@ -287,6 +287,7 @@ struct ieee80211_if_sta {
  * generator reports that there are no present stations that cannot support short
  * preambles */
 #define IEEE80211_SDATA_SHORT_PREAMBLE	BIT(3)
+#define IEEE80211_SDATA_USERSPACE_MLME	BIT(4)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 	enum ieee80211_if_types type;
@@ -553,8 +554,6 @@ struct ieee80211_local {
 	unsigned int hw_modes; /* bitfield of supported hardware modes;
 				* (1 << MODE_*) */
 
-	int user_space_mlme;
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *channel;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-26 17:51:24.757337342 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-26 17:51:25.827337342 +0200
@@ -267,7 +267,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_enable_keys(sdata);
 
 		if (sdata->type == IEEE80211_IF_TYPE_STA &&
-		    !local->user_space_mlme)
+		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-26 17:44:40.867337342 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-26 17:51:25.827337342 +0200
@@ -105,12 +105,12 @@ static int ieee80211_ioctl_siwgenie(stru
 				    struct iw_point *data, char *extra)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (local->user_space_mlme)
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
 		return -EOPNOTSUPP;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		int ret = ieee80211_sta_set_extra_ie(dev, extra, data->length);
@@ -374,7 +374,6 @@ static int ieee80211_ioctl_siwessid(stru
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *ssid)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 	size_t len = data->length;
 
@@ -386,7 +385,7 @@ static int ieee80211_ioctl_siwessid(stru
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		int ret;
-		if (local->user_space_mlme) {
+		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			if (len > IEEE80211_MAX_SSID_LEN)
 				return -EINVAL;
 			memcpy(sdata->u.sta.ssid, ssid, len);
@@ -451,14 +450,13 @@ static int ieee80211_ioctl_siwap(struct 
 				 struct iw_request_info *info,
 				 struct sockaddr *ap_addr, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		int ret;
-		if (local->user_space_mlme) {
+		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
 			       ETH_ALEN);
 			return 0;
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 17:45:32.207337342 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 17:51:25.837337342 +0200
@@ -1199,7 +1199,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->type == IEEE80211_IF_TYPE_STA ||
 	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
-	    !rx->local->user_space_mlme)
+	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
 		return TXRX_DROP;

-- 

