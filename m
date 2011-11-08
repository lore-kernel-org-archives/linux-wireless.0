Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1KHNhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:37:05 -0500
Received: by wyh15 with SMTP id 15so474141wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 05:37:04 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: set carrier_on for ibss vifs only while joined
Date: Tue,  8 Nov 2011 15:36:59 +0200
Message-Id: <1320759419-20743-1-git-send-email-eliad@wizery.com> (sfid-20111108_143710_502423_252973B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 should set carrier_on for ibss vifs
only while they are joined (similar to sta vifs)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/ibss.c  |    3 +++
 net/mac80211/iface.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2da3040..ecf24ec 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -97,6 +97,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* if merging, indicate to driver that we leave the old IBSS */
 	if (sdata->vif.bss_conf.ibss_joined) {
 		sdata->vif.bss_conf.ibss_joined = false;
+		netif_carrier_off(sdata->dev);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
 	}
 
@@ -207,6 +208,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
 					mgmt, skb->len, 0, GFP_KERNEL);
 	cfg80211_put_bss(bss);
+	netif_carrier_on(sdata->dev);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
 }
 
@@ -990,6 +992,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	}
 
 	sta_info_flush(sdata->local, sdata);
+	netif_carrier_off(sdata->dev);
 
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ef741e8..ce372ea 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -282,7 +282,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
-- 
1.7.6.401.g6a319

