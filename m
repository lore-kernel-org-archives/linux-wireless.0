Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYCPRgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 13:36:13 -0400
Subject: [PATCH] mac80211: use ieee80211_get_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 18:35:56 +0100
Message-Id: <1205688956.3878.5.camel@johannes.berg> (sfid-20080316_173616_682891_8D289BD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new ieee80211_get_channel() function instead of open-coding it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_ioctl.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-03-16 18:24:36.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-03-16 18:26:41.000000000 +0100
@@ -282,35 +282,14 @@ static int ieee80211_ioctl_giwmode(struc
 
 int ieee80211_set_freq(struct ieee80211_local *local, int freqMHz)
 {
-	int set = 0;
 	int ret = -EINVAL;
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-	int i;
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
-		sband = local->hw.wiphy->bands[band];
-
-		if (!sband)
-			continue;
+	struct ieee80211_channel *chan;
 
-		for (i = 0; i < sband->n_channels; i++) {
-			struct ieee80211_channel *chan = &sband->channels[i];
+	chan = ieee80211_get_channel(&local->hw.wiphy, freqMHz);
 
-			if (chan->flags & IEEE80211_CHAN_DISABLED)
-				continue;
-
-			if (chan->center_freq == freqMHz) {
-				set = 1;
-				local->oper_channel = chan;
-				break;
-			}
-		}
-		if (set)
-			break;
-	}
+	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+		local->oper_channel = chan;
 
-	if (set) {
 		if (local->sta_sw_scanning)
 			ret = 0;
 		else


