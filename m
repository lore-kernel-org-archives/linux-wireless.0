Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53126 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753342AbdJMM0I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 08:26:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 13 Oct 2017 15:26:01 +0300
Message-Id: <20171013122601.18964-1-luca@coelho.fi> (sfid-20171013_142612_400326_0430AE22)
Subject: [PATCH] mac80211: don't track HT capability changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code here (more or less accidentally) tracks the HT capability of
the AP when connected, and we found at least one AP that erroneously
toggles its 20/40 capability bit when changing between 20/40 MHz. The
connection to the AP is then broken because we set the 40 MHz disable
flag based on this, as soon as it switches to 20 MHz, but because the
flag then changed, we disconnect.

I'd be inclined to just ignore this issue, since we then reconnect
while the AP is in 20 MHz mode and never use 40 MHz with it again,
but this code is a bit strange anyway - we don't use the capabilities
for anything else.

Change the code to simply not track the HT capabilities at all, which
assumes that the AP at least sets 20/40 capability when operating in
40 MHz (or higher). If not, rate scaling might end up using only the
narrower bandwidth.

The new behaviour also mirrors what VHT does, where we only check the
VHT operation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee5ca1bc5a20..e4ededa1909d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -145,7 +145,6 @@ static u32
 ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_supported_band *sband,
 			     struct ieee80211_channel *channel,
-			     const struct ieee80211_ht_cap *ht_cap,
 			     const struct ieee80211_ht_operation *ht_oper,
 			     const struct ieee80211_vht_operation *vht_oper,
 			     struct cfg80211_chan_def *chandef, bool tracking)
@@ -163,20 +162,13 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	chandef->center_freq1 = channel->center_freq;
 	chandef->center_freq2 = 0;
 
-	if (!ht_cap || !ht_oper || !sta_ht_cap.ht_supported) {
+	if (!ht_oper || !sta_ht_cap.ht_supported) {
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
 
 	chandef->width = NL80211_CHAN_WIDTH_20;
 
-	if (!(ht_cap->cap_info &
-	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
-		ret = IEEE80211_STA_DISABLE_40MHZ;
-		vht_chandef = *chandef;
-		goto out;
-	}
-
 	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
 						  channel->band);
 	/* check that channel matches the right operating channel */
@@ -344,7 +336,7 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 
 	/* calculate new channel (type) based on HT/VHT operation IEs */
 	flags = ieee80211_determine_chantype(sdata, sband, chan,
-					     ht_cap, ht_oper, vht_oper,
+					     ht_oper, vht_oper,
 					     &chandef, true);
 
 	/*
@@ -4312,7 +4304,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
-						     ht_cap, ht_oper, vht_oper,
+						     ht_oper, vht_oper,
 						     &chandef, false);
 
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
-- 
2.14.2
