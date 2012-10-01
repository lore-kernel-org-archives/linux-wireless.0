Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JAOB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 10:01:29 -0400
Message-ID: <1349100121.10330.36.camel@jlt4.sipsolutions.net> (sfid-20121001_160132_854322_0F7EDEE5)
Subject: [RFC] mac80211: connect with HT20 if HT40 is not permitted
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>
Date: Mon, 01 Oct 2012 16:02:01 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some changes to fix issues with HT40 APs in Korea
and follow-up changes to allow using HT40 even if
the local regulatory database disallows it caused
issues with iwlwifi (and could cause issues with
other devices); iwlwifi firmware would assert if
you tried to connect to an AP that has an invalid
configuration (e.g. using HT40- on channel 140.)

Fix this, while avoiding the "Korean AP" issue by
disabling HT40 and advertising HT20 to the AP
when connecting.

Cc: stable@vger.kernel.org [3.6]
Reported-by: Florian Reitmeir <florian@reitmeir.org>
Tested-by: Florian Reitmeir <florian@reitmeir.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fe4b744..3b05952 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3199,27 +3199,39 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 				   ht_cfreq, ht_oper->primary_chan,
 				   cbss->channel->band);
 			ht_oper = NULL;
+		} else {
+			channel_type = NL80211_CHAN_HT20;
 		}
 	}
 
-	if (ht_oper) {
-		const u8 *ht_cap_ie;
-		const struct ieee80211_ht_cap *ht_cap;
-		u8 chains = 1;
-
-		channel_type = NL80211_CHAN_HT20;
+	if (ht_oper && sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		/*
+		 * cfg80211 already verified that the channel itself can
+		 * be used, but it didn't check that we can do the right
+		 * HT type, so do that here as well. If HT40 isn't allowed
+		 * on this channel, disable 40 MHz operation.
+		 */
 
-		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-			switch (ht_oper->ht_param &
-					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
+				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
+			else
 				channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
+				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
+			else
 				channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
+			break;
 		}
+	}
+
+	if (ht_oper) {
+		const u8 *ht_cap_ie;
+		const struct ieee80211_ht_cap *ht_cap;
+		u8 chains = 1;
 
 		ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
 					     cbss->information_elements,
-- 
1.7.10.4



