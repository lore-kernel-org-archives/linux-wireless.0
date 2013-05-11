Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52450 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3EKAvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 20:51:04 -0400
Received: by mail-pb0-f50.google.com with SMTP id um15so3121385pbc.9
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 17:51:02 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, ashok@cozybit.com
Subject: [PATCH 1/3] {cfg,mac}80211: move mandatory rates calculation to cfg80211
Date: Fri, 10 May 2013 17:50:51 -0700
Message-Id: <1368233453-10581-1-git-send-email-ashok@cozybit.com> (sfid-20130511_025122_765222_7FB51540)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mandatory rates calculation to cfg80211, shared with non mac80211 drivers.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 include/net/cfg80211.h     |    8 ++++++++
 net/mac80211/ibss.c        |   10 +++++++---
 net/mac80211/ieee80211_i.h |    3 ---
 net/mac80211/mesh.c        |    5 +++--
 net/mac80211/util.c        |   26 --------------------------
 net/wireless/util.c        |   23 +++++++++++++++++++++++
 6 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..fcb7764 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2989,6 +2989,14 @@ struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 			    u32 basic_rates, int bitrate);
 
+/**
+ * ieee80211_mandatory_rates - get mandatory rates for a given band
+ * @sband: the band to look for rates in
+ *
+ * This function returns the mandatory rates for the given band
+ */
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband);
+
 /*
  * Radiotap parsing functions -- for controlled injection support
  *
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 170f9a7..956ba63 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -341,6 +341,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_supported_band *sband;
 	int band;
 
 	/*
@@ -380,8 +381,9 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->last_rx = jiffies;
 
 	/* make sure mandatory rates are always added */
+	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sband);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -492,7 +494,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(local, band);
+					ieee80211_mandatory_rates(sband);
 
 				if (sta->sta.supp_rates[band] != prev_rates) {
 					ibss_dbg(sdata,
@@ -624,6 +626,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_supported_band *sband;
 	int band;
 
 	/*
@@ -658,8 +661,9 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	sta->last_rx = jiffies;
 
 	/* make sure mandatory rates are always added */
+	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sband);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 158e6eb..b7cbd4e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1505,9 +1505,6 @@ static inline void ieee802_11_parse_elems(u8 *start, size_t len, bool action,
 	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
 }
 
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
-			      enum ieee80211_band band);
-
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6952760..5a37f95 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -741,6 +741,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		      BSS_CHANGED_BASIC_RATES |
 		      BSS_CHANGED_BEACON_INT;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	struct ieee80211_supported_band *sband =
+					sdata->local->hw.wiphy->bands[band];
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -759,8 +761,7 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.enable_beacon = true;
-	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(local, band);
+	sdata->vif.bss_conf.basic_rates = ieee80211_mandatory_rates(sband);
 
 	changed |= ieee80211_mps_local_status_update(sdata);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3f87fa4..707953f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1072,32 +1072,6 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_wmm_default(sdata, true);
 }
 
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
-			      enum ieee80211_band band)
-{
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *bitrates;
-	u32 mandatory_rates;
-	enum ieee80211_rate_flags mandatory_flag;
-	int i;
-
-	sband = local->hw.wiphy->bands[band];
-	if (WARN_ON(!sband))
-		return 1;
-
-	if (band == IEEE80211_BAND_2GHZ)
-		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
-	else
-		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
-
-	bitrates = sband->bitrates;
-	mandatory_rates = 0;
-	for (i = 0; i < sband->n_bitrates; i++)
-		if (bitrates[i].flags & mandatory_flag)
-			mandatory_rates |= BIT(i);
-	return mandatory_rates;
-}
-
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *da,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a7046a4..d6727f2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -33,6 +33,29 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_rate *bitrates;
+	u32 mandatory_rates = 0;
+	enum ieee80211_rate_flags mandatory_flag;
+	int i;
+
+	if (WARN_ON(!sband))
+		return 1;
+
+	if (sband->band == IEEE80211_BAND_2GHZ)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+	else
+		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+
+	bitrates = sband->bitrates;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (bitrates[i].flags & mandatory_flag)
+			mandatory_rates |= BIT(i);
+	return mandatory_rates;
+}
+EXPORT_SYMBOL(ieee80211_mandatory_rates);
+
 int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
 {
 	/* see 802.11 17.3.8.3.2 and Annex J
-- 
1.7.5.4

