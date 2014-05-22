Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56000 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaEVOPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:10 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so2685835eek.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 3/6] mac80211: make check_combinations() aware of chanctx reservation
Date: Thu, 22 May 2014 16:07:53 +0200
Message-Id: <1400767676-15994-4-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161516_966153_6A7D7F5C)
In-Reply-To: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_check_combinations() computes
radar_detect accordingly depending on chanctx
reservation status.

This makes it possible to use the function for
channel_switch validation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * fix typo in comment [Johannes]
     * fix comment style [Johannes]

 net/mac80211/util.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e0dd4b..419bf55 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2835,6 +2835,42 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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
@@ -2876,8 +2912,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
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

