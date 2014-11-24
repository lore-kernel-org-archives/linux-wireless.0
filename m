Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45940 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbaKXPz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:55:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: disable 80+80/160 in VHT correctly
Date: Mon, 24 Nov 2014 16:55:53 +0100
Message-Id: <1416844553-32068-1-git-send-email-johannes@sipsolutions.net> (sfid-20141124_165600_815536_C1232BBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The supported bandwidth field is a two-bit field, not a bitmap,
so treat it accordingly when disabling 80+80 or 160 MHz.

Note that we can only advertise "80+80 and 160" or "160", not
"80+80" by itself, so disabling 160 also disables 80+80.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d29589a09065..36e39ed4dfd9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -552,13 +552,17 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	cap = vht_cap.cap;
 
 	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_80P80MHZ) {
-		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
-		cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+		u32 bw = cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+
+		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (bw == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ ||
+		    bw == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+			cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
 	}
 
 	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_160MHZ) {
 		cap &= ~IEEE80211_VHT_CAP_SHORT_GI_160;
-		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 	}
 
 	/*
-- 
2.1.1

