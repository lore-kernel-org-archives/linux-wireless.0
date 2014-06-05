Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33713 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaFEND6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 09:03:58 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so10472595wiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 06:03:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v8 2/5] mac80211: make check_combinations() aware of chanctx reservation
Date: Thu,  5 Jun 2014 14:56:17 +0200
Message-Id: <1401972980-21484-3-git-send-email-michal.kazior@tieto.com> (sfid-20140605_150403_801478_D8E831C5)
In-Reply-To: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
 <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
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
    
    v8:
     * use replace_state/replace_ctx instead of replaces/replaced_by (rebased)

 net/mac80211/util.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8e661ea..16dc720 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2837,6 +2837,35 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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
+	if (WARN_ON(ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED))
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
+	WARN_ON(ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER &&
+		!list_empty(&ctx->assigned_vifs));
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
@@ -2880,8 +2909,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
 			continue;
-		if (ctx->conf.radar_enabled)
-			radar_detect |= BIT(ctx->conf.def.width);
+		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
 			num_different_channels++;
 			continue;
@@ -2943,8 +2971,7 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 
 		num_different_channels++;
 
-		if (ctx->conf.radar_enabled)
-			radar_detect |= BIT(ctx->conf.def.width);
+		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-- 
1.8.5.3

