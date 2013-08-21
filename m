Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35919 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3HUNau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 09:30:50 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH-mac8011] mac80211: fix ignored channel parameter
Date: Wed, 21 Aug 2013 15:30:25 +0200
Message-Id: <1377091825-30564-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130821_153053_427513_5AA77EBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

my earlier patch "mac80211: change IBSS channel state to chandef"
created a regression by ignoring the channel parameter in
__ieee80211_sta_join_ibss, which breaks IBSS channel selection. This
patch fixes this situation by using the right channel and adopting the
selected bandwidth mode.

Cc: stable@vger.kernel.org
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
This version is based on mac80211.git for fixes, and the bandwidth
handling was changed in ieee80211_sta_join_ibss to more readable.
---
 net/mac80211/ibss.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ea7b9c2..f292e8f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -36,7 +36,7 @@
 
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
-				      struct ieee80211_channel *chan,
+				      struct cfg80211_chan_def *req_chandef,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf,
 				      bool creator)
@@ -51,6 +51,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
+	struct ieee80211_channel *chan;
 	struct beacon_data *presp;
 	int frame_len;
 
@@ -81,7 +82,9 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	chandef = ifibss->chandef;
+	/* make a copy of the chandef, it could be modified below. */
+	chandef = *req_chandef;
+	chan = chandef.chan;
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
@@ -259,10 +262,12 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def chandef;
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
 	const struct cfg80211_bss_ies *ies;
+	enum nl80211_channel_type chan_type;
 	u64 tsf;
 
 	sdata_assert_lock(sdata);
@@ -270,6 +275,26 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (beacon_int < 10)
 		beacon_int = 10;
 
+	switch (sdata->u.ibss.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
+		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
+		break;
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+		cfg80211_chandef_create(&chandef, cbss->channel,
+					NL80211_CHAN_WIDTH_20_NOHT);
+		chandef.width = sdata->u.ibss.chandef.width;
+		break;
+	default:
+		/* fall back to 20 MHz for unsupported modes */
+		cfg80211_chandef_create(&chandef, cbss->channel,
+					NL80211_CHAN_WIDTH_20_NOHT);
+		break;
+	}
+
 	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
 
 	basic_rates = 0;
@@ -294,7 +319,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
-				  cbss->channel,
+				  &chandef,
 				  basic_rates,
 				  cbss->capability,
 				  tsf, false);
@@ -736,7 +761,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->chandef.chan, ifibss->basic_rates,
+				  &ifibss->chandef, ifibss->basic_rates,
 				  capability, 0, true);
 }
 
-- 
1.7.10.4

