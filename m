Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51001 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 09:52:38 -0400
Received: by wibhr14 with SMTP id hr14so1725672wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 06:52:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: reconfigure channel contexts on ieee80211_reconfigure
Date: Mon,  6 Aug 2012 16:52:49 +0300
Message-Id: <1344261169-19962-1-git-send-email-eliad@wizery.com> (sfid-20120806_155242_159461_E647703A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel contexts have to be re-added and re-assigned
on device reconfiguration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
this patch is based on the channel contexts patches
in mac80211-next/wip branch.

net/mac80211/util.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 293e6fe..c254abc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1255,6 +1255,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_chanctx *ctx;
 	struct sta_info *sta;
 	int res, i;
 
@@ -1327,6 +1328,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			res = drv_add_interface(local, sdata);
 	}
 
+	/* add channel contexts */
+	mutex_lock(&local->chanctx_mtx);
+	list_for_each_entry(ctx, &local->chanctx_list, list)
+		WARN_ON(drv_add_chanctx(local, ctx));
+	mutex_unlock(&local->chanctx_mtx);
+
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -1367,11 +1374,22 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		struct ieee80211_chanctx_conf *ctx_conf;
 		u32 changed;
 
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
+		mutex_lock(&local->chanctx_mtx);
+		ctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+		if (ctx_conf) {
+			ctx = container_of(ctx_conf, struct ieee80211_chanctx,
+					   conf);
+			drv_assign_vif_chanctx(local, sdata, ctx);
+		}
+		mutex_unlock(&local->chanctx_mtx);
+
 		/* common change flags for all interface types */
 		changed = BSS_CHANGED_ERP_CTS_PROT |
 			  BSS_CHANGED_ERP_PREAMBLE |
-- 
1.7.6.401.g6a319

