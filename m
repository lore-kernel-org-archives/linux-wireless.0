Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1ELNHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 09:07:15 -0400
Subject: [PATCH] mac80211: fix another key non-race
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:07:15 +0200
Message-ID: <1305205635.3461.28.camel@jlt3.sipsolutions.net> (sfid-20110512_150720_321626_92EFDB08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code here is only not racy because all the
places that assign the pointers it uses are
holding the sta_mtx as well as the key_mtx and
so can't race against this because this code
holds the sta_mtx. But that's not intuitive,
so fix it to hold the key_mtx.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c	2011-05-12 14:35:00.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-05-12 14:35:28.000000000 +0200
@@ -652,10 +652,12 @@ static int __must_check __sta_info_destr
 	if (ret)
 		return ret;
 
+	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-		ieee80211_key_free(local, sta->gtk[i]);
+		__ieee80211_key_free(sta->gtk[i]);
 	if (sta->ptk)
-		ieee80211_key_free(local, sta->ptk);
+		__ieee80211_key_free(sta->ptk);
+	mutex_unlock(&local->key_mtx);
 
 	sta->dead = true;
 


