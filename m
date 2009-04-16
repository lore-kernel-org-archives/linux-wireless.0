Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60582 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681AbZDPPpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:45:13 -0400
Date: Thu, 16 Apr 2009 18:44:53 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Allow scan to be requested in AP mode
Message-ID: <20090416154453.GA7311@jm.kir.nu> (sfid-20090416_174516_953775_6A788077)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can allow scan requests in AP mode as long as the interface has not
yet been configured to send out Beacon frames (or if beaconing has
been disabled prior to the scan request). This makes it easier to scan
for neighboring BSSes during AP initialization and makes it possible
to run a scan without setting the interface down, if needed. Without
this change, the only available option would be to set the interface
down, move into station mode, and set the interface up, prior to
requesting the scan.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- uml.orig/net/mac80211/cfg.c	2009-04-16 18:20:19.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-04-16 18:33:44.000000000 +0300
@@ -1167,7 +1167,8 @@ static int ieee80211_scan(struct wiphy *
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+	    (sdata->vif.type != NL80211_IFTYPE_AP || sdata->u.ap.beacon))
 		return -EOPNOTSUPP;
 
 	return ieee80211_request_scan(sdata, req);

-- 
Jouni Malinen                                            PGP id EFC895FA
