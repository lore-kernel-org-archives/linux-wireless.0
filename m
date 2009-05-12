Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZELTTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 15:19:11 -0400
Subject: [PATCH] mac80211: IBSS supported rate fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:18:38 +0200
Message-Id: <1242155918.14227.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 announces a rate set with no basic rates,
this fixes it to use 1/2 or 6/9 Mbit as basic rates by default.
Additionally, mac80211 will currently adopt the peer's entire
rate set, rather than just the basic rate set; fix that too.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |   67 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-05-12 20:53:06.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-05-12 21:14:05.000000000 +0200
@@ -63,19 +63,18 @@ static void ieee80211_rx_mgmt_auth_ibss(
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
-				      const size_t supp_rates_len,
-				      const u8 *supp_rates,
+				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	int rates, i, j;
+	int rates, i;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
 	u32 bss_change;
-
+	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local);
@@ -101,6 +100,16 @@ static void __ieee80211_sta_join_ibss(st
 
 	sband = local->hw.wiphy->bands[chan->band];
 
+	/* build supported rates array */
+	pos = supp_rates;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		int rate = sband->bitrates[i].bitrate;
+		u8 basic = 0;
+		if (basic_rates & BIT(i))
+			basic = 0x80;
+		*pos++ = basic | (u8) (rate / 5);
+	}
+
 	/* Build IBSS probe response */
 	mgmt = (void *) skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
@@ -118,7 +127,7 @@ static void __ieee80211_sta_join_ibss(st
 	*pos++ = ifibss->ssid_len;
 	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
 
-	rates = supp_rates_len;
+	rates = sband->n_bitrates;
 	if (rates > 8)
 		rates = 8;
 	pos = skb_put(skb, 2 + rates);
@@ -140,8 +149,8 @@ static void __ieee80211_sta_join_ibss(st
 	*pos++ = 0;
 	*pos++ = 0;
 
-	if (supp_rates_len > 8) {
-		rates = supp_rates_len - 8;
+	if (sband->n_bitrates > 8) {
+		rates = sband->n_bitrates - 8;
 		pos = skb_put(skb, 2 + rates);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = rates;
@@ -162,15 +171,7 @@ static void __ieee80211_sta_join_ibss(st
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-	rates = 0;
-	for (i = 0; i < supp_rates_len; i++) {
-		int bitrate = (supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == bitrate)
-				rates |= BIT(j);
-	}
-
-	ieee80211_sta_def_wmm_params(sdata, supp_rates_len, supp_rates);
+	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
 	mod_timer(&ifibss->timer,
@@ -184,15 +185,35 @@ static void __ieee80211_sta_join_ibss(st
 static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_bss *bss)
 {
+	struct ieee80211_supported_band *sband;
+	u32 basic_rates;
+	int i, j;
 	u16 beacon_int = bss->cbss.beacon_interval;
 
 	if (beacon_int < 10)
 		beacon_int = 10;
 
+	sband = sdata->local->hw.wiphy->bands[bss->cbss.channel->band];
+
+	basic_rates = 0;
+
+	for (i = 0; i < bss->supp_rates_len; i++) {
+		int rate = (bss->supp_rates[i] & 0x7f) * 5;
+		bool is_basic = !!(bss->supp_rates[i] & 0x80);
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate) {
+				if (is_basic)
+					basic_rates |= BIT(j);
+				break;
+			}
+		}
+	}
+
 	__ieee80211_sta_join_ibss(sdata, bss->cbss.bssid,
 				  beacon_int,
 				  bss->cbss.channel,
-				  bss->supp_rates_len, bss->supp_rates,
+				  basic_rates,
 				  bss->cbss.capability,
 				  bss->cbss.tsf);
 }
@@ -449,9 +470,7 @@ static void ieee80211_sta_create_ibss(st
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	u8 *pos;
 	u8 bssid[ETH_ALEN];
-	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	u16 capability;
 	int i;
 
@@ -480,15 +499,9 @@ static void ieee80211_sta_create_ibss(st
 	else
 		sdata->drop_unencrypted = 0;
 
-	pos = supp_rates;
-	for (i = 0; i < sband->n_bitrates; i++) {
-		int rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
-
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, sband->n_bitrates,
-				  supp_rates, capability, 0);
+				  ifibss->channel, 3, /* first two are basic */
+				  capability, 0);
 }
 
 static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)


