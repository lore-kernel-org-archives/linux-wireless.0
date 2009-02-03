Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53749 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZBCFCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 00:02:37 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 21:02:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 2/2] ath9k: follow beacon hints on reg_notifier when world roaming
Date: Mon, 2 Feb 2009 21:01:53 -0800
Message-ID: <1233637313-16786-3-git-send-email-lrodriguez@atheros.com> (sfid-20090203_060241_111267_3934749E)
In-Reply-To: <1233637313-16786-2-git-send-email-lrodriguez@atheros.com>
References: <1233637313-16786-1-git-send-email-lrodriguez@atheros.com>
 <1233637313-16786-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we are roaming we allow to follow beacon hints.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |   92 ++++++++++++++++++++++++-------------
 1 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index fe08a4f..f01ca7f 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -161,13 +161,18 @@ static bool ath9k_is_radar_freq(u16 center_freq)
 }
 
 /*
- * Enable adhoc on 5 GHz if allowed by 11d.
- * Remove passive scan if channel is allowed by 11d,
- * except when on radar frequencies.
+ * N.B: These exception rules do not apply radar freqs.
+ *
+ * - We enable adhoc (or beaconing) if allowed by 11d
+ * - We enable active scan if the channel is allowed by 11d
+ * - If no country IE has been processed and a we determine we have
+ *   received a beacon on a channel we can enable active scan and
+ *   adhoc (or beaconing).
  */
-static void ath9k_reg_apply_5ghz_beaconing_flags(struct wiphy *wiphy,
+static void ath9k_reg_apply_beaconing_flags(struct wiphy *wiphy,
 					     enum reg_set_by setby)
 {
+	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
@@ -175,29 +180,49 @@ static void ath9k_reg_apply_5ghz_beaconing_flags(struct wiphy *wiphy,
 	u32 bandwidth = 0;
 	int r;
 
-	if (setby != REGDOM_SET_BY_COUNTRY_IE)
-		return;
-	if (!wiphy->bands[IEEE80211_BAND_5GHZ])
-		return;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 
-	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
-	for (i = 0; i < sband->n_channels; i++) {
-		ch = &sband->channels[i];
-		r = freq_reg_info(wiphy, ch->center_freq,
-			&bandwidth, &reg_rule);
-		if (r)
+		if (!wiphy->bands[band])
 			continue;
-		/* If 11d had a rule for this channel ensure we enable adhoc
-		 * if it allows us to use it. Note that we would have disabled
-		 * it by applying our static world regdomain by default during
-		 * probe */
-		if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
-			ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
-		if (!ath9k_is_radar_freq(ch->center_freq))
-			continue;
-		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+
+		sband = wiphy->bands[band];
+
+		for (i = 0; i < sband->n_channels; i++) {
+
+			ch = &sband->channels[i];
+
+			if (ath9k_is_radar_freq(ch->center_freq))
+				continue;
+
+			if (setby == REGDOM_SET_BY_COUNTRY_IE) {
+				r = freq_reg_info(wiphy, ch->center_freq,
+					&bandwidth, &reg_rule);
+				if (r)
+					continue;
+				/*
+				 * If 11d had a rule for this channel ensure
+				 * we enable adhoc/beaconing if it allows us to
+				 * use it. Note that we would have disabled it
+				 * by applying our static world regdomain by
+				 * default during init, prior to calling our
+				 * regulatory_hint().
+				 */
+				if (!(reg_rule->flags &
+				    NL80211_RRF_NO_IBSS))
+					ch->flags &=
+					  ~IEEE80211_CHAN_NO_IBSS;
+				if (!(reg_rule->flags &
+				    NL80211_RRF_PASSIVE_SCAN))
+					ch->flags &=
+					  ~IEEE80211_CHAN_PASSIVE_SCAN;
+			} else {
+				if (ch->beacon_found)
+					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
+					  IEEE80211_CHAN_PASSIVE_SCAN);
+			}
+		}
 	}
+
 }
 
 /* Allows active scan scan on Ch 12 and 13 */
@@ -210,11 +235,12 @@ static void ath9k_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	u32 bandwidth = 0;
 	int r;
 
-	/* Force passive scan on Channels 12-13 */
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 
-	/* If no country IE has been received always enable active scan
-	 * on these channels */
+	/*
+	 * If no country IE has been received always enable active scan
+	 * on these channels. This is only done for specific regulatory SKUs
+	 */
 	if (setby != REGDOM_SET_BY_COUNTRY_IE) {
 		ch = &sband->channels[11]; /* CH 12 */
 		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -225,10 +251,12 @@ static void ath9k_reg_apply_active_scan_flags(struct wiphy *wiphy,
 		return;
 	}
 
-	/* If a country IE has been recieved check its rule for this
+	/*
+	 * If a country IE has been recieved check its rule for this
 	 * channel first before enabling active scan. The passive scan
-	 * would have been enforced by the initial probe processing on
-	 * our custom regulatory domain. */
+	 * would have been enforced by the initial processing of our
+	 * custom regulatory domain.
+	 */
 
 	ch = &sband->channels[11]; /* CH 12 */
 	r = freq_reg_info(wiphy, ch->center_freq, &bandwidth, &reg_rule);
@@ -291,10 +319,10 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 	case 0x63:
 	case 0x66:
 	case 0x67:
-		ath9k_reg_apply_5ghz_beaconing_flags(wiphy, setby);
+		ath9k_reg_apply_beaconing_flags(wiphy, setby);
 		break;
 	case 0x68:
-		ath9k_reg_apply_5ghz_beaconing_flags(wiphy, setby);
+		ath9k_reg_apply_beaconing_flags(wiphy, setby);
 		ath9k_reg_apply_active_scan_flags(wiphy, setby);
 		break;
 	}
-- 
1.6.1.2.253.ga34a

