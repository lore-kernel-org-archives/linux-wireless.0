Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZGGBrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:47:03 -0400
Message-Id: <20090707014552.047272618@sipsolutions.net>
References: <20090707014515.024822579@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:45:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: remove dead code from mlme
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ap_capab and last_probe struct members are unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c |    3 ---
 net/mac80211/ieee80211_i.h    |    4 +---
 net/mac80211/mlme.c           |    2 --
 3 files changed, 1 insertion(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-07-07 03:37:02.000000000 +0200
@@ -100,7 +100,6 @@ IEEE80211_IF_FILE(bssid, u.mgd.bssid, MA
 IEEE80211_IF_FILE(prev_bssid, u.mgd.prev_bssid, MAC);
 IEEE80211_IF_FILE(ssid_len, u.mgd.ssid_len, SIZE);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
-IEEE80211_IF_FILE(ap_capab, u.mgd.ap_capab, HEX);
 IEEE80211_IF_FILE(capab, u.mgd.capab, HEX);
 IEEE80211_IF_FILE(extra_ie_len, u.mgd.extra_ie_len, SIZE);
 IEEE80211_IF_FILE(auth_tries, u.mgd.auth_tries, DEC);
@@ -186,7 +185,6 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(prev_bssid, sta);
 	DEBUGFS_ADD(ssid_len, sta);
 	DEBUGFS_ADD(aid, sta);
-	DEBUGFS_ADD(ap_capab, sta);
 	DEBUGFS_ADD(capab, sta);
 	DEBUGFS_ADD(extra_ie_len, sta);
 	DEBUGFS_ADD(auth_tries, sta);
@@ -318,7 +316,6 @@ static void del_sta_files(struct ieee802
 	DEBUGFS_DEL(prev_bssid, sta);
 	DEBUGFS_DEL(ssid_len, sta);
 	DEBUGFS_DEL(aid, sta);
-	DEBUGFS_DEL(ap_capab, sta);
 	DEBUGFS_DEL(capab, sta);
 	DEBUGFS_DEL(extra_ie_len, sta);
 	DEBUGFS_DEL(auth_tries, sta);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-07 03:37:02.000000000 +0200
@@ -268,7 +268,7 @@ struct ieee80211_if_managed {
 	} state;
 
 	u16 aid;
-	u16 ap_capab, capab;
+	u16 capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
 	size_t extra_ie_len;
 
@@ -288,7 +288,6 @@ struct ieee80211_if_managed {
 
 	unsigned long request;
 
-	unsigned long last_probe;
 	unsigned long last_beacon;
 
 	unsigned int flags;
@@ -472,7 +471,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *prev_bssid;
 			struct dentry *ssid_len;
 			struct dentry *aid;
-			struct dentry *ap_capab;
 			struct dentry *capab;
 			struct dentry *extra_ie_len;
 			struct dentry *auth_tries;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-07 03:37:02.000000000 +0200
@@ -879,7 +879,6 @@ static void ieee80211_set_associated(str
 		ieee80211_rx_bss_put(local, bss);
 	}
 
-	ifmgd->last_probe = jiffies;
 	ieee80211_led_assoc(local, 1);
 
 	sdata->vif.bss_conf.assoc = 1;
@@ -1488,7 +1487,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	printk(KERN_DEBUG "%s: associated\n", sdata->dev->name);
 	ifmgd->aid = aid;
-	ifmgd->ap_capab = capab_info;
 
 	kfree(ifmgd->assocresp_ies);
 	ifmgd->assocresp_ies_len = len - (pos - (u8 *) mgmt);

-- 

