Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:55709 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614AbXKIPX0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 10:23:26 -0500
From: Helmut Schaa <hschaa@suse.de>
To: linville@tuxdriver.com
Subject: [PATCH 2/2] mac80211: Remove local->scan_flags
Date: Fri, 9 Nov 2007 16:26:09 +0100
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200711091622.16671.hschaa@suse.de> <200711091625.08261.hschaa@suse.de>
In-Reply-To: <200711091625.08261.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711091626.09611.hschaa@suse.de> (sfid-20071109_152328_711152_1078D313)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all references to local->scan_flags as these are not 
used anymore since the removal of prism2 ioctls.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
Signed-off-by: Jiri Benc <jbenc@suse.cz>
---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4b4ed2a..31b634c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -481,10 +483,6 @@ struct ieee80211_local {
 	struct list_head sta_bss_list;
 	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
 	spinlock_t sta_bss_lock;
-#define IEEE80211_SCAN_MATCH_SSID BIT(0)
-#define IEEE80211_SCAN_WPA_ONLY BIT(1)
-#define IEEE80211_SCAN_EXTRA_INFO BIT(2)
-	int scan_flags;
 
 	/* SNMP counters */
 	/* dot11CountersTable */
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 6caa3ec..bd4804e 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -513,7 +513,6 @@ static int ieee80211_ioctl_siwscan(struct net_device *dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct iw_scan_req *req = NULL;
 	u8 *ssid = NULL;
@@ -522,21 +521,9 @@ static int ieee80211_ioctl_siwscan(struct net_device 
*dev,
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.sta.ssid;
-			ssid_len = sdata->u.sta.ssid_len;
-		}
-		break;
-	case IEEE80211_IF_TYPE_AP:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.ap.ssid;
-			ssid_len = sdata->u.ap.ssid_len;
-		}
-		break;
-	default:
+	if (sdata->type != IEEE80211_IF_TYPE_STA &&
+	    sdata->type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->type != IEEE80211_IF_TYPE_AP) {
 		return -EOPNOTSUPP;
 	}
 
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f7ffeec..f4c76ea 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2887,15 +2893,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
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
@@ -3002,9 +2999,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
 	do {
 		char *buf;
 
-		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
-			break;
-
 		buf = kmalloc(100, GFP_ATOMIC);
 		if (!buf)
 			break;
