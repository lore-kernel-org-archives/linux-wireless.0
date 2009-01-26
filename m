Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZAZSMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:12:02 -0500
Subject: [PATCH] mac80211: don't try to powersave/config disabled interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 19:11:57 +0100
Message-Id: <1232993518.4533.27.camel@johannes.local> (sfid-20090126_191208_293454_F0BA7B43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-testing.orig/net/mac80211/scan.c	2009-01-26 19:10:06.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-01-26 19:10:33.000000000 +0100
@@ -475,6 +475,9 @@ void ieee80211_scan_completed(struct iee
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
 		/* Tell AP we're back */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
@@ -637,6 +640,9 @@ int ieee80211_start_scan(struct ieee8021
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
 		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {


