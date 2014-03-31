Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44757 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaCaLnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:43:13 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so5666727wgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:43:12 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 04/13] mac80211: add support for radar detection for reservations
Date: Mon, 31 Mar 2014 12:39:22 +0200
Message-Id: <1396262371-6466-5-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134318_874621_C3307B5D)
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial chanctx reservation code wasn't aware of
radar detection requirements. This is necessary
for chanctx reservations to be used for channel
switching in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        | 5 ++++-
 net/mac80211/ieee80211_i.h | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 90cac10..cc85ad8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -743,7 +743,8 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 
 int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 				  const struct cfg80211_chan_def *chandef,
-				  enum ieee80211_chanctx_mode mode)
+				  enum ieee80211_chanctx_mode mode,
+				  bool radar_required)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
@@ -787,6 +788,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	new_ctx->refcount++;
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
+	sdata->reserved_radar_required = radar_required;
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
@@ -831,6 +833,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 	/* unref our reservation */
 	ctx->refcount--;
 	sdata->reserved_chanctx = NULL;
+	sdata->radar_required = sdata->reserved_radar_required;
 
 	if (old_ctx == ctx) {
 		/* This is our own context, just change it */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 41d9e49..a96e375 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -760,6 +760,7 @@ struct ieee80211_sub_if_data {
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
+	bool reserved_radar_required;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1785,7 +1786,8 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 int __must_check
 ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 			      const struct cfg80211_chan_def *chandef,
-			      enum ieee80211_chanctx_mode mode);
+			      enum ieee80211_chanctx_mode mode,
+			      bool radar_required);
 int __must_check
 ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 				   u32 *changed);
-- 
1.8.5.3

