Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53607 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbcAMJty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:49:54 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC V2 1/3] nl80211: add extended feature for BSS selection support
Date: Wed, 13 Jan 2016 10:49:41 +0100
Message-ID: <1452678583-20086-2-git-send-email-arend@broadcom.com> (sfid-20160113_105004_186990_C1714232)
In-Reply-To: <1452678583-20086-1-git-send-email-arend@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introducing a new extended feature that the driver can use to
indicate the driver/firmware supports configuration of BSS
selection criteria upon CONNECT command. This can be useful
when multiple BSS-es are found belonging to the same ESS,
ie. Infra-BSS with same SSID. The criteria can then be used to
offload selection of a preferred BSS.

This patch adds the nested NL80211_ATTR_BSS_SELECT attribute
in NL80211_CMD_GET_WIPHY indicating supported selection criteria.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
V2:
 - added NL80211_ATTR_BSS_SELECT for NL80211_CMD_GET_WIPHY.
 - still adds extended feature although it is redundant now.
---
 include/net/cfg80211.h       |  5 +++++
 include/uapi/linux/nl80211.h | 26 ++++++++++++++++++++++++++
 net/wireless/core.c          |  5 +++++
 net/wireless/nl80211.c       | 20 ++++++++++++++++++++
 4 files changed, 56 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7..34c4929 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3178,6 +3178,9 @@ struct wiphy_vendor_command {
  *	low rssi when a frame is heard on different channel, then it should set
  *	this variable to the maximal offset for which it can compensate.
  *	This value should be set in MHz.
+ * @bss_select_support: bitmask indicating the BSS selection criteria supported
+ *	by the driver in the .connect() callback. The bit position maps to the
+ *	criteria defined in &enum nl80211_bss_select_primitive.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3300,6 +3303,8 @@ struct wiphy {
 	u8 max_num_csa_counters;
 	u8 max_adj_channel_rssi_comp;
 
+	u32 bss_select_support;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7b5eb..a5baf93 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1789,6 +1789,11 @@ enum nl80211_commands {
  *	thus it must not specify the number of iterations, only the interval
  *	between scans. The scan plans are executed sequentially.
  *	Each scan plan is a nested attribute of &enum nl80211_sched_scan_plan.
+ * @NL80211_ATTR_BSS_SELECT: nested attribute for driver supporting the
+ *	extended feature %NL80211_EXT_FEATURE_BSS_SELECT. When used with
+ *	%NL80211_CMD_GET_WIPHY is contains NLA_FLAG type according
+ *	&enum nl80211_bss_select_primitive to indicate what primitives are
+ *	supported.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2164,6 +2169,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
+	NL80211_ATTR_BSS_SELECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4396,12 +4403,15 @@ enum nl80211_feature_flags {
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
  * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
+ * @NL80211_EXT_FEATURE_BSS_SELECT: This driver supports BSS selection criteria
+ *	to be given upon %NL80211_CMD_CONNECT.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
+	NL80211_EXT_FEATURE_BSS_SELECT,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -4651,4 +4661,20 @@ enum nl80211_sched_scan_plan {
 		__NL80211_SCHED_SCAN_PLAN_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_bss_select_primitive - primitives for bss selection.
+ *
+ * @NL80211_BSS_SELECT_RSSI:
+ * @NL80211_BSS_SELECT_BAND_PREF:
+ * @NL80211_BSS_SELECT_ADJUST_RSSI:
+ * @NUM_NL80211_BSS_SELECT: Must be kept last.
+ */
+enum nl80211_bss_select_primitive {
+	NL80211_BSS_SELECT_RSSI,
+	NL80211_BSS_SELECT_BAND_PREF,
+	NL80211_BSS_SELECT_ADJUST_RSSI,
+	/* add other primitives before this one */
+	NUM_NL80211_BSS_SELECT
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3a9c41b..73ab509 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -626,6 +626,11 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->set_mac_acl)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy_ext_feature_isset(wiphy,
+					    NL80211_EXT_FEATURE_BSS_SELECT) &&
+		    !wiphy->bss_select_support))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72de698..7a51de0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1730,6 +1730,26 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			    rdev->wiphy.ext_features))
 			goto nla_put_failure;
 
+		if (wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_BSS_SELECT) &&
+		    rdev->wiphy.bss_select_support) {
+			struct nlattr *nested;
+			u32 bss_select_support = rdev->wiphy.bss_select_support;
+
+			nested = nla_nest_start(msg, NL80211_ATTR_BSS_SELECT);
+			if (!nested)
+				goto nla_put_failure;
+
+			i = 0;
+			while (bss_select_support) {
+				if ((bss_select_support & 1) &&
+				    nla_put_flag(msg, i))
+					goto nla_put_failure;
+				i++;
+				bss_select_support >>= 1;
+			}
+			nla_nest_end(msg, nested);
+		}
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.9.1

