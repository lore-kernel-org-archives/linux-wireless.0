Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40027 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCaLnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:43:06 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3124371wiv.9
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:43:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 02/13] mac80211: add max channel calculation utility function
Date: Mon, 31 Mar 2014 12:39:20 +0200
Message-Id: <1396262371-6466-3-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134315_438822_1A9EE280)
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The utility function has no uses yet. It is aimed
at future chanctx reservation management and
channel switching.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/util.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 02fe9f4..41d9e49 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1830,6 +1830,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 const struct cfg80211_chan_def *chandef,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
+int ieee80211_max_num_channels(struct ieee80211_local *local);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 639bc13..09c4794 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2877,3 +2877,46 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 					   num_different_channels,
 					   radar_detect, num);
 }
+
+static void
+ieee80211_iter_max_chans(const struct ieee80211_iface_combination *c,
+			 void *data)
+{
+	u32 *max_num_different_channels = data;
+
+	*max_num_different_channels = max(*max_num_different_channels,
+					  c->num_different_channels);
+}
+
+int ieee80211_max_num_channels(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int num[NUM_NL80211_IFTYPES] = {};
+	struct ieee80211_chanctx *ctx;
+	int num_different_channels = 0;
+	u8 radar_detect = 0;
+	u32 max_num_different_channels = 1;
+	int err;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		num_different_channels++;
+
+		if (ctx->conf.radar_enabled)
+			radar_detect |= BIT(ctx->conf.def.width);
+	}
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		num[sdata->wdev.iftype]++;
+	}
+
+	err = cfg80211_iter_combinations(local->hw.wiphy,
+					 num_different_channels, radar_detect,
+					 num, ieee80211_iter_max_chans,
+					 &max_num_different_channels);
+	if (err < 0)
+		return err;
+
+	return max_num_different_channels;
+}
-- 
1.8.5.3

