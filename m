Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40622 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754549AbeDTKth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Apr 2018 13:49:21 +0300
Message-Id: <20180420104926.8816-5-luca@coelho.fi> (sfid-20180420_124940_292020_C26E1655)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 4/9] mac80211: clean up rate info bandwidth setting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to do the same thing three times in
the different switch cases, pull that out to a single
place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 11f9cfc016d9..2d82c88efd0b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2793,12 +2793,13 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 
 	memset(&ri, 0, sizeof(ri));
 
+	ri.bw = status->bw;
+
 	/* Fill cfg80211 rate info */
 	switch (status->encoding) {
 	case RX_ENC_HT:
 		ri.mcs = status->rate_idx;
 		ri.flags |= RATE_INFO_FLAGS_MCS;
-		ri.bw = status->bw;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
@@ -2806,7 +2807,6 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
 		ri.mcs = status->rate_idx;
 		ri.nss = status->nss;
-		ri.bw = status->bw;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
@@ -2818,8 +2818,6 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		int shift = 0;
 		int bitrate;
 
-		ri.bw = status->bw;
-
 		switch (status->bw) {
 		case RATE_INFO_BW_10:
 			shift = 1;
-- 
2.17.0
