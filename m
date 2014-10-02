Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37442 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaJBG6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 02:58:37 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so1664130lbv.7
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2014 23:58:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] mac80211: enable DFS with channel contexts
Date: Thu,  2 Oct 2014 08:45:04 +0200
Message-Id: <1412232304-7588-1-git-send-email-michal.kazior@tieto.com> (sfid-20141002_085841_248183_661A790A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is okay to enable DFS for channel contexts
based drivers as long as no combination advertises
radar detection and multi-channel operation at the
same time.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
I think this is enough for single-channel
chanctx-based drivers or am I missing something?

 net/mac80211/main.c |  5 +++--
 net/mac80211/util.c | 16 ++++++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0de7c93..ba46251 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -787,13 +787,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS))
 			return -EINVAL;
 
-		/* DFS currently not supported with channel context drivers */
+		/* DFS is not supported with multi-channel combinations yet */
 		for (i = 0; i < local->hw.wiphy->n_iface_combinations; i++) {
 			const struct ieee80211_iface_combination *comb;
 
 			comb = &local->hw.wiphy->iface_combinations[i];
 
-			if (comb->radar_detect_widths)
+			if (comb->radar_detect_widths &&
+			    comb->num_different_channels > 1)
 				return -EINVAL;
 		}
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c61060..c76c9d7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2526,11 +2526,23 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, radar_detected_work);
 	struct cfg80211_chan_def chandef = local->hw.conf.chandef;
+	struct ieee80211_chanctx *ctx;
+	int num_chanctx = 0;
+
+	mutex_lock(&local->chanctx_mtx);
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER)
+			continue;
+
+		num_chanctx++;
+		chandef = ctx->conf.def;
+	}
+	mutex_unlock(&local->chanctx_mtx);
 
 	ieee80211_dfs_cac_cancel(local);
 
-	if (local->use_chanctx)
-		/* currently not handled */
+	if (num_chanctx > 1)
+		/* XXX: multi-channel is not supported yet */
 		WARN_ON(1);
 	else
 		cfg80211_radar_event(local->hw.wiphy, &chandef, GFP_KERNEL);
-- 
1.8.5.3

