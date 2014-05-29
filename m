Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62514 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbaE2Hlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 03:41:46 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so5028749wiw.14
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 00:41:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v7 2/5] mac80211: make check_combinations() aware of chanctx reservation
Date: Thu, 29 May 2014 09:34:08 +0200
Message-Id: <1401348851-26732-3-git-send-email-michal.kazior@tieto.com> (sfid-20140529_094151_722315_160C82BF)
In-Reply-To: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
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
    
    v7:
     * use replaces/replaced_by pointers
     * replace radar_detect calculation in ieee80211_max_num_channels() too

 net/mac80211/util.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6615044..b2f7bf9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2836,6 +2836,34 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 	ps->dtim_count = dtim_count;
 }
 
+static u8 ieee80211_chanctx_radar_detect(struct ieee80211_local *local,
+					 struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u8 radar_detect = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (WARN_ON(ctx->replaced_by))
+		return 0;
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list)
+		if (sdata->reserved_radar_required)
+			radar_detect |= BIT(sdata->reserved_chandef.width);
+
+	/*
+	 * An in-place reservation context should not have any assigned vifs
+	 * until it replaces the other context.
+	 */
+	WARN_ON(ctx->replaces && !list_empty(&ctx->assigned_vifs));
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
@@ -2879,8 +2907,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		if (ctx->replaced_by)
 			continue;
-		if (ctx->conf.radar_enabled)
-			radar_detect |= BIT(ctx->conf.def.width);
+		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
 			num_different_channels++;
 			continue;
@@ -2942,8 +2969,7 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 
 		num_different_channels++;
 
-		if (ctx->conf.radar_enabled)
-			radar_detect |= BIT(ctx->conf.def.width);
+		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-- 
1.8.5.3

