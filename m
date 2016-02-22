Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35393 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbcBVWnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 17:43:00 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Let VHT work on 2.4Ghz
Date: Mon, 22 Feb 2016 14:42:54 -0800
Message-Id: <1456180974-21062-1-git-send-email-greearb@candelatech.com> (sfid-20160222_234305_188814_D62222E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

ath10k supports VHT on 2.4Ghz band.
If supplicant and hostapd and radio think
VHT should be allowed, then kernel should let them
try.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/mlme.c | 16 ----------------
 net/mac80211/util.c | 13 +------------
 net/mac80211/vht.c  | 15 ---------------
 3 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6f079ca..7719867 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4233,8 +4233,6 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
 	int ret;
-	u32 i;
-	bool have_80mhz;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -4285,20 +4283,6 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	/* Allow VHT if at least one channel on the sband supports 80 MHz */
-	have_80mhz = false;
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
-
-	if (!have_80mhz)
-		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
-
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
 						     ht_cap, ht_oper, vht_oper,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f8eb0f8..cabe16f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1475,7 +1475,6 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 	int ext_rates_len;
 	int shift;
 	u32 rate_flags;
-	bool have_80mhz = false;
 
 	*offset = 0;
 
@@ -1604,17 +1603,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		*offset = noffset;
 	}
 
-	/* Check if any channel in this sband supports at least 80 MHz */
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
-
-	if (sband->vht_cap.vht_supported && have_80mhz && !disable_vht) {
+	if (sband->vht_cap.vht_supported && /*have_80mhz &&*/ !disable_vht) {
 		if (end - pos < 2 + sizeof(struct ieee80211_vht_cap))
 			goto out_err;
 		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index c38b2f0..58887b3 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -120,7 +120,6 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
 	struct ieee80211_sta_vht_cap own_cap;
 	u32 cap_info, i;
-	bool have_80mhz;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
@@ -130,20 +129,6 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
-	/* Allow VHT if at least one channel on the sband supports 80 MHz */
-	have_80mhz = false;
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
-
-	if (!have_80mhz)
-		return;
-
 	/*
 	 * A VHT STA must support 40 MHz, but if we verify that here
 	 * then we break a few things - some APs (e.g. Netgear R6300v2
-- 
2.4.3

