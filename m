Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59368 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3F0Q7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:59:14 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 05/18] cfg80211/mac80211: get mandatory rates based on scan width
Date: Thu, 27 Jun 2013 18:58:47 +0200
Message-Id: <1372352340-20663-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_185921_358655_18B7C989)
In-Reply-To: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mandatory rates for 5 and 10 MHz are different from the rates used for
20 MHz in 2.4 GHz mode, as they use OFDM only.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCHv4:
 * it is now based on scan_width instead of rate flags
---
 include/net/cfg80211.h |    4 +++-
 net/mac80211/ibss.c    |   19 +++++++++++++++----
 net/wireless/mesh.c    |    5 ++++-
 net/wireless/util.c    |   14 ++++++++++----
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 820cce5..83d52dc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3069,11 +3069,13 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 /**
  * ieee80211_mandatory_rates - get mandatory rates for a given band
  * @sband: the band to look for rates in
+ * @scan_width: width of the control channel
  *
  * This function returns a bitmap of the mandatory rates for the given
  * band, bits are set according to the rate position in the bitrates array.
  */
-u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband);
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      enum nl80211_bss_scan_width scan_width);
 
 /*
  * Radiotap parsing functions -- for controlled injection support
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fa91df8..d0c27dc 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -376,6 +376,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
+	enum nl80211_bss_scan_width scan_width;
 	int band;
 
 	/*
@@ -404,6 +405,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON_ONCE(!chanctx_conf))
 		return NULL;
 	band = chanctx_conf->def.chan->band;
+	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
@@ -417,7 +419,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(sband);
+			ieee80211_mandatory_rates(sband, scan_width);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -499,6 +501,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	u64 beacon_timestamp, rx_timestamp;
 	u32 supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
+	enum nl80211_bss_scan_width scan_width;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool rates_updated = false;
 
@@ -527,9 +530,15 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
+				scan_width = NL80211_BSS_CHAN_WIDTH_20;
+				if (rx_status->flag & RX_FLAG_5MHZ)
+					scan_width = NL80211_BSS_CHAN_WIDTH_5;
+				if (rx_status->flag & RX_FLAG_10MHZ)
+					scan_width = NL80211_BSS_CHAN_WIDTH_10;
+
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(sband);
-
+					ieee80211_mandatory_rates(sband,
+								  scan_width);
 				if (sta->sta.supp_rates[band] != prev_rates) {
 					ibss_dbg(sdata,
 						 "updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
@@ -663,6 +672,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
+	enum nl80211_bss_scan_width scan_width;
 	int band;
 
 	/*
@@ -688,6 +698,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 	band = chanctx_conf->def.chan->band;
+	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
@@ -699,7 +710,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(sband);
+			ieee80211_mandatory_rates(sband, scan_width);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 30c4920..0553fd4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -167,9 +167,12 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	 * basic rates
 	 */
 	if (!setup->basic_rates) {
+		enum nl80211_bss_scan_width scan_width;
 		struct ieee80211_supported_band *sband =
 				rdev->wiphy.bands[setup->chandef.chan->band];
-		setup->basic_rates = ieee80211_mandatory_rates(sband);
+		scan_width = cfg80211_chandef_to_scan_width(&setup->chandef);
+		setup->basic_rates = ieee80211_mandatory_rates(sband,
+							       scan_width);
 	}
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 74458b7..ce090c1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -33,7 +33,8 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
-u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      enum nl80211_bss_scan_width scan_width)
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
+		if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
+		    scan_width == NL80211_BSS_CHAN_WIDTH_10)
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

