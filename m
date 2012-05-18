Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43813 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030207Ab2ERMDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:21 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 4/6] mac80211: use channel context notifications
Date: Fri, 18 May 2012 14:03:07 +0200
Message-ID: <1337342589-10617-5-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140334_335661_1C4E0BDD)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel context pointer will be accessiable on
both assign and unassign events.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e9b0f3e..32b7088 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -181,6 +182,8 @@ ieee80211_new_channel_context(struct ieee80211_local *local,
 	ctx->channel_type = channel_type;
 	INIT_LIST_HEAD(&ctx->vif_list);
 
+	drv_add_channel_context(local, ctx);
+
 	return ctx;
 }
 
@@ -191,6 +194,8 @@ ieee80211_free_channel_context(struct ieee80211_local *local,
 	if (WARN_ON(!list_empty(&ctx->vif_list)))
 		return;
 
+	drv_remove_channel_context(local, ctx);
+
 	ctx->channel = NULL;
 }
 
@@ -198,14 +203,22 @@ static void
 ieee80211_assign_vif_channel_context(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_channel_context *ctx)
 {
+	struct ieee80211_local *local = sdata->local;
+
 	list_add(&sdata->vif.list, &ctx->vif_list);
 	sdata->vif.channel_context = ctx;
+
+	drv_assign_vif_channel_context(local, sdata, ctx);
 }
 
 static void
 ieee80211_unassign_vif_channel_context(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_channel_context *ctx)
 {
+	struct ieee80211_local *local = sdata->local;
+
+	drv_unassign_vif_channel_context(local, sdata, ctx);
+
 	sdata->vif.channel_context = NULL;
 	list_del(&sdata->vif.list);
 }
-- 
1.7.0.4

