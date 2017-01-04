Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:43116 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935177AbdADKx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:53:58 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] cfg80211: only pass sband to set_mandatory_flags_band()
Date: Wed,  4 Jan 2017 10:53:37 +0000
Message-Id: <1483527217-11854-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170104_115414_801194_6AF50EC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The supported band structure contains the band is applies to
so no need to pass it separately. Also added a default case
to the switch for completeness. The current code base does not
call this function with NUM_NL80211_BANDS but kept that case
statement although default case would cover that.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Stumbled upon this function and wanted to start the new year lightly.
It applies to master branch of mac80211-next repo.

Best wishes,
Arend
---
 net/wireless/util.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2cf7df8..c91bc25 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -136,12 +136,11 @@ struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq)
 }
 EXPORT_SYMBOL(ieee80211_get_channel);
 
-static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
-				     enum nl80211_band band)
+static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 {
 	int i, want;
 
-	switch (band) {
+	switch (sband->band) {
 	case NL80211_BAND_5GHZ:
 		want = 3;
 		for (i = 0; i < sband->n_bitrates; i++) {
@@ -191,6 +190,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 		WARN_ON((sband->ht_cap.mcs.rx_mask[0] & 0x1e) != 0x1e);
 		break;
 	case NUM_NL80211_BANDS:
+	default:
 		WARN_ON(1);
 		break;
 	}
@@ -202,7 +202,7 @@ void ieee80211_set_bitrate_flags(struct wiphy *wiphy)
 
 	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		if (wiphy->bands[band])
-			set_mandatory_flags_band(wiphy->bands[band], band);
+			set_mandatory_flags_band(wiphy->bands[band]);
 }
 
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
-- 
1.9.1
