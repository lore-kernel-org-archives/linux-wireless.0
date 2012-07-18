Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54086 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2GREm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 00:42:57 -0400
Received: by obbuo13 with SMTP id uo13so1580388obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 21:42:56 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, thomas@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH V2 1/2] {cfg,mac}80211: utility function for calculating mandatory rates
Date: Tue, 17 Jul 2012 21:42:49 -0700
Message-Id: <1342586570-522-1-git-send-email-ashok@cozybit.com> (sfid-20120718_064302_806254_3F591F03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move up mandatory rate calculation to cfg80211. Currently
ieee80211_mandatory_rates() doesn't get 802.11g mandatory rates. This patch
will make the function to return correct mandatory rates when operating in
2.4GHz band.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h     |   10 ++++++++++
 net/mac80211/ibss.c        |    8 +++++---
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/iface.c       |    8 +++++---
 net/mac80211/mesh.c        |    6 ++++--
 net/mac80211/util.c        |   26 --------------------------
 net/wireless/util.c        |   31 +++++++++++++++++++++++++++++++
 7 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..5b15ef7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2527,6 +2527,16 @@ struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 			    u32 basic_rates, int bitrate);
 
+/**
+ * ieee80211_mandatory_rates - get mandatory rates for a given band
+ *
+ * @sband: the band to look for rates in
+ * @band: the band this structure represents
+ */
+
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      enum ieee80211_band band);
+
 /*
  * Radiotap parsing functions -- for controlled injection support
  *
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5746d62..1765e53 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -295,6 +295,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -327,7 +328,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+					 ieee80211_mandatory_rates(sband, band);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -410,7 +411,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(local, band);
+					 ieee80211_mandatory_rates(sband, band);
 
 				if (sta->sta.supp_rates[band] != prev_rates) {
 					ibss_dbg(sdata,
@@ -562,6 +563,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -587,7 +589,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+					 ieee80211_mandatory_rates(sband, band);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bb61f77..66b54a8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1412,8 +1412,6 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
-			      enum ieee80211_band band);
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bfb57dc..62b6c1e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1250,6 +1250,9 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type)
 {
 	int ret;
+	int band = sdata->local->hw.conf.channel->band;
+	struct ieee80211_supported_band *sband =
+					sdata->local->hw.wiphy->bands[band];
 
 	ASSERT_RTNL();
 
@@ -1272,9 +1275,8 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* reset some values that shouldn't be kept across type changes */
-	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
-			sdata->local->hw.conf.channel->band);
+	sdata->vif.bss_conf.basic_rates = cfg80211_mandatory_rates(sband, band);
+
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..66a718c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -583,6 +583,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	int band = sdata->local->hw.conf.channel->band;
+	struct ieee80211_supported_band *sband =
+					sdata->local->hw.wiphy->bands[band];
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -602,8 +605,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
-					  sdata->local->hw.conf.channel->band);
+					ieee80211_mandatory_rates(sband, band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 39b82fe..f542b57 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -928,32 +928,6 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
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
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *da,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 26f8cd3..6acb3d2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -31,6 +31,37 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
+u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
+			      enum ieee80211_band band)
+{
+	struct ieee80211_rate *bitrates;
+	u32 mandatory_rates = 0;
+	enum ieee80211_rate_flags mandatory_flag;
+	int i;
+
+	if (WARN_ON(!sband))
+		return 1;
+
+	bitrates = sband->bitrates;
+	if (band == IEEE80211_BAND_5GHZ)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+	else {
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+		for (i = 0; i < sband->n_bitrates; i++)
+			if (bitrates[i].bitrate > 110) {
+				mandatory_flag =
+					IEEE80211_RATE_MANDATORY_G;
+				break;
+			}
+	}
+
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

