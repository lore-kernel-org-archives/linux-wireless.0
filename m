Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40561 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3LETnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 14:43:14 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so11403959eaj.7
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 11:43:13 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 3/3] nl80211: add VHT support for set_bitrate_mask
Date: Thu,  5 Dec 2013 20:42:58 +0100
Message-Id: <1386272578-3540-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_204330_089468_AE3096A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT MCS/NSS set support for nl80211_set_tx_bitrate_mask().
This should be used mainly for test purpose, to check
different MCS/NSS VHT combinations.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h       |    1 +
 include/uapi/linux/nl80211.h |   12 ++++++
 net/wireless/nl80211.c       |   92 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 626087b..d5bb243 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1764,6 +1764,7 @@ struct cfg80211_bitrate_mask {
 	struct {
 		u32 legacy;
 		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
+		u16 vht_mcs[NL80211_VHT_NSS_MAX];
 	} control[IEEE80211_NUM_BANDS];
 };
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 59d65e3..63c39bd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3060,6 +3060,8 @@ enum nl80211_key_attributes {
  *	%NL80211_MAX_SUPP_RATES in a single array).
  * @NL80211_TXRATE_HT: HT (MCS) rates allowed for TX rate selection
  *	in an array of MCS numbers.
+ * @NL80211_TXRATE_VHT: VHT rates allowed for TX rate selection,
+ *	see &struct nl80211_txrate_vht
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
@@ -3067,6 +3069,7 @@ enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
 	NL80211_TXRATE_HT,
+	NL80211_TXRATE_VHT,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
@@ -3074,6 +3077,15 @@ enum nl80211_tx_rate_attributes {
 };
 
 #define NL80211_TXRATE_MCS NL80211_TXRATE_HT
+#define NL80211_VHT_NSS_MAX		8
+
+/**
+ * struct nl80211_txrate_vht - VHT MCS/NSS txrate bitmap
+ * @mcs: MCS bitmap table for each NSS
+ */
+struct nl80211_txrate_vht {
+	__u16 mcs[NL80211_VHT_NSS_MAX];
+};
 
 /**
  * enum nl80211_band - Frequency band
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc43374..12d38c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7293,11 +7293,72 @@ static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
 	return true;
 }
 
+static u16 vht_mcs_map_to_mcs_mask(u8 vht_mcs_map)
+{
+	u16 mcs_mask = 0;
+
+	switch (vht_mcs_map) {
+	case IEEE80211_VHT_MCS_NOT_SUPPORTED:
+		break;
+	case IEEE80211_VHT_MCS_SUPPORT_0_7:
+		mcs_mask = 0x00FF;
+		break;
+	case IEEE80211_VHT_MCS_SUPPORT_0_8:
+		mcs_mask = 0x01FF;
+		break;
+	case IEEE80211_VHT_MCS_SUPPORT_0_9:
+		mcs_mask = 0x03FF;
+		break;
+	default:
+		break;
+	}
+
+	return mcs_mask;
+}
+
+static void vht_build_mcs_mask(u16 vht_mcs_map,
+			       u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+{
+	u8 nss;
+
+	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++) {
+		vht_mcs_mask[nss] = vht_mcs_map_to_mcs_mask(vht_mcs_map & 0x03);
+		vht_mcs_map >>= 2;
+	}
+}
+
+static bool vht_set_mcs_mask(struct ieee80211_supported_band *sband,
+			     struct nl80211_txrate_vht *txrate,
+			     u16 mcs[NL80211_VHT_NSS_MAX])
+{
+	u16 tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+	u16 tx_mcs_mask[NL80211_VHT_NSS_MAX] = {};
+	u8 i;
+
+	if (!sband->vht_cap.vht_supported)
+		return false;
+
+	memset(mcs, 0, sizeof(mcs));
+
+	/* Build vht_mcs_mask from VHT capabilities */
+	vht_build_mcs_mask(tx_mcs_map, tx_mcs_mask);
+
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		if ((tx_mcs_mask[i] & txrate->mcs[i]) == txrate->mcs[i])
+			mcs[i] = txrate->mcs[i];
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
 	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
 				.len = NL80211_MAX_SUPP_HT_RATES },
+	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
 };
 
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
@@ -7310,6 +7371,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
+	u16 vht_tx_mcs_map;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
@@ -7326,6 +7388,12 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		memcpy(mask.control[i].ht_mcs,
 		       sband->ht_cap.mcs.rx_mask,
 		       sizeof(mask.control[i].ht_mcs));
+
+		if (!sband->vht_cap.vht_supported)
+			continue;
+
+		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+		vht_build_mcs_mask(vht_tx_mcs_map, mask.control[i].vht_mcs);
 	}
 
 	/* Back to default settings */
@@ -7364,20 +7432,32 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 					mask.control[band].ht_mcs))
 				return -EINVAL;
 		}
+		if (tb[NL80211_TXRATE_VHT]) {
+			if (!vht_set_mcs_mask(
+					sband,
+					nla_data(tb[NL80211_TXRATE_VHT]),
+					mask.control[band].vht_mcs))
+				return -EINVAL;
+		}
 
 		if (mask.control[band].legacy == 0) {
-			/* don't allow empty legacy rates if HT
-			 * is not even supported. */
-			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
+			/* don't allow empty legacy rates if HT or VHT
+			 * are not even supported.
+			 */
+			if (!(rdev->wiphy.bands[band]->ht_cap.ht_supported ||
+			      rdev->wiphy.bands[band]->vht_cap.vht_supported))
 				return -EINVAL;
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
 				if (mask.control[band].ht_mcs[i])
-					break;
+					goto out;
+
+			for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
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

