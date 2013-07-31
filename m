Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066Ab3GaJuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:50:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	Andy Isaacson <adi@hexapodia.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] mac80211: ignore HT primary channel while connected
Date: Wed, 31 Jul 2013 11:50:34 +0200
Message-Id: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_115057_319103_0639D869)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

While we're connected, the AP shouldn't change the primary channel
in the HT information. We checked this, and dropped the connection
if it did change it.

Unfortunately, this is causing problems on some APs, e.g. on the
Netgear WRT610NL: the beacons seem to always contain a bad channel
and if we made a connection using a probe response (correct data)
we drop the connection immediately and can basically not connect
properly at all.

Work around this by ignoring the HT primary channel information in
beacons if we're already connected.

Also print out more verbose messages in the other situations to
help diagnose similar bugs quicker in the future.

Cc: stable@vger.kernel.org [3.10]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 383a961..77e7796 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -211,8 +211,9 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_channel *channel,
 			     const struct ieee80211_ht_operation *ht_oper,
 			     const struct ieee80211_vht_operation *vht_oper,
-			     struct cfg80211_chan_def *chandef, bool verbose)
+			     struct cfg80211_chan_def *chandef, bool tracking)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_chan_def vht_chandef;
 	u32 ht_cfreq, ret;
 
@@ -231,7 +232,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
 						  channel->band);
 	/* check that channel matches the right operating channel */
-	if (channel->center_freq != ht_cfreq) {
+	if (!tracking && channel->center_freq != ht_cfreq) {
 		/*
 		 * It's possible that some APs are confused here;
 		 * Netgear WNDR3700 sometimes reports 4 higher than
@@ -239,11 +240,10 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		 * since we look at probe response/beacon data here
 		 * it should be OK.
 		 */
-		if (verbose)
-			sdata_info(sdata,
-				   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
-				   channel->center_freq, ht_cfreq,
-				   ht_oper->primary_chan, channel->band);
+		sdata_info(sdata,
+			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
+			   channel->center_freq, ht_cfreq,
+			   ht_oper->primary_chan, channel->band);
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
@@ -297,7 +297,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 				channel->band);
 		break;
 	default:
-		if (verbose)
+		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
 				   vht_oper->chan_width);
@@ -306,7 +306,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!cfg80211_chandef_valid(&vht_chandef)) {
-		if (verbose)
+		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT information is invalid, disable VHT\n");
 		ret = IEEE80211_STA_DISABLE_VHT;
@@ -319,7 +319,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!cfg80211_chandef_compatible(chandef, &vht_chandef)) {
-		if (verbose)
+		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT information doesn't match HT, disable VHT\n");
 		ret = IEEE80211_STA_DISABLE_VHT;
@@ -346,7 +346,7 @@ out:
 		ret |= chandef_downgrade(chandef);
 	}
 
-	if (chandef->width != vht_chandef.width && verbose)
+	if (chandef->width != vht_chandef.width && !tracking)
 		sdata_info(sdata,
 			   "capabilities/regulatory prevented using AP HT/VHT configuration, downgraded\n");
 
@@ -386,7 +386,7 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 
 	/* calculate new channel (type) based on HT/VHT operation IEs */
 	flags = ieee80211_determine_chantype(sdata, sband, chan, ht_oper,
-					     vht_oper, &chandef, false);
+					     vht_oper, &chandef, true);
 
 	/*
 	 * Downgrade the new channel if we associated with restricted
@@ -3838,7 +3838,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
 						     ht_oper, vht_oper,
-						     &chandef, true);
+						     &chandef, false);
 
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
 				      local->rx_chains);
-- 
1.8.0

