Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab2FHCVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 22:21:35 -0400
Received: by dady13 with SMTP id y13so1694346dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 19:21:34 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/3] mac80211: return correct mandatory rates when operating in 2.4GHz band
Date: Thu,  7 Jun 2012 19:21:24 -0700
Message-Id: <1339122086-23190-1-git-send-email-ashok@cozybit.com> (sfid-20120608_042138_802046_ED470CE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the function ieee80211_mandatory_rates() doesn't get 802.11g
mandatory rates. This patch will make the function to return correct mandatory
rates when operating in 2.4GHz band.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/ibss.c        |    6 +++---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/util.c        |    8 ++++++--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 725cb4b..d3d891d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -330,7 +330,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sdata, band);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -413,7 +413,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(local, band);
+					ieee80211_mandatory_rates(sdata, band);
 
 				if (sta->sta.supp_rates[band] != prev_rates) {
 					ibss_vdbg("%s: updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
@@ -588,7 +588,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sdata, band);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..7af7c25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1399,7 +1399,7 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_band band);
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 87aeb4f..994e459 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1147,7 +1147,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
+		ieee80211_mandatory_rates(sdata,
 			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1df4019..974e022 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -911,9 +911,10 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_wmm_default(sdata, true);
 }
 
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_band band)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	u32 mandatory_rates;
@@ -924,7 +925,10 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 	if (WARN_ON(!sband))
 		return 1;
 
-	if (band == IEEE80211_BAND_2GHZ)
+	if (band == IEEE80211_BAND_2GHZ &&
+	    sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_G;
+	else if (band == IEEE80211_BAND_2GHZ)
 		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
 	else
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
-- 
1.7.5.4

