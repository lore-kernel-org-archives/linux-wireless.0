Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbZESIcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 04:32:32 -0400
Subject: Re: mac80211: fix managed mode BSSID handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 10:32:29 +0200
Message-Id: <1242721949.17164.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

You asked whether the fix-up was correct, but was there also a problem
applying that to wireless-testing? It seems to be missing a hunk (below)
in commit

commit 4eca27a55d34bc3256fb367842ab225948fa155b
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 14 13:10:14 2009 +0200

    mac80211: fix managed mode BSSID handling

---
 net/mac80211/main.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-05-18 19:48:04.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-05-19 10:30:50.000000000 +0200
@@ -219,18 +219,26 @@ void ieee80211_bss_info_change_notify(st
 				      u32 changed)
 {
 	struct ieee80211_local *local = sdata->local;
+	static const u8 zero[ETH_ALEN] = { 0 };
 
 	if (!changed)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
-	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		/*
+		 * While not associated, claim a BSSID of all-zeroes
+		 * so that drivers don't do any weird things with the
+		 * BSSID at that time.
+		 */
+		if (sdata->vif.bss_conf.assoc)
+			sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
+		else
+			sdata->vif.bss_conf.bssid = zero;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		sdata->vif.bss_conf.bssid = sdata->dev->dev_addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		static const u8 zero[ETH_ALEN] = { 0 };
 		sdata->vif.bss_conf.bssid = zero;
 	} else {
 		WARN_ON(1);


