Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYBNOCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 09:02:40 -0500
Subject: [PATCH] mac80211: fix ecw2cw brain-damage
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 00:30:35 +0100
Message-Id: <1202945435.8931.102.camel@johannes.berg> (sfid-20080214_140247_937386_4C9351D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This brain-damaged code just bothers me, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_sta.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-14 00:23:04.447865289 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-14 00:24:11.977817546 +0100
@@ -227,12 +227,7 @@ static void ieee802_11_parse_elems(u8 *s
 
 static int ecw2cw(int ecw)
 {
-	int cw = 1;
-	while (ecw > 0) {
-		cw <<= 1;
-		ecw--;
-	}
-	return cw - 1;
+	return (1 << ecw) - 1;
 }
 
 static void ieee80211_sta_wmm_params(struct net_device *dev,


