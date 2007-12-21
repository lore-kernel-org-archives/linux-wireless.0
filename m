Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbXLULWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 06:22:17 -0500
Subject: [PATCH] mac80211: remove useless sdata variable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 01:03:05 +0100
Message-Id: <1198195385.16241.68.camel@johannes.berg> (sfid-20071221_112220_503044_2805384E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dunno why I slipped that variable in...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_sta.c |    2 --
 1 file changed, 2 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:11.253160428 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.113165907 +0100
@@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
 		return;
 
 	if (assoc) {
-		struct ieee80211_sub_if_data *sdata;
 		struct ieee80211_sta_bss *bss;
 
 		ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 			return;
 


