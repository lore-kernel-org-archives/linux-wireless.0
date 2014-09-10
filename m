Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaIJLLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:11:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] cfg80211: allow requesting SMPS mode on ap start
Date: Wed, 10 Sep 2014 14:07:34 +0300
Message-Id: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_131120_293424_C0247857)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add feature bits to indicate device support for
static-smps and dynamic-smps modes.

Add a new NL80211_ATTR_SMPS_MODE attribue to allow
configuring the smps mode to be used by the ap
(e.g. configuring to ap to dynamic smps mode will
reduce power consumption while having minor effect
on throughput)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
WARNING: this will probably conflict with other patches I have sent earlier
This is based on your current mac80211-next.
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 33 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 24 ++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0d17ec9..d2aa555 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -664,6 +664,7 @@ struct cfg80211_acl_data {
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
+ * @smps_mode: SMPS mode
  * @inactivity_timeout: time in seconds to determine station's inactivity.
  * @p2p_ctwindow: P2P CT Window
  * @p2p_opp_ps: P2P opportunistic PS
@@ -682,6 +683,7 @@ struct cfg80211_ap_settings {
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
+	enum nl80211_smps_mode smps_mode;
 	int inactivity_timeout;
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 29c4399..cca29f7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1611,6 +1611,9 @@ enum nl80211_commands {
  *	drivers to indicate dynack capability. Dynack is automatically disabled
  *	setting valid value for coverage class.
  *
+ * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
+ *	&enum nl80211_smps_mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1957,6 +1960,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_DYN_ACK,
 
+	NL80211_ATTR_SMPS_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4002,6 +4007,13 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_ACKTO_ESTIMATION: This driver supports dynamic ACK timeout
  *	estimation (dynack). %NL80211_ATTR_WIPHY_DYN_ACK flag attribute is used
  *	to enable dynack.
+ * @NL80211_FEATURE_STATIC_SMPS: Device supports static spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	even on HT connections that should be using more chains.
+ * @NL80211_FEATURE_DYNAMIC_SMPS: Device supports dynamic spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	and then wake the rest up as required after, for example,
+ *	rts/cts handshake.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4028,6 +4040,8 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_QUIET				= 1 << 21,
 	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
 	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
+	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
+	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
 };
 
 /**
@@ -4102,6 +4116,25 @@ enum nl80211_acl_policy {
 };
 
 /**
+ * enum nl80211_smps_mode - SMPS mode
+ *
+ * Requested SMPS mode (for AP mode)
+ *
+ * @NL80211_SMPS_OFF: SMPS off (use all antennas).
+ * @NL80211_SMPS_STATIC: static SMPS (use a single antenna)
+ * @NL80211_SMPS_DYNAMIC: dynamic smps (start with a single antenna and
+ *	turn on other antennas after CTS/RTS).
+ */
+enum nl80211_smps_mode {
+	NL80211_SMPS_OFF,
+	NL80211_SMPS_STATIC,
+	NL80211_SMPS_DYNAMIC,
+
+	__NL80211_SMPS_AFTER_LAST,
+	NL80211_SMPS_MAX = __NL80211_SMPS_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_radar_event - type of radar event for DFS operation
  *
  * Type of event to be used with NL80211_ATTR_RADAR_EVENT to inform userspace
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf178d2..00ccfb2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -391,6 +391,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
 	[NL80211_ATTR_USE_RRM] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -3339,6 +3340,29 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	if (info->attrs[NL80211_ATTR_SMPS_MODE]) {
+		params.smps_mode =
+			nla_get_u8(info->attrs[NL80211_ATTR_SMPS_MODE]);
+		switch (params.smps_mode) {
+		case NL80211_SMPS_OFF:
+			break;
+		case NL80211_SMPS_STATIC:
+			if (!(rdev->wiphy.features &
+			      NL80211_FEATURE_STATIC_SMPS))
+				return -EINVAL;
+			break;
+		case NL80211_SMPS_DYNAMIC:
+			if (!(rdev->wiphy.features &
+			      NL80211_FEATURE_DYNAMIC_SMPS))
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		params.smps_mode = NL80211_SMPS_OFF;
+	}
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
1.9.1

