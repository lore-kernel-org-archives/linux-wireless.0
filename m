Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2G0LRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 03/20] mac80211: add drv_* wrappers for channel contexts
Date: Fri, 27 Jul 2012 13:16:39 +0200
Message-Id: <1343387816-9414-4-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131728_790707_47ADE4DB)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |   46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 597a474..b38f97d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -866,4 +866,50 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 		local->ops->mgd_prepare_tx(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
 }
+
+static inline void drv_add_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->add_chanctx)
+		local->ops->add_chanctx(&local->hw, &ctx->conf);
+}
+
+static inline void drv_remove_chanctx(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->remove_chanctx)
+		local->ops->remove_chanctx(&local->hw, &ctx->conf);
+}
+
+static inline void drv_change_chantype(struct ieee80211_local *local,
+				       struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->change_chantype)
+		local->ops->change_chantype(&local->hw, &ctx->conf);
+}
+
+static inline void drv_assign_vif_chanctx(struct ieee80211_local *local,
+					  struct ieee80211_sub_if_data *sdata,
+					  struct ieee80211_chanctx *ctx)
+{
+	check_sdata_in_driver(sdata);
+
+	if (local->ops->assign_vif_chanctx)
+		local->ops->assign_vif_chanctx(&local->hw,
+					       &sdata->vif,
+					       &ctx->conf);
+}
+
+static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
+					    struct ieee80211_sub_if_data *sdata,
+					    struct ieee80211_chanctx *ctx)
+{
+	check_sdata_in_driver(sdata);
+
+	if (local->ops->unassign_vif_chanctx)
+		local->ops->unassign_vif_chanctx(&local->hw,
+						 &sdata->vif,
+						 &ctx->conf);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
-- 
1.7.10.4

