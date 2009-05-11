Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54941 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbZEKS6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:58:52 -0400
Message-Id: <20090511185846.039848438@atheros.com>
References: <20090511185754.653711567@atheros.com>
Date: Mon, 11 May 2009 21:57:56 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/4] nl80211: improve station flags handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

It is currently not possible to modify station flags, but that
capability would be very useful. This patch introduces a new
nl80211 attribute that contains a set/mask for station flags,
and updates the internal API (and mac80211) to mirror that.

The new attribute is parsed before falling back to the old so
that userspace can specify both (if it can) to work on all
kernels.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |   21 ++++++++++++++++++++-
 include/net/cfg80211.h  |   28 +++++-----------------------
 net/mac80211/cfg.c      |   28 ++++++++++++++++------------
 net/wireless/nl80211.c  |   38 ++++++++++++++++++++++++++++++--------
 4 files changed, 71 insertions(+), 44 deletions(-)

--- uml.orig/include/net/cfg80211.h	2009-05-11 21:39:21.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-05-11 21:39:24.000000000 +0300
@@ -252,27 +252,6 @@ struct beacon_parameters {
 };
 
 /**
- * enum station_flags - station flags
- *
- * Station capability flags. Note that these must be the bits
- * according to the nl80211 flags.
- *
- * @STATION_FLAG_CHANGED: station flags were changed
- * @STATION_FLAG_AUTHORIZED: station is authorized to send frames (802.1X)
- * @STATION_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
- *	with short preambles
- * @STATION_FLAG_WME: station is WME/QoS capable
- * @STATION_FLAG_MFP: station uses management frame protection
- */
-enum station_flags {
-	STATION_FLAG_CHANGED		= 1<<0,
-	STATION_FLAG_AUTHORIZED		= 1<<NL80211_STA_FLAG_AUTHORIZED,
-	STATION_FLAG_SHORT_PREAMBLE	= 1<<NL80211_STA_FLAG_SHORT_PREAMBLE,
-	STATION_FLAG_WME		= 1<<NL80211_STA_FLAG_WME,
-	STATION_FLAG_MFP		= 1<<NL80211_STA_FLAG_MFP,
-};
-
-/**
  * enum plink_action - actions to perform in mesh peers
  *
  * @PLINK_ACTION_INVALID: action 0 is reserved
@@ -294,14 +273,17 @@ enum plink_actions {
  * @supported_rates: supported rates in IEEE 802.11 format
  *	(or NULL for no change)
  * @supported_rates_len: number of supported rates
- * @station_flags: station flags (see &enum station_flags)
+ * @sta_flags_mask: station flags that changed
+ *	(bitmask of BIT(NL80211_STA_FLAG_...))
+ * @sta_flags_set: station flags values
+ *	(bitmask of BIT(NL80211_STA_FLAG_...))
  * @listen_interval: listen interval or -1 for no change
  * @aid: AID or zero for no change
  */
 struct station_parameters {
 	u8 *supported_rates;
 	struct net_device *vlan;
-	u32 station_flags;
+	u32 sta_flags_mask, sta_flags_set;
 	int listen_interval;
 	u16 aid;
 	u8 supported_rates_len;
--- uml.orig/net/wireless/nl80211.c	2009-05-11 21:39:23.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-11 21:39:24.000000000 +0300
@@ -123,6 +123,9 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_USE_MFP] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_FLAGS2] = {
+		.len = sizeof(struct nl80211_sta_flag_update),
+	},
 };
 
 /* IE validation */
@@ -1334,13 +1337,33 @@ static const struct nla_policy sta_flags
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
 };
 
-static int parse_station_flags(struct nlattr *nla, u32 *staflags)
+static int parse_station_flags(struct genl_info *info,
+			       struct station_parameters *params)
 {
 	struct nlattr *flags[NL80211_STA_FLAG_MAX + 1];
+	struct nlattr *nla;
 	int flag;
 
-	*staflags = 0;
+	/*
+	 * Try parsing the new attribute first so userspace
+	 * can specify both for older kernels.
+	 */
+	nla = info->attrs[NL80211_ATTR_STA_FLAGS2];
+	if (nla) {
+		struct nl80211_sta_flag_update *sta_flags;
+
+		sta_flags = nla_data(nla);
+		params->sta_flags_mask = sta_flags->mask;
+		params->sta_flags_set = sta_flags->set;
+		if ((params->sta_flags_mask |
+		     params->sta_flags_set) & BIT(__NL80211_STA_FLAG_INVALID))
+			return -EINVAL;
+		return 0;
+	}
+
+	/* if present, parse the old attribute */
 
+	nla = info->attrs[NL80211_ATTR_STA_FLAGS];
 	if (!nla)
 		return 0;
 
@@ -1348,11 +1371,12 @@ static int parse_station_flags(struct nl
 			     nla, sta_flags_policy))
 		return -EINVAL;
 
-	*staflags = STATION_FLAG_CHANGED;
+	params->sta_flags_mask = (1 << __NL80211_STA_FLAG_AFTER_LAST) - 1;
+	params->sta_flags_mask &= ~1;
 
 	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++)
 		if (flags[flag])
-			*staflags |= (1<<flag);
+			params->sta_flags_set |= (1<<flag);
 
 	return 0;
 }
@@ -1648,8 +1672,7 @@ static int nl80211_set_station(struct sk
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
-	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
-				&params.station_flags))
+	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
@@ -1718,8 +1741,7 @@ static int nl80211_new_station(struct sk
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
-	if (parse_station_flags(info->attrs[NL80211_ATTR_STA_FLAGS],
-				&params.station_flags))
+	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
 	rtnl_lock();
--- uml.orig/include/linux/nl80211.h	2009-05-11 21:39:13.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-05-11 21:39:24.000000000 +0300
@@ -25,6 +25,8 @@
  *
  */
 
+#include <linux/types.h>
+
 /**
  * DOC: Station handling
  *
@@ -380,7 +382,7 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_STA_AID: Association ID for the station (u16)
  * @NL80211_ATTR_STA_FLAGS: flags, nested element with NLA_FLAG attributes of
- *	&enum nl80211_sta_flags.
+ *	&enum nl80211_sta_flags (deprecated, use %NL80211_ATTR_STA_FLAGS2)
  * @NL80211_ATTR_STA_LISTEN_INTERVAL: listen interval as defined by
  *	IEEE 802.11 7.3.1.6 (u16).
  * @NL80211_ATTR_STA_SUPPORTED_RATES: supported rates, array of supported
@@ -499,6 +501,9 @@ enum nl80211_commands {
  *	this attribute can be used
  *	with %NL80211_CMD_ASSOCIATE request
  *
+ * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
+ *	&struct nl80211_sta_flag_update.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -603,6 +608,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USE_MFP,
 
+	NL80211_ATTR_STA_FLAGS2,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -692,6 +699,18 @@ enum nl80211_sta_flags {
 };
 
 /**
+ * struct nl80211_sta_flag_update - station flags mask/set
+ * @mask: mask of station flags to set
+ * @set: which values to set them to
+ *
+ * Both mask and set contain bits as per &enum nl80211_sta_flags.
+ */
+struct nl80211_sta_flag_update {
+	__u32 mask;
+	__u32 set;
+} __attribute__((packed));
+
+/**
  * enum nl80211_rate_info - bitrate information
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
--- uml.orig/net/mac80211/cfg.c	2009-05-11 21:39:18.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-05-11 21:39:24.000000000 +0300
@@ -629,34 +629,38 @@ static void sta_apply_parameters(struct 
 	int i, j;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 mask, set;
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	/*
-	 * FIXME: updating the flags is racy when this function is
-	 *	  called from ieee80211_change_station(), this will
-	 *	  be resolved in a future patch.
-	 */
+	spin_lock_bh(&sta->lock);
+	mask = params->sta_flags_mask;
+	set = params->sta_flags_set;
 
-	if (params->station_flags & STATION_FLAG_CHANGED) {
-		spin_lock_bh(&sta->lock);
+	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
-		if (params->station_flags & STATION_FLAG_AUTHORIZED)
+		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
 			sta->flags |= WLAN_STA_AUTHORIZED;
+	}
 
+	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
 		sta->flags &= ~WLAN_STA_SHORT_PREAMBLE;
-		if (params->station_flags & STATION_FLAG_SHORT_PREAMBLE)
+		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
 			sta->flags |= WLAN_STA_SHORT_PREAMBLE;
+	}
 
+	if (mask & BIT(NL80211_STA_FLAG_WME)) {
 		sta->flags &= ~WLAN_STA_WME;
-		if (params->station_flags & STATION_FLAG_WME)
+		if (set & BIT(NL80211_STA_FLAG_WME))
 			sta->flags |= WLAN_STA_WME;
+	}
 
+	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
 		sta->flags &= ~WLAN_STA_MFP;
-		if (params->station_flags & STATION_FLAG_MFP)
+		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
-		spin_unlock_bh(&sta->lock);
 	}
+	spin_unlock_bh(&sta->lock);
 
 	/*
 	 * FIXME: updating the following information is racy when this

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
