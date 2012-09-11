Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab2IKNZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 08/12] mac80211: return error code from ieee80211_vif_use_channel
Date: Tue, 11 Sep 2012 15:26:19 +0200
Message-Id: <1347369983-12459-9-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152607_132529_8BB0FFAA)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of returning a bool successful value, return a
regular error code that could come from the driver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        |   22 ++++++++++++----------
 net/mac80211/ieee80211_i.h |    9 +++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 95c4a5f..94ed9e7 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -223,20 +223,22 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	int err;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	ctx = kzalloc(sizeof(*ctx) + local->hw.chanctx_data_size, GFP_KERNEL);
 	if (!ctx)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ctx->conf.channel = channel;
 	ctx->conf.channel_type = channel_type;
 	ctx->mode = mode;
 
-	if (drv_add_chanctx(local, ctx)) {
+	err = drv_add_chanctx(local, ctx);
+	if (err) {
 		kfree(ctx);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	list_add(&ctx->list, &local->chanctx_list);
@@ -343,10 +345,10 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_free_chanctx(local, ctx);
 }
 
-bool ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type,
-			       enum ieee80211_chanctx_mode mode)
+int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211_channel *channel,
+			      enum nl80211_channel_type channel_type,
+			      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx *ctx;
@@ -357,14 +359,14 @@ bool ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
 	if (!ctx)
 		ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
-	if (!ctx) {
+	if (IS_ERR(ctx)) {
 		mutex_unlock(&local->chanctx_mtx);
-		return false;
+		return PTR_ERR(ctx);
 	}
 
 	ieee80211_assign_vif_chanctx(sdata, ctx);
 	mutex_unlock(&local->chanctx_mtx);
-	return true;
+	return 0;
 }
 
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e0315d4..8fa00ad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1540,10 +1540,11 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 
-bool ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type,
-			       enum ieee80211_chanctx_mode mode);
+int __must_check
+ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_channel_type channel_type,
+			  enum ieee80211_chanctx_mode mode);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 
 #ifdef CONFIG_MAC80211_NOINLINE
-- 
1.7.10.4

