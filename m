Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55780 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3F0Moi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:38 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 05/18] cfg80211/mac80211: get mandatory rates based on rate flags
Date: Thu, 27 Jun 2013 14:44:11 +0200
Message-Id: <1372337064-19254-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144534_586616_2B8D5FC6)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mandatory rates for 5 and 10 MHz are different from the rates used for
20 MHz in 2.4 GHz mode, as they use OFDM only.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |    4 +++-
 net/mac80211/ibss.c    |   21 ++++++++++++++++-----
 net/wireless/mesh.c    |    5 ++++-
 net/wireless/util.c    |   14 ++++++++++----
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 820cce5..a0c5e04 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3069,11 +3069,13 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 /**
  * ieee80211_mandatory_rates - get mandatory rates for a given band
  * @sband: the band to look for rates in
+ * @rate_flags: rate flags which may limit the mandatory rates
  *
  * This function returns a bitmap of the mandatory rates for the given
  * band, bits are set according to the rate position in the bitrates array.
  */
-u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband);
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      u32 rate_flags);
 
 /*
  * Radiotap parsing functions -- for controlled injection support
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f3171fc..cf66ddc 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -376,6 +376,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
+	u32 rate_flags;
 	int band;
 
 	/*
@@ -404,6 +405,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON_ONCE(!chanctx_conf))
 		return NULL;
 	band = chanctx_conf->def.chan->band;
+	rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
@@ -417,7 +419,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(sband);
+			ieee80211_mandatory_rates(sband, rate_flags);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -497,7 +499,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
-	u32 supp_rates = 0;
+	u32 rate_flags, supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool rates_updated = false;
@@ -522,14 +524,21 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		if (elems->supp_rates) {
 			supp_rates = ieee80211_sta_get_rates(sdata, elems,
 							     band, NULL);
+			rate_flags = 0;
+			if (rx_status->flag & RX_FLAG_5MHZ)
+				rate_flags = IEEE80211_RATE_SUPPORTS_5MHZ;
+			if (rx_status->flag & RX_FLAG_10MHZ)
+				rate_flags = IEEE80211_RATE_SUPPORTS_10MHZ;
+
 			if (sta) {
 				u32 prev_rates;
 
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
+
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(sband);
-
+					ieee80211_mandatory_rates(sband,
+								  rate_flags);
 				if (sta->sta.supp_rates[band] != prev_rates) {
 					ibss_dbg(sdata,
 						 "updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
@@ -663,6 +672,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
+	u32 rate_flags;
 	int band;
 
 	/*
@@ -688,6 +698,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 	band = chanctx_conf->def.chan->band;
+	rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
@@ -699,7 +710,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(sband);
+			ieee80211_mandatory_rates(sband, rate_flags);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 30c4920..9a529c9 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -167,9 +167,12 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	 * basic rates
 	 */
 	if (!setup->basic_rates) {
+		u32 rate_flags;
 		struct ieee80211_supported_band *sband =
 				rdev->wiphy.bands[setup->chandef.chan->band];
-		setup->basic_rates = ieee80211_mandatory_rates(sband);
+		rate_flags = ieee80211_chandef_rate_flags(&setup->chandef);
+		setup->basic_rates = ieee80211_mandatory_rates(sband,
+							       rate_flags);
 	}
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 74458b7..5f42ab3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -33,7 +33,8 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
-u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      u32 rate_flags)
 {
 	struct ieee80211_rate *bitrates;
 	u32 mandatory_rates = 0;
@@ -43,10 +44,15 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
 	if (WARN_ON(!sband))
 		return 1;
 
-	if (sband->band == IEEE80211_BAND_2GHZ)
-		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
-	else
+	if (sband->band == IEEE80211_BAND_2GHZ) {
+		if ((rate_flags & (IEEE80211_RATE_SUPPORTS_5MHZ |
+				   IEEE80211_RATE_SUPPORTS_10MHZ)))
+			mandatory_flag = IEEE80211_RATE_MANDATORY_G;
+		else
+			mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+	} else {
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+	}
 
 	bitrates = sband->bitrates;
 	for (i = 0; i < sband->n_bitrates; i++)
-- 
1.7.10.4

