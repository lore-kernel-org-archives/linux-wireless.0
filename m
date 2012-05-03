Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33155 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab2ECWHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 18:07:09 -0400
Received: by dady13 with SMTP id y13so2460602dad.5
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 15:07:08 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH] mac80211: send peer candidate event for new sta only
Date: Thu,  3 May 2012 15:06:09 -0700
Message-Id: <1336082769-23408-1-git-send-email-thomas@cozybit.com> (sfid-20120504_000748_632789_C83B828C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only send a cfg80211 new peer candidate notification if userspace has
yet to allocate this station entry.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8cc8461..ae026ac 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -346,6 +346,15 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	sta = sta_info_get(sdata, addr);
 	if (!sta) {
+		/* Userspace handles peer allocation when security is enabled */
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
+			cfg80211_notify_new_peer_candidate(sdata->dev, addr,
+							   elems->ie_start,
+							   elems->total_len,
+							   GFP_ATOMIC);
+			return NULL;
+		}
+
 		sta = mesh_plink_alloc(sdata, addr);
 		if (!sta)
 			return NULL;
@@ -387,15 +396,6 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 {
 	struct sta_info *sta;
 
-	/* Userspace handles peer allocation when security is enabled */
-	if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
-		cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
-						   elems->ie_start,
-						   elems->total_len,
-						   GFP_KERNEL);
-		return;
-	}
-
 	rcu_read_lock();
 	sta = mesh_peer_init(sdata, hw_addr, elems);
 	if (!sta)
-- 
1.7.5.4

