Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28691 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbLXMTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 07:19:15 -0500
From: Arend van Spriel <arend@broadcom.com>
To: <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 1/2] nl80211: add extended feature for BSS selection support
Date: Thu, 24 Dec 2015 13:19:09 +0100
Message-ID: <1450959550-19655-2-git-send-email-arend@broadcom.com> (sfid-20151224_131919_347872_59D91872)
In-Reply-To: <1450959550-19655-1-git-send-email-arend@broadcom.com>
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introducing a new extended feature that the driver can support which
indicate the driver/firmware supports configuration of BSS selection
criteria upon CONNECT command.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h       | 17 ++++++++++++++++
 include/uapi/linux/nl80211.h | 35 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7..4001947 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1854,6 +1854,22 @@ struct cfg80211_ibss_params {
 };
 
 /**
+ * struct cfg80211_bss_selection - Connection parameters for BSS selection.
+ *
+ * @present: indicates whether parameters are set.
+ * @pref_band: preferred band.
+ * @rssi_adjust: adjustment for RSSI level of the preferred band.
+ * @ignore_rssi: indicates whether BSS in preferred band is to be selected
+ *	regardless its RSSI level.
+ */
+struct cfg80211_bss_selection {
+	bool present;
+	enum nl80211_band pref_band;
+	u8 rssi_adjust;
+	bool ignore_rssi;
+};
+
+/**
  * struct cfg80211_connect_params - Connection parameters
  *
  * This structure provides information needed to complete IEEE 802.11
@@ -1910,6 +1926,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa;
 	struct ieee80211_vht_cap vht_capa_mask;
+	struct cfg80211_bss_selection bss_select;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7b5eb..6753468 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1789,6 +1789,9 @@ enum nl80211_commands {
  *	thus it must not specify the number of iterations, only the interval
  *	between scans. The scan plans are executed sequentially.
  *	Each scan plan is a nested attribute of &enum nl80211_sched_scan_plan.
+ * @NL80211_ATTR_BSS_SELECT: nested attribute used with %NL80211_CMD_CONNECT
+ *	containing criteria for BSS selection to be done by driver and/or
+ *	firmware.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2164,6 +2167,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
+	NL80211_ATTR_BSS_SELECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4396,12 +4401,15 @@ enum nl80211_feature_flags {
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
@@ -4651,4 +4659,31 @@ enum nl80211_sched_scan_plan {
 		__NL80211_SCHED_SCAN_PLAN_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_attr_bss_select - attributes for bss selection.
+ *
+ * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
+ * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
+ *	preferred band. The preference by itself still allows RSSI based
+ *	selection of BSS and as such is only a tie breaker. Value according
+ *	%enum nl80211_band.
+ * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the RSSI level for
+ *	the BSS in the preferred band is adjusted accordingly (u8).
+ * @NL80211_ATTR_BSS_SELECT_IGNORE_RSSI: flag attribute which can be used to
+ *	to have the BSS in the preferred band being selected regardless
+ *	of its RSSI level.
+ * @NL80211_ATTR_BSS_SELECT_MAX: highest bss select attribute number.
+ *@__NL80211_ATTR_BSS_SELECT_AFTER_LAST: internal use.
+ */
+enum nl80211_attr_bss_select {
+	__NL80211_ATTR_BSS_SELECT_INVALID,
+	NL80211_ATTR_BSS_SELECT_BAND_PREF,
+	NL80211_ATTR_BSS_SELECT_RSSI_ADJUST,
+	NL80211_ATTR_BSS_SELECT_IGNORE_RSSI,
+
+	/* keep last */
+	__NL80211_ATTR_BSS_SELECT_AFTER_LAST,
+	NL80211_ATTR_BSS_SELECT_MAX = __NL80211_ATTR_BSS_SELECT_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72de698..850f27e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -485,6 +485,13 @@ nl80211_plan_policy[NL80211_SCHED_SCAN_PLAN_MAX + 1] = {
 	[NL80211_SCHED_SCAN_PLAN_ITERATIONS] = { .type = NLA_U32 },
 };
 
+static const struct nla_policy
+nl80211_bss_select_policy[NL80211_ATTR_BSS_SELECT_MAX + 1] = {
+	[NL80211_ATTR_BSS_SELECT_BAND_PREF] = { .type = NLA_U32 },
+	[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_SELECT_IGNORE_RSSI] = { .type = NLA_FLAG },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -5753,6 +5760,33 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static int parse_bss_select(struct nlattr *nla,
+			    struct cfg80211_bss_selection *bss_select)
+{
+	struct nlattr *attr[NL80211_ATTR_BSS_SELECT_MAX + 1];
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
+	bss_select->present = true;
+	if (!attr[NL80211_ATTR_BSS_SELECT_BAND_PREF])
+		return -EINVAL;
+
+	bss_select->pref_band =
+		nla_get_u32(attr[NL80211_ATTR_BSS_SELECT_BAND_PREF]);
+	bss_select->rssi_adjust =
+		nla_get_u8(attr[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST]);
+	bss_select->ignore_rssi = !!attr[NL80211_ATTR_BSS_SELECT_IGNORE_RSSI];
+
+	return 0;
+}
+
 static int nl80211_parse_random_mac(struct nlattr **attrs,
 				    u8 *mac_addr, u8 *mac_addr_mask)
 {
@@ -7978,6 +8012,18 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
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

