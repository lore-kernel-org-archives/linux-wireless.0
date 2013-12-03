Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34017 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3LCIvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 03:51:03 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so1310106eei.28
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 00:51:02 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
Date: Tue,  3 Dec 2013 09:50:47 +0100
Message-Id: <1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095110_015543_83CCBB45)
In-Reply-To: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT mcs support for nl80211_set_tx_bitrate_mask().

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/linux/ieee80211.h    |    1 +
 include/net/cfg80211.h       |    1 +
 include/uapi/linux/nl80211.h |    4 ++
 net/wireless/nl80211.c       |   93 +++++++++++++++++++++++++++++++++++++++---
 4 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8c3b26a..3c92dfd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1124,6 +1124,7 @@ struct ieee80211_bar {
 #define IEEE80211_BAR_CTRL_TID_INFO_MASK	0xf000
 #define IEEE80211_BAR_CTRL_TID_INFO_SHIFT	12
 
+#define IEEE80211_VHT_NSS_MAX			8
 #define IEEE80211_HT_MCS_MASK_LEN		10
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 626087b..ffdf771 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1764,6 +1764,7 @@ struct cfg80211_bitrate_mask {
 	struct {
 		u32 legacy;
 		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
+		u16 vht_mcs[IEEE80211_VHT_NSS_MAX];
 	} control[IEEE80211_NUM_BANDS];
 };
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4d89492..5b7ed5d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1862,6 +1862,7 @@ enum nl80211_attrs {
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
+#define NL80211_MAX_SUPP_VHT_RATES		80
 #define NL80211_MAX_SUPP_REG_RULES		32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
@@ -3060,6 +3061,8 @@ enum nl80211_key_attributes {
  *	%NL80211_MAX_SUPP_RATES in a single array).
  * @NL80211_TXRATE_HT_MCS: HT (MCS) rates allowed for TX rate selection
  *	in an array of MCS numbers.
+ * @NL80211_TXRATE_VHT_MCS: VHT (MCS) rates allowed for TX rate selection
+ *	in an array of MCS numbers.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
@@ -3067,6 +3070,7 @@ enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
 	NL80211_TXRATE_HT_MCS,
+	NL80211_TXRATE_VHT_MCS,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ff65172..3ab794e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7293,11 +7293,74 @@ static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
 	return true;
 }
 
+static void vht_mcs_map_to_mcs_mask(u16 vht_mcs_map,
+				    u16 vht_mcs_mask[IEEE80211_VHT_NSS_MAX])
+{
+	u8 nss;
+
+	for (nss = 0; nss < IEEE80211_VHT_NSS_MAX; nss++) {
+		switch (vht_mcs_map & 0x03) {
+		case IEEE80211_VHT_MCS_NOT_SUPPORTED:
+			vht_mcs_mask[nss] = 0;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			vht_mcs_mask[nss] = 0x00FF;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			vht_mcs_mask[nss] = 0x01FF;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			vht_mcs_mask[nss] = 0x03FF;
+			break;
+		}
+
+		vht_mcs_map >>= 2;
+	}
+}
+
+static bool vht_rateset_to_mask(struct ieee80211_supported_band *sband,
+				u8 *rates, u8 rates_len,
+				u16 mcs[IEEE80211_VHT_NSS_MAX])
+{
+	u16 tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+	u16 tx_mcs_mask[IEEE80211_VHT_NSS_MAX] = {};
+	u8 i;
+
+	if (!sband->vht_cap.vht_supported)
+		return false;
+
+	memset(mcs, 0, sizeof(mcs));
+
+	/* Build vht_mcs_mask from VHT capabilities */
+	vht_mcs_map_to_mcs_mask(tx_mcs_map, tx_mcs_mask);
+
+	for (i = 0; i < rates_len; i++) {
+		int ridx, rbit;
+
+		ridx = rates[i] / 10;
+		rbit = BIT(rates[i] % 10);
+
+		/* check validity */
+		if ((ridx < 0) || (ridx >= IEEE80211_VHT_NSS_MAX))
+			return false;
+
+		/* check availability */
+		if (!(tx_mcs_mask[ridx] & rbit))
+			return false;
+
+		mcs[ridx] |= rbit;
+	}
+
+	return true;
+}
+
 static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
 				    .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_TXRATE_HT_MCS] = { .type = NLA_BINARY,
 				    .len = NL80211_MAX_SUPP_HT_RATES },
+	[NL80211_TXRATE_VHT_MCS] = { .type = NLA_BINARY,
+				     .len = NL80211_MAX_SUPP_VHT_RATES},
 };
 
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
@@ -7310,6 +7373,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
+	u16 vht_tx_mcs_map;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
@@ -7326,6 +7390,13 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		memcpy(mask.control[i].ht_mcs,
 		       sband->ht_cap.mcs.rx_mask,
 		       sizeof(mask.control[i].ht_mcs));
+
+		if (!sband->vht_cap.vht_supported)
+			continue;
+
+		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+		vht_mcs_map_to_mcs_mask(vht_tx_mcs_map,
+					mask.control[i].vht_mcs);
 	}
 
 	/* Back to default settings */
@@ -7364,20 +7435,32 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 					mask.control[band].ht_mcs))
 				return -EINVAL;
 		}
+		if (tb[NL80211_TXRATE_VHT_MCS]) {
+			if (!vht_rateset_to_mask(
+					sband,
+					nla_data(tb[NL80211_TXRATE_VHT_MCS]),
+					nla_len(tb[NL80211_TXRATE_VHT_MCS]),
+					mask.control[band].vht_mcs))
+				return -EINVAL;
+		}
 
 		if (mask.control[band].legacy == 0) {
-			/* don't allow empty legacy rates if HT
+			/* don't allow empty legacy rates if HT and VHT
 			 * is not even supported. */
-			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
+			if (!(rdev->wiphy.bands[band]->ht_cap.ht_supported ||
+			      rdev->wiphy.bands[band]->vht_cap.vht_supported))
 				return -EINVAL;
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
 				if (mask.control[band].ht_mcs[i])
-					break;
+					goto out;
+
+			for (i = 0; i < IEEE80211_VHT_NSS_MAX; i++)
+				if (mask.control[band].vht_mcs[i])
+					goto out;
 
 			/* legacy and mcs rates may not be both empty */
-			if (i == IEEE80211_HT_MCS_MASK_LEN)
-				return -EINVAL;
+			return -EINVAL;
 		}
 	}
 
-- 
1.7.9.5

