Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:14834
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbcBONf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 08:35:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/3] nl80211: add feature for BSS selection support
Date: Mon, 15 Feb 2016 14:35:51 +0100
Message-Id: <1455543353-20311-2-git-send-email-arend@broadcom.com> (sfid-20160215_181516_378707_C8096444)
In-Reply-To: <1455543353-20311-1-git-send-email-arend@broadcom.com>
References: <1455543353-20311-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introducing a new feature that the driver can use to
indicate the driver/firmware supports configuration of BSS
selection criteria upon CONNECT command. This can be useful
when multiple BSS-es are found belonging to the same ESS,
ie. Infra-BSS with same SSID. The criteria can then be used to
offload selection of a preferred BSS.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h       |  34 +++++++++++++++
 include/uapi/linux/nl80211.h |  52 ++++++++++++++++++++++
 net/wireless/core.c          |   4 ++
 net/wireless/nl80211.c       | 101 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 191 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9e1b24c..1dfb890 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1857,6 +1857,33 @@ struct cfg80211_ibss_params {
 };
 
 /**
+ * struct cfg80211_bss_select_adjust - BSS selection with RSSI adjustment.
+ *
+ * @band: band of BSS which should match for RSSI level adjustment.
+ * @delta: value of RSSI level adjustment.
+ */
+struct cfg80211_bss_select_adjust {
+	enum nl80211_band band;
+	s8 delta;
+};
+
+/**
+ * struct cfg80211_bss_selection - connection parameters for BSS selection.
+ *
+ * @behaviour: requested BSS selection behaviour.
+ * @param: parameters for requestion behaviour.
+ * @band_pref: preferred band for %NL80211_BSS_SELECT_ATTR_BAND_PREF.
+ * @adjust: parameters for %NL80211_BSS_SELECT_ATTR_RSSI_ADJUST.
+ */
+struct cfg80211_bss_selection {
+	enum nl80211_bss_select_attr behaviour;
+	union {
+		enum nl80211_band band_pref;
+		struct cfg80211_bss_select_adjust adjust;
+	} param;
+};
+
+/**
  * struct cfg80211_connect_params - Connection parameters
  *
  * This structure provides information needed to complete IEEE 802.11
@@ -1893,6 +1920,7 @@ struct cfg80211_ibss_params {
  * @vht_capa_mask: The bits of vht_capa which are to be used.
  * @pbss: if set, connect to a PCP instead of AP. Valid for DMG
  *	networks.
+ * @bss_select: criteria to be used for BSS selection.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1916,6 +1944,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_vht_cap vht_capa;
 	struct ieee80211_vht_cap vht_capa_mask;
 	bool pbss;
+	struct cfg80211_bss_selection bss_select;
 };
 
 /**
@@ -3184,6 +3213,9 @@ struct wiphy_vendor_command {
  *	low rssi when a frame is heard on different channel, then it should set
  *	this variable to the maximal offset for which it can compensate.
  *	This value should be set in MHz.
+ * @bss_select_support: bitmask indicating the BSS selection criteria supported
+ *	by the driver in the .connect() callback. The bit position maps to the
+ *	attribute indices defined in &enum nl80211_bss_select_attr.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3306,6 +3338,8 @@ struct wiphy {
 	u8 max_num_csa_counters;
 	u8 max_adj_channel_rssi_comp;
 
+	u32 bss_select_support;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7758969..1f25fbf5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1793,6 +1793,12 @@ enum nl80211_commands {
  *	in a PBSS. Specified in %NL80211_CMD_CONNECT to request
  *	connecting to a PCP, and in %NL80211_CMD_START_AP to start
  *	a PCP instead of AP. Relevant for DMG networks only.
+ * @NL80211_ATTR_BSS_SELECT: nested attribute for driver supporting the
+ *	BSS selection feature. When used with %NL80211_CMD_GET_WIPHY it contains
+ *	NLA_FLAG type according &enum nl80211_bss_select_attr to indicate what
+ *	BSS selection behaviours are supported. When used with %NL80211_CMD_CONNECT
+ *	it contains the behaviour and parameters for BSS selection to be done by
+ *	driver and/or firmware.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2169,6 +2175,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
 	NL80211_ATTR_PBSS,
+	NL80211_ATTR_BSS_SELECT,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -3617,6 +3624,7 @@ enum nl80211_band {
 	NL80211_BAND_2GHZ,
 	NL80211_BAND_5GHZ,
 	NL80211_BAND_60GHZ,
+	NUM_NL80211_BAND,
 };
 
 /**
@@ -4657,4 +4665,48 @@ enum nl80211_sched_scan_plan {
 		__NL80211_SCHED_SCAN_PLAN_AFTER_LAST - 1
 };
 
+/**
+ * struct nl80211_bss_select_rssi_adjust - RSSI adjustment parameters.
+ *
+ * @band: band of BSS that must match for RSSI value adjustment.
+ * @delta: value used to adjust the RSSI value of matching BSS.
+ */
+struct nl80211_bss_select_rssi_adjust {
+	enum nl80211_band band;
+	__s8 delta;
+} __attribute__((packed));
+
+/**
+ * enum nl80211_bss_select_attr - attributes for bss selection.
+ *
+ * @__NL80211_BSS_SELECT_ATTR_INVALID: reserved.
+ * @NL80211_BSS_SELECT_ATTR_RSSI: Flag indicating only RSSI-based BSS selection
+ *	is requested.
+ * @NL80211_BSS_SELECT_ATTR_BAND_PREF: attribute indicating BSS
+ *	selection should be done such that the specified band is preferred.
+ *	When there are multiple BSS-es in the preferred band, the driver
+ *	shall use RSSI-based BSS selection as a second step. The value of
+ *	this attribute is according to &enum nl80211_band (u32).
+ * @NL80211_BSS_SELECT_ATTR_RSSI_ADJUST: When present the RSSI level for
+ *	BSS-es in the specified band is to be adjusted before doing
+ *	RSSI-based BSS selection. The attribute value is a packed structure
+ *	value as specified by &struct nl80211_bss_select_rssi_adjust.
+ * @NL80211_BSS_SELECT_ATTR_MAX: highest bss select attribute number.
+ * @__NL80211_BSS_SELECT_ATTR_AFTER_LAST: internal use.
+ *
+ * One and only one of these attributes are found within %NL80211_ATTR_BSS_SELECT
+ * for %NL80211_CMD_CONNECT. It specifies the required BSS selection behaviour
+ * which the driver shall use.
+ */
+enum nl80211_bss_select_attr {
+	__NL80211_BSS_SELECT_ATTR_INVALID,
+	NL80211_BSS_SELECT_ATTR_RSSI,
+	NL80211_BSS_SELECT_ATTR_BAND_PREF,
+	NL80211_BSS_SELECT_ATTR_RSSI_ADJUST,
+
+	/* keep last */
+	__NL80211_BSS_SELECT_ATTR_AFTER_LAST,
+	NL80211_BSS_SELECT_ATTR_MAX = __NL80211_BSS_SELECT_ATTR_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3a9c41b..1177ec6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -626,6 +626,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->set_mac_acl)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy->bss_select_support &&
+		    (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 268cb49..36e2a8d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -486,6 +486,15 @@ nl80211_plan_policy[NL80211_SCHED_SCAN_PLAN_MAX + 1] = {
 	[NL80211_SCHED_SCAN_PLAN_ITERATIONS] = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
+	[NL80211_BSS_SELECT_ATTR_RSSI] = { .type = NLA_FLAG },
+	[NL80211_BSS_SELECT_ATTR_BAND_PREF] = { .type = NLA_U32 },
+	[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST] = {
+		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
+	},
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -1731,6 +1740,24 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			    rdev->wiphy.ext_features))
 			goto nla_put_failure;
 
+		if (rdev->wiphy.bss_select_support) {
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
@@ -5758,6 +5785,65 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static bool is_band_valid(struct wiphy *wiphy, enum nl80211_band b)
+{
+	return b < NUM_NL80211_BAND && wiphy->bands[b];
+}
+
+static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
+			    struct cfg80211_bss_selection *bss_select)
+{
+	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
+	struct nlattr *nest;
+	int err;
+	bool found = false;
+	int i;
+
+	/* only process one nested attribute */
+	nest = nla_data(nla);
+	err = nla_parse(attr, NL80211_BSS_SELECT_ATTR_MAX, nla_data(nest),
+			nla_len(nest), nl80211_bss_select_policy);
+	if (err)
+		return err;
+
+	/* only one attribute may be given */
+	for (i = 0; i <= NL80211_BSS_SELECT_ATTR_MAX; i++)
+		if (attr[i]) {
+			if (found)
+				return -EINVAL;
+			found = true;
+		}
+
+	bss_select->behaviour = __NL80211_BSS_SELECT_ATTR_INVALID;
+
+	if (attr[NL80211_BSS_SELECT_ATTR_RSSI])
+		bss_select->behaviour = NL80211_BSS_SELECT_ATTR_RSSI;
+
+	if (attr[NL80211_BSS_SELECT_ATTR_BAND_PREF]) {
+		bss_select->behaviour = NL80211_BSS_SELECT_ATTR_BAND_PREF;
+		bss_select->param.band_pref =
+			nla_get_u32(attr[NL80211_BSS_SELECT_ATTR_BAND_PREF]);
+		if (!is_band_valid(wiphy, bss_select->param.band_pref))
+			return -EINVAL;
+	}
+	if (attr[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST]) {
+		struct nl80211_bss_select_rssi_adjust *adj_param;
+
+		adj_param = nla_data(attr[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST]);
+		bss_select->behaviour = NL80211_BSS_SELECT_ATTR_RSSI_ADJUST;
+		bss_select->param.adjust.band = adj_param->band;
+		bss_select->param.adjust.delta = adj_param->delta;
+		if (!is_band_valid(wiphy, bss_select->param.adjust.band))
+			return -EINVAL;
+	}
+
+	/* user-space did not provide behaviour attribute */
+	if (bss_select->behaviour == __NL80211_BSS_SELECT_ATTR_INVALID)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nl80211_parse_random_mac(struct nlattr **attrs,
 				    u8 *mac_addr, u8 *mac_addr_mask)
 {
@@ -7991,6 +8077,21 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
+	/* only do bss selection when no BSSID is specified. */
+	if (!connect.bssid && wiphy->bss_select_support &&
+	    info->attrs[NL80211_ATTR_BSS_SELECT]) {
+		err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
+				       wiphy, &connect.bss_select);
+		if (err) {
+			kzfree(connkeys);
+			return err;
+		}
+		if (!(wiphy->bss_select_support & BIT(connect.bss_select.behaviour))) {
+			kzfree(connkeys);
+			return -EINVAL;
+		}
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
-- 
1.9.1

