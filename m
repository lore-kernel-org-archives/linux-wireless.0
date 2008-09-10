Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYIJWK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:10:29 -0400
Message-Id: <20080910220421.558946000@sipsolutions.net> (sfid-20080911_001032_730124_03D6BA72)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/18] mac80211: inform driver of basic rateset
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers need to know the basic rateset to be able to configure
the ACK/CTS programming in hardware correctly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    6 ++++++
 net/mac80211/ieee80211_i.h |    7 ++-----
 net/mac80211/iface.c       |    4 +++-
 net/mac80211/mlme.c        |   40 +++++++++-------------------------------
 net/mac80211/tx.c          |    4 ++--
 net/mac80211/util.c        |   28 ++++++++++++++++++++++++++++
 6 files changed, 50 insertions(+), 39 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-10 23:57:58.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-10 23:58:03.000000000 +0200
@@ -160,6 +160,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
  * @BSS_CHANGED_ERP_SLOT: slot timing changed
  * @BSS_CHANGED_HT: 802.11n parameters changed
+ * @BSS_CHANGED_BASIC_RATES: Basic rateset changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -167,6 +168,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
 	BSS_CHANGED_ERP_SLOT		= 1<<3,
 	BSS_CHANGED_HT                  = 1<<4,
+	BSS_CHANGED_BASIC_RATES		= 1<<5,
 };
 
 /**
@@ -187,6 +189,9 @@ enum ieee80211_bss_change {
  * @assoc_ht: association in HT mode
  * @ht_conf: ht capabilities
  * @ht_bss_conf: ht extended capabilities
+ * @basic_rates: bitmap of basic rates, each bit stands for an
+ *	index into the rate table configured by the driver in
+ *	the current band.
  */
 struct ieee80211_bss_conf {
 	/* association related data */
@@ -200,6 +205,7 @@ struct ieee80211_bss_conf {
 	u16 beacon_int;
 	u16 assoc_capability;
 	u64 timestamp;
+	u64 basic_rates;
 	/* ht related data */
 	bool assoc_ht;
 	struct ieee80211_ht_info *ht_conf;
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:03.000000000 +0200
@@ -433,11 +433,6 @@ struct ieee80211_sub_if_data {
 
 	int drop_unencrypted;
 
-	/*
-	 * basic rates of this AP or the AP we're associated to
-	 */
-	u64 basic_rates;
-
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
@@ -1017,6 +1012,8 @@ void ieee80211_tx_skb(struct ieee80211_s
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
+u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
+			      enum ieee80211_band band);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:57:59.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:58:03.000000000 +0200
@@ -144,7 +144,9 @@ int ieee80211_if_change_type(struct ieee
 	ieee80211_setup_sdata(sdata, type);
 
 	/* reset some values that shouldn't be kept across type changes */
-	sdata->basic_rates = 0;
+	sdata->bss_conf.basic_rates =
+		ieee80211_mandatory_rates(sdata->local,
+			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
 
 	return 0;
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:58:03.000000000 +0200
@@ -741,6 +741,12 @@ static void ieee80211_set_associated(str
 	ieee80211_led_assoc(local, 1);
 
 	sdata->bss_conf.assoc = 1;
+	/*
+	 * For now just always ask the driver to update the basic rateset
+	 * when we have associated, we aren't checking whether it actually
+	 * changed or not.
+	 */
+	changed |= BSS_CHANGED_BASIC_RATES;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_tx_start_all_queues(sdata->dev);
@@ -1327,7 +1333,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	}
 
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
-	sdata->basic_rates = basic_rates;
+	sdata->bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
 	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
@@ -1484,34 +1490,6 @@ static int ieee80211_sta_join_ibss(struc
 	return res;
 }
 
-static u64 ieee80211_sta_get_mandatory_rates(struct ieee80211_local *local,
-					enum ieee80211_band band)
-{
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *bitrates;
-	u64 mandatory_rates;
-	enum ieee80211_rate_flags mandatory_flag;
-	int i;
-
-	sband = local->hw.wiphy->bands[band];
-	if (!sband) {
-		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	}
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
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -1553,7 +1531,7 @@ static void ieee80211_rx_bss_info(struct
 			prev_rates = sta->supp_rates[band];
 			/* make sure mandatory rates are always added */
 			sta->supp_rates[band] = supp_rates |
-				ieee80211_sta_get_mandatory_rates(local, band);
+				ieee80211_mandatory_rates(local, band);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			if (sta->supp_rates[band] != prev_rates)
@@ -2392,7 +2370,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 
 	/* make sure mandatory rates are always added */
 	sta->supp_rates[band] = supp_rates |
-			ieee80211_sta_get_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(local, band);
 
 	rate_control_rate_init(sta, local);
 
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:58:03.000000000 +0200
@@ -153,7 +153,7 @@ static __le16 ieee80211_duration(struct 
 		if (r->bitrate > txrate->bitrate)
 			break;
 
-		if (tx->sdata->basic_rates & BIT(i))
+		if (tx->sdata->bss_conf.basic_rates & BIT(i))
 			rate = r->bitrate;
 
 		switch (sband->band) {
@@ -594,7 +594,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 		for (idx = 0; idx < sband->n_bitrates; idx++) {
 			if (sband->bitrates[idx].bitrate > rate->bitrate)
 				continue;
-			if (tx->sdata->basic_rates & BIT(idx) &&
+			if (tx->sdata->bss_conf.basic_rates & BIT(idx) &&
 			    (baserate < 0 ||
 			     (sband->bitrates[baserate].bitrate
 			      < sband->bitrates[idx].bitrate)))
--- everything.orig/net/mac80211/util.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-10 23:58:03.000000000 +0200
@@ -640,3 +640,31 @@ int ieee80211_set_freq(struct ieee80211_
 
 	return ret;
 }
+
+u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
+			      enum ieee80211_band band)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	u64 mandatory_rates;
+	enum ieee80211_rate_flags mandatory_flag;
+	int i;
+
+	sband = local->hw.wiphy->bands[band];
+	if (!sband) {
+		WARN_ON(1);
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	}
+
+	if (band == IEEE80211_BAND_2GHZ)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+	else
+		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+
+	bitrates = sband->bitrates;
+	mandatory_rates = 0;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (bitrates[i].flags & mandatory_flag)
+			mandatory_rates |= BIT(i);
+	return mandatory_rates;
+}

-- 

