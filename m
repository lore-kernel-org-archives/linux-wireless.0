Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXKPLyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:54:19 -0500
Subject: [PATCH] mac80211: fix ieee80211_set_multicast_list
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 01:49:11 +0100
Message-Id: <1195174151.8147.87.camel@johannes.berg> (sfid-20071116_115421_715340_4E4EC730)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently experienced unexplainable behaviour with the b43
driver when I had broken firmware uploaded. The cause may have
been that promisc mode was not correctly enabled or disabled
and this bug may have been the cause.

Note how the values are compared later in the function so
just doing the & will result in the wrong thing being
compared and the test being false almost always.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, please push for 2.6.24. As this bug was introduced with the filter
flags changes, it's not applicable to .23.

 net/mac80211/ieee80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2007-11-16 01:44:14.211949434 +0100
+++ everything/net/mac80211/ieee80211.c	2007-11-16 01:44:22.401940754 +0100
@@ -366,8 +366,8 @@ static void ieee80211_set_multicast_list
 
 	allmulti = !!(dev->flags & IFF_ALLMULTI);
 	promisc = !!(dev->flags & IFF_PROMISC);
-	sdata_allmulti = sdata->flags & IEEE80211_SDATA_ALLMULTI;
-	sdata_promisc = sdata->flags & IEEE80211_SDATA_PROMISC;
+	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
+	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
 
 	if (allmulti != sdata_allmulti) {
 		if (dev->flags & IFF_ALLMULTI)


