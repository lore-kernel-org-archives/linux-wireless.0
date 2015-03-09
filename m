Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:43229 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbCIG7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 02:59:09 -0400
Received: by labgf13 with SMTP id gf13so44302056lab.10
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2015 23:59:07 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCHv2 2/3] mac80211: ibss refactor ieee80211_rx_bss_info
Date: Mon,  9 Mar 2015 07:58:15 +0100
Message-Id: <1425884296-7074-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_075921_319174_DFA0E270)
In-Reply-To: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put station specific code in ieee80211_update_sta_info
function.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c | 186 ++++++++++++++++++++++++++++------------------------
 1 file changed, 100 insertions(+), 86 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 650e69c..4299973 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -965,6 +965,105 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0, 0);
 }
 
+static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_mgmt *mgmt, size_t len,
+				      struct ieee80211_rx_status *rx_status,
+				      struct ieee802_11_elems *elems,
+				      struct ieee80211_channel *channel)
+{
+	struct sta_info *sta;
+	enum ieee80211_band band = rx_status->band;
+	enum nl80211_bss_scan_width scan_width;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	bool rates_updated = false;
+	u32 supp_rates = 0;
+
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+		return;
+
+	if (!ether_addr_equal(mgmt->bssid, sdata->u.ibss.bssid))
+		return;
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, mgmt->sa);
+
+	if (elems->supp_rates) {
+		supp_rates = ieee80211_sta_get_rates(sdata, elems,
+						     band, NULL);
+		if (sta) {
+			u32 prev_rates;
+
+			prev_rates = sta->sta.supp_rates[band];
+			/* make sure mandatory rates are always added */
+			scan_width = NL80211_BSS_CHAN_WIDTH_20;
+			if (rx_status->flag & RX_FLAG_5MHZ)
+				scan_width = NL80211_BSS_CHAN_WIDTH_5;
+			if (rx_status->flag & RX_FLAG_10MHZ)
+				scan_width = NL80211_BSS_CHAN_WIDTH_10;
+
+			sta->sta.supp_rates[band] = supp_rates |
+				ieee80211_mandatory_rates(sband, scan_width);
+			if (sta->sta.supp_rates[band] != prev_rates) {
+				ibss_dbg(sdata,
+					 "updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
+					 sta->sta.addr, prev_rates,
+					 sta->sta.supp_rates[band]);
+				rates_updated = true;
+			}
+		} else {
+			rcu_read_unlock();
+			sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
+						     mgmt->sa, supp_rates);
+		}
+	}
+
+	if (sta && elems->wmm_info)
+		sta->sta.wme = true;
+
+	if (sta && elems->ht_operation && elems->ht_cap_elem &&
+	    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_5 &&
+	    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_10) {
+		/* we both use HT */
+		struct ieee80211_ht_cap htcap_ie;
+		struct cfg80211_chan_def chandef;
+
+		ieee80211_ht_oper_to_chandef(channel,
+					     elems->ht_operation,
+					     &chandef);
+
+		memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
+
+		/*
+		 * fall back to HT20 if we don't use or use
+		 * the other extension channel
+		 */
+		if (chandef.center_freq1 != sdata->u.ibss.chandef.center_freq1)
+			htcap_ie.cap_info &=
+				cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+
+		rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
+								   &htcap_ie,
+								   sta);
+	}
+
+	if (sta && rates_updated) {
+		u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
+		u8 rx_nss = sta->sta.rx_nss;
+
+		/* Force rx_nss recalculation */
+		sta->sta.rx_nss = 0;
+		rate_control_rate_init(sta);
+		if (sta->sta.rx_nss != rx_nss)
+			changed |= IEEE80211_RC_NSS_CHANGED;
+
+		drv_sta_rc_update(local, sdata, &sta->sta, changed);
+	}
+
+	rcu_read_unlock();
+}
+
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt, size_t len,
 				  struct ieee80211_rx_status *rx_status,
@@ -973,101 +1072,16 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
-	struct sta_info *sta;
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
 	u32 supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
-	enum nl80211_bss_scan_width scan_width;
-	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
-	bool rates_updated = false;
 
 	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
 	if (!channel)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-	    ether_addr_equal(mgmt->bssid, sdata->u.ibss.bssid)) {
-
-		rcu_read_lock();
-		sta = sta_info_get(sdata, mgmt->sa);
-
-		if (elems->supp_rates) {
-			supp_rates = ieee80211_sta_get_rates(sdata, elems,
-							     band, NULL);
-			if (sta) {
-				u32 prev_rates;
-
-				prev_rates = sta->sta.supp_rates[band];
-				/* make sure mandatory rates are always added */
-				scan_width = NL80211_BSS_CHAN_WIDTH_20;
-				if (rx_status->flag & RX_FLAG_5MHZ)
-					scan_width = NL80211_BSS_CHAN_WIDTH_5;
-				if (rx_status->flag & RX_FLAG_10MHZ)
-					scan_width = NL80211_BSS_CHAN_WIDTH_10;
-
-				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(sband,
-								  scan_width);
-				if (sta->sta.supp_rates[band] != prev_rates) {
-					ibss_dbg(sdata,
-						 "updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
-						 sta->sta.addr, prev_rates,
-						 sta->sta.supp_rates[band]);
-					rates_updated = true;
-				}
-			} else {
-				rcu_read_unlock();
-				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates);
-			}
-		}
-
-		if (sta && elems->wmm_info)
-			sta->sta.wme = true;
-
-		if (sta && elems->ht_operation && elems->ht_cap_elem &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_5 &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_10) {
-			/* we both use HT */
-			struct ieee80211_ht_cap htcap_ie;
-			struct cfg80211_chan_def chandef;
-
-			ieee80211_ht_oper_to_chandef(channel,
-						     elems->ht_operation,
-						     &chandef);
-
-			memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
-
-			/*
-			 * fall back to HT20 if we don't use or use
-			 * the other extension channel
-			 */
-			if (chandef.center_freq1 !=
-			    sdata->u.ibss.chandef.center_freq1)
-				htcap_ie.cap_info &=
-					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
-			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
-						sdata, sband, &htcap_ie, sta);
-		}
-
-		if (sta && rates_updated) {
-			u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
-			u8 rx_nss = sta->sta.rx_nss;
-
-			/* Force rx_nss recalculation */
-			sta->sta.rx_nss = 0;
-			rate_control_rate_init(sta);
-			if (sta->sta.rx_nss != rx_nss)
-				changed |= IEEE80211_RC_NSS_CHANGED;
-
-			drv_sta_rc_update(local, sdata, &sta->sta, changed);
-		}
-
-		rcu_read_unlock();
-	}
+	ieee80211_update_sta_info(sdata, mgmt, len, rx_status, elems, channel);
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
-- 
1.9.1

