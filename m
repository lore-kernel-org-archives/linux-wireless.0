Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38223 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab2AET6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:58:17 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2 1/2] nl80211: add support for mcs masks
Date: Thu,  5 Jan 2012 20:58:07 +0100
Message-Id: <1325793490-21501-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20120105_205826_971333_45DB2E08)
In-Reply-To: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to set mcs masks through nl80211. We also allow to set MCS
rates but no legacy rates (and vice versa).

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/linux/nl80211.h |    4 +++
 include/net/cfg80211.h  |    3 +-
 net/wireless/nl80211.c  |   61 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0f5ff37..225272c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1475,6 +1475,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
 #define NL80211_MAX_SUPP_RATES			32
+#define NL80211_MAX_SUPP_HT_RATES		77
 #define NL80211_MAX_SUPP_REG_RULES		32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
@@ -2401,12 +2402,15 @@ enum nl80211_key_attributes {
  *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
  *	1 = 500 kbps) but without the IE length restriction (at most
  *	%NL80211_MAX_SUPP_RATES in a single array).
+ * @NL80211_TXRATE_MCS: HT (MCS) rates allowed for TX rate selection
+ *	in an array of MCS numbers.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
 enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
+	NL80211_TXRATE_MCS,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15f4be7..2b23757 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1228,8 +1228,7 @@ enum wiphy_params_flags {
 struct cfg80211_bitrate_mask {
 	struct {
 		u32 legacy;
-		/* TODO: add support for masking MCS rates; e.g.: */
-		/* u8 mcs[IEEE80211_HT_MCS_MASK_LEN]; */
+		u8 mcs[IEEE80211_HT_MCS_MASK_LEN];
 	} control[IEEE80211_NUM_BANDS];
 };
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3d3cf8..1f510fa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5364,9 +5364,39 @@ static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
 	return mask;
 }
 
+static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
+			       u8 *rates, u8 rates_len,
+			       u8 mcs[IEEE80211_HT_MCS_MASK_LEN])
+{
+	u8 i;
+
+	memset(mcs, 0, IEEE80211_HT_MCS_MASK_LEN);
+
+	for (i = 0; i < rates_len; i++) {
+		int ridx, rbit;
+
+		ridx = rates[i] / 8;
+		rbit = BIT(rates[i] % 8);
+
+		/* check validity */
+		if ((ridx < 0) || (ridx > IEEE80211_HT_MCS_MASK_LEN))
+			return false;
+
+		/* check availability */
+		if (sband->ht_cap.mcs.rx_mask[ridx] & rbit)
+			mcs[ridx] |= rbit;
+		else
+			return false;
+	}
+
+	return true;
+}
+
 static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
 				    .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_TXRATE_MCS] = { .type = NLA_BINARY,
+				 .len = NL80211_MAX_SUPP_HT_RATES },
 };
 
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
@@ -5392,12 +5422,20 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		sband = rdev->wiphy.bands[i];
 		mask.control[i].legacy =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
+		if (sband)
+			memcpy(mask.control[i].mcs,
+			       sband->ht_cap.mcs.rx_mask,
+			       sizeof(mask.control[i].mcs));
+		else
+			memset(mask.control[i].mcs, 0,
+			       sizeof(mask.control[i].mcs));
 	}
 
 	/*
 	 * The nested attribute uses enum nl80211_band as the index. This maps
 	 * directly to the enum ieee80211_band values used in cfg80211.
 	 */
+	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
 	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
 	{
 		enum ieee80211_band band = nla_type(tx_rates);
@@ -5413,7 +5451,28 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 				sband,
 				nla_data(tb[NL80211_TXRATE_LEGACY]),
 				nla_len(tb[NL80211_TXRATE_LEGACY]));
-			if (mask.control[band].legacy == 0)
+		}
+		if (tb[NL80211_TXRATE_MCS]) {
+			if (!ht_rateset_to_mask(
+					sband,
+					nla_data(tb[NL80211_TXRATE_MCS]),
+					nla_len(tb[NL80211_TXRATE_MCS]),
+					mask.control[band].mcs))
+				return -EINVAL;
+		}
+
+		if (mask.control[band].legacy == 0) {
+			/* don't allow empty legacy rates if HT
+			 * is not even supported. */
+			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
+				return -EINVAL;
+
+			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+				if (mask.control[band].mcs[i])
+					break;
+
+			/* legacy and mcs rates may not be both empty */
+			if (i == IEEE80211_HT_MCS_MASK_LEN)
 				return -EINVAL;
 		}
 	}
-- 
1.7.7.3

