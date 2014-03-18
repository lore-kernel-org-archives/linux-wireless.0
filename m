Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59105 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaCRN7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:10 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5448442eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:09 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 03/21] mac80211: add max channel calculation utility function
Date: Tue, 18 Mar 2014 14:53:06 +0100
Message-Id: <1395150804-24090-4-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145928_707661_39A02614)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
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
index 15556fe..d4b3fe4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1823,6 +1823,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 const struct cfg80211_chan_def *chandef,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
+int ieee80211_max_num_channels(struct ieee80211_local *local);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7029a59..2e3e6a3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2873,3 +2873,46 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
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

