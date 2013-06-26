Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp26.msg.oleane.net ([62.161.4.26]:38537 "EHLO
	smtp26.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3FZR2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 13:28:50 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp26.msg.oleane.net (MTA) with ESMTP id r5QHSmaL031493
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 19:28:48 +0200
From: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
To: linux-wireless@vger.kernel.org
Cc: "J.P. Tosoni" <jp.tosoni@acksys.fr>
Subject: [RFC] mac80211: Use libnl-configurable values for retry counts
Date: Wed, 26 Jun 2013 19:28:43 +0200
Message-Id: <1372267723-25072-1-git-send-email-jp.tosoni@acksys.fr> (sfid-20130626_192854_423262_C776B6B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: J.P. Tosoni <jp.tosoni@acksys.fr>

In the rate control algorithms, the maximum retry count is limited by
a) a constant value obtained from the hardware driver
b) a constant limit (6ms) on the time allowed for all
   retries of each frame.

Replace the retry count by existing configurable values from nl80211.
Use wiphy->retry_short for management frames.
Use wiphy->retry_long for other frames.
Check that the configured value does not exceed driver capabilities.

Caveat: in minstrel rate control, the retry count is reused for each
rate of the rate table, potentially resulting in 4*max_retry retries.
---
Please comment on the patch and the caveat above, then I'll proceed
to update iw and to change the hard limit of 30 retries in ath9k.

 net/mac80211/cfg.c              |    4 ++++
 net/mac80211/rate.c             |    2 +-
 net/mac80211/rc80211_minstrel.c |    6 +-----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 082f270..4d3eb56 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2203,11 +2203,15 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
 		if (wiphy->retry_short > IEEE80211_MAX_TX_RETRY)
 			return -EINVAL;
+		if (wiphy->retry_short > local->hw.max_rate_tries)
+			return -EINVAL;
 		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
 		if (wiphy->retry_long > IEEE80211_MAX_TX_RETRY)
 			return -EINVAL;
+		if (wiphy->retry_long > local->hw.max_rate_tries)
+			return -EINVAL;
 		local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	}
 	if (changed &
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index a02bef3..9be3006 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -266,7 +266,7 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-		1 : hw->max_rate_tries;
+		1 : hw->conf.short_frame_max_tx_count;
 
 	info->control.skip_table = 1;
 }
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index ac7ef54..502d0c9 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -592,11 +592,7 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 	/* maximum time that the hw is allowed to stay in one MRR segment */
 	mp->segment_size = 6000;
 
-	if (hw->max_rate_tries > 0)
-		mp->max_retry = hw->max_rate_tries;
-	else
-		/* safe default, does not necessarily have to match hw properties */
-		mp->max_retry = 7;
+	mp->max_retry = hw->conf.long_frame_max_tx_count;
 
 	if (hw->max_rates >= 4)
 		mp->has_mrr = true;
-- 
1.7.2.5

