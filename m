Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17982 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760440AbcINMJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 08:09:21 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH v5] cfg80211: Add support to configure a beacon data rate
Date: Wed, 14 Sep 2016 17:38:44 +0530
Message-ID: <1473854924-10352-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160914_140926_442265_C4ABED3B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows an option to configure a single beacon tx rate (u8) for an AP.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h |  25 +--
 net/wireless/nl80211.c | 509 ++++++++++++++++++++++++++++---------------------
 2 files changed, 301 insertions(+), 233 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e7f69..c58afc8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -676,6 +676,18 @@ struct cfg80211_acl_data {
 	struct mac_address mac_addrs[];
 };
 
+/*
+ * cfg80211_bitrate_mask - masks for bitrate control
+ */
+struct cfg80211_bitrate_mask {
+	struct {
+		u32 legacy;
+		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
+		u16 vht_mcs[NL80211_VHT_NSS_MAX];
+		enum nl80211_txrate_gi gi;
+	} control[NUM_NL80211_BANDS];
+};
+
 /**
  * struct cfg80211_ap_settings - AP configuration
  *
@@ -700,6 +712,7 @@ struct cfg80211_acl_data {
  *	MAC address based access control
  * @pbss: If set, start as a PCP instead of AP. Relevant for DMG
  *	networks.
+ * @beacon_rate: masks for setting user configured beacon tx rate.
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -719,6 +732,7 @@ struct cfg80211_ap_settings {
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
 	bool pbss;
+	struct cfg80211_bitrate_mask beacon_rate;
 };
 
 /**
@@ -2001,17 +2015,6 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_DYN_ACK		= 1 << 5,
 };
 
-/*
- * cfg80211_bitrate_mask - masks for bitrate control
- */
-struct cfg80211_bitrate_mask {
-	struct {
-		u32 legacy;
-		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
-		u16 vht_mcs[NL80211_VHT_NSS_MAX];
-		enum nl80211_txrate_gi gi;
-	} control[NUM_NL80211_BANDS];
-};
 /**
  * struct cfg80211_pmksa - PMK Security Association
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ebad35..b533bd8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3324,6 +3324,279 @@ static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
+			   u8 *rates, u8 rates_len)
+{
+	u8 i;
+	u32 mask = 0;
+
+	for (i = 0; i < rates_len; i++) {
+		int rate = (rates[i] & 0x7f) * 5;
+		int ridx;
+
+		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
+			struct ieee80211_rate *srate =
+				&sband->bitrates[ridx];
+			if (rate == srate->bitrate) {
+				mask |= 1 << ridx;
+				break;
+			}
+		}
+		if (ridx == sband->n_bitrates)
+			return 0; /* rate not found */
+	}
+
+	return mask;
+}
+
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
+		if ((ridx < 0) || (ridx >= IEEE80211_HT_MCS_MASK_LEN))
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
+	memset(mcs, 0, sizeof(u16) * NL80211_VHT_NSS_MAX);
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
+static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
+	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
+				    .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
+				.len = NL80211_MAX_SUPP_HT_RATES },
+	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
+	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
+};
+
+static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
+					 struct cfg80211_bitrate_mask *mask)
+{
+	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int rem, i;
+	struct nlattr *tx_rates;
+	struct ieee80211_supported_band *sband;
+	u16 vht_tx_mcs_map;
+
+	memset(mask, 0, sizeof(*mask));
+	/* Default to all rates enabled */
+	for (i = 0; i < NUM_NL80211_BANDS; i++) {
+		sband = rdev->wiphy.bands[i];
+
+		if (!sband)
+			continue;
+
+		mask->control[i].legacy = (1 << sband->n_bitrates) - 1;
+		memcpy(mask->control[i].ht_mcs,
+		       sband->ht_cap.mcs.rx_mask,
+		       sizeof(mask->control[i].ht_mcs));
+
+		if (!sband->vht_cap.vht_supported)
+			continue;
+
+		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+		vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
+	}
+
+	/* if no rates are given set it back to the defaults */
+	if (!info->attrs[NL80211_ATTR_TX_RATES])
+		goto out;
+
+	/* The nested attribute uses enum nl80211_band as the index. This maps
+	 * directly to the enum nl80211_band values used in cfg80211.
+	 */
+	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
+	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem) {
+		enum nl80211_band band = nla_type(tx_rates);
+		int err;
+
+		if (band < 0 || band >= NUM_NL80211_BANDS)
+			return -EINVAL;
+		sband = rdev->wiphy.bands[band];
+		if (sband == NULL)
+			return -EINVAL;
+		err = nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
+				nla_len(tx_rates), nl80211_txattr_policy);
+		if (err)
+			return err;
+		if (tb[NL80211_TXRATE_LEGACY]) {
+			mask->control[band].legacy = rateset_to_mask(
+				sband,
+				nla_data(tb[NL80211_TXRATE_LEGACY]),
+				nla_len(tb[NL80211_TXRATE_LEGACY]));
+			if ((mask->control[band].legacy == 0) &&
+			    nla_len(tb[NL80211_TXRATE_LEGACY]))
+				return -EINVAL;
+		}
+		if (tb[NL80211_TXRATE_HT]) {
+			if (!ht_rateset_to_mask(
+					sband,
+					nla_data(tb[NL80211_TXRATE_HT]),
+					nla_len(tb[NL80211_TXRATE_HT]),
+					mask->control[band].ht_mcs))
+				return -EINVAL;
+		}
+		if (tb[NL80211_TXRATE_VHT]) {
+			if (!vht_set_mcs_mask(
+					sband,
+					nla_data(tb[NL80211_TXRATE_VHT]),
+					mask->control[band].vht_mcs))
+				return -EINVAL;
+		}
+		if (tb[NL80211_TXRATE_GI]) {
+			mask->control[band].gi =
+				nla_get_u8(tb[NL80211_TXRATE_GI]);
+			if (mask->control[band].gi > NL80211_TXRATE_FORCE_LGI)
+				return -EINVAL;
+		}
+
+		if (mask->control[band].legacy == 0) {
+			/* don't allow empty legacy rates if HT or VHT
+			 * are not even supported.
+			 */
+			if (!(rdev->wiphy.bands[band]->ht_cap.ht_supported ||
+			      rdev->wiphy.bands[band]->vht_cap.vht_supported))
+				return -EINVAL;
+
+			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+				if (mask->control[band].ht_mcs[i])
+					goto out;
+
+			for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+				if (mask->control[band].vht_mcs[i])
+					goto out;
+
+			/* legacy and mcs rates may not be both empty */
+			return -EINVAL;
+		}
+	}
+
+out:
+	return 0;
+}
+
+static int validate_beacon_tx_rate(struct cfg80211_ap_settings *params)
+{
+	u32 rate, count_ht, count_vht, i;
+	enum nl80211_band band;
+
+	band = params->chandef.chan->band;
+	rate = params->beacon_rate.control[band].legacy;
+
+	/* Allow only one rate */
+	if (hweight32(rate) > 1)
+		return -EINVAL;
+
+	count_ht = 0;
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+		if (hweight8(params->beacon_rate.control[band].ht_mcs[i]) > 1) {
+			return -EINVAL;
+		} else if (hweight8(params->beacon_rate.control[band].ht_mcs[i])) {
+			count_ht++;
+			if (count_ht > 1)
+				return -EINVAL;
+		}
+		if (count_ht && rate)
+			return -EINVAL;
+	}
+
+	count_vht = 0;
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		if (hweight16(params->beacon_rate.control[band].vht_mcs[i]) > 1) {
+			return -EINVAL;
+		} else if (hweight16(params->beacon_rate.control[band].vht_mcs[i])) {
+			count_vht++;
+			if (count_vht > 1)
+				return -EINVAL;
+		}
+		if (count_vht && rate)
+			return -EINVAL;
+	}
+
+	if ((count_ht && count_vht) || (!rate && !count_ht && !count_vht))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nl80211_parse_beacon(struct nlattr *attrs[],
 				struct cfg80211_beacon_data *bcn)
 {
@@ -3553,6 +3826,15 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					   wdev->iftype))
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_TX_RATES]) {
+		err = nl80211_parse_tx_bitrate_mask(info, &params.beacon_rate);
+		if (err)
+			return err;
+
+		if (validate_beacon_tx_rate(&params))
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_SMPS_MODE]) {
 		params.smps_mode =
 			nla_get_u8(info->attrs[NL80211_ATTR_SMPS_MODE]);
@@ -8623,238 +8905,21 @@ static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 	return rdev_cancel_remain_on_channel(rdev, wdev, cookie);
 }
 
-static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
-			   u8 *rates, u8 rates_len)
-{
-	u8 i;
-	u32 mask = 0;
-
-	for (i = 0; i < rates_len; i++) {
-		int rate = (rates[i] & 0x7f) * 5;
-		int ridx;
-
-		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
-			struct ieee80211_rate *srate =
-				&sband->bitrates[ridx];
-			if (rate == srate->bitrate) {
-				mask |= 1 << ridx;
-				break;
-			}
-		}
-		if (ridx == sband->n_bitrates)
-			return 0; /* rate not found */
-	}
-
-	return mask;
-}
-
-static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
-			       u8 *rates, u8 rates_len,
-			       u8 mcs[IEEE80211_HT_MCS_MASK_LEN])
-{
-	u8 i;
-
-	memset(mcs, 0, IEEE80211_HT_MCS_MASK_LEN);
-
-	for (i = 0; i < rates_len; i++) {
-		int ridx, rbit;
-
-		ridx = rates[i] / 8;
-		rbit = BIT(rates[i] % 8);
-
-		/* check validity */
-		if ((ridx < 0) || (ridx >= IEEE80211_HT_MCS_MASK_LEN))
-			return false;
-
-		/* check availability */
-		if (sband->ht_cap.mcs.rx_mask[ridx] & rbit)
-			mcs[ridx] |= rbit;
-		else
-			return false;
-	}
-
-	return true;
-}
-
-static u16 vht_mcs_map_to_mcs_mask(u8 vht_mcs_map)
-{
-	u16 mcs_mask = 0;
-
-	switch (vht_mcs_map) {
-	case IEEE80211_VHT_MCS_NOT_SUPPORTED:
-		break;
-	case IEEE80211_VHT_MCS_SUPPORT_0_7:
-		mcs_mask = 0x00FF;
-		break;
-	case IEEE80211_VHT_MCS_SUPPORT_0_8:
-		mcs_mask = 0x01FF;
-		break;
-	case IEEE80211_VHT_MCS_SUPPORT_0_9:
-		mcs_mask = 0x03FF;
-		break;
-	default:
-		break;
-	}
-
-	return mcs_mask;
-}
-
-static void vht_build_mcs_mask(u16 vht_mcs_map,
-			       u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
-{
-	u8 nss;
-
-	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++) {
-		vht_mcs_mask[nss] = vht_mcs_map_to_mcs_mask(vht_mcs_map & 0x03);
-		vht_mcs_map >>= 2;
-	}
-}
-
-static bool vht_set_mcs_mask(struct ieee80211_supported_band *sband,
-			     struct nl80211_txrate_vht *txrate,
-			     u16 mcs[NL80211_VHT_NSS_MAX])
-{
-	u16 tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
-	u16 tx_mcs_mask[NL80211_VHT_NSS_MAX] = {};
-	u8 i;
-
-	if (!sband->vht_cap.vht_supported)
-		return false;
-
-	memset(mcs, 0, sizeof(u16) * NL80211_VHT_NSS_MAX);
-
-	/* Build vht_mcs_mask from VHT capabilities */
-	vht_build_mcs_mask(tx_mcs_map, tx_mcs_mask);
-
-	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
-		if ((tx_mcs_mask[i] & txrate->mcs[i]) == txrate->mcs[i])
-			mcs[i] = txrate->mcs[i];
-		else
-			return false;
-	}
-
-	return true;
-}
-
-static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
-	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
-				    .len = NL80211_MAX_SUPP_RATES },
-	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
-				.len = NL80211_MAX_SUPP_HT_RATES },
-	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
-	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
-};
-
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct cfg80211_bitrate_mask mask;
-	int rem, i;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct nlattr *tx_rates;
-	struct ieee80211_supported_band *sband;
-	u16 vht_tx_mcs_map;
+	int err;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
-	memset(&mask, 0, sizeof(mask));
-	/* Default to all rates enabled */
-	for (i = 0; i < NUM_NL80211_BANDS; i++) {
-		sband = rdev->wiphy.bands[i];
-
-		if (!sband)
-			continue;
-
-		mask.control[i].legacy = (1 << sband->n_bitrates) - 1;
-		memcpy(mask.control[i].ht_mcs,
-		       sband->ht_cap.mcs.rx_mask,
-		       sizeof(mask.control[i].ht_mcs));
-
-		if (!sband->vht_cap.vht_supported)
-			continue;
-
-		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
-		vht_build_mcs_mask(vht_tx_mcs_map, mask.control[i].vht_mcs);
-	}
-
-	/* if no rates are given set it back to the defaults */
-	if (!info->attrs[NL80211_ATTR_TX_RATES])
-		goto out;
-
-	/*
-	 * The nested attribute uses enum nl80211_band as the index. This maps
-	 * directly to the enum nl80211_band values used in cfg80211.
-	 */
-	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
-	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem) {
-		enum nl80211_band band = nla_type(tx_rates);
-		int err;
-
-		if (band < 0 || band >= NUM_NL80211_BANDS)
-			return -EINVAL;
-		sband = rdev->wiphy.bands[band];
-		if (sband == NULL)
-			return -EINVAL;
-		err = nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
-				nla_len(tx_rates), nl80211_txattr_policy);
-		if (err)
-			return err;
-		if (tb[NL80211_TXRATE_LEGACY]) {
-			mask.control[band].legacy = rateset_to_mask(
-				sband,
-				nla_data(tb[NL80211_TXRATE_LEGACY]),
-				nla_len(tb[NL80211_TXRATE_LEGACY]));
-			if ((mask.control[band].legacy == 0) &&
-			    nla_len(tb[NL80211_TXRATE_LEGACY]))
-				return -EINVAL;
-		}
-		if (tb[NL80211_TXRATE_HT]) {
-			if (!ht_rateset_to_mask(
-					sband,
-					nla_data(tb[NL80211_TXRATE_HT]),
-					nla_len(tb[NL80211_TXRATE_HT]),
-					mask.control[band].ht_mcs))
-				return -EINVAL;
-		}
-		if (tb[NL80211_TXRATE_VHT]) {
-			if (!vht_set_mcs_mask(
-					sband,
-					nla_data(tb[NL80211_TXRATE_VHT]),
-					mask.control[band].vht_mcs))
-				return -EINVAL;
-		}
-		if (tb[NL80211_TXRATE_GI]) {
-			mask.control[band].gi =
-				nla_get_u8(tb[NL80211_TXRATE_GI]);
-			if (mask.control[band].gi > NL80211_TXRATE_FORCE_LGI)
-				return -EINVAL;
-		}
-
-		if (mask.control[band].legacy == 0) {
-			/* don't allow empty legacy rates if HT or VHT
-			 * are not even supported.
-			 */
-			if (!(rdev->wiphy.bands[band]->ht_cap.ht_supported ||
-			      rdev->wiphy.bands[band]->vht_cap.vht_supported))
-				return -EINVAL;
-
-			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-				if (mask.control[band].ht_mcs[i])
-					goto out;
-
-			for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
-				if (mask.control[band].vht_mcs[i])
-					goto out;
-
-			/* legacy and mcs rates may not be both empty */
-			return -EINVAL;
-		}
-	}
+	err = nl80211_parse_tx_bitrate_mask(info, &mask);
+	if (err)
+		return err;
 
-out:
 	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
 }
 
-- 
1.9.1
