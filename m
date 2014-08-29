Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:47693 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaH2SJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 14:09:51 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XNQcL-0002XX-Cf
	for linux-wireless@vger.kernel.org; Fri, 29 Aug 2014 20:09:46 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XNQcL-0000Tq-3s
	for linux-wireless@vger.kernel.org; Fri, 29 Aug 2014 20:09:45 +0200
In-Reply-To: <20140829081902.GB21763@sesse.net>
References: <20140829081902.GB21763@sesse.net>
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Date: Fri, 29 Aug 2014 19:27:53 +0200
Subject: [PATCH 1/2] mac80211: split 802.11h parsing from transmit power
 policy
To: linux-wireless@vger.kernel.org
Message-Id: <E1XNQcL-0000Tq-3s@pannekake.samfundet.no> (sfid-20140829_201003_571690_D0909E0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Decouple the logic of parsing the 802.11d and 802.11h IEs from the
part of deciding what to do about the data (messaging, clamping to
0 dBm, doing the actual setting). This paves the way for the next
patch, which introduces more data sources for transmit power limitation.

Signed-off-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
---
 net/mac80211/mlme.c |   62 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b82a12a..5c90e49 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1157,19 +1157,22 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			  TU_TO_EXP_TIME(csa_ie.count * cbss->beacon_interval));
 }
 
-static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-				       struct ieee80211_channel *channel,
-				       const u8 *country_ie, u8 country_ie_len,
-				       const u8 *pwr_constr_elem)
+static bool ieee80211_find_80211h_pwr_constr(
+	struct ieee80211_sub_if_data *sdata,
+	struct ieee80211_channel *channel,
+	const u8 *country_ie, u8 country_ie_len,
+	const u8 *pwr_constr_elem,
+	int *chan_pwr,
+	int *pwr_reduction)
 {
 	struct ieee80211_country_ie_triplet *triplet;
 	int chan = ieee80211_frequency_to_channel(channel->center_freq);
-	int i, chan_pwr, chan_increment, new_ap_level;
+	int i, chan_increment;
 	bool have_chan_pwr = false;
 
 	/* Invalid IE */
 	if (country_ie_len % 2 || country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
-		return 0;
+		return false;
 
 	triplet = (void *)(country_ie + 3);
 	country_ie_len -= 3;
@@ -1197,7 +1200,7 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < triplet->chans.num_channels; i++) {
 			if (first_channel + i * chan_increment == chan) {
 				have_chan_pwr = true;
-				chan_pwr = triplet->chans.max_power;
+				*chan_pwr = triplet->chans.max_power;
 				break;
 			}
 		}
@@ -1209,19 +1212,41 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 		country_ie_len -= 3;
 	}
 
-	if (!have_chan_pwr)
-		return 0;
+	if (have_chan_pwr)
+		*pwr_reduction = *pwr_constr_elem;
+	return have_chan_pwr;
+}
 
-	new_ap_level = max_t(int, 0, chan_pwr - *pwr_constr_elem);
+static bool ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_channel *channel,
+					struct ieee80211_mgmt *mgmt,
+					const u8 *country_ie, u8 country_ie_len,
+					const u8 *pwr_constr_ie)
+{
+	bool has_80211h_pwr = false;
+	int chan_pwr, pwr_reduction_80211h;
+	int new_ap_level;
 
-	if (sdata->ap_power_level == new_ap_level)
+	if (country_ie && pwr_constr_ie &&
+	    mgmt->u.probe_resp.capab_info &
+		cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT)) {
+		has_80211h_pwr = ieee80211_find_80211h_pwr_constr(
+			sdata, channel, country_ie, country_ie_len,
+			pwr_constr_ie, &chan_pwr, &pwr_reduction_80211h);
+		new_ap_level = max_t(int, 0, chan_pwr - pwr_reduction_80211h);
+	}
+
+	if (!has_80211h_pwr)
 		return 0;
 
 	sdata_info(sdata,
 		   "Limiting TX power to %d (%d - %d) dBm as advertised by %pM\n",
-		   new_ap_level, chan_pwr, *pwr_constr_elem,
+		   new_ap_level, chan_pwr, pwr_reduction_80211h,
 		   sdata->u.mgd.bssid);
-	sdata->ap_power_level = new_ap_level;
+
+	if (sdata->ap_power_level == new_ap_level)
+		return 0;
+
 	if (__ieee80211_recalc_txpower(sdata))
 		return BSS_CHANGED_TXPOWER;
 	return 0;
@@ -3190,13 +3215,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					    rx_status->band, true);
 	mutex_unlock(&local->sta_mtx);
 
-	if (elems.country_elem && elems.pwr_constr_elem &&
-	    mgmt->u.probe_resp.capab_info &
-				cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT))
-		changed |= ieee80211_handle_pwr_constr(sdata, chan,
-						       elems.country_elem,
-						       elems.country_elem_len,
-						       elems.pwr_constr_elem);
+	changed |= ieee80211_handle_pwr_constr(sdata, chan, mgmt,
+					       elems.country_elem,
+					       elems.country_elem_len,
+					       elems.pwr_constr_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
-- 
1.7.10.4

