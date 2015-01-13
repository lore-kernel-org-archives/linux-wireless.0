Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:61046 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbAMIgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 03:36:20 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so1478983wes.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 00:36:19 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 1/2] cfg80211: add VHT support for IBSS
Date: Tue, 13 Jan 2015 09:35:23 +0100
Message-Id: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150113_093624_121952_337A7AF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT support for IBSS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h       | 17 +++++++++++++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 34 ++++++++++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1977357..d16ce05 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1712,6 +1712,17 @@ struct cfg80211_disassoc_request {
 };
 
 /**
+ * enum cfg80211_ibss_params_flags - Over-ride default IBSS behaviour.
+ *
+ * @IBSS_PARAMS_DISABLE_HT:  Disable HT (802.11n)
+ * @IBSS_PARAMS_DISABLE_VHT:  Disable VHT
+ */
+enum cfg80211_ibss_params_flags {
+	IBSS_PARAMS_DISABLE_HT	= BIT(0),
+	IBSS_PARAMS_DISABLE_VHT	= BIT(1),
+};
+
+/**
  * struct cfg80211_ibss_params - IBSS parameters
  *
  * This structure defines the IBSS parameters for the join_ibss()
@@ -1738,9 +1749,12 @@ struct cfg80211_disassoc_request {
  *	to operate on DFS channels.
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
+ * @flags See &enum cfg80211_ibss_params_flags
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *	will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
+ * @vht_capa:  VHT Capability overrides
+ * @vht_capa_mask: The bits of vht_capa which are to be used.
  */
 struct cfg80211_ibss_params {
 	const u8 *ssid;
@@ -1755,8 +1769,11 @@ struct cfg80211_ibss_params {
 	bool control_port;
 	bool userspace_handles_dfs;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 flags;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
+	struct ieee80211_vht_cap vht_capa;
+	struct ieee80211_vht_cap vht_capa_mask;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a963d48..d78030fe 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4306,11 +4306,13 @@ enum nl80211_feature_flags {
 
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
+ * @NL80211_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
+	NL80211_FEATURE_VHT_IBSS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7c2ce26..15f638a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7235,8 +7235,18 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		break;
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
-		if (rdev->wiphy.features & NL80211_FEATURE_HT_IBSS)
-			break;
+		if (!(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+			return -EINVAL;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		if (!(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+			return -EINVAL;
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_FEATURE_VHT_IBSS))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -7258,6 +7268,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
+		ibss.flags |= IBSS_PARAMS_DISABLE_HT;
+
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
 		memcpy(&ibss.ht_capa_mask,
 		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]),
@@ -7271,6 +7284,23 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(ibss.ht_capa));
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_VHT]))
+		ibss.flags |= IBSS_PARAMS_DISABLE_VHT;
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
+		memcpy(&ibss.vht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]),
+		       sizeof(ibss.vht_capa_mask));
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
+		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
+			return -EINVAL;
+		memcpy(&ibss.vht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]),
+		       sizeof(ibss.vht_capa));
+	}
+
+
 	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
 	    !nl80211_parse_mcast_rate(rdev, ibss.mcast_rate,
 			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
-- 
1.9.1

