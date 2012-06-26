Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54258 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2FZMh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:37:28 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 3/7] mac80211: add drv_* wrappers for channel contexts
Date: Tue, 26 Jun 2012 14:37:18 +0200
Message-ID: <1340714242-20032-4-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143734_008808_4C7C178C)
In-Reply-To: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/driver-ops.h |   51 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..e79f06d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,55 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline void
+drv_add_chanctx(struct ieee80211_local *local,
+		struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->add_chanctx)
+		local->ops->add_chanctx(&local->hw, &ctx->conf);
+}
+
+static inline void
+drv_remove_chanctx(struct ieee80211_local *local,
+		   struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->remove_chanctx)
+		local->ops->remove_chanctx(&local->hw, &ctx->conf);
+}
+
+static inline void
+drv_change_chantype(struct ieee80211_local *local,
+		    struct ieee80211_chanctx *ctx)
+{
+	if (local->ops->change_chantype)
+		local->ops->change_chantype(&local->hw, &ctx->conf);
+}
+
+static inline void
+drv_assign_vif_chanctx(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_chanctx *ctx)
+{
+	check_sdata_in_driver(sdata);
+
+	if (local->ops->assign_vif_chanctx)
+		local->ops->assign_vif_chanctx(&local->hw,
+					       &sdata->vif,
+					       &ctx->conf);
+}
+
+static inline void
+drv_unassign_vif_chanctx(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_chanctx *ctx)
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
1.7.0.4

