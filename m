Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46534 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaB1PMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:12:01 -0500
Received: by mail-ea0-f169.google.com with SMTP id d10so2802952eaj.28
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:12:00 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/3] mac80211: add max channel calculation utility function
Date: Fri, 28 Feb 2014 16:06:46 +0100
Message-Id: <1393600007-28766-3-git-send-email-michal.kazior@tieto.com> (sfid-20140228_161207_706143_671D0DC9)
In-Reply-To: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
References: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
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
index d3ebe7f..508eecf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1814,6 +1814,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 const struct cfg80211_chan_def *chandef,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
+int ieee80211_max_num_channels(struct ieee80211_local *local);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 955b043..7233102 100644
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

