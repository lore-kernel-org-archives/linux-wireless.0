Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38244 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbaDINvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:54 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1932408eei.14
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:51:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 1/5] mac80211: make check_combinations() aware of chanctx reservation
Date: Wed,  9 Apr 2014 15:45:33 +0200
Message-Id: <1397051137-26201-2-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155212_077887_14A4413E)
In-Reply-To: <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_check_combinations() computes
radar_detect accordingly depending on chanctx
reservation status.

This makes it possible to use the function for
channel_switch validation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * fix typo in comment [Johannes]
 * fix comment style [Johannes]

 net/mac80211/util.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7a376f8..c296727 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2798,6 +2798,42 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 	ps->dtim_count = dtim_count;
 }
 
+static u8 ieee80211_chanctx_radar_detect(struct ieee80211_local *local,
+					 struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_chanctx_conf *conf;
+	u8 radar_detect = 0;
+	bool in_place = false;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		if (sdata->reserved_radar_required)
+			radar_detect |= BIT(sdata->reserved_chandef.width);
+
+		conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+		if (conf == &ctx->conf)
+			in_place = true;
+	}
+
+	/*
+	 * if chanctx has in-place reservation then consider only the future
+	 * radar_detect. multi-vif reservation is deferred so ignore assigned
+	 * vifs. it is impossible for new vifs to be bound to an in-place
+	 * reserved chanctx so consistency is guaranteed
+	 */
+	if (in_place)
+		return radar_detect;
+
+	list_for_each_entry(sdata, &ctx->assigned_vifs, assigned_chanctx_list)
+		if (sdata->radar_required)
+			radar_detect |= BIT(sdata->vif.bss_conf.chandef.width);
+
+	return radar_detect;
+}
+
 int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 const struct cfg80211_chan_def *chandef,
 				 enum ieee80211_chanctx_mode chanmode,
@@ -2839,8 +2875,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		num[iftype] = 1;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
-		if (ctx->conf.radar_enabled)
-			radar_detect |= BIT(ctx->conf.def.width);
+		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
 			num_different_channels++;
 			continue;
-- 
1.8.5.3

