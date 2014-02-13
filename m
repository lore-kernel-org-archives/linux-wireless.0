Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59159 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaBMAVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 19:21:44 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so9711967pde.34
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 16:21:44 -0800 (PST)
MIME-Version: 1.0
From: Blaise Gassend <blaise@suitabletech.com>
Date: Wed, 12 Feb 2014 16:21:24 -0800
Message-ID: <CAPvVjiuvKSTMxBqDYwskx39TC=TCh+o9zZwGFcZTc_N-Y+YLyA@mail.gmail.com> (sfid-20140213_012148_123983_9EA51140)
Subject: PATCH: wireless: Allow active scanning while associated with custom
 world regulatory domain
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath9k sets a custom world regulatory domain with only
passive scanning allowed throughout the 5 GHz band. Once you associate
to an AP, the passive scanning limitation gets added to the country IE
regulatory domain for the AP. However, once you are associated you are
no longer in a world regulatory domain so beacon hints stop working.
As a result active scanning is forbidden, and there is no mechanism to
enable it. This is despite the fact that active scanning would be
allowed when not associated (thanks to beacon hints), and is allowed
by the country IE regulatory domain.

The following patch considers that IEEE80211_CHAN_PASSIVE_SCAN from
the custom world regulatory domain should be ignored once we are
associated, since we now actually know which regulatory domain we are
in. If the custom regulatory domain was disabling certain frequencies,
those frequencies will still be disabled with this patch applied.

Signed-off-by: Blaise Gassend <blaise.gassend_linux@m4x.org>
---
diff --git a/modules/backports-20131025/net/wireless/reg.c
b/modules/backports-20131025/net/wireless/reg.c
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -837,8 +837,6 @@ static void handle_channel(struct wiphy

        request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);

-       flags = chan->orig_flags;
-
        reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
        if (IS_ERR(reg_rule)) {
                /*
@@ -892,7 +890,16 @@ static void handle_channel(struct wiphy
        chan->dfs_state = NL80211_DFS_USABLE;
        chan->dfs_state_entered = jiffies;

-       chan->beacon_found = false;
+        /*
+         * Clear IEEE80211_CHAN_PASSIVE_SCAN from the driver's flags to
+         * allow the associated country IE to permit active scanning on
+         * frequencies that only allow passive scanning according to the
+         * driver's world regulatory domain. Prior to association, beacon
+         * hints would enable active scanning on these channels.
+         */
+        flags = chan->orig_flags & ~IEEE80211_CHAN_PASSIVE_SCAN;
+
+        chan->beacon_found = false;
        chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
        chan->max_antenna_gain =
                min_t(int, chan->orig_mag,
