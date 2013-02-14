Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38276 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNTKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:10:19 -0500
Date: Thu, 14 Feb 2013 21:10:13 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Pass station (extended) capability info to
 kernel
Message-ID: <20130214191013.GA28969@jouni.qca.qualcomm.com> (sfid-20130214_201023_971750_ABC1B732)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information of the peer's capabilities and extended capabilities are
required for the driver to perform TDLS Peer UAPSD operations and off
channel operations. This information of the peer is passed from user space
using NL80211_CMD_SET_STATION command. This commit enhances
the function nl80211_set_station to pass the capability information of
the peer to the driver.

Similarly, there may be need for capability information for other modes,
so allow this to be provided with both add_station and change_station.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |    8 ++++++++
 include/uapi/linux/nl80211.h |   10 ++++++++++
 net/wireless/nl80211.c       |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 77686ca..f7e51f3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -603,12 +603,14 @@ enum plink_actions {
 /**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
+ * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
  *
  * Not all station parameters have in-band "no change" signalling,
  * for those that don't these flags will are used.
  */
 enum station_parameters_apply_mask {
 	STATION_PARAM_APPLY_UAPSD = BIT(0),
+	STATION_PARAM_APPLY_CAPABILITY = BIT(1),
 };
 
 /**
@@ -639,6 +641,9 @@ enum station_parameters_apply_mask {
  *	see &enum station_parameters_apply_mask
  * @local_pm: local link-specific mesh power save mode (no change when set
  *	to unknown)
+ * @capability: station capability
+ * @ext_capab: extended capabilities of the station
+ * @ext_capab_len: number of extended capabilities
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -655,6 +660,9 @@ struct station_parameters {
 	u8 uapsd_queues;
 	u8 max_sp;
 	enum nl80211_mesh_power_mode local_pm;
+	u16 capability;
+	u8 *ext_capab;
+	u8 ext_capab_len;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a2ecdc..1a1171d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1342,6 +1342,13 @@ enum nl80211_commands {
  *	number of MAC addresses that a device can support for MAC
  *	ACL.
  *
+ * @NL80211_ATTR_STA_CAPABILITY: Station capabilities (u16) are advertised to
+ *	the driver, e.g., to enable TDLS power save (PU-APSD).
+ *
+ * @NL80211_ATTR_STA_EXT_CAPABILITY: Station extended capabilities are
+ *	advertised to the driver, e.g., to enable TDLS off channel operations
+ *	and PU-APSD.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1620,6 +1627,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_ACL_MAX,
 
+	NL80211_ATTR_STA_CAPABILITY,
+	NL80211_ATTR_STA_EXT_CAPABILITY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 93bc63e..1216573 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -367,6 +367,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
 	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U32 },
 	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_STA_CAPABILITY] = { .type = NLA_U16 },
+	[NL80211_ATTR_STA_EXT_CAPABILITY] = { .type = NLA_BINARY, },
 };
 
 /* policy for the key attributes */
@@ -3328,6 +3330,19 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_CAPABILITY]) {
+		params.capability =
+			nla_get_u16(info->attrs[NL80211_ATTR_STA_CAPABILITY]);
+		params.sta_modify_mask |= STATION_PARAM_APPLY_CAPABILITY;
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]) {
+		params.ext_capab =
+			nla_data(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
+		params.ext_capab_len =
+			nla_len(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
+	}
+
 	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL] ||
 	    info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		return -EINVAL;
@@ -3398,6 +3413,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* reject other things that can't change */
 		if (params.supported_rates)
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_STA_CAPABILITY])
+			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
+			return -EINVAL;
 
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
@@ -3430,6 +3449,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.supported_rates)
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_STA_CAPABILITY])
+			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
+			return -EINVAL;
 		/*
 		 * No special handling for TDLS here -- the userspace
 		 * mesh code doesn't have this bug.
@@ -3494,6 +3517,19 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (!params.aid || params.aid > IEEE80211_MAX_AID)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_STA_CAPABILITY]) {
+		params.capability =
+			nla_get_u16(info->attrs[NL80211_ATTR_STA_CAPABILITY]);
+		params.sta_modify_mask |= STATION_PARAM_APPLY_CAPABILITY;
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]) {
+		params.ext_capab =
+			nla_data(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
+		params.ext_capab_len =
+			nla_len(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
+	}
+
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
