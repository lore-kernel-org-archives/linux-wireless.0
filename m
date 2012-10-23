Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35834 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JWSzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 14:55:18 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2967103pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 11:55:18 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: don't allocate mesh peer under RCU
Date: Tue, 23 Oct 2012 11:55:07 -0700
Message-Id: <1351018508-6390-1-git-send-email-thomas@cozybit.com> (sfid-20121023_205523_891677_C9940C2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh_plink_alloc() was being called with the RCU read lock held, which
triggered warnings because various things inside this function must
sleep. It doesn't make much sense to hold an RCU lock on a pointer we
don't yet have anyway, so do rcu_read_unlock() if allocating and relock
on insertion. This also means there is no need for
cfg80211_notify_new_peer_candidate() to be atomic.

Also balance the RCU lock if we are returning early.

This warning was only visible with CONFIG_DEBUG_ATOMIC_SLEEP enabled.

Reported-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 234fe75..427c87d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -346,7 +346,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0;
-	struct sta_info *sta;
+	struct sta_info *sta = NULL;
 	bool insert = false;
 
 	sband = local->hw.wiphy->bands[band];
@@ -354,18 +354,19 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	sta = sta_info_get(sdata, addr);
 	if (!sta) {
+		rcu_read_unlock();
 		/* Userspace handles peer allocation when security is enabled */
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
 			cfg80211_notify_new_peer_candidate(sdata->dev, addr,
 							   elems->ie_start,
 							   elems->total_len,
-							   GFP_ATOMIC);
-			return NULL;
+							   GFP_KERNEL);
+			goto lock_out;
 		}
 
 		sta = mesh_plink_alloc(sdata, addr);
 		if (!sta)
-			return NULL;
+			goto lock_out;
 		insert = true;
 	}
 
@@ -397,10 +398,13 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	rate_control_rate_init(sta);
 	spin_unlock_bh(&sta->lock);
 
-	if (insert && sta_info_insert(sta))
+	if (insert && sta_info_insert_rcu(sta))
 		return NULL;
 
 	return sta;
+lock_out:
+	rcu_read_lock();
+	return sta;
 }
 
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-- 
1.7.9.5

