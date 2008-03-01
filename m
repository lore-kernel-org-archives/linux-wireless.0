Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYCASc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 13:32:29 -0500
Subject: [PATCH] mac80211: always insert key into list
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 19:32:18 +0100
Message-Id: <1204396338.3917.9.camel@johannes.berg> (sfid-20080301_183233_001973_574DF809)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today I hit one of my new WARN_ONs in the mac80211 code because
a key wasn't being freed correctly. After wondering for a while
I finally tracked it to the fact that STA keys aren't added to
the per-sdata key list correctly, they are supposed to always be
on that list, not just for default keys. This patch fixes that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, please merge soon, the ultimate consequence of this bug is that
when trying to delete everything mac80211 segfaults with an access to
already freed memory because the key is freed but still thought to
belong to a STA.

 net/mac80211/key.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/key.c	2008-03-01 19:28:56.000000000 +0100
+++ everything/net/mac80211/key.c	2008-03-01 19:29:00.000000000 +0100
@@ -174,6 +174,9 @@ static void __ieee80211_key_replace(stru
 {
 	int idx, defkey;
 
+	if (new)
+		list_add(&new->list, &sdata->key_list);
+
 	if (sta) {
 		rcu_assign_pointer(sta->key, new);
 	} else {
@@ -190,9 +193,6 @@ static void __ieee80211_key_replace(stru
 			ieee80211_set_default_key(sdata, -1);
 
 		rcu_assign_pointer(sdata->keys[idx], new);
-		if (new)
-			list_add(&new->list, &sdata->key_list);
-
 		if (defkey && new)
 			ieee80211_set_default_key(sdata, new->conf.keyidx);
 	}


