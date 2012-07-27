Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2G0LR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 18/20] mac80211: allow drv_add_chanctx to fail
Date: Fri, 27 Jul 2012 13:16:54 +0200
Message-Id: <1343387816-9414-19-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131823_317962_AA8D50FC)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver might need to do some operations to the
device that could fail, so allow drv_add_chanctx()
to fail and propagate that error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |    4 ++--
 net/mac80211/chan.c       |    5 ++++-
 net/mac80211/driver-ops.h |   12 ++++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 969eb20..a3c647c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2445,8 +2445,8 @@ struct ieee80211_ops {
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
 
-	void (*add_chanctx)(struct ieee80211_hw *hw,
-			    struct ieee80211_chanctx_conf *ctx);
+	int (*add_chanctx)(struct ieee80211_hw *hw,
+			   struct ieee80211_chanctx_conf *ctx);
 	void (*remove_chanctx)(struct ieee80211_hw *hw,
 			       struct ieee80211_chanctx_conf *ctx);
 	void (*change_chantype)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 40e707c..2c7c975 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -237,7 +237,10 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add(&ctx->list, &local->chanctx_list);
 
-	drv_add_chanctx(local, ctx);
+	if (drv_add_chanctx(local, ctx)) {
+		kfree(ctx);
+		return NULL;
+	}
 
 	return ctx;
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index da0fa69..bca963a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -867,13 +867,17 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
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

