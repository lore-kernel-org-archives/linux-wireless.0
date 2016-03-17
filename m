Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbcCQNlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:41:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/5] cfg80211: allow userspace to specify client P2P PS support
Date: Thu, 17 Mar 2016 15:41:38 +0200
Message-Id: <1458222099-30301-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_144152_169658_43CA5035)
In-Reply-To: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Legacy clients don't support P2P power save mechanisms, and thus
if a P2P GO has a legacy client connected to it, it has to make
some changes in the PS behavior.

To handle this, add an attribute to specify whether a station supports
P2P PS or not. If the attribute was not specified cfg80211 will assume
that station supports it for P2P GO interface, and does NOT support it
for AP interface, matching the current assumptions in the code.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 19 +++++++++++++++++++
 net/wireless/nl80211.c       | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3f49867..c7fa0b3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -816,6 +816,7 @@ enum station_parameters_apply_mask {
  * @supported_oper_classes_len: number of supported operating classes
  * @opmode_notif: operating mode field from Operating Mode Notification
  * @opmode_notif_used: information if operating mode field is used
+ * @support_p2p_ps: information if station supports P2P PS mechanism
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -841,6 +842,7 @@ struct station_parameters {
 	u8 supported_oper_classes_len;
 	u8 opmode_notif;
 	bool opmode_notif_used;
+	int support_p2p_ps;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 673328a..53dd160 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1807,6 +1807,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT: If set, the driver should not
  *	take action (e.g. disconnect) upon beacon loss besides sending an event.
  *
+ * @NL80211_ATTR_STA_SUPPORT_P2P_PS: whether P2P PS mechanism supported
+ *	or not. u8, one of the values of &enum nl80211_sta_p2p_ps_status
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2187,6 +2190,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT,
 
+	NL80211_ATTR_STA_SUPPORT_P2P_PS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2330,6 +2335,20 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_sta_p2p_ps_status - station support of P2P PS
+ *
+ * @NL80211_P2P_PS_UNSUPPORTED: station doesn't support P2P PS mechanism
+ * @@NL80211_P2P_PS_SUPPORTED: station supports P2P PS mechanism
+ * @NUM_NL80211_P2P_PS_STATUS: number of values
+ */
+enum nl80211_sta_p2p_ps_status {
+	NL80211_P2P_PS_UNSUPPORTED = 0,
+	NL80211_P2P_PS_SUPPORTED,
+
+	NUM_NL80211_P2P_PS_STATUS,
+};
+
 #define NL80211_STA_FLAG_MAX_OLD_API	NL80211_STA_FLAG_TDLS_PEER
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 749e315..f8022538 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -404,6 +404,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_PBSS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_BSS_SELECT] = { .type = NLA_NESTED },
 	[NL80211_ATTR_BEACON_LOSS_DO_NOT_DISCONNECT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STA_SUPPORT_P2P_PS] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -4007,6 +4008,10 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 	    statype != CFG80211_STA_AP_CLIENT_UNASSOC)
 		return -EINVAL;
 
+	if (params->support_p2p_ps != -1 &&
+	    statype != CFG80211_STA_AP_CLIENT_UNASSOC)
+		return -EINVAL;
+
 	if (params->aid &&
 	    !(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
 	    statype != CFG80211_STA_AP_CLIENT_UNASSOC)
@@ -4300,6 +4305,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	else
 		params.listen_interval = -1;
 
+	if (info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]) {
+		u8 tmp;
+
+		tmp = nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
+		if (tmp >= NUM_NL80211_P2P_PS_STATUS)
+			return -EINVAL;
+
+		params.support_p2p_ps = tmp;
+	} else {
+		params.support_p2p_ps = -1;
+	}
+
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
@@ -4423,6 +4440,23 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
+	if (info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]) {
+		u8 tmp;
+
+		tmp = nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
+		if (tmp >= NUM_NL80211_P2P_PS_STATUS)
+			return -EINVAL;
+
+		params.support_p2p_ps = tmp;
+	} else {
+		/*
+		 * if not specified, assume it's supported for P2P GO interface,
+		 * and is NOT supported for AP interface
+		 */
+		params.support_p2p_ps =
+			dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO;
+	}
+
 	if (info->attrs[NL80211_ATTR_PEER_AID])
 		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
 	else
-- 
2.5.0

