Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0DFJWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:42 -0400
Message-Id: <20100406092141.321900265@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] mac80211: fix station destruction problem
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station w/o a key is destroyed, or when
a driver submits work for a station and thereby
references it again, it seems like potentially
we could reference the station structure while
it is being destroyed.

Wait for an RCU grace period to elapse before
finishing destroying the station after we have
removed the station from the driver and from
the hash table etc., even in the case where no
key is associated with the station.

Also, there's no point in deleting the plink
timer here since it'll be properly deleted just
a bit later.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.c	2010-04-06 09:07:33.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-04-06 09:08:15.000000000 +0200
@@ -645,9 +645,6 @@ static int __must_check __sta_info_destr
 		 * may mean it is removed from hardware which requires that
 		 * the key->sta pointer is still valid, so flush the key todo
 		 * list here.
-		 *
-		 * ieee80211_key_todo() will synchronize_rcu() so after this
-		 * nothing can reference this sta struct any more.
 		 */
 		ieee80211_key_todo();
 
@@ -679,11 +676,17 @@ static int __must_check __sta_info_destr
 		sdata = sta->sdata;
 	}
 
+	/*
+	 * At this point, after we wait for an RCU grace period,
+	 * neither mac80211 nor the driver can reference this
+	 * sta struct any more except by still existing timers
+	 * associated with this station that we clean up below.
+	 */
+	synchronize_rcu();
+
 #ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
-		del_timer(&sta->plink_timer);
-	}
 #endif
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG


