Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYIIMzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 08:55:15 -0400
Subject: [PATCH] mac80211: make ieee80211_rx_h_mgmt more readable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 14:55:09 +0200
Message-Id: <1220964909.31304.171.camel@johannes.berg> (sfid-20080909_145524_265558_D2EA479E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That function isn't exactly easy to read especially since it
does something in an if branch that continues after the if
because the else returns. Express it in a more readable way.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-09-09 14:49:42.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-09 14:51:25.000000000 +0200
@@ -1586,20 +1586,20 @@ ieee80211_rx_h_action(struct ieee80211_r
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
-	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS ||
-	     sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) &&
-	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
-		ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
-	else
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return RX_DROP_MONITOR;
+
+	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
 		return RX_DROP_MONITOR;
 
+	ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
 	return RX_QUEUED;
 }
 


