Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbZCXHrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 03:47:02 -0400
Subject: [PATCH] mac80211: fix RX path
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 08:46:57 +0100
Message-Id: <1237880817.6147.26.camel@johannes.local> (sfid-20090324_084706_753942_8ABD89FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch ("mac80211: remove mixed-cell and userspace MLME code")
was too obvious to me, so obvious that a stupid bug crept in. The IBSS
RX function must be invoked for IBSS, of course, not anything != IBSS.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-03-24 08:44:20.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-03-24 08:44:34.000000000 +0100
@@ -1884,7 +1884,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
 
-	if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)


