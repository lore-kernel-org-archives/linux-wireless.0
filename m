Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57461 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760948AbaCUNxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:53:36 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1820718eek.18
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:53:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 04/13] mac80211: add support for radar detection for reservations
Date: Fri, 21 Mar 2014 14:47:22 +0100
Message-Id: <1395409651-26120-5-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145346_974097_503A4152)
In-Reply-To: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
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
index 2bf2d01..6b993f9 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -736,7 +736,8 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 
 int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 				  const struct cfg80211_chan_def *chandef,
-				  enum ieee80211_chanctx_mode mode)
+				  enum ieee80211_chanctx_mode mode,
+				  bool radar_required)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
@@ -780,6 +781,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	new_ctx->refcount++;
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
+	sdata->reserved_radar_required = radar_required;
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
@@ -824,6 +826,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
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

