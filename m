Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249Ab2FHUai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 16:30:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so2994377pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 13:30:38 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: Rename stainfo variable for the more common sta
Date: Fri,  8 Jun 2012 13:30:25 -0700
Message-Id: <1339187425-12549-3-git-send-email-jason@cozybit.com> (sfid-20120608_223041_622523_FF0210A9)
In-Reply-To: <1339187425-12549-1-git-send-email-jason@cozybit.com>
References: <1339187425-12549-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
formerly sent as:
	[PATCH v3 4/5] mac80211: Rename stainfo variable for the more common sta

now also renames stainfo in mesh.h

 net/mac80211/mesh.h      |    2 +-
 net/mac80211/mesh_hwmp.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e364275..c7400a2 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -245,7 +245,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
 void ieee80211s_update_metric(struct ieee80211_local *local,
-		struct sta_info *stainfo, struct sk_buff *skb);
+		struct sta_info *sta, struct sk_buff *skb);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index acbd1ad..9b6da2d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -303,7 +303,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 }
 
 void ieee80211s_update_metric(struct ieee80211_local *local,
-		struct sta_info *stainfo, struct sk_buff *skb)
+		struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -315,9 +315,9 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100 */
-	stainfo->fail_avg = ((80 * stainfo->fail_avg + 5) / 100 + 20 * failed);
-	if (stainfo->fail_avg > 95)
-		mesh_plink_broken(stainfo);
+	sta->fail_avg = ((80 * sta->fail_avg + 5) / 100 + 20 * failed);
+	if (sta->fail_avg > 95)
+		mesh_plink_broken(sta);
 }
 
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
-- 
1.7.9.5

