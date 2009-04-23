Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZDWJt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 05:49:29 -0400
Subject: [PATCH v2] mac80211: fix various problems in ibss code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240479861.30082.176.camel@johannes.local> (sfid-20090423_114512_813708_5D5800AB)
References: <1240479861.30082.176.camel@johannes.local>
	 (sfid-20090423_114512_813708_5D5800AB)
Content-Type: text/plain
Date: Thu, 23 Apr 2009 11:48:56 +0200
Message-Id: <1240480136.30082.177.camel@johannes.local> (sfid-20090423_114931_111569_22AF4750)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few problems in the IBSS code:
 a) it tries to activate interfaces that are down after scanning
 b) it crashes after scanning on an IBSS iface that isn't active
 c) since the ssid_len is used as a flag, need to make it visible
    only after all other settings are set, this helps protect
    against b)

For b), we get a system crash:

wlan0: Creating new IBSS network, BSSID ce:f9:88:76:1e:4d
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<...>] ieee80211_sta_find_ibss+0x294/0x37d [mac80211]
Call Trace:
 [<...>] ieee80211_ibss_notify_scan_completed+0x0/0x88 [mac80211]

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sorry, other version was based against some RFC patches.

 net/mac80211/ibss.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-23 11:47:12.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-23 11:48:03.000000000 +0200
@@ -788,8 +788,12 @@ void ieee80211_ibss_notify_scan_complete
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			continue;
+		if (!sdata->u.ibss.ssid_len)
+			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
 		ieee80211_sta_find_ibss(sdata);
 	}
@@ -829,9 +833,6 @@ int ieee80211_ibss_join(struct ieee80211
 {
 	struct sk_buff *skb;
 
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
-	sdata->u.ibss.ssid_len = params->ssid_len;
-
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
 		sdata->u.ibss.fixed_bssid = true;
@@ -861,6 +862,17 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
+	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+
+	/*
+	 * The ssid_len setting below is used to see whether
+	 * we are active, and we need all other settings
+	 * before that may get visible.
+	 */
+	mb();
+
+	sdata->u.ibss.ssid_len = params->ssid_len;
+
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
 


