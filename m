Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46454 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab2FUMDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:43 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 5/7] mac80211: use channel context notifications
Date: Thu, 21 Jun 2012 14:03:34 +0200
Message-ID: <1340280216-18807-6-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140353_917538_39E23C49)
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
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
index f5b4a77..20483a0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -187,6 +188,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	list_add(&ctx->list, &local->chanctx_list);
 	INIT_LIST_HEAD(&ctx->interfaces);
 
+	drv_add_chanctx(local, ctx);
+
 	return ctx;
 }
 
@@ -195,6 +198,8 @@ ieee80211_free_chanctx(struct ieee80211_chanctx *ctx)
 {
 	BUG_ON(!list_empty(&ctx->interfaces));
 
+	drv_remove_chanctx(ctx->local, ctx);
+
 	list_del(&ctx->list);
 	kfree(ctx);
 }
@@ -205,12 +210,16 @@ ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 {
 	list_add(&sdata->chanctx_listitem, &ctx->interfaces);
 	sdata->vif.chanctx_conf = &ctx->conf;
+
+	drv_assign_vif_chanctx(sdata->local, sdata, ctx);
 }
 
 static void
 ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_chanctx *ctx)
 {
+	drv_unassign_vif_chanctx(sdata->local, sdata, ctx);
+
 	sdata->vif.chanctx_conf = NULL;
 	list_del(&sdata->chanctx_listitem);
 }
-- 
1.7.0.4

