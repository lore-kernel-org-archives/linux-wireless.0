Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5684 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbcAMJtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:49:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT command
Date: Wed, 13 Jan 2016 10:49:42 +0100
Message-ID: <1452678583-20086-3-git-send-email-arend@broadcom.com> (sfid-20160113_105000_216630_3B17D3E0)
In-Reply-To: <1452678583-20086-1-git-send-email-arend@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass user-space provided bss selection criteria to the driver
in the .connect() callback. It handles three selection primitives:

1. RSSI based selection.
2. Band selection, RSSI based selection.
3. RSSI adjustment in given band, RSSI based selection.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h       | 29 +++++++++++++++++++
 include/uapi/linux/nl80211.h | 28 ++++++++++++++++++-
 net/wireless/nl80211.c       | 66 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 34c4929..68695fd 100644
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
+ * @primitive: primitive for BSS selection.
+ * @param: parameters for given primitive.
+ * @band_pref: preferred band for %NL80211_BSS_SELECT_BAND_PREF primitive.
+ * @adjust: parameters for %NL80211_BSS_SELECT_ADJUST_RSSI primitive.
+ */
+struct cfg80211_bss_selection {
+	enum nl80211_bss_select_primitive primitive;
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
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a5baf93..9a1b968 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1793,7 +1793,8 @@ enum nl80211_commands {
  *	extended feature %NL80211_EXT_FEATURE_BSS_SELECT. When used with
  *	%NL80211_CMD_GET_WIPHY is contains NLA_FLAG type according
  *	&enum nl80211_bss_select_primitive to indicate what primitives are
- *	supported.
+ *	supported. When used with %NL80211_CMD_CONNECT is contains the criteria
+ *	for BSS selection to be done by driver and/or firmware.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -4677,4 +4678,29 @@ enum nl80211_bss_select_primitive {
 	NUM_NL80211_BSS_SELECT
 };
 
+/**
+ * enum nl80211_attr_bss_select - attributes for bss selection.
+ *
+ * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
+ * @NL80211_ATTR_BSS_SELECT_PRIMITIVE: Indicates what criteria are to
+ *	be used for bss selection. Value according
+ *	%enum nl80211_bss_select_primitive.
+ * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
+ *	preferred band. Value according %enum nl80211_band.
+ * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the value is to be
+ *	added to the RSSI level for BSS-es in the preferred band (s8).
+ * @NL80211_ATTR_BSS_SELECT_MAX: highest bss select attribute number.
+ *@__NL80211_ATTR_BSS_SELECT_AFTER_LAST: internal use.
+ */
+enum nl80211_attr_bss_select {
+	__NL80211_ATTR_BSS_SELECT_INVALID,
+	NL80211_ATTR_BSS_SELECT_PRIMITIVE,
+	NL80211_ATTR_BSS_SELECT_BAND_PREF,
+	NL80211_ATTR_BSS_SELECT_RSSI_ADJUST,
+
+	/* keep last */
+	__NL80211_ATTR_BSS_SELECT_AFTER_LAST,
+	NL80211_ATTR_BSS_SELECT_MAX = __NL80211_ATTR_BSS_SELECT_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7a51de0..580c6ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -485,6 +485,13 @@ nl80211_plan_policy[NL80211_SCHED_SCAN_PLAN_MAX + 1] = {
 	[NL80211_SCHED_SCAN_PLAN_ITERATIONS] = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+nl80211_bss_select_policy[NL80211_ATTR_BSS_SELECT_MAX + 1] = {
+	[NL80211_ATTR_BSS_SELECT_PRIMITIVE] = { .type = NLA_U32 },
+	[NL80211_ATTR_BSS_SELECT_BAND_PREF] = { .type = NLA_U32 },
+	[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST] = { .type = NLA_U8 },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -5773,6 +5780,53 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static int parse_bss_select(struct nlattr *nla,
+			    struct cfg80211_bss_selection *bss_select)
+{
+	struct nlattr *attr[NL80211_ATTR_BSS_SELECT_MAX + 1];
+	enum nl80211_band band = NL80211_BAND_2GHZ;
+	int err;
+
+	if (!nla)
+		return 0;
+
+	err = nla_parse(attr, NL80211_ATTR_BSS_SELECT_MAX,
+			nla_data(nla), nla_len(nla), nl80211_bss_select_policy);
+	if (err)
+		return err;
+
+	if (!attr[NL80211_ATTR_BSS_SELECT_PRIMITIVE])
+		return -EINVAL;
+
+	bss_select->primitive =
+		nla_get_u32(attr[NL80211_ATTR_BSS_SELECT_PRIMITIVE]);
+
+	if (bss_select->primitive == NL80211_BSS_SELECT_BAND_PREF ||
+	    bss_select->primitive == NL80211_BSS_SELECT_ADJUST_RSSI) {
+		if (!attr[NL80211_ATTR_BSS_SELECT_BAND_PREF])
+			return -EINVAL;
+		band = nla_get_u32(attr[NL80211_ATTR_BSS_SELECT_BAND_PREF]);
+	}
+
+	switch (bss_select->primitive) {
+	case NL80211_BSS_SELECT_BAND_PREF:
+		bss_select->param.band_pref = band;
+		break;
+	case NL80211_BSS_SELECT_ADJUST_RSSI:
+		bss_select->param.adjust.band = band;
+		if (!attr[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST])
+			return -EINVAL;
+		bss_select->param.adjust.delta =
+			nla_get_u8(attr[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST]);
+		break;
+	case NL80211_BSS_SELECT_RSSI:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int nl80211_parse_random_mac(struct nlattr **attrs,
 				    u8 *mac_addr, u8 *mac_addr_mask)
 {
@@ -7998,6 +8052,18 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		connect.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	/* only do bss selection when no BSSID is specified. */
+	if (!connect.bssid &&
+	    wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_BSS_SELECT)) {
+		err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
+				       &connect.bss_select);
+		if (err) {
+			kzfree(connkeys);
+			return err;
+		}
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
-- 
1.9.1

