Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2KZLoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:44:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] nl80211: support P2P GO powersave configuration
Date: Mon, 26 Nov 2012 12:44:48 +0100
Message-Id: <1353930289-2710-2-git-send-email-johannes@sipsolutions.net> (sfid-20121126_124430_068926_7B70F13B)
In-Reply-To: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
References: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a driver supports P2P GO powersave, allow it to
set the new feature flags for it and allow userspace
to configure the parameters for it. This can be done
at GO startup and later changed with SET_BSS.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  7 ++++++
 include/uapi/linux/nl80211.h | 16 +++++++++++++
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a238f41..731b48f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -538,6 +538,8 @@ struct cfg80211_beacon_data {
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
+ * @p2p_ctwindow: P2P CT Window
+ * @p2p_opp_ps: P2P opportunistic PS
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -552,6 +554,8 @@ struct cfg80211_ap_settings {
 	bool privacy;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
+	u8 p2p_ctwindow;
+	bool p2p_opp_ps;
 };
 
 /**
@@ -913,6 +917,8 @@ struct mpath_info {
  * @ap_isolate: do not forward packets between connected stations
  * @ht_opmode: HT Operation mode
  * 	(u16 = opmode, -1 = do not change)
+ * @p2p_ctwindow: P2P CT Window (-1 = no change)
+ * @p2p_opp_ps: P2P opportunistic PS (-1 = no change)
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -922,6 +928,7 @@ struct bss_parameters {
 	u8 basic_rates_len;
 	int ap_isolate;
 	int ht_opmode;
+	s8 p2p_ctwindow, p2p_opp_ps;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 33a4174..e3e19f8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1303,6 +1303,13 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_P2P_CTWINDOW: P2P GO Client Traffic Window (u8), used with
+ *	the START_AP and SET_BSS commands
+ * @NL80211_ATTR_P2P_OPPPS: P2P GO opportunistic PS (u8), used with the
+ *	START_AP and SET_BSS commands. This can have the values 0 or 1;
+ *	if not given in START_AP 0 is assumed, if not given in SET_BSS
+ *	no change is made.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1570,6 +1577,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_CENTER_FREQ1,
 	NL80211_ATTR_CENTER_FREQ2,
 
+	NL80211_ATTR_P2P_CTWINDOW,
+	NL80211_ATTR_P2P_OPPPS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3126,6 +3136,10 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_NEED_OBSS_SCAN: The driver expects userspace to perform
  *	OBSS scans and generate 20/40 BSS coex reports. This flag is used only
  *	for drivers implementing the CONNECT API, for AUTH/ASSOC it is implied.
+ * @NL80211_FEATURE_P2P_GO_CTWIN: P2P GO implementation supports CT Window
+ *	setting
+ * @NL80211_FEATURE_P2P_GO_OPPPS: P2P GO implementation supports opportunistic
+ *	powersave
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3139,6 +3153,8 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_AP_SCAN				= 1 << 8,
 	NL80211_FEATURE_VIF_TXPOWER			= 1 << 9,
 	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
+	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
+	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ced04f2..5cff535 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -363,6 +363,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
+	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
+	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -2701,6 +2703,32 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]);
 	}
 
+	if (info->attrs[NL80211_ATTR_P2P_CTWINDOW]) {
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+			return -EINVAL;
+		params.p2p_ctwindow =
+			nla_get_u8(info->attrs[NL80211_ATTR_P2P_CTWINDOW]);
+		if (params.p2p_ctwindow < 0 || params.p2p_ctwindow > 127)
+			return -EINVAL;
+		if (params.p2p_ctwindow != 0 &&
+		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_CTWIN))
+			return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_P2P_OPPPS]) {
+		u8 tmp;
+
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+			return -EINVAL;
+		tmp = nla_get_u8(info->attrs[NL80211_ATTR_P2P_OPPPS]);
+		if (tmp < 0 || tmp > 1)
+			return -EINVAL;
+		params.p2p_opp_ps = tmp;
+		if (params.p2p_opp_ps != 0 &&
+		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_OPPPS))
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		err = nl80211_parse_chandef(rdev, info, &params.chandef);
 		if (err)
@@ -3667,6 +3695,8 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.use_short_slot_time = -1;
 	params.ap_isolate = -1;
 	params.ht_opmode = -1;
+	params.p2p_ctwindow = -1;
+	params.p2p_opp_ps = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -3689,6 +3719,30 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 		params.ht_opmode =
 			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
 
+	if (info->attrs[NL80211_ATTR_P2P_CTWINDOW]) {
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+			return -EINVAL;
+		params.p2p_ctwindow =
+			nla_get_u8(info->attrs[NL80211_ATTR_P2P_CTWINDOW]);
+		if (params.p2p_ctwindow < 0 || params.p2p_ctwindow > 127)
+			return -EINVAL;
+		if (params.p2p_ctwindow != 0 &&
+		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_CTWIN))
+			return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_P2P_OPPPS]) {
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+			return -EINVAL;
+		params.p2p_opp_ps =
+			nla_get_u8(info->attrs[NL80211_ATTR_P2P_OPPPS]);
+		if (params.p2p_opp_ps < 0 || params.p2p_opp_ps > 1)
+			return -EINVAL;
+		if (params.p2p_opp_ps != 0 &&
+		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_OPPPS))
+			return -EINVAL;
+	}
+
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
 
-- 
1.8.0

