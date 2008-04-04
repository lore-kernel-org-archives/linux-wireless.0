Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYDDVhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:37:31 -0400
Subject: [PATCH]
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 23:37:28 +0200
Message-Id: <1207345048.3625.15.camel@johannes.berg> (sfid-20080404_223733_489853_ED39E8D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_ioctl_giwrate() ioctl handler doesn't rcu_read_lock()
its access to the sta table, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_ioctl.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-04-04 17:48:11.000000000 +0200
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-04-04 17:48:56.000000000 +0200
@@ -586,19 +586,25 @@ static int ieee80211_ioctl_giwrate(struc
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
-		sta = sta_info_get(local, sdata->u.sta.bssid);
-	else
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return -EOPNOTSUPP;
-	if (!sta)
-		return -ENODEV;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	if (sta->txrate_idx < sband->n_bitrates)
+	rcu_read_lock();
+
+	sta = sta_info_get(local, sdata->u.sta.bssid);
+
+	if (sta && sta->txrate_idx < sband->n_bitrates)
 		rate->value = sband->bitrates[sta->txrate_idx].bitrate;
 	else
 		rate->value = 0;
+
+	rcu_read_unlock();
+
+	if (!sta)
+		return -ENODEV;
+
 	rate->value *= 100000;
 
 	return 0;


