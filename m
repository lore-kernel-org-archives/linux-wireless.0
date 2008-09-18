Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYIRKY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 06:24:58 -0400
Subject: [PATCH] mac80211: fix mesh action frame handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Li YanBo <dreamfly281@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 12:24:20 +0200
Message-Id: <1221733460.9262.68.camel@johannes.berg> (sfid-20080918_122517_754795_385EDD0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I split off the action frame handling I made the code drop
all action frames we don't want to handle. This is wrong since
some action frames are actually handled via rx_h_mgmt through
being queued to the sta/mesh implementations.

Thanks to Li YanBo for noticing the problem.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Li YanBo <dreamfly281@gmail.com>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/rx.c	2008-09-18 12:21:47.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-18 12:21:54.000000000 +0200
@@ -1534,7 +1534,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
-		return RX_DROP_MONITOR;
+		return RX_CONTINUE;
 
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:


