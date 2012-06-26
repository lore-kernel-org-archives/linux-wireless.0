Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54258 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab2FZMh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:37:29 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 5/7] mac80211: use channel context notifications
Date: Tue, 26 Jun 2012 14:37:20 +0200
Message-ID: <1340714242-20032-6-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143739_438291_21C33DEA)
In-Reply-To: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Channel context pointer will be accessiable on
both assign and unassign events.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index dc397a8..1aa553d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -190,6 +191,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add(&ctx->list, &local->chanctx_list);
 
+	drv_add_chanctx(local, ctx);
+
 	return ctx;
 }
 
@@ -200,6 +203,8 @@ ieee80211_free_chanctx(struct ieee80211_chanctx *ctx)
 
 	BUG_ON(ctx->refcount != 0);
 
+	drv_remove_chanctx(ctx->local, ctx);
+
 	list_del(&ctx->list);
 	kfree(ctx);
 }
@@ -212,6 +217,8 @@ ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.chanctx_conf = &ctx->conf;
 	ctx->refcount++;
+
+	drv_assign_vif_chanctx(sdata->local, sdata, ctx);
 }
 
 static void
@@ -220,6 +227,8 @@ ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 {
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	drv_unassign_vif_chanctx(sdata->local, sdata, ctx);
+
 	ctx->refcount--;
 	sdata->vif.chanctx_conf = NULL;
 }
-- 
1.7.0.4

