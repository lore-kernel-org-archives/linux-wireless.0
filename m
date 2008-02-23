Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYBWOVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:23 -0500
Message-Id: <20080223142017.846789000@sipsolutions.net> (sfid-20080223_142134_383695_5837F50A)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 17/18] mac80211: mesh hwmp locking fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes missing unlocks noticed by sparse.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mesh_hwmp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/mesh_hwmp.c	2008-02-23 13:50:40.000000000 +0100
+++ everything/net/mac80211/mesh_hwmp.c	2008-02-23 13:51:11.000000000 +0100
@@ -264,8 +264,10 @@ static u32 hwmp_route_info_get(struct ne
 
 	rcu_read_lock();
 	sta = sta_info_get(local, mgmt->sa);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return 0;
+	}
 
 	last_hop_metric = airtime_link_metric_get(local, sta);
 	/* Update and check originator routing info */
@@ -293,6 +295,7 @@ static u32 hwmp_route_info_get(struct ne
 		break;
 	default:
 		sta_info_put(sta);
+		rcu_read_unlock();
 		return 0;
 	}
 	new_metric = orig_metric + last_hop_metric;

-- 

