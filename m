Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2IKNZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 07/12] mac80211: allow drv_add_chanctx to fail
Date: Tue, 11 Sep 2012 15:26:18 +0200
Message-Id: <1347369983-12459-8-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152616_465412_5360E029)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver might need to do some operations to the
device that could fail, so allow drv_add_chanctx()
to fail and propagate that error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |    4 ++--
 net/mac80211/chan.c       |    7 +++++--
 net/mac80211/driver-ops.h |   12 ++++++++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d955c1..d6111a1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2508,8 +2508,8 @@ struct ieee80211_ops {
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
 
-	void (*add_chanctx)(struct ieee80211_hw *hw,
-			    struct ieee80211_chanctx_conf *ctx);
+	int (*add_chanctx)(struct ieee80211_hw *hw,
+			   struct ieee80211_chanctx_conf *ctx);
 	void (*remove_chanctx)(struct ieee80211_hw *hw,
 			       struct ieee80211_chanctx_conf *ctx);
 	void (*change_chanctx)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e77da88..95c4a5f 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -234,9 +234,12 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.channel_type = channel_type;
 	ctx->mode = mode;
 
-	list_add(&ctx->list, &local->chanctx_list);
+	if (drv_add_chanctx(local, ctx)) {
+		kfree(ctx);
+		return NULL;
+	}
 
-	drv_add_chanctx(local, ctx);
+	list_add(&ctx->list, &local->chanctx_list);
 
 	return ctx;
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index aa34cb5..0526d9f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -872,13 +872,17 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_add_chanctx(struct ieee80211_local *local,
-				   struct ieee80211_chanctx *ctx)
+static inline int drv_add_chanctx(struct ieee80211_local *local,
+				  struct ieee80211_chanctx *ctx)
 {
+	int ret = -EOPNOTSUPP;
+
 	trace_drv_add_chanctx(local, ctx);
 	if (local->ops->add_chanctx)
-		local->ops->add_chanctx(&local->hw, &ctx->conf);
-	trace_drv_return_void(local);
+		ret = local->ops->add_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_int(local, ret);
+
+	return ret;
 }
 
 static inline void drv_remove_chanctx(struct ieee80211_local *local,
-- 
1.7.10.4

