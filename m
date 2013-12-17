Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:35191 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab3LQHCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 02:02:03 -0500
Date: Mon, 16 Dec 2013 23:01:30 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCHv2 1/2] cfg80211: Add support for QoS mapping
Message-ID: <20131217070130.GA9776@w1.fi> (sfid-20131217_080211_394694_B0438DC3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>

This allows QoS mapping from external networks to be implemented as
defined in IEEE Std 802.11-2012, 10.24.9. APs can use this to advertise
DSCP ranges and exceptions for mapping frames to a specific UP over
Wi-Fi.

The payload of the QoS Map Set element (IEEE Std 802.11-2012, 8.4.2.97)
is sent to the driver through the new NL80211_ATTR_QOS_MAP attribute to
configure the local behavior either on the AP (based on local
configuration) or on a station (based on information received from the
AP).

Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  2 +-
 drivers/net/wireless/mwifiex/main.c                |  2 +-
 include/net/cfg80211.h                             | 53 +++++++++++++++++-
 include/uapi/linux/nl80211.h                       | 14 +++++
 net/mac80211/wme.c                                 |  2 +-
 net/wireless/ap.c                                  |  1 +
 net/wireless/ibss.c                                |  2 +
 net/wireless/mesh.c                                |  1 +
 net/wireless/nl80211.c                             | 62 ++++++++++++++++++++++
 net/wireless/rdev-ops.h                            | 15 ++++++
 net/wireless/sme.c                                 |  2 +
 net/wireless/trace.h                               | 40 ++++++++++++++
 net/wireless/util.c                                | 19 ++++++-
 13 files changed, 210 insertions(+), 5 deletions(-)

v2:
- remove 'bool valid'
- clear QoS Map configuration from cfg80211 on disconnection, AP
  stop, etc.
- reject command if in client mode and not associated


diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index e9bdfdb..4f80e12 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1873,7 +1873,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
 	if (!skb->priority)
-		skb->priority = cfg80211_classify8021d(skb);
+		skb->priority = cfg80211_classify8021d(skb, NULL);
 
 	drvr->tx_multicast += !!multicast;
 	if (pae)
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 6bf58ab..2d6f5e1 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -749,7 +749,7 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 static u16
 mwifiex_netdev_select_wmm_queue(struct net_device *dev, struct sk_buff *skb)
 {
-	skb->priority = cfg80211_classify8021d(skb);
+	skb->priority = cfg80211_classify8021d(skb, NULL);
 	return mwifiex_1d_to_wmm_queue[skb->priority];
 }
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e9abc7b..22ad2c1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1967,6 +1967,50 @@ struct cfg80211_mgmt_tx_params {
 };
 
 /**
+ * struct cfg80211_dscp_exception - DSCP exception
+ *
+ * @dscp: DSCP value that does not adhere to the user priority range definition
+ * @up: user priority value to which the corresponding DSCP value belongs
+ */
+struct cfg80211_dscp_exception {
+	u8 dscp;
+	u8 up;
+};
+
+/**
+ * struct cfg80211_dscp_range - DSCP range definition for user priority
+ *
+ * @low: lowest DSCP value of this user priority range, inclusive
+ * @high: highest DSCP value of this user priority range, inclusive
+ */
+struct cfg80211_dscp_range {
+	u8 low;
+	u8 high;
+};
+
+/* QoS Map Set element length defined in IEEE Std 802.11-2012, 8.4.2.97 */
+#define IEEE80211_QOS_MAP_MAX_EX	21
+#define IEEE80211_QOS_MAP_LEN_MIN	16
+#define IEEE80211_QOS_MAP_LEN_MAX \
+	(IEEE80211_QOS_MAP_LEN_MIN + 2 * IEEE80211_QOS_MAP_MAX_EX)
+
+/**
+ * struct cfg80211_qos_map - QoS Map Information
+ *
+ * This struct defines the Interworking QoS map setting for DSCP values
+ *
+ * @num_des: number of DSCP exceptions (0..21)
+ * @dscp_exception: optionally up to maximum of 21 DSCP exceptions from
+ *	the user priority DSCP range definition
+ * @up: DSCP range definition for a particular user priority
+ */
+struct cfg80211_qos_map {
+	u8 num_des;
+	struct cfg80211_dscp_exception dscp_exception[IEEE80211_QOS_MAP_MAX_EX];
+	struct cfg80211_dscp_range up[8];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2208,6 +2252,8 @@ struct cfg80211_mgmt_tx_params {
  * @set_coalesce: Set coalesce parameters.
  *
  * @channel_switch: initiate channel-switch procedure (with CSA)
+ *
+ * @set_qos_map: Set QoS mapping information to the driver
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2449,6 +2495,9 @@ struct cfg80211_ops {
 	int	(*channel_switch)(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  struct cfg80211_csa_settings *params);
+	int     (*set_qos_map)(struct wiphy *wiphy,
+			       struct net_device *dev,
+			       struct cfg80211_qos_map *qos_map);
 };
 
 /*
@@ -3390,9 +3439,11 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
  * @skb: the data frame
+ * @qos_map: Interworking QoS mapping or %NULL if not in use
  * Return: The 802.1p/1d tag.
  */
-unsigned int cfg80211_classify8021d(struct sk_buff *skb);
+unsigned int cfg80211_classify8021d(struct sk_buff *skb,
+				    struct cfg80211_qos_map *qos_map);
 
 /**
  * cfg80211_find_ie - find information element in data
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 129b7b0..783d55c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -693,6 +693,12 @@
  *	other station that transmission must be blocked until the channel
  *	switch is complete.
  *
+ * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
+ *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
+ *	that attribute is not included, QoS mapping is disabled. Since this
+ *	QoS mapping is relevant for IP packets, it is only valid during an
+ *	association. This is cleared on disassociation and AP restart.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -860,6 +866,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CHANNEL_SWITCH,
 
+	NL80211_CMD_SET_QOS_MAP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1520,6 +1528,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_10_MHZ: A flag indicating that the device supports
  *	10 MHz channel bandwidth.
  *
+ * @NL80211_ATTR_QOS_MAP: IP DSCP mapping for Interworking QoS mapping. This
+ *	data is in the format defined for the payload of the QoS Map Set element
+ *	in IEEE Std 802.11-2012, 8.4.2.97.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1839,6 +1851,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SUPPORT_5_MHZ,
 	NL80211_ATTR_SUPPORT_10_MHZ,
 
+	NL80211_ATTR_QOS_MAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index afba19c..faa9d8e 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -155,7 +155,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
-	skb->priority = cfg80211_classify8021d(skb);
+	skb->priority = cfg80211_classify8021d(skb, NULL);
 
 	return ieee80211_downgrade_queue(sdata, skb);
 }
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 324e8d8..11ee4ed 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -29,6 +29,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		wdev->beacon_interval = 0;
 		wdev->channel = NULL;
 		wdev->ssid_len = 0;
+		rdev_set_qos_map(rdev, dev, NULL);
 	}
 
 	return err;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 730147e..f911c5f 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -183,6 +183,8 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 	kfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
+	rdev_set_qos_map(rdev, dev, NULL);
+
 	/*
 	 * Delete all the keys ... pairwise keys can't really
 	 * exist any more anyway, but default keys might.
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b0e1869..04c6bab 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -268,6 +268,7 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		wdev->mesh_id_len = 0;
 		wdev->channel = NULL;
+		rdev_set_qos_map(rdev, dev, NULL);
 	}
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a693f86..b8dd3cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -376,6 +376,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
+				   .len = IEEE80211_QOS_MAP_LEN_MAX },
 };
 
 /* policy for the key attributes */
@@ -1450,6 +1452,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
 		}
+		CMD(set_qos_map, SET_QOS_MAP);
 
 #ifdef CONFIG_NL80211_TESTMODE
 		CMD(testmode_cmd, TESTMODE);
@@ -8875,6 +8878,57 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_set_qos_map(struct sk_buff *skb,
+			       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_qos_map *qos_map = NULL;
+	struct net_device *dev = info->user_ptr[1];
+	u8 *pos, len, num_des, des_len, des;
+	int ret;
+
+	if (!rdev->ops->set_qos_map)
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_QOS_MAP]) {
+		pos = nla_data(info->attrs[NL80211_ATTR_QOS_MAP]);
+		len = nla_len(info->attrs[NL80211_ATTR_QOS_MAP]);
+
+		if (len % 2 || len < IEEE80211_QOS_MAP_LEN_MIN ||
+		    len > IEEE80211_QOS_MAP_LEN_MAX)
+			return -EINVAL;
+
+		qos_map = kzalloc(sizeof(struct cfg80211_qos_map), GFP_KERNEL);
+		if (!qos_map)
+			return -ENOMEM;
+
+		num_des = (len - IEEE80211_QOS_MAP_LEN_MIN) >> 1;
+		if (num_des) {
+			des_len = num_des *
+				sizeof(struct cfg80211_dscp_exception);
+			memcpy(qos_map->dscp_exception, pos, des_len);
+			qos_map->num_des = num_des;
+			for (des = 0; des < num_des; des++) {
+				if (qos_map->dscp_exception[des].up > 7) {
+					kfree(qos_map);
+					return -EINVAL;
+				}
+			}
+			pos += des_len;
+		}
+		memcpy(qos_map->up, pos, IEEE80211_QOS_MAP_LEN_MIN);
+	}
+
+	wdev_lock(dev->ieee80211_ptr);
+	ret = nl80211_key_allowed(dev->ieee80211_ptr);
+	if (!ret)
+		ret = rdev_set_qos_map(rdev, dev, qos_map);
+	wdev_unlock(dev->ieee80211_ptr);
+
+	kfree(qos_map);
+	return ret;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -9599,6 +9653,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_QOS_MAP,
+		.doit = nl80211_set_qos_map,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index a6c03ab..c8e2259 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -932,4 +932,19 @@ static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_qos_map *qos_map)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (rdev->ops->set_qos_map) {
+		trace_rdev_set_qos_map(&rdev->wiphy, dev, qos_map);
+		ret = rdev->ops->set_qos_map(&rdev->wiphy, dev, qos_map);
+		trace_rdev_return_int(&rdev->wiphy, ret);
+	}
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 65f8008..3f64202 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -870,6 +870,8 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 		for (i = 0; i < 6; i++)
 			rdev_del_key(rdev, dev, i, false, NULL);
 
+	rdev_set_qos_map(rdev, dev, NULL);
+
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f7aa7a7..fbcc23e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -186,6 +186,28 @@
 
 #define BOOL_TO_STR(bo) (bo) ? "true" : "false"
 
+#define QOS_MAP_ENTRY __field(u8, num_des)			\
+		      __array(u8, dscp_exception,		\
+			      2 * IEEE80211_QOS_MAP_MAX_EX)	\
+		      __array(u8, up, IEEE80211_QOS_MAP_LEN_MIN)
+#define QOS_MAP_ASSIGN(qos_map)					\
+	do {							\
+		if ((qos_map)) {				\
+			__entry->num_des = (qos_map)->num_des;	\
+			memcpy(__entry->dscp_exception,		\
+			       &(qos_map)->dscp_exception,	\
+			       2 * IEEE80211_QOS_MAP_MAX_EX);	\
+			memcpy(__entry->up, &(qos_map)->up,	\
+			       IEEE80211_QOS_MAP_LEN_MIN);	\
+		} else {					\
+			__entry->num_des = 0;			\
+			memset(__entry->dscp_exception, 0,	\
+			       2 * IEEE80211_QOS_MAP_MAX_EX);	\
+			memset(__entry->up, 0,			\
+			       IEEE80211_QOS_MAP_LEN_MIN);	\
+		}						\
+	} while (0)
+
 /*************************************************************
  *			rdev->ops traces		     *
  *************************************************************/
@@ -1875,6 +1897,24 @@ TRACE_EVENT(rdev_channel_switch,
 		  __entry->counter_offset_presp)
 );
 
+TRACE_EVENT(rdev_set_qos_map,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_qos_map *qos_map),
+	TP_ARGS(wiphy, netdev, qos_map),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		QOS_MAP_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		QOS_MAP_ASSIGN(qos_map);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", num_des: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->num_des)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..5618888 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -689,7 +689,8 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
 
 /* Given a data frame determine the 802.1p/1d tag to use. */
-unsigned int cfg80211_classify8021d(struct sk_buff *skb)
+unsigned int cfg80211_classify8021d(struct sk_buff *skb,
+				    struct cfg80211_qos_map *qos_map)
 {
 	unsigned int dscp;
 	unsigned char vlan_priority;
@@ -720,6 +721,21 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 		return 0;
 	}
 
+	if (qos_map) {
+		unsigned int i, tmp_dscp = dscp >> 2;
+
+		for (i = 0; i < qos_map->num_des; i++) {
+			if (tmp_dscp == qos_map->dscp_exception[i].dscp)
+				return qos_map->dscp_exception[i].up;
+		}
+
+		for (i = 0; i < 8; i++) {
+			if (tmp_dscp >= qos_map->up[i].low &&
+			    tmp_dscp <= qos_map->up[i].high)
+				return i;
+		}
+	}
+
 	return dscp >> 5;
 }
 EXPORT_SYMBOL(cfg80211_classify8021d);
@@ -863,6 +879,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
+		rdev_set_qos_map(rdev, dev, NULL);
 
 		switch (otype) {
 		case NL80211_IFTYPE_AP:
-- 
1.8.3.2


-- 
Jouni Malinen                                            PGP id EFC895FA
