Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:37295 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2FGAcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 20:32:50 -0400
Received: by mail-pz0-f66.google.com with SMTP id o14so24667dad.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 17:32:50 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 4/5] mac80211: Rename stainfo variable for the more common sta
Date: Wed,  6 Jun 2012 17:29:40 -0700
Message-Id: <1339028981-17097-5-git-send-email-jason@cozybit.com> (sfid-20120607_023254_398502_76252604)
In-Reply-To: <1339028981-17097-1-git-send-email-jason@cozybit.com>
References: <1339028981-17097-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 8fb3e59..22b327a 100644
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
@@ -317,16 +317,16 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100 */
-	stainfo->fail_avg = ((80 * stainfo->fail_avg + 5) / 100 + 20 * failed);
-	if (stainfo->fail_avg > 95)
-		mesh_plink_broken(stainfo);
+	sta->fail_avg = ((80 * sta->fail_avg + 5) / 100 + 20 * failed);
+	if (sta->fail_avg > 95)
+		mesh_plink_broken(sta);
 
-	sta_set_rate_info_tx(stainfo, &stainfo->last_tx_rate, &rinfo);
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
 	rate = cfg80211_calculate_bitrate(&rinfo);
 	if (WARN_ON(!rate))
 		return;
 
-	ewma_add(&stainfo->avg_rate, rate);
+	ewma_add(&sta->avg_rate, rate);
 	return;
 }
 
-- 
1.7.9.5

