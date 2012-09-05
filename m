Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2IELwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 07:52:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: properly handle power constraint/country IE
Date: Wed,  5 Sep 2012 13:52:56 +0200
Message-Id: <1346845976-15831-3-git-send-email-johannes@sipsolutions.net> (sfid-20120905_135225_130117_0BDB4ECC)
In-Reply-To: <1346845976-15831-1-git-send-email-johannes@sipsolutions.net>
References: <1346845976-15831-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, mac80211 uses the power constraint IE, and reduces
the regulatory max TX power by it. This can cause issues if
the AP is advertising a large power constraint value matching
a high TX power in its country IE, for example in this case:

...
Country: US  Environment: Indoor/Outdoor
    ...
    Channels [157 - 157] @ 30 dBm
    ...
Power constraint: 13 dB
...

What happened here is that our local regulatory TX power is
15 dBm, and gets reduced by 13 dB so we end up with only
2 dBm effective TX power, which is way too low.

Instead, handle the country IE/power constraint IE combined
and restrict our TX power to the max of the regulatory power
and the maximum power advertised by the AP, in this case
17 dBm (= 30 dBm - 13 dB).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/main.c        |    8 +++---
 net/mac80211/mlme.c        |   58 ++++++++++++++++++++++++++++++++------------
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2eee293..8937056 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1052,7 +1052,7 @@ struct ieee80211_local {
 	bool disable_dynamic_ps;
 
 	int user_power_level; /* in dBm */
-	int power_constr_level; /* in dBm */
+	int ap_power_level; /* in dBm */
 
 	enum ieee80211_smps_mode smps_mode;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c26e231..412f1aa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -150,13 +150,11 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_HW_SCANNING, &local->scanning))
+	    test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+	    !local->ap_power_level)
 		power = chan->max_power;
 	else
-		power = local->power_constr_level ?
-			min(chan->max_power,
-				(chan->max_reg_power  - local->power_constr_level)) :
-			chan->max_power;
+		power = min(chan->max_power, local->ap_power_level);
 
 	if (local->user_power_level >= 0)
 		power = min(power, local->user_power_level);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6f64364..92b035b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -796,16 +796,45 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-					u16 capab_info, u8 *pwr_constr_elem)
+					struct ieee80211_channel *channel,
+					const u8 *country_ie, u8 country_ie_len,
+					const u8 *pwr_constr_elem)
 {
-	struct ieee80211_conf *conf = &sdata->local->hw.conf;
+	struct ieee80211_country_ie_triplet *triplet;
+	int chan = ieee80211_frequency_to_channel(channel->center_freq);
+	int chan_pwr;
+	bool have_chan_pwr = false;
 
-	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
+	/* Invalid IE */
+	if (country_ie_len % 2 || country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
 		return;
 
-	if ((*pwr_constr_elem <= conf->channel->max_reg_power) &&
-	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
-		sdata->local->power_constr_level = *pwr_constr_elem;
+	triplet = (void *)(country_ie + 3);
+	country_ie_len -= 3;
+
+	/* find channel */
+	while (country_ie_len >= 3) {
+		if (triplet->chans.first_channel >=
+					IEEE80211_COUNTRY_EXTENSION_ID)
+			goto next;
+
+		/* XXX: How to use triplet->chans.num_channels? */
+		if (triplet->chans.first_channel == chan) {
+			have_chan_pwr = true;
+			chan_pwr = triplet->chans.max_power;
+			break;
+		}
+
+ next:
+		triplet++;
+		country_ie_len -= 3;
+	}
+
+	if (!have_chan_pwr)
+		return;
+
+	if (*pwr_constr_elem <= chan_pwr) {
+		sdata->local->ap_power_level = chan_pwr - *pwr_constr_elem;
 		ieee80211_hw_config(sdata->local, 0);
 	}
 }
@@ -1396,7 +1425,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 
-	local->power_constr_level = 0;
+	local->ap_power_level = 0;
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -2491,14 +2520,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 						  bssid, true);
 	}
 
-	/* Note: country IE parsing is done for us by cfg80211 */
-	if (elems.country_elem) {
-		/* TODO: IBSS also needs this */
-		if (elems.pwr_constr_elem)
-			ieee80211_handle_pwr_constr(sdata,
-				le16_to_cpu(mgmt->u.probe_resp.capab_info),
-				elems.pwr_constr_elem);
-	}
+	if (elems.country_elem && elems.pwr_constr_elem &&
+	    mgmt->u.probe_resp.capab_info &
+				cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT))
+		ieee80211_handle_pwr_constr(sdata, local->oper_channel,
+					    elems.country_elem,
+					    elems.country_elem_len,
+					    elems.pwr_constr_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
-- 
1.7.10.4

