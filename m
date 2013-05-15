Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40228 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab3EOOTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 05/18] mac80211: round rates to the next multiple of 500kbps
Date: Wed, 15 May 2013 16:18:56 +0200
Message-Id: <1368627549-22518-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162020_829899_BBF9C547)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some rates in reduced bandwidth modes which can't be
represented as multiples of 500kbps, like 2.25 MBit/s in 5 MHz mode. The
standard suggests to round up to the next multiple of 500kbps, just do
that in mac80211 as well.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c             |    8 ++++----
 net/mac80211/mlme.c             |   18 +++++++++---------
 net/mac80211/rc80211_minstrel.c |    2 +-
 net/mac80211/rx.c               |    2 +-
 net/mac80211/status.c           |    5 ++++-
 net/mac80211/util.c             |    7 ++++---
 6 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4e1fb81..6a96663 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -142,7 +142,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		u8 basic = 0;
 		if (basic_rates & BIT(i))
 			basic = 0x80;
-		*pos++ = basic | (u8) (rate / 5);
+		*pos++ = basic | (u8) ((rate + 4) / 5);
 	}
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
@@ -165,7 +165,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 			u8 basic = 0;
 			if (basic_rates & BIT(i))
 				basic = 0x80;
-			*pos++ = basic | (u8) (rate / 5);
+			*pos++ = basic | (u8) ((rate + 4) / 5);
 		}
 	}
 
@@ -275,11 +275,11 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	basic_rates = 0;
 
 	for (i = 0; i < bss->supp_rates_len; i++) {
-		int rate = (bss->supp_rates[i] & 0x7f) * 5;
+		int rate = bss->supp_rates[i] & 0x7f;
 		bool is_basic = !!(bss->supp_rates[i] & 0x80);
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
+			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
 				if (is_basic)
 					basic_rates |= BIT(j);
 				break;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0eaee23..03c1b73 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -520,10 +520,10 @@ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 	*rates = 0;
 	count = 0;
 	for (i = 0; i < supp_rates_len; i++) {
-		int rate = (supp_rates[i] & 0x7F) * 5;
+		int rate = supp_rates[i] & 0x7F;
 
 		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == rate) {
+			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
 				*rates |= BIT(j);
 				count++;
 				break;
@@ -765,7 +765,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (BIT(i) & rates) {
 			int rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
+			*pos++ = (u8) ((rate + 4) / 5);
 			if (++count == 8)
 				break;
 		}
@@ -779,7 +779,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		for (i++; i < sband->n_bitrates; i++) {
 			if (BIT(i) & rates) {
 				int rate = sband->bitrates[i].bitrate;
-				*pos++ = (u8) (rate / 5);
+				*pos++ = (u8) ((rate + 4) / 5);
 			}
 		}
 	}
@@ -2448,10 +2448,10 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 	int i, j;
 
 	for (i = 0; i < supp_rates_len; i++) {
-		int rate = (supp_rates[i] & 0x7f) * 5;
+		int rate = supp_rates[i] & 0x7f;
 		bool is_basic = !!(supp_rates[i] & 0x80);
 
-		if (rate > 110)
+		if ((rate * 5) > 110)
 			*have_higher_than_11mbit = true;
 
 		/*
@@ -2467,12 +2467,12 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 			continue;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
+			if ((sband->bitrates[j].bitrate + 4) / 5 == rate) {
 				*rates |= BIT(j);
 				if (is_basic)
 					*basic_rates |= BIT(j);
-				if (rate < *min_rate) {
-					*min_rate = rate;
+				if ((rate * 5) < *min_rate) {
+					*min_rate = rate * 5;
 					*min_rate_index = j;
 				}
 				break;
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3fe134a..6c89c29 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -451,7 +451,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		memset(mr, 0, sizeof(*mr));
 
 		mr->rix = i;
-		mr->bitrate = sband->bitrates[i].bitrate / 5;
+		mr->bitrate = (sband->bitrates[i].bitrate + 4) / 5;
 		calc_rate_durations(sband->band, mr, &sband->bitrates[i], mp);
 
 		/* calculate maximum number of retransmissions before
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c8447af..06f71c6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -208,7 +208,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = 0;
 	} else {
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		*pos = rate->bitrate / 5;
+		*pos = (rate->bitrate + 4) / 5;
 	}
 	pos++;
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..f62e4f6 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -280,8 +280,11 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		int rate;
+
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		*pos = sband->bitrates[info->status.rates[0].idx].bitrate / 5;
+		rate = sband->bitrates[info->status.rates[0].idx].bitrate;
+		*pos = (rate + 4) / 5;
 		/* padding for tx flags */
 		pos += 2;
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5496764..9d04989 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1213,7 +1213,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((BIT(i) & rate_mask) == 0)
 			continue; /* skip rate */
-		rates[num_rates++] = (u8) (sband->bitrates[i].bitrate / 5);
+		rates[num_rates++] = (u8)
+			((sband->bitrates[i].bitrate + 4) / 5);
 	}
 
 	supp_rates_len = min_t(int, num_rates, 8);
@@ -2055,7 +2056,7 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 		if (need_basic && basic_rates & BIT(i))
 			basic = 0x80;
 		rate = sband->bitrates[i].bitrate;
-		*pos++ = basic | (u8) (rate / 5);
+		*pos++ = basic | (u8) ((rate + 4) / 5);
 	}
 
 	return 0;
@@ -2090,7 +2091,7 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
 			rate = sband->bitrates[i].bitrate;
-			*pos++ = basic | (u8) (rate / 5);
+			*pos++ = basic | (u8) ((rate + 4) / 5);
 		}
 	}
 	return 0;
-- 
1.7.10.4

