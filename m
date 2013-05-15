Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40201 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab3EOOTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:33 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 02/18] nl80211: add half/quarter channel bitrate tables to supported band struct
Date: Wed, 15 May 2013 16:18:53 +0200
Message-Id: <1368627549-22518-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161939_866972_F4D2337C)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduced bandwidth channels use other bitrates (half or quarter of the
original 20 MHz rate). To allow internal use of these different rates,
add bitrate tables for these channel types. Drivers which support these
channel types must fill these tables, and mac80211 (or full-mac drivers
support 5/10 MHz) must check them.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |   39 ++++++++++++++++++++++++++++++++
 net/wireless/util.c    |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 08489cc..d4c687a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -273,13 +273,52 @@ struct ieee80211_sta_vht_cap {
 struct ieee80211_supported_band {
 	struct ieee80211_channel *channels;
 	struct ieee80211_rate *bitrates;
+	struct ieee80211_rate *bitrates_half;
+	struct ieee80211_rate *bitrates_quarter;
 	enum ieee80211_band band;
 	int n_channels;
 	int n_bitrates;
+	int n_bitrates_half;
+	int n_bitrates_quarter;
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
 };
 
+/**
+ * ieee80211_get_bitrates - get the bitrates for the channel width
+ *
+ * @sband: supported band
+ * @width: channel width where the bitrates are operated
+ * @bitrates: pointer to bitrate array for return
+ * @n_bitrates: pointer for the number of bitrates to return
+ *
+ * Return: 0 on success, -EINVAL if no rates are defined
+ */
+static inline int
+ieee80211_get_bitrates(struct ieee80211_supported_band *sband,
+		       enum nl80211_chan_width width,
+		       struct ieee80211_rate **bitrates,
+		       int *n_bitrates)
+{
+	switch (width) {
+	case NL80211_CHAN_WIDTH_5:
+		*bitrates = sband->bitrates_quarter;
+		*n_bitrates = sband->n_bitrates_quarter;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		*bitrates = sband->bitrates_half;
+		*n_bitrates = sband->n_bitrates_half;
+		break;
+	default:
+		*bitrates = sband->bitrates;
+		*n_bitrates = sband->n_bitrates;
+		break;
+	}
+	if (*bitrates)
+		return 0;
+	else
+		return -EINVAL;
+}
 /*
  * Wireless hardware/device configuration structures and methods
  */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f5ad4d9..b0fd2f3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -122,6 +122,32 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 			}
 		}
 		WARN_ON(want);
+		if (sband->n_bitrates_half) {
+			want = 3;
+			for (i = 0; i < sband->n_bitrates_half; i++) {
+				if (sband->bitrates_half[i].bitrate == 30 ||
+				    sband->bitrates_half[i].bitrate == 60 ||
+				    sband->bitrates_half[i].bitrate == 120) {
+					sband->bitrates_half[i].flags |=
+						IEEE80211_RATE_MANDATORY_A;
+					want--;
+				}
+			}
+			WARN_ON(want);
+		}
+		if (sband->n_bitrates_quarter) {
+			want = 3;
+			for (i = 0; i < sband->n_bitrates_quarter; i++) {
+				if (sband->bitrates_quarter[i].bitrate == 15 ||
+				    sband->bitrates_quarter[i].bitrate == 30 ||
+				    sband->bitrates_quarter[i].bitrate == 60) {
+					sband->bitrates_quarter[i].flags |=
+						IEEE80211_RATE_MANDATORY_A;
+					want--;
+				}
+			}
+			WARN_ON(want);
+		}
 		break;
 	case IEEE80211_BAND_2GHZ:
 		want = 7;
@@ -152,6 +178,38 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 					IEEE80211_RATE_ERP_G;
 		}
 		WARN_ON(want != 0 && want != 3 && want != 6);
+
+		/*
+		 * NOTE: half/quarter bitrates are actually only defined for
+		 * the OFDM PHY, yet some chipsets support them so define
+		 * mandatory rates as for 5 GHZ.
+		 */
+		if (sband->n_bitrates_half) {
+			want = 3;
+			for (i = 0; i < sband->n_bitrates_half; i++) {
+				if (sband->bitrates_half[i].bitrate == 30 ||
+				    sband->bitrates_half[i].bitrate == 60 ||
+				    sband->bitrates_half[i].bitrate == 120) {
+					sband->bitrates_half[i].flags |=
+						IEEE80211_RATE_MANDATORY_B;
+					want--;
+				}
+			}
+			WARN_ON(want);
+		}
+		if (sband->n_bitrates_quarter) {
+			want = 3;
+			for (i = 0; i < sband->n_bitrates_quarter; i++) {
+				if (sband->bitrates_quarter[i].bitrate == 15 ||
+				    sband->bitrates_quarter[i].bitrate == 30 ||
+				    sband->bitrates_quarter[i].bitrate == 60) {
+					sband->bitrates_quarter[i].flags |=
+						IEEE80211_RATE_MANDATORY_B;
+					want--;
+				}
+			}
+			WARN_ON(want);
+		}
 		break;
 	case IEEE80211_BAND_60GHZ:
 		/* check for mandatory HT MCS 1..4 */
-- 
1.7.10.4

