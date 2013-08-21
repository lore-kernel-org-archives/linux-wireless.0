Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48860 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3HULkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 07:40:24 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix ignored channel parameter
Date: Wed, 21 Aug 2013 13:40:13 +0200
Message-Id: <1377085213-29695-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130821_134027_990130_672F5020)
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
 net/mac80211/ibss.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 74de0f1..2669595 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -201,7 +201,7 @@ error:
 
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
-				      struct ieee80211_channel *chan,
+				      struct cfg80211_chan_def *req_chandef,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf,
 				      bool creator)
@@ -213,6 +213,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	struct cfg80211_chan_def chandef;
+	struct ieee80211_channel *chan;
 	struct beacon_data *presp;
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
@@ -244,7 +245,9 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	chandef = ifibss->chandef;
+	/* make a copy of the chandef, it could be modified below. */
+	chandef = *req_chandef;
+	chan = chandef.chan;
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
 		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
 		    chandef.width == NL80211_CHAN_WIDTH_10 ||
@@ -339,6 +342,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def chandef;
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
@@ -352,6 +356,13 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (beacon_int < 10)
 		beacon_int = 10;
 
+	chandef.chan = cbss->channel;
+	chandef.width = sdata->u.ibss.chandef.width;
+	chandef.center_freq1 = chandef.chan->center_freq +
+			       sdata->u.ibss.chandef.center_freq1 -
+			       sdata->u.ibss.chandef.chan->center_freq;
+	chandef.center_freq2 = 0;
+
 	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
 	rate_flags = ieee80211_chandef_rate_flags(&sdata->u.ibss.chandef);
 	shift = ieee80211_vif_get_shift(&sdata->vif);
@@ -385,7 +396,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
-				  cbss->channel,
+				  &chandef,
 				  basic_rates,
 				  cbss->capability,
 				  tsf, false);
@@ -867,7 +878,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->chandef.chan, ifibss->basic_rates,
+				  &ifibss->chandef, ifibss->basic_rates,
 				  capability, 0, true);
 }
 
-- 
1.7.10.4

