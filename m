Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32896 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbcGEMXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Aviya Erenfeld <aviya.erenfeld@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:08 +0300
Message-Id: <1467721394-8195-2-git-send-email-luca@coelho.fi> (sfid-20160705_142326_800420_23B07FCE)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 1/7] nl80211: Add API to support VHT MU-MIMO air sniffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

add API to support VHT MU-MIMO air sniffer.
in MU-MIMO there are parallel frames on the air while the HW
has only one RX.
add the capability to sniff one of the MU-MIMO parallel frames by
giving the sniffer additional information so it'll know which
of the parallel frames it shall follow.

Add attribute - NL80211_ATTR_MU_MIMO_GROUP_DATA - for getting
a MU-MIMO groupID in order to monitor packets from that group
using VHT MU-MIMO.
And add attribute -NL80211_ATTR_MU_MIMO_FOLLOW_ADDR - for passing
MAC address to monitor mode.
that option will be used by VHT MU-MIMO air sniffer to follow a
station according to it's MAC address using VHT MU-MIMO.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 10 ++++++++--
 include/uapi/linux/nl80211.h | 29 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7bbb00d..fa4f0f7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -330,6 +330,9 @@ struct ieee80211_supported_band {
  * in a separate chapter.
  */
 
+#define VHT_MUMIMO_GROUPS_DATA_LEN (WLAN_MEMBERSHIP_LEN +\
+				    WLAN_USER_POSITION_LEN)
+
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
@@ -339,10 +342,13 @@ struct ieee80211_supported_band {
  *	This feature is only fully supported by drivers that enable the
  *	%NL80211_FEATURE_MAC_ON_CREATE flag.  Others may support creating
  **	only p2p devices with specified MAC.
+ * @vht_mumimo_groups: MU-MIMO groupID. used for monitoring only
+ *	 packets belonging to that MU-MIMO groupID.
  */
 struct vif_params {
-       int use_4addr;
-       u8 macaddr[ETH_ALEN];
+	int use_4addr;
+	u8 macaddr[ETH_ALEN];
+	u8 vht_mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN];
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 53c8278..1d7da78 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1829,6 +1829,25 @@ enum nl80211_commands {
  *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
  *	interface type.
  *
+ * @NL80211_ATTR_MU_MIMO_GROUP_DATA: array of 24 bytes that defines a MU-MIMO
+ *	groupID for monitor mode.
+ *	The first 8 bytes are a mask that defines the membership in each
+ *	group (there are 64 groups, group 0 and 63 are reserved),
+ *	each bit represents a group and set to 1 for being a member in
+ *	that group and 0 for not being a member.
+ *	The remaining 16 bytes define the position in each group: 2 bits for
+ *	each group.
+ *	(smaller group numbers represented on most significant bits and bigger
+ *	group numbers on least significant bits.)
+ *	This attribute is used only if all interfaces are in monitor mode.
+ *	Set this attribute in order to monitor packets using the given MU-MIMO
+ *	groupID data.
+ *	to turn off that feature set all the bits of the groupID to zero.
+ * @NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR: mac address for the sniffer to follow
+ *	when using MU-MIMO air sniffer.
+ *	to turn that feature off set an invalid mac address
+ *	(e.g. FF:FF:FF:FF:FF:FF)
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2213,6 +2232,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_IFTYPE_EXT_CAPA,
 
+	NL80211_ATTR_MU_MIMO_GROUP_DATA,
+	NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4479,6 +4501,12 @@ enum nl80211_feature_flags {
  *	%NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests, which will set
  *	the ASSOC_REQ_USE_RRM flag in the association request even if
  *	NL80211_FEATURE_QUIET is not advertized.
+ * @NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER: This device supports MU-MIMO air
+ *	sniffer which means that it can be configured to hear packets from
+ *	certain groups which can be configured by the
+ *	%NL80211_ATTR_MU_MIMO_GROUP_DATA attribute,
+ *	or can be configured to follow a station by configuring the
+ *	%NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR attribute.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4486,6 +4514,7 @@ enum nl80211_feature_flags {
 enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
 	NL80211_EXT_FEATURE_RRM,
+	NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 244d552..447026f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_PBSS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_BSS_SELECT] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_SUPPORT_P2P_PS] = { .type = NLA_U8 },
+	[NL80211_ATTR_MU_MIMO_GROUP_DATA] = {
+		.len = VHT_MUMIMO_GROUPS_DATA_LEN
+	},
+	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
 };
 
 /* policy for the key attributes */
@@ -2695,6 +2699,38 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
+	if (info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]) {
+		const u8 *mumimo_groups;
+		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
+			return -EOPNOTSUPP;
+
+		mumimo_groups =
+			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]);
+
+		/* bits 0 and 63 are reserved and must be zero */
+		if ((mumimo_groups[0] & BIT(7)) ||
+		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(0)))
+			return -EINVAL;
+
+		memcpy(params.vht_mumimo_groups, mumimo_groups,
+		       VHT_MUMIMO_GROUPS_DATA_LEN);
+		change = true;
+	}
+
+	if (info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]) {
+		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
+			return -EOPNOTSUPP;
+
+		nla_memcpy(params.macaddr,
+			   info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR],
+			   ETH_ALEN);
+		change = true;
+	}
+
 	if (flags && (*flags & MONITOR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
-- 
2.8.1

