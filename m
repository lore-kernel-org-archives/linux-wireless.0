Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63991 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2TV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 15:21:59 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so9610970pbb.34
        for <linux-wireless@vger.kernel.org>; Wed, 29 May 2013 12:21:59 -0700 (PDT)
From: Jacob Minshall <jacob@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org
Subject: [PATCH] mac80211: mesh formation info properly set
Date: Wed, 29 May 2013 12:21:53 -0700
Message-Id: <1369855313-25871-1-git-send-email-jacob@cozybit.com> (sfid-20130529_212203_866884_2F183EA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max peerings capped at 63 in accordance with IEEE-2012 8.4.2.100.7,
and trigger a beacon regeneration every time the number of peerings
changes. Previously this would only happen if the "accepting peerings"
bit changed.

Signed-off-by: Jacob Minshall <jacob@cozybit.com>
---
 include/linux/ieee80211.h |    1 +
 net/mac80211/mesh.c       |    4 ++--
 net/mac80211/mesh.h       |    6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 06b0ed0..c181f48 100644
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
index 6952760..d3e973e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -271,8 +271,8 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	*pos++ = ifmsh->mesh_auth_id;
 	/* Mesh Formation Info - number of neighbors */
 	neighbors = atomic_read(&ifmsh->estab_plinks);
-	/* Number of neighbor mesh STAs or 15 whichever is smaller */
-	neighbors = (neighbors > 15) ? 15 : neighbors;
+	neighbors = (neighbors > IEEE80211_MAX_MESH_PEERINGS) ?
+			IEEE80211_MAX_MESH_PEERINGS : neighbors;
 	*pos++ = neighbors << 1;
 	/* Mesh capability */
 	*pos = IEEE80211_MESHCONF_CAPAB_FORWARDING;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index da15877..7d0f1df 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -324,14 +324,16 @@ static inline
 u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
+	mesh_accept_plinks_update(sdata);
+	return BSS_CHANGED_BEACON;
 }
 
 static inline
 u32 mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.estab_plinks);
-	return mesh_accept_plinks_update(sdata);
+	mesh_accept_plinks_update(sdata);
+	return BSS_CHANGED_BEACON;
 }
 
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
-- 
1.7.9.5

