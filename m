Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8912 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934018AbcAZNGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:06:37 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC V4 1/2] nl80211: add feature for BSS selection support
Date: Tue, 26 Jan 2016 14:06:31 +0100
Message-ID: <1453813592-5266-2-git-send-email-arend@broadcom.com> (sfid-20160126_140642_932891_20AA3A23)
In-Reply-To: <1453813592-5266-1-git-send-email-arend@broadcom.com>
References: <1453813592-5266-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 include/net/cfg80211.h       | 34 ++++++++++++++++++++
 include/uapi/linux/nl80211.h | 42 ++++++++++++++++++++++++
 net/wireless/core.c          |  4 +++
 net/wireless/nl80211.c       | 76 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 156 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7..f571f4a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1854,6 +1854,33 @@ struct cfg80211_ibss_params {
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
@@ -1888,6 +1915,7 @@ struct cfg80211_ibss_params {
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
  * @vht_capa:  VHT Capability overrides
  * @vht_capa_mask: The bits of vht_capa which are to be used.
+ * @bss_select: criteria to be used for BSS selection.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1910,6 +1938,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa;
 	struct ieee80211_vht_cap vht_capa_mask;
+	struct cfg80211_bss_selection bss_select;
 };
 
 /**
@@ -3178,6 +3207,9 @@ struct wiphy_vendor_command {
  *	low rssi when a frame is heard on different channel, then it should set
  *	this variable to the maximal offset for which it can compensate.
  *	This value should be set in MHz.
+ * @bss_select_support: bitmask indicating the BSS selection criteria supported
+ *	by the driver in the .connect() callback. The bit position maps to the
+ *	attribute indices defined in &enum nl80211_bss_select_attr.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3300,6 +3332,8 @@ struct wiphy {
 	u8 max_num_csa_counters;
 	u8 max_adj_channel_rssi_comp;
 
+	u32 bss_select_support;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7b5eb..f3ece95 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1789,6 +1789,12 @@ enum nl80211_commands {
  *	thus it must not specify the number of iterations, only the interval
  *	between scans. The scan plans are executed sequentially.
  *	Each scan plan is a nested attribute of &enum nl80211_sched_scan_plan.
+ * @NL80211_ATTR_BSS_SELECT: nested attribute for driver supporting the
+ *	BSS selection feature. When used with %NL80211_CMD_GET_WIPHY it contains
+ *	NLA_FLAG type according &enum nl80211_bss_select_attr to indicate what
+ *	BSS selection behaviours are supported. When used with %NL80211_CMD_CONNECT
+ *	it contains the behaviour and parameters for BSS selection to be done by
+ *	driver and/or firmware.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2164,6 +2170,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
+	NL80211_ATTR_BSS_SELECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4651,4 +4659,38 @@ enum nl80211_sched_scan_plan {
 		__NL80211_SCHED_SCAN_PLAN_AFTER_LAST - 1
 };
 
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
+ *	RSSI-based BSS selection. The attribute value is a packed two-byte
+ *	value. The lower byte contains the adjustment value (s8) and the
+ *	high byte contains the band according &enum nl80211_band.
+ * @NL80211_BSS_SELECT_ATTR_MAX: highest bss select attribute number.
+ *@__NL80211_BSS_SELECT_ATTR_AFTER_LAST: internal use.
+ *
+ * These attributes are found within %NL80211_ATTR_BSS_SELECT and
+ * indicate the required BSS selection behaviour which the driver
+ * should use.
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
index 3a9c41b..f6b2976 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -626,6 +626,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->set_mac_acl)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy->bss_select_support &&
+		    (wiphy->bss_select_support & ~(BIT(NL80211_BSS_SELECT_ATTR_MAX) - 1))))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d4786f2..e17044d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -485,6 +485,13 @@ nl80211_plan_policy[NL80211_SCHED_SCAN_PLAN_MAX + 1] = {
 	[NL80211_SCHED_SCAN_PLAN_ITERATIONS] = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
+	[NL80211_BSS_SELECT_ATTR_RSSI] = { .type = NLA_FLAG },
+	[NL80211_BSS_SELECT_ATTR_BAND_PREF] = { .type = NLA_U32 },
+	[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST] = { .type = NLA_U8 },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -1730,6 +1737,24 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
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
@@ -5753,6 +5778,42 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static int parse_bss_select(struct nlattr *nla,
+			    struct cfg80211_bss_selection *bss_select)
+{
+	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
+	u16 band_delta;
+	int err;
+
+	err = nla_parse(attr, NL80211_BSS_SELECT_ATTR_MAX,
+			nla_data(nla), nla_len(nla), nl80211_bss_select_policy);
+	if (err)
+		return err;
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
+	}
+	if (attr[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST]) {
+		bss_select->behaviour = NL80211_BSS_SELECT_ATTR_RSSI_ADJUST;
+		band_delta =
+			nla_get_u16(attr[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST]);
+		bss_select->param.adjust.delta = (s8)(band_delta & 0xFF);
+		bss_select->param.adjust.band = band_delta >> 8;
+	}
+
+	if (bss_select->behaviour == __NL80211_BSS_SELECT_ATTR_INVALID)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nl80211_parse_random_mac(struct nlattr **attrs,
 				    u8 *mac_addr, u8 *mac_addr_mask)
 {
@@ -7980,6 +8041,21 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		connect.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	/* only do bss selection when no BSSID is specified. */
+	if (!connect.bssid && rdev->wiphy.bss_select_support &&
+	    info->attrs[NL80211_ATTR_BSS_SELECT]) {
+		err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
+				       &connect.bss_select);
+		if (err) {
+			kzfree(connkeys);
+			return err;
+		}
+		if (!(rdev->wiphy.bss_select_support & BIT(connect.bss_select.behaviour))) {
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

