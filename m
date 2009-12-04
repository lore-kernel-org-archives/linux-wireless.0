Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZLDI0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 03:26:37 -0500
Subject: [PATCH] mac80211: disallow fixing bitrates with hw rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 09:26:38 +0100
Message-ID: <1259915198.20064.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hw rate control is used, these parameters have
no meaning because the hardware cannot get at them
right now, so disallow setting them. Also clean up
the function a bit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-12-04 09:20:44.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-12-04 09:24:28.000000000 +0100
@@ -1397,15 +1397,25 @@ static int ieee80211_set_bitrate_mask(st
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int i, err = -EINVAL;
+	int i;
 	u32 target_rate;
 	struct ieee80211_supported_band *sband;
 
+	/*
+	 * This _could_ be supported by providing a hook for
+	 * drivers for this function, but at this point it
+	 * doesn't seem worth bothering.
+	 */
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+		return -EOPNOTSUPP;
+
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
+	/*
+	 * target_rate = -1, rate->fixed = 0 means auto only, so use all rates
 	 * target_rate = X, rate->fixed = 1 means only rate X
-	 * target_rate = X, rate->fixed = 0 means all rates <= X */
+	 * target_rate = X, rate->fixed = 0 means all rates <= X
+	 */
 	sdata->max_ratectrl_rateidx = -1;
 	sdata->force_unicast_rateidx = -1;
 
@@ -1416,20 +1426,18 @@ static int ieee80211_set_bitrate_mask(st
 	else
 		return 0;
 
-	for (i=0; i< sband->n_bitrates; i++) {
-		struct ieee80211_rate *brate = &sband->bitrates[i];
-		int this_rate = brate->bitrate;
-
-		if (target_rate == this_rate) {
-			sdata->max_ratectrl_rateidx = i;
-			if (mask->fixed)
-				sdata->force_unicast_rateidx = i;
-			err = 0;
-			break;
-		}
+	for (i = 0; i< sband->n_bitrates; i++) {
+		if (target_rate != sband->bitrates[i].bitrate)
+			continue;
+
+		/* requested bitrate found */
+		sdata->max_ratectrl_rateidx = i;
+		if (mask->fixed)
+			sdata->force_unicast_rateidx = i;
+		return 0;
 	}
 
-	return err;
+	return -EINVAL;
 }
 
 struct cfg80211_ops mac80211_config_ops = {


