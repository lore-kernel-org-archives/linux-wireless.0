Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56447 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbYJ3PDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:03:42 -0400
Message-Id: <20081030150238.681583254@localhost> (sfid-20081030_160346_103938_BBE4D54E)
References: <20081030145920.233178987@localhost>
Date: Thu, 30 Oct 2008 16:59:24 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 4/5] nl80211: Add TX queue parameter configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new attribute, NL80211_ATTR_WIPHY_TXQ_PARAMS, that can be used with
NL80211_CMD_SET_WIPHY for userspace (e.g., hostapd) to set TX queue
parameters (txop, cwmin, cwmax, aifs).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-10-30 16:11:27.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2008-10-30 16:13:37.000000000 +0200
@@ -25,8 +25,9 @@
  *
  * @NL80211_CMD_GET_WIPHY: request information about a wiphy or dump request
  *	to get a list of all present wiphys.
- * @NL80211_CMD_SET_WIPHY: set wiphy name, needs %NL80211_ATTR_WIPHY and
- *	%NL80211_ATTR_WIPHY_NAME.
+ * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
+ *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME
+ *	and/or %NL80211_ATTR_WIPHY_TXQ_PARAMS.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -178,6 +179,7 @@
  * @NL80211_ATTR_WIPHY: index of wiphy to operate on, cf.
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
+ * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -312,6 +314,8 @@
 
 	NL80211_ATTR_BSS_BASIC_RATES,
 
+	NL80211_ATTR_WIPHY_TXQ_PARAMS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -324,6 +328,7 @@
  */
 #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
 #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
+#define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -698,4 +703,38 @@
 	NL80211_MESHCONF_ATTR_MAX = __NL80211_MESHCONF_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_txq_attr - TX queue parameter attributes
+ * @__NL80211_TXQ_ATTR_INVALID: Attribute number 0 is reserved
+ * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
+ * @NL80211_TXQ_ATTR_TXOP: Maximum burst time in units of 32 usecs, 0 meaning
+ *	disabled
+ * @NL80211_TXQ_ATTR_CWMIN: Minimum contention window [a value of the form
+ *	2^n-1 in the range 1..32767]
+ * @NL80211_TXQ_ATTR_CWMAX: Maximum contention window [a value of the form
+ *	2^n-1 in the range 1..32767]
+ * @NL80211_TXQ_ATTR_AIFS: Arbitration interframe space [0..255]
+ * @__NL80211_TXQ_ATTR_AFTER_LAST: Internal
+ * @NL80211_TXQ_ATTR_MAX: Maximum TXQ attribute number
+ */
+enum nl80211_txq_attr {
+	__NL80211_TXQ_ATTR_INVALID,
+	NL80211_TXQ_ATTR_QUEUE,
+	NL80211_TXQ_ATTR_TXOP,
+	NL80211_TXQ_ATTR_CWMIN,
+	NL80211_TXQ_ATTR_CWMAX,
+	NL80211_TXQ_ATTR_AIFS,
+
+	/* keep last */
+	__NL80211_TXQ_ATTR_AFTER_LAST,
+	NL80211_TXQ_ATTR_MAX = __NL80211_TXQ_ATTR_AFTER_LAST - 1
+};
+
+enum nl80211_txq_q {
+	NL80211_TXQ_Q_VO,
+	NL80211_TXQ_Q_VI,
+	NL80211_TXQ_Q_BE,
+	NL80211_TXQ_Q_BK
+};
+
 #endif /* __LINUX_NL80211_H */
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h	2008-10-30 16:11:27.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2008-10-30 16:31:21.000000000 +0200
@@ -371,6 +371,24 @@
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 };
 
+/**
+ * struct ieee80211_txq_params - TX queue parameters
+ * @queue: TX queue identifier (NL80211_TXQ_Q_*)
+ * @txop: Maximum burst time in units of 32 usecs, 0 meaning disabled
+ * @cwmin: Minimum contention window [a value of the form 2^n-1 in the range
+ *	1..32767]
+ * @cwmax: Maximum contention window [a value of the form 2^n-1 in the range
+ *	1..32767]
+ * @aifs: Arbitration interframe space [0..255]
+ */
+struct ieee80211_txq_params {
+	enum nl80211_txq_q queue;
+	u16 txop;
+	u16 cwmin;
+	u16 cwmax;
+	u8 aifs;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -430,6 +448,8 @@
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  *
  * @change_bss: Modify parameters for a given BSS.
+ *
+ * @set_txq_params: Set TX queue parameters
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -490,6 +510,9 @@
 				const struct mesh_config *nconf, u32 mask);
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
+
+	int	(*set_txq_params)(struct wiphy *wiphy,
+				  struct ieee80211_txq_params *params);
 };
 
 #endif /* __NET_CFG80211_H */
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c	2008-10-30 16:11:27.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-10-30 16:11:40.000000000 +0200
@@ -1071,6 +1071,30 @@
 	return 0;
 }
 
+static int ieee80211_set_txq_params(struct wiphy *wiphy,
+				    struct ieee80211_txq_params *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_tx_queue_params p;
+
+	if (!local->ops->conf_tx)
+		return -EOPNOTSUPP;
+
+	memset(&p, 0, sizeof(p));
+	p.aifs = params->aifs;
+	p.cw_max = params->cwmax;
+	p.cw_min = params->cwmin;
+	p.txop = params->txop;
+	if (local->ops->conf_tx(local_to_hw(local), params->queue, &p)) {
+		printk(KERN_DEBUG "%s: failed to set TX queue "
+		       "parameters for queue %d\n", local->mdev->name,
+		       params->queue);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1097,4 +1121,5 @@
 	.get_mesh_params = ieee80211_get_mesh_params,
 #endif
 	.change_bss = ieee80211_change_bss,
+	.set_txq_params = ieee80211_set_txq_params,
 };
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2008-10-30 16:11:27.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2008-10-30 16:14:54.000000000 +0200
@@ -58,6 +58,7 @@
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = BUS_ID_SIZE-1 },
+	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -286,20 +287,76 @@
 	return -ENOBUFS;
 }
 
+static const struct nla_policy txq_params_policy[NL80211_TXQ_ATTR_MAX + 1] = {
+	[NL80211_TXQ_ATTR_QUEUE]		= { .type = NLA_U8 },
+	[NL80211_TXQ_ATTR_TXOP]			= { .type = NLA_U16 },
+	[NL80211_TXQ_ATTR_CWMIN]		= { .type = NLA_U16 },
+	[NL80211_TXQ_ATTR_CWMAX]		= { .type = NLA_U16 },
+	[NL80211_TXQ_ATTR_AIFS]			= { .type = NLA_U8 },
+};
+
+static int parse_txq_params(struct nlattr *tb[],
+			    struct ieee80211_txq_params *txq_params)
+{
+	if (!tb[NL80211_TXQ_ATTR_QUEUE] || !tb[NL80211_TXQ_ATTR_TXOP] ||
+	    !tb[NL80211_TXQ_ATTR_CWMIN] || !tb[NL80211_TXQ_ATTR_CWMAX] ||
+	    !tb[NL80211_TXQ_ATTR_AIFS])
+		return -EINVAL;
+
+	txq_params->queue = nla_get_u8(tb[NL80211_TXQ_ATTR_QUEUE]);
+	txq_params->txop = nla_get_u16(tb[NL80211_TXQ_ATTR_TXOP]);
+	txq_params->cwmin = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMIN]);
+	txq_params->cwmax = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMAX]);
+	txq_params->aifs = nla_get_u8(tb[NL80211_TXQ_ATTR_AIFS]);
+
+	return 0;
+}
+
 static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
-	int result;
-
-	if (!info->attrs[NL80211_ATTR_WIPHY_NAME])
-		return -EINVAL;
+	int result = 0, rem_txq_params = 0;
+	struct nlattr *nl_txq_params;
 
 	rdev = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-	result = cfg80211_dev_rename(rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
+	if (info->attrs[NL80211_ATTR_WIPHY_NAME]) {
+		result = cfg80211_dev_rename(
+			rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
+		if (result)
+			goto bad_res;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
+		struct ieee80211_txq_params txq_params;
+		struct nlattr *tb[NL80211_TXQ_ATTR_MAX + 1];
+
+		if (!rdev->ops->set_txq_params) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		nla_for_each_nested(nl_txq_params,
+				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
+				    rem_txq_params) {
+			nla_parse(tb, NL80211_TXQ_ATTR_MAX,
+				  nla_data(nl_txq_params),
+				  nla_len(nl_txq_params),
+				  txq_params_policy);
+			result = parse_txq_params(tb, &txq_params);
+			if (result)
+				goto bad_res;
+
+			result = rdev->ops->set_txq_params(&rdev->wiphy,
+							   &txq_params);
+			if (result)
+				goto bad_res;
+		}
+	}
 
+bad_res:
 	cfg80211_put_dev(rdev);
 	return result;
 }

--

-- 
Jouni Malinen                                            PGP id EFC895FA
