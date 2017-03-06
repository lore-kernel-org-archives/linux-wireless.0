Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52948 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932238AbdCFWIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:08:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: ignore VHT membership selector when parsing rates
Date: Mon,  6 Mar 2017 23:01:13 +0100
Message-Id: <20170306220113.4666-1-johannes@sipsolutions.net> (sfid-20170306_230841_676592_1490CE3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There isn't really much harm in not ignoring, since it doesn't
represent a valid rate, but since we already ignore the HT one
also ignore VHT. Also simplify the code a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1568a74757bc..6340127a71c6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2823,15 +2823,15 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 			*have_higher_than_11mbit = true;
 
 		/*
-		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in 802.11n-2009
-		 * 7.3.2.2 as a magic value instead of a rate. Hence, skip it.
+		 * Skip HT and VHT BSS membership selectors since they're not
+		 * rates.
 		 *
 		 * Note: Even through the membership selector and the basic
 		 *	 rate flag share the same bit, they are not exactly
 		 *	 the same.
 		 */
-		if (!!(supp_rates[i] & 0x80) &&
-		    (supp_rates[i] & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
+		if (supp_rates[i] == (0x80 | BSS_MEMBERSHIP_SELECTOR_HT_PHY) ||
+		    supp_rates[i] == (0x80 | BSS_MEMBERSHIP_SELECTOR_VHT_PHY))
 			continue;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-- 
2.11.0
