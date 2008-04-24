Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbYDZPuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:50:24 -0400
Subject: [PATCH] mac80211: don't allow invalid WDS peer addresses
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 14:16:36 +0200
Message-Id: <1209039396.3357.72.camel@johannes.berg> (sfid-20080426_175046_954326_E7A142CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than just disallowing the zero address, disallow all
invalid ones.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/main.c	2008-04-24 13:29:06.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-24 13:29:13.000000000 +0200
@@ -255,7 +255,7 @@ static int ieee80211_open(struct net_dev
 
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_WDS:
-		if (is_zero_ether_addr(sdata->u.wds.remote_addr))
+		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
 
 		/* Create STA entry for the WDS peer */


