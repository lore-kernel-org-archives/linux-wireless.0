Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60423 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbZDWVAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 17:00:14 -0400
Date: Fri, 24 Apr 2009 00:00:00 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Send timeout event on failed direct probe
Message-ID: <20090423210000.GA3260@jm.kir.nu> (sfid-20090423_230018_498068_3E0A7831)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the direct probe times out, we need to send the authentication
timeout event to notify SME in the same way as we notify on timeout
with authentication frames since the direct probe is run as part of
the authentication attempt.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- uml.orig/net/mac80211/mlme.c	2009-04-23 23:52:15.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-04-23 23:54:36.000000000 +0300
@@ -882,7 +882,7 @@ static void ieee80211_direct_probe(struc
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata);
+		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the

-- 
Jouni Malinen                                            PGP id EFC895FA
