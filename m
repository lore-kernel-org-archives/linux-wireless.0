Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab2KWHmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:42:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: fix RX chains configuration
Date: Fri, 23 Nov 2012 08:42:58 +0100
Message-Id: <1353656580-12134-2-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084236_760953_121D63CC)
In-Reply-To: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
References: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver doesn't support 40 MHz channels, then
mac80211 erroneously sets number of RX chains to one
although the number of chains is independent of the
support for 40 MHz channels.

Fix this by checking the 40 MHz support only for the
code that sets the 40 MHz channel not the complete
HT code block.

This also means the HT20 channel type will always be
set in the changed code block so there's no need to
set it in case we override the AP due to invalid IEs
in the probe response/beacon.

The indentation is a bit quirky, but I'm rewriting
this code for VHT support so this will change again
very soon.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6161446..19969ec 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3219,12 +3219,10 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 				   ht_cfreq, ht_oper->primary_chan,
 				   cbss->channel->band);
 			ht_oper = NULL;
-		} else {
-			channel_type = NL80211_CHAN_HT20;
 		}
 	}
 
-	if (ht_oper && sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+	if (ht_oper) {
 		/*
 		 * cfg80211 already verified that the channel itself can
 		 * be used, but it didn't check that we can do the right
@@ -3237,19 +3235,26 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 		channel_type = NL80211_CHAN_HT20;
 
-		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
-				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
-			else
-				channel_type = NL80211_CHAN_HT40PLUS;
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
-				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
-			else
-				channel_type = NL80211_CHAN_HT40MINUS;
-			break;
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+			switch (ht_oper->ht_param &
+					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				if (cbss->channel->flags &
+						IEEE80211_CHAN_NO_HT40PLUS)
+					ifmgd->flags |=
+						IEEE80211_STA_DISABLE_40MHZ;
+				else
+					channel_type = NL80211_CHAN_HT40PLUS;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				if (cbss->channel->flags &
+						IEEE80211_CHAN_NO_HT40MINUS)
+					ifmgd->flags |=
+						IEEE80211_STA_DISABLE_40MHZ;
+				else
+					channel_type = NL80211_CHAN_HT40MINUS;
+				break;
+			}
 		}
 
 		ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
-- 
1.8.0

