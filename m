Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZBFK6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 05:58:38 -0500
Subject: [RFC 1/2] mac80211: don't add BSS when creating IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Alina Friedrichsen <x-alina@gmx.net>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 11:58:03 +0100
Message-Id: <1233917883.4099.9.camel@johannes.local> (sfid-20090206_115848_195519_25A34D99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Untested. Please test, also in combination with 2/2.

 net/mac80211/ieee80211_i.h |    3 -
 net/mac80211/mlme.c        |  107 ++++++++++++++++++++++++---------------------
 net/mac80211/scan.c        |    8 ---
 3 files changed, 60 insertions(+), 58 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-06 10:32:04.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-06 10:32:05.000000000 +0100
@@ -513,14 +513,15 @@ static void ieee80211_send_deauth_disass
 
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_bss *bss)
+					 const size_t supp_rates_len,
+					 const u8 *supp_rates)
 {
 	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
 
 	/* cf. IEEE 802.11 9.2.12 */
-	for (i = 0; i < bss->supp_rates_len; i++)
-		if ((bss->supp_rates[i] & 0x7f) * 5 > 110)
+	for (i = 0; i < supp_rates_len; i++)
+		if ((supp_rates[i] & 0x7f) * 5 > 110)
 			have_higher_than_11mbit = 1;
 
 	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
@@ -1516,9 +1517,13 @@ static void ieee80211_rx_mgmt_assoc_resp
 }
 
 
-static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta,
-				   struct ieee80211_bss *bss)
+static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_if_sta *ifsta,
+				     const u8 *bssid, const int beacon_int,
+				     const int freq,
+				     const size_t supp_rates_len,
+				     const u8 *supp_rates,
+				     const u16 capability)
 {
 	struct ieee80211_local *local = sdata->local;
 	int res = 0, rates, i, j;
@@ -1534,7 +1539,7 @@ static int ieee80211_sta_join_ibss(struc
 	}
 
 	if ((ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) &&
-	   memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) == 0)
+	   memcmp(ifsta->bssid, bssid, ETH_ALEN) == 0)
 		return res;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
@@ -1545,28 +1550,28 @@ static int ieee80211_sta_join_ibss(struc
 		return -ENOMEM;
 	}
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
 	if (!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) {
 		/* Remove possible STA entries from other IBSS networks. */
 		sta_info_flush_delayed(sdata);
 	}
 
-	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
+	memcpy(ifsta->bssid, bssid, ETH_ALEN);
 	res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 	if (res)
 		return res;
 
-	local->hw.conf.beacon_int = bss->beacon_int >= 10 ? bss->beacon_int : 10;
+	local->hw.conf.beacon_int = beacon_int >= 10 ? beacon_int : 10;
 
-	sdata->drop_unencrypted = bss->capability &
+	sdata->drop_unencrypted = capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_freq(sdata, bss->freq);
+	res = ieee80211_set_freq(sdata, freq);
 
 	if (res)
 		return res;
 
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	/* Build IBSS probe response */
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -1575,33 +1580,32 @@ static int ieee80211_sta_join_ibss(struc
 		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						IEEE80211_STYPE_PROBE_RESP);
+					  IEEE80211_STYPE_PROBE_RESP);
 	memset(mgmt->da, 0xff, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 	mgmt->u.beacon.beacon_int =
 		cpu_to_le16(local->hw.conf.beacon_int);
-	mgmt->u.beacon.timestamp = cpu_to_le64(bss->timestamp);
-	mgmt->u.beacon.capab_info = cpu_to_le16(bss->capability);
+	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
 
 	pos = skb_put(skb, 2 + ifsta->ssid_len);
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
 
-	rates = bss->supp_rates_len;
+	rates = supp_rates_len;
 	if (rates > 8)
 		rates = 8;
 	pos = skb_put(skb, 2 + rates);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = rates;
-	memcpy(pos, bss->supp_rates, rates);
+	memcpy(pos, supp_rates, rates);
 
-	if (bss->band == IEEE80211_BAND_2GHZ) {
+	if (sband->band == IEEE80211_BAND_2GHZ) {
 		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(bss->freq);
+		*pos++ = ieee80211_frequency_to_channel(freq);
 	}
 
 	pos = skb_put(skb, 2 + 2);
@@ -1611,12 +1615,12 @@ static int ieee80211_sta_join_ibss(struc
 	*pos++ = 0;
 	*pos++ = 0;
 
-	if (bss->supp_rates_len > 8) {
-		rates = bss->supp_rates_len - 8;
+	if (supp_rates_len > 8) {
+		rates = supp_rates_len - 8;
 		pos = skb_put(skb, 2 + rates);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = rates;
-		memcpy(pos, &bss->supp_rates[8], rates);
+		memcpy(pos, &supp_rates[8], rates);
 	}
 
 	add_extra_ies(skb, sdata->u.sta.ie_proberesp,
@@ -1629,16 +1633,15 @@ static int ieee80211_sta_join_ibss(struc
 
 
 	rates = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	for (i = 0; i < bss->supp_rates_len; i++) {
-		int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
+	for (i = 0; i < supp_rates_len; i++) {
+		int bitrate = (supp_rates[i] & 0x7f) * 5;
 		for (j = 0; j < sband->n_bitrates; j++)
 			if (sband->bitrates[j].bitrate == bitrate)
 				rates |= BIT(j);
 	}
 	ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
 
-	ieee80211_sta_def_wmm_params(sdata, bss);
+	ieee80211_sta_def_wmm_params(sdata, supp_rates_len, supp_rates);
 
 	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
@@ -1647,12 +1650,23 @@ static int ieee80211_sta_join_ibss(struc
 	ieee80211_led_assoc(local, true);
 
 	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 
 	return res;
 }
 
+static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_if_sta *ifsta,
+				   struct ieee80211_bss *bss)
+{
+	return __ieee80211_sta_join_ibss(sdata, ifsta,
+					 bss->bssid, bss->beacon_int,
+					 bss->freq,
+					 bss->supp_rates_len, bss->supp_rates,
+					 bss->capability);
+}
+
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -2206,11 +2220,12 @@ static int ieee80211_sta_create_ibss(str
 				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss;
 	struct ieee80211_supported_band *sband;
-	u8 bssid[ETH_ALEN], *pos;
+	u8 *pos;
+	u8 bssid[ETH_ALEN];
+	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	u16 capability;
 	int i;
-	int ret;
 
 	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) {
 		memcpy(bssid, ifsta->bssid, ETH_ALEN);
@@ -2228,36 +2243,29 @@ static int ieee80211_sta_create_ibss(str
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->dev->name, bssid);
 
-	bss = ieee80211_rx_bss_add(local, bssid,
-				   local->hw.conf.channel->center_freq,
-				   sdata->u.sta.ssid, sdata->u.sta.ssid_len);
-	if (!bss)
-		return -ENOMEM;
-
-	bss->band = local->hw.conf.channel->band;
-	sband = local->hw.wiphy->bands[bss->band];
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	if (local->hw.conf.beacon_int == 0)
 		local->hw.conf.beacon_int = 100;
-	bss->beacon_int = local->hw.conf.beacon_int;
-	bss->last_update = jiffies;
-	bss->capability = WLAN_CAPABILITY_IBSS;
+
+	capability = WLAN_CAPABILITY_IBSS;
 
 	if (sdata->default_key)
-		bss->capability |= WLAN_CAPABILITY_PRIVACY;
+		capability |= WLAN_CAPABILITY_PRIVACY;
 	else
 		sdata->drop_unencrypted = 0;
 
-	bss->supp_rates_len = sband->n_bitrates;
-	pos = bss->supp_rates;
+	pos = supp_rates;
 	for (i = 0; i < sband->n_bitrates; i++) {
 		int rate = sband->bitrates[i].bitrate;
 		*pos++ = (u8) (rate / 5);
 	}
 
-	ret = ieee80211_sta_join_ibss(sdata, ifsta, bss);
-	ieee80211_rx_bss_put(local, bss);
-	return ret;
+	return __ieee80211_sta_join_ibss(sdata, ifsta,
+					 bssid, local->hw.conf.beacon_int,
+					 local->hw.conf.channel->center_freq,
+					 sband->n_bitrates, supp_rates,
+					 capability);
 }
 
 
@@ -2426,7 +2434,8 @@ static int ieee80211_sta_config_auth(str
 			ieee80211_sta_set_ssid(sdata, selected->ssid,
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(sdata, selected->bssid);
-		ieee80211_sta_def_wmm_params(sdata, selected);
+		ieee80211_sta_def_wmm_params(sdata, selected->supp_rates_len,
+						    selected->supp_rates);
 		if (sdata->u.sta.mfp == IEEE80211_MFP_REQUIRED)
 			sdata->u.sta.flags |= IEEE80211_STA_MFP_ENABLED;
 		else
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-06 10:32:04.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-06 10:34:10.000000000 +0100
@@ -14,11 +14,7 @@
 
 /* TODO:
  * figure out how to avoid that the "current BSS" expires
- * clean up IBSS code (in MLME), see why it adds a BSS to the list
- * use cfg80211's BSS handling (depends on IBSS TODO above)
- * order BSS list by RSSI(?) ("quality of AP")
- * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
- *    SSID)
+ * use cfg80211's BSS handling
  */
 
 #include <linux/wireless.h>
@@ -107,7 +103,7 @@ static void __ieee80211_rx_bss_hash_del(
 	}
 }
 
-struct ieee80211_bss *
+static struct ieee80211_bss *
 ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-06 10:33:52.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-06 10:34:00.000000000 +0100
@@ -954,9 +954,6 @@ ieee80211_bss_info_update(struct ieee802
 			  struct ieee80211_channel *channel,
 			  bool beacon);
 struct ieee80211_bss *
-ieee80211_rx_bss_add(struct ieee80211_local *local, u8 *bssid, int freq,
-		     u8 *ssid, u8 ssid_len);
-struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,


