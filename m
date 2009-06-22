Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:56308 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbZFVRtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 13:49:50 -0400
Date: Mon, 22 Jun 2009 19:51:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Zhu, Yi" <yi.zhu@intel.com>
Subject: [PATCH 2/2 RFC] mac80211: connect API port
Message-ID: <20090622175154.GC30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090622170409.GB30147@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


With the connect()/disconnect() API, some of the mac80211 STA wext
hooks can now move to cfg80211.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 net/mac80211/cfg.c  |   40 +++++++++++++++++----------
 net/mac80211/mlme.c |   15 ----------
 net/mac80211/wext.c |   76 +++++++++-------------------------------------------
 3 files changed, 39 insertions(+), 92 deletions(-)

Index: iwm-2.6/net/mac80211/cfg.c
===================================================================
--- iwm-2.6.orig/net/mac80211/cfg.c	2009-06-22 18:42:43.000000000 +0200
+++ iwm-2.6/net/mac80211/cfg.c	2009-06-22 18:46:35.000000000 +0200
@@ -1173,6 +1173,7 @@ static int ieee80211_auth(struct wiphy *
 			  struct cfg80211_auth_request *req)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1193,12 +1194,20 @@ static int ieee80211_auth(struct wiphy *
 		return -EOPNOTSUPP;
 	}
 
-	memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
-	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+	if (req->peer_addr) {
+		memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+	} else {
+		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
+		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_BSSID_SET;
+	}
 
-	/* TODO: req->chan */
-	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+	if (!wdev->channel)
+		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+	else
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	if (req->ssid) {
 		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
@@ -1220,6 +1229,7 @@ static int ieee80211_auth(struct wiphy *
 
 	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_DIRECT_PROBE;
+
 	ieee80211_sta_req_auth(sdata);
 	return 0;
 }
@@ -1232,27 +1242,26 @@ static int ieee80211_assoc(struct wiphy 
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0 ||
-	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
+	if ((req->peer_addr &&
+	     memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0) ||
+	     !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
 
 	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
 	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
 
-	/* TODO: req->chan */
-	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
-
 	if (req->ssid) {
 		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
 		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
 		sdata->u.mgd.ssid_len = req->ssid_len;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
-	} else
-		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
+	}
 
-	ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
-	if (ret && ret != -EALREADY)
-		return ret;
+	if (req->ie) {
+		ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
+		if (ret && ret != -EALREADY)
+			return ret;
+	}
 
 	if (req->use_mfp) {
 		sdata->u.mgd.mfp = IEEE80211_MFP_REQUIRED;
@@ -1269,6 +1278,7 @@ static int ieee80211_assoc(struct wiphy 
 
 	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
+
 	ieee80211_sta_req_auth(sdata);
 	return 0;
 }
Index: iwm-2.6/net/mac80211/wext.c
===================================================================
--- iwm-2.6.orig/net/mac80211/wext.c	2009-06-22 18:42:43.000000000 +0200
+++ iwm-2.6/net/mac80211/wext.c	2009-06-22 18:46:35.000000000 +0200
@@ -61,7 +61,7 @@ static int ieee80211_ioctl_siwfreq(struc
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
+		return cfg80211_mgd_wext_siwfreq(dev, info, freq, extra);
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
@@ -95,9 +95,6 @@ static int ieee80211_ioctl_siwfreq(struc
 	if (local->oper_channel == chan)
 		return 0;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		ieee80211_sta_req_auth(sdata);
-
 	local->oper_channel = chan;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, 0);
@@ -115,6 +112,8 @@ static int ieee80211_ioctl_giwfreq(struc
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
 
 	freq->m = local->oper_channel->center_freq;
 	freq->e = 6;
@@ -128,31 +127,11 @@ static int ieee80211_ioctl_siwessid(stru
 				    struct iw_point *data, char *ssid)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	size_t len = data->length;
-	int ret;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
-
-	/* iwconfig uses nul termination in SSID.. */
-	if (len > 0 && ssid[len - 1] == '\0')
-		len--;
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (data->flags)
-			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
-		else
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
-
-		ret = ieee80211_sta_set_ssid(sdata, ssid, len);
-		if (ret)
-			return ret;
-
-		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		ieee80211_sta_req_auth(sdata);
-		return 0;
-	}
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_siwessid(dev, info, data, ssid);
 
 	return -EOPNOTSUPP;
 }
@@ -162,23 +141,14 @@ static int ieee80211_ioctl_giwessid(stru
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *ssid)
 {
-	size_t len;
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
-		if (res == 0) {
-			data->length = len;
-			data->flags = 1;
-		} else
-			data->flags = 0;
-		return res;
-	}
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwessid(dev, info, data, ssid);
 
 	return -EOPNOTSUPP;
 }
@@ -193,24 +163,10 @@ static int ieee80211_ioctl_siwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		int ret;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_siwap(dev, info, ap_addr, extra);
 
-		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL |
-				IEEE80211_STA_AUTO_CHANNEL_SEL;
-		else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
-		else
-			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
-		if (ret)
-			return ret;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		ieee80211_sta_req_auth(sdata);
-		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/*
 		 * If it is necessary to update the WDS peer address
 		 * while the interface is running, then we need to do
@@ -240,14 +196,10 @@ static int ieee80211_ioctl_giwap(struct 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (sdata->u.mgd.state == IEEE80211_STA_MLME_ASSOCIATED) {
-			ap_addr->sa_family = ARPHRD_ETHER;
-			memcpy(&ap_addr->sa_data, sdata->u.mgd.bssid, ETH_ALEN);
-		} else
-			memset(&ap_addr->sa_data, 0, ETH_ALEN);
-		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return cfg80211_mgd_wext_giwap(dev, info, ap_addr, extra);
+
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
 		return 0;
Index: iwm-2.6/net/mac80211/mlme.c
===================================================================
--- iwm-2.6.orig/net/mac80211/mlme.c	2009-06-22 18:42:43.000000000 +0200
+++ iwm-2.6/net/mac80211/mlme.c	2009-06-22 18:46:35.000000000 +0200
@@ -868,17 +868,6 @@ static u32 ieee80211_handle_bss_capabili
 	return changed;
 }
 
-static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata)
-{
-	union iwreq_data wrqu;
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED)
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.mgd.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
-}
-
 static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -991,8 +980,6 @@ static void ieee80211_set_associated(str
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
-
-	ieee80211_sta_send_apinfo(sdata);
 }
 
 static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
@@ -1143,8 +1130,6 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_sta_send_apinfo(sdata);
-
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
