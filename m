Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65401 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965980Ab3E2Vck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 17:32:40 -0400
Received: by mail-pd0-f171.google.com with SMTP id z11so9551751pdj.16
        for <linux-wireless@vger.kernel.org>; Wed, 29 May 2013 14:32:40 -0700 (PDT)
From: Jacob Minshall <jacob@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org
Subject: [PATCH v2] mac80211: set mesh formation field properly
Date: Wed, 29 May 2013 14:32:36 -0700
Message-Id: <1369863156-26149-1-git-send-email-jacob@cozybit.com> (sfid-20130529_233243_944271_1022DFE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cap max peerings at 63 in accordance with IEEE-2012 8.4.2.100.7.
Triggers a beacon regeneration every time the number of peerings changes.
Previously this would only happen if the "accepting peerings" bit changed.

Signed-off-by: Jacob Minshall <jacob@cozybit.com>
---
using min_t instead of ternary (Johannes)
returning bitwise or value of mesh_accept..(...) and BSS_CHANGED_BEACON
when inc or dec estab plinks (Johannes)
 include/linux/ieee80211.h |    1 +
 net/mac80211/mesh.c       |    3 +--
 net/mac80211/mesh.h       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d826e5a..b0dc87a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -146,6 +146,7 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
 #define IEEE80211_MAX_RTS_THRESHOLD	2353
 #define IEEE80211_MAX_AID		2007
 #define IEEE80211_MAX_TIM_LEN		251
+#define IEEE80211_MAX_MESH_PEERINGS	63
 /* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
    6.2.1.1.2.
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b3d1fdd..73a597b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -274,8 +274,7 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	*pos++ = ifmsh->mesh_auth_id;
 	/* Mesh Formation Info - number of neighbors */
 	neighbors = atomic_read(&ifmsh->estab_plinks);
-	/* Number of neighbor mesh STAs or 15 whichever is smaller */
-	neighbors = (neighbors > 15) ? 15 : neighbors;
+	neighbors = min_t(int, neighbors, IEEE80211_MAX_MESH_PEERINGS);
 	*pos++ = neighbors << 1;
 	/* Mesh capability */
 	*pos = IEEE80211_MESHCONF_CAPAB_FORWARDING;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index da15877..8b4d9a3 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -324,14 +324,14 @@ static inline
 u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
+	return mesh_accept_plinks_update(sdata) | BSS_CHANGED_BEACON;
 }
 
 static inline
 u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
+	return mesh_accept_plinks_update(sdata) | BSS_CHANGED_BEACON;
 }
 
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
-- 
1.7.9.5

