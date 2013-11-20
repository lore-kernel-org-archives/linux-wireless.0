Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21587 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTK30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 05:29:26 -0500
Date: Wed, 20 Nov 2013 12:28:28 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Add support for QoS mapping
Message-ID: <20131120102828.GA26154@jouni.qca.qualcomm.com> (sfid-20131120_112931_282033_A282B510)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 drivers/net/wireless/mwifiex/main.c                |    2 +-
 include/net/cfg80211.h                             |   55 +++++++++++++++++++-
 include/uapi/linux/nl80211.h                       |   12 +++++
 net/mac80211/wme.c                                 |    2 +-
 net/wireless/nl80211.c                             |   50 ++++++++++++++++++
 net/wireless/rdev-ops.h                            |   12 +++++
 net/wireless/trace.h                               |   44 ++++++++++++++++
 net/wireless/util.c                                |   18 ++++++-
 9 files changed, 192 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index d0cd0bf..ac0fd69 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1757,7 +1757,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
 	if (!skb->priority)
-		skb->priority = cfg80211_classify8021d(skb);
+		skb->priority = cfg80211_classify8021d(skb, NULL);
 
 	drvr->tx_multicast += !!multicast;
 	if (pae)
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 78e8a66..76df74b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -748,7 +748,7 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 static u16
 mwifiex_netdev_select_wmm_queue(struct net_device *dev, struct sk_buff *skb)
 {
-	skb->priority = cfg80211_classify8021d(skb);
+	skb->priority = cfg80211_classify8021d(skb, NULL);
 	return mwifiex_1d_to_wmm_queue[skb->priority];
 }
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3eae46c..ddfa5cd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1945,6 +1945,52 @@ struct cfg80211_update_ft_ies_params {
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
+ * @valid: validity flag
+ * @num_des: number of DSCP exceptions (0..21)
+ * @dscp_exception: optionally up to maximum of 21 DSCP exceptions from
+ *	the user priority DSCP range definition
+ * @up: DSCP range definition for a particular user priority
+ */
+struct cfg80211_qos_map {
+	bool valid;
+	u8 num_des;
+	struct cfg80211_dscp_exception dscp_exception[IEEE80211_QOS_MAP_MAX_EX];
+	struct cfg80211_dscp_range up[8];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2186,6 +2232,8 @@ struct cfg80211_update_ft_ies_params {
  * @set_coalesce: Set coalesce parameters.
  *
  * @channel_switch: initiate channel-switch procedure (with CSA)
+ *
+ * @set_qos_map: Set QoS mapping information to the driver
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2428,6 +2476,9 @@ struct cfg80211_ops {
 	int	(*channel_switch)(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  struct cfg80211_csa_settings *params);
+	int     (*set_qos_map)(struct wiphy *wiphy,
+			       struct net_device *dev,
+			       struct cfg80211_qos_map *qos_map);
 };
 
 /*
@@ -3388,9 +3439,11 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
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
index f752e98..4782c20 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -686,6 +686,10 @@
  *	other station that transmission must be blocked until the channel
  *	switch is complete.
  *
+ * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
+ *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
+ *	that attribute is not included, QoS mapping is disabled.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -853,6 +857,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CHANNEL_SWITCH,
 
+	NL80211_CMD_SET_QOS_MAP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1508,6 +1514,10 @@ enum nl80211_commands {
  *	to react to radar events, e.g. initiate a channel switch or leave the
  *	IBSS network.
  *
+ * @NL80211_ATTR_QOS_MAP: IP DSCP mapping for Interworking QoS mapping. This
+ *	data is in the format defined for the payload of the QoS Map Set element
+ *	in IEEE Std 802.11-2012, 8.4.2.97.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1824,6 +1834,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..e292a2b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,6 +357,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
+				   .len = IEEE80211_QOS_MAP_LEN_MAX },
 };
 
 /* policy for the key attributes */
@@ -8840,6 +8842,46 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_set_qos_map(struct sk_buff *skb,
+			       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_qos_map qos_map;
+	struct net_device *dev = info->user_ptr[1];
+	u8 *pos, len, num_des, des_len, des;
+
+	if (!rdev->ops->set_qos_map)
+		return -EOPNOTSUPP;
+
+	memset(&qos_map, 0, sizeof(struct cfg80211_qos_map));
+
+	if (info->attrs[NL80211_ATTR_QOS_MAP]) {
+		pos = nla_data(info->attrs[NL80211_ATTR_QOS_MAP]);
+		len = nla_len(info->attrs[NL80211_ATTR_QOS_MAP]);
+
+		if (len & 1 || len < IEEE80211_QOS_MAP_LEN_MIN ||
+		    len > IEEE80211_QOS_MAP_LEN_MAX)
+			return -EINVAL;
+
+		num_des = (len - IEEE80211_QOS_MAP_LEN_MIN) >> 1;
+		if (num_des) {
+			des_len = num_des *
+				sizeof(struct cfg80211_dscp_exception);
+			memcpy(&qos_map.dscp_exception, pos, des_len);
+			qos_map.num_des = num_des;
+			for (des = 0; des < num_des; des++) {
+				if (qos_map.dscp_exception[des].up > 7)
+					return -EINVAL;
+			}
+			pos += des_len;
+		}
+		memcpy(&qos_map.up, pos, IEEE80211_QOS_MAP_LEN_MIN);
+		qos_map.valid = true;
+	}
+
+	return rdev_set_qos_map(rdev, dev, &qos_map);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -9564,6 +9606,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 37ce9fd..be4247e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -936,4 +936,16 @@ static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_qos_map *qos_map)
+{
+	int ret;
+
+	trace_rdev_set_qos_map(&rdev->wiphy, dev, qos_map);
+	ret = rdev->ops->set_qos_map(&rdev->wiphy, dev, qos_map);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ba5f0d6..59ea972 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -186,6 +186,31 @@
 
 #define BOOL_TO_STR(bo) (bo) ? "true" : "false"
 
+#define QOS_MAP_ENTRY __field(bool, valid)			\
+		      __field(u8, num_des)			\
+		      __array(u8, dscp_exception,		\
+			      2 * IEEE80211_QOS_MAP_MAX_EX)	\
+		      __array(u8, up, IEEE80211_QOS_MAP_LEN_MIN)
+#define QOS_MAP_ASSIGN(qos_map)					\
+	do {							\
+		if ((qos_map)) {				\
+			__entry->valid = (qos_map)->valid;	\
+			__entry->num_des = (qos_map)->num_des;	\
+			memcpy(__entry->dscp_exception,		\
+			       &(qos_map)->dscp_exception,	\
+			       2 * IEEE80211_QOS_MAP_MAX_EX);	\
+			memcpy(__entry->up, &(qos_map)->up,	\
+			       IEEE80211_QOS_MAP_LEN_MIN);	\
+		} else {					\
+			__entry->valid = false;			\
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
@@ -1876,6 +1901,25 @@ TRACE_EVENT(rdev_channel_switch,
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
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", valid: %s, num_des: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, BOOL_TO_STR(__entry->valid),
+		  __entry->num_des)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..e129822 100644
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
 
+	if (qos_map && qos_map->valid) {
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
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
