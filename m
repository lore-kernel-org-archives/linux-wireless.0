Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16277 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbcHEEfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 00:35:34 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <ganeshk@qti.qualcomm.com>,
	<mkalikot@qca.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Add support for user configurable beacon data rate
Date: Fri, 5 Aug 2016 10:05:01 +0530
Message-ID: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160805_063539_145131_AAF73DCA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow user to configure beacon tx rate (u8) from userspace.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h | 25 +++++++++++---------
 net/wireless/nl80211.c | 62 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..dd900de 100644
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
index 46417f9..53e7bf5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -36,6 +36,8 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info);
 static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			      struct genl_info *info);
+static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
+					 struct cfg80211_bitrate_mask *mask);
 
 /* the netlink family */
 static struct genl_family nl80211_fam = {
@@ -3457,6 +3459,11 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
 	if (err)
 		return err;
+	if (info->attrs[NL80211_ATTR_TX_RATES]) {
+		err = nl80211_parse_tx_bitrate_mask(info, &params.beacon_rate);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * In theory, some of these attributes should be required here
@@ -8696,22 +8703,17 @@ static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
 };
 
-static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
-				       struct genl_info *info)
+static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
+					 struct cfg80211_bitrate_mask *mask)
 {
 	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct cfg80211_bitrate_mask mask;
 	int rem, i;
-	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
 	u16 vht_tx_mcs_map;
 
-	if (!rdev->ops->set_bitrate_mask)
-		return -EOPNOTSUPP;
-
-	memset(&mask, 0, sizeof(mask));
+	memset(mask, 0, sizeof(*mask));
 	/* Default to all rates enabled */
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		sband = rdev->wiphy.bands[i];
@@ -8719,16 +8721,16 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		if (!sband)
 			continue;
 
-		mask.control[i].legacy = (1 << sband->n_bitrates) - 1;
-		memcpy(mask.control[i].ht_mcs,
+		mask->control[i].legacy = (1 << sband->n_bitrates) - 1;
+		memcpy(mask->control[i].ht_mcs,
 		       sband->ht_cap.mcs.rx_mask,
-		       sizeof(mask.control[i].ht_mcs));
+		       sizeof(mask->control[i].ht_mcs));
 
 		if (!sband->vht_cap.vht_supported)
 			continue;
 
 		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
-		vht_build_mcs_mask(vht_tx_mcs_map, mask.control[i].vht_mcs);
+		vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
 	}
 
 	/* if no rates are given set it back to the defaults */
@@ -8754,11 +8756,11 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		if (err)
 			return err;
 		if (tb[NL80211_TXRATE_LEGACY]) {
-			mask.control[band].legacy = rateset_to_mask(
+			mask->control[band].legacy = rateset_to_mask(
 				sband,
 				nla_data(tb[NL80211_TXRATE_LEGACY]),
 				nla_len(tb[NL80211_TXRATE_LEGACY]));
-			if ((mask.control[band].legacy == 0) &&
+			if ((mask->control[band].legacy == 0) &&
 			    nla_len(tb[NL80211_TXRATE_LEGACY]))
 				return -EINVAL;
 		}
@@ -8767,24 +8769,24 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 					sband,
 					nla_data(tb[NL80211_TXRATE_HT]),
 					nla_len(tb[NL80211_TXRATE_HT]),
-					mask.control[band].ht_mcs))
+					mask->control[band].ht_mcs))
 				return -EINVAL;
 		}
 		if (tb[NL80211_TXRATE_VHT]) {
 			if (!vht_set_mcs_mask(
 					sband,
 					nla_data(tb[NL80211_TXRATE_VHT]),
-					mask.control[band].vht_mcs))
+					mask->control[band].vht_mcs))
 				return -EINVAL;
 		}
 		if (tb[NL80211_TXRATE_GI]) {
-			mask.control[band].gi =
+			mask->control[band].gi =
 				nla_get_u8(tb[NL80211_TXRATE_GI]);
-			if (mask.control[band].gi > NL80211_TXRATE_FORCE_LGI)
+			if (mask->control[band].gi > NL80211_TXRATE_FORCE_LGI)
 				return -EINVAL;
 		}
 
-		if (mask.control[band].legacy == 0) {
+		if (mask->control[band].legacy == 0) {
 			/* don't allow empty legacy rates if HT or VHT
 			 * are not even supported.
 			 */
@@ -8793,11 +8795,11 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 				return -EINVAL;
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-				if (mask.control[band].ht_mcs[i])
+				if (mask->control[band].ht_mcs[i])
 					goto out;
 
 			for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
-				if (mask.control[band].vht_mcs[i])
+				if (mask->control[band].vht_mcs[i])
 					goto out;
 
 			/* legacy and mcs rates may not be both empty */
@@ -8806,6 +8808,24 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	}
 
 out:
+	return 0;
+}
+
+static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_bitrate_mask mask;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	int err;
+
+	if (!rdev->ops->set_bitrate_mask)
+		return -EOPNOTSUPP;
+
+	err = nl80211_parse_tx_bitrate_mask(info, &mask);
+	if (err)
+		return err;
+
 	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
 }
 
-- 
1.9.1

