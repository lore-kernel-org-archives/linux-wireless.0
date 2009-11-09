Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47150 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZKIXrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:05 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3974559ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:10 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>
Subject: [PATCH v2 03/20] mac80211: implement the meshconf formation info field
Date: Mon,  9 Nov 2009 23:46:41 +0000
Message-Id: <1257810418-30075-4-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Mesh Configuration Formation Info field contains the number of
neighbors.  This means that the beacon must be updated every time a
peer joins or leaves.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <rpaulo@gmail.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.c       |    9 ++++++---
 net/mac80211/mesh_plink.c |    2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a49a337..7942518 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -223,6 +223,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 	int len, i, rate;
+	u8 neighbors;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	len = sband->n_bitrates;
@@ -271,9 +272,11 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	/* Authentication Protocol identifier */
 	*pos++ = sdata->u.mesh.mesh_auth_id;
 
-	/* Mesh Formation Info */
-	memset(pos, 0x00, 1);
-	pos += 1;
+	/* Mesh Formation Info - number of neighbors */
+	neighbors = atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
+	/* Number of neighbor mesh STAs or 15 whichever is smaller */
+	neighbors = (neighbors > 15) ? 15 : neighbors;
+	*pos++ = neighbors << 1;
 
 	/* Mesh capability */
 	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ffcbad7..f98c8d2 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -65,6 +65,7 @@ void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 static inline
@@ -72,6 +73,7 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 /**
-- 
1.5.6.5

