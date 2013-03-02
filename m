Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45459 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3CBGEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 01:04:15 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so2140877pbc.35
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 22:04:14 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 6/6] mac80211: init mesh timer for user authed STAs
Date: Fri,  1 Mar 2013 22:02:52 -0800
Message-Id: <1362204172-28307-6-git-send-email-thomas@cozybit.com> (sfid-20130302_070423_655385_8BF58280)
In-Reply-To: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a corner case which wasn't being covered:
userspace may authenticate and allocate stations,
but still leave the peering up to the kernel.

Initialize the peering timer if the MPM is not in
userspace, in a path which is taken by both the kernel and
userspace when allocating stations.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    1 -
 net/mac80211/sta_info.c   |    5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 635d643..bfb1720 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -420,7 +420,6 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 		return NULL;
 
 	sta->plink_state = NL80211_PLINK_LISTEN;
-	init_timer(&sta->plink_timer);
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a79ce82..2216361 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -342,6 +342,11 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
+#ifdef CONFIG_MAC80211_MESH
+	if (ieee80211_vif_is_mesh(&sdata->vif) &&
+	    !sdata->u.mesh.user_mpm)
+		init_timer(&sta->plink_timer);
+#endif
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
-- 
1.7.10.4

