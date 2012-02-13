Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2BMORZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 09:17:25 -0500
Subject: [PATCH] cfg80211: restructure AP/GO mode API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 15:17:18 +0100
Message-ID: <1329142638.3365.7.camel@jlt3.sipsolutions.net> (sfid-20120213_151730_213166_23CF2501)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The AP/GO mode API isn't very clearly defined, it
has "set beacon" and "new beacon" etc.

Modify the API to the following:
 * start AP -- all settings
 * change beacon -- new beacon data
 * stop AP -- stop AP mode operation

This also reflects in the nl80211 API, rename
the commands there correspondingly (but keep
the old names for compatibility.)

Overall, this makes it much clearer what's going
on in the API.

Kalle developed the ath6kl changes, I created
the rest of the patch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   82 +++++----
 include/linux/nl80211.h                    |   34 ++-
 include/net/cfg80211.h                     |   70 ++++---
 net/mac80211/cfg.c                         |  146 ++++++----------
 net/mac80211/ieee80211_i.h                 |    2 
 net/mac80211/tx.c                          |   13 -
 net/wireless/nl80211.c                     |  255 ++++++++++++++++-------------
 7 files changed, 316 insertions(+), 286 deletions(-)

--- a/include/net/cfg80211.h	2012-02-12 17:53:59.000000000 +0100
+++ b/include/net/cfg80211.h	2012-02-13 15:10:27.000000000 +0100
@@ -366,25 +366,13 @@ struct cfg80211_crypto_settings {
 };
 
 /**
- * struct beacon_parameters - beacon parameters
- *
- * Used to configure the beacon for an interface.
- *
+ * struct cfg80211_beacon_data - beacon data
  * @head: head portion of beacon (before TIM IE)
  *     or %NULL if not changed
  * @tail: tail portion of beacon (after TIM IE)
  *     or %NULL if not changed
- * @interval: beacon interval or zero if not changed
- * @dtim_period: DTIM period or zero if not changed
  * @head_len: length of @head
  * @tail_len: length of @tail
- * @ssid: SSID to be used in the BSS (note: may be %NULL if not provided from
- *	user space)
- * @ssid_len: length of @ssid
- * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
- * @crypto: crypto settings
- * @privacy: the BSS uses privacy
- * @auth_type: Authentication type (algorithm)
  * @beacon_ies: extra information element(s) to add into Beacon frames or %NULL
  * @beacon_ies_len: length of beacon_ies in octets
  * @proberesp_ies: extra information element(s) to add into Probe Response
@@ -396,24 +384,46 @@ struct cfg80211_crypto_settings {
  * @probe_resp_len: length of probe response template (@probe_resp)
  * @probe_resp: probe response template (AP mode only)
  */
-struct beacon_parameters {
-	u8 *head, *tail;
-	int interval, dtim_period;
-	int head_len, tail_len;
+struct cfg80211_beacon_data {
+	const u8 *head, *tail;
+	const u8 *beacon_ies;
+	const u8 *proberesp_ies;
+	const u8 *assocresp_ies;
+	const u8 *probe_resp;
+
+	size_t head_len, tail_len;
+	size_t beacon_ies_len;
+	size_t proberesp_ies_len;
+	size_t assocresp_ies_len;
+	size_t probe_resp_len;
+};
+
+/**
+ * struct cfg80211_ap_settings - AP configuration
+ *
+ * Used to configure an AP interface.
+ *
+ * @beacon: beacon data
+ * @beacon_interval: beacon interval
+ * @dtim_period: DTIM period
+ * @ssid: SSID to be used in the BSS (note: may be %NULL if not provided from
+ *	user space)
+ * @ssid_len: length of @ssid
+ * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
+ * @crypto: crypto settings
+ * @privacy: the BSS uses privacy
+ * @auth_type: Authentication type (algorithm)
+ */
+struct cfg80211_ap_settings {
+	struct cfg80211_beacon_data beacon;
+
+	int beacon_interval, dtim_period;
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_hidden_ssid hidden_ssid;
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
-	const u8 *beacon_ies;
-	size_t beacon_ies_len;
-	const u8 *proberesp_ies;
-	size_t proberesp_ies_len;
-	const u8 *assocresp_ies;
-	size_t assocresp_ies_len;
-	int probe_resp_len;
-	u8 *probe_resp;
 };
 
 /**
@@ -1518,11 +1528,11 @@ struct cfg80211_ops {
 					struct net_device *netdev,
 					u8 key_index);
 
-	int	(*add_beacon)(struct wiphy *wiphy, struct net_device *dev,
-			      struct beacon_parameters *info);
-	int	(*set_beacon)(struct wiphy *wiphy, struct net_device *dev,
-			      struct beacon_parameters *info);
-	int	(*del_beacon)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*start_ap)(struct wiphy *wiphy, struct net_device *dev,
+			    struct cfg80211_ap_settings *settings);
+	int	(*change_beacon)(struct wiphy *wiphy, struct net_device *dev,
+				 struct cfg80211_beacon_data *info);
+	int	(*stop_ap)(struct wiphy *wiphy, struct net_device *dev);
 
 
 	int	(*add_station)(struct wiphy *wiphy, struct net_device *dev,
--- a/include/linux/nl80211.h	2012-02-07 23:52:34.000000000 +0100
+++ b/include/linux/nl80211.h	2012-02-13 15:10:27.000000000 +0100
@@ -156,21 +156,23 @@
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  *
- * @NL80211_CMD_GET_BEACON: retrieve beacon information (returned in a
- *	%NL80222_CMD_NEW_BEACON message)
- * @NL80211_CMD_SET_BEACON: set the beacon on an access point interface
- *	using the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
- *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL attributes.
- *	Following attributes are provided for drivers that generate full Beacon
- *	and Probe Response frames internally: %NL80211_ATTR_SSID,
+ * @NL80211_CMD_GET_BEACON: (not used)
+ * @NL80211_CMD_SET_BEACON: change the beacon on an access point interface
+ *	using the %NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL
+ *	attributes. For drivers that generate the beacon and probe responses
+ *	internally, the following attributes must be provided: %NL80211_ATTR_IE,
+ *	%NL80211_ATTR_IE_PROBE_RESP and %NL80211_ATTR_IE_ASSOC_RESP.
+ * @NL80211_CMD_START_AP: Start AP operation on an AP interface, parameters
+ *	are like for %NL80211_CMD_SET_BEACON, and additionally parameters that
+ *	do not change are used, these include %NL80211_ATTR_BEACON_INTERVAL,
+ *	%NL80211_ATTR_DTIM_PERIOD, %NL80211_ATTR_SSID,
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
- *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_IE, %NL80211_ATTR_IE_PROBE_RESP,
- *	%NL80211_ATTR_IE_ASSOC_RESP.
- * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
- *	parameters are like for %NL80211_CMD_SET_BEACON.
- * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
+ *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY and
+ *	%NL80211_ATTR_AUTH_TYPE.
+ * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
+ * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
+ * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
  *
  * @NL80211_CMD_GET_STATION: Get station attributes for station identified by
  *	%NL80211_ATTR_MAC on the interface identified by %NL80211_ATTR_IFINDEX.
@@ -565,8 +567,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_BEACON,
 	NL80211_CMD_SET_BEACON,
-	NL80211_CMD_NEW_BEACON,
-	NL80211_CMD_DEL_BEACON,
+	NL80211_CMD_START_AP,
+	NL80211_CMD_NEW_BEACON = NL80211_CMD_START_AP,
+	NL80211_CMD_STOP_AP,
+	NL80211_CMD_DEL_BEACON = NL80211_CMD_STOP_AP,
 
 	NL80211_CMD_GET_STATION,
 	NL80211_CMD_SET_STATION,
--- a/net/wireless/nl80211.c	2012-02-12 17:53:59.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-02-13 15:10:27.000000000 +0100
@@ -871,7 +871,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(add_virtual_intf, NEW_INTERFACE);
 	CMD(change_virtual_intf, SET_INTERFACE);
 	CMD(add_key, NEW_KEY);
-	CMD(add_beacon, NEW_BEACON);
+	CMD(start_ap, START_AP);
 	CMD(add_station, NEW_STATION);
 	CMD(add_mpath, NEW_MPATH);
 	CMD(update_mesh_config, SET_MESH_CONFIG);
@@ -2075,15 +2075,10 @@ static int nl80211_del_key(struct sk_buf
 	return err;
 }
 
-static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_parse_beacon(struct genl_info *info,
+				struct cfg80211_beacon_data *bcn)
 {
-        int (*call)(struct wiphy *wiphy, struct net_device *dev,
-		    struct beacon_parameters *info);
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct beacon_parameters params;
-	int haveinfo = 0, err;
+	bool haveinfo = false;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]) ||
 	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]) ||
@@ -2091,149 +2086,183 @@ static int nl80211_addset_beacon(struct
 	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]))
 		return -EINVAL;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
-		return -EOPNOTSUPP;
-
-	memset(&params, 0, sizeof(params));
-
-	switch (info->genlhdr->cmd) {
-	case NL80211_CMD_NEW_BEACON:
-		/* these are required for NEW_BEACON */
-		if (!info->attrs[NL80211_ATTR_BEACON_INTERVAL] ||
-		    !info->attrs[NL80211_ATTR_DTIM_PERIOD] ||
-		    !info->attrs[NL80211_ATTR_BEACON_HEAD])
-			return -EINVAL;
-
-		params.interval =
-			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
-		params.dtim_period =
-			nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
-
-		err = cfg80211_validate_beacon_int(rdev, params.interval);
-		if (err)
-			return err;
-
-		/*
-		 * In theory, some of these attributes could be required for
-		 * NEW_BEACON, but since they were not used when the command was
-		 * originally added, keep them optional for old user space
-		 * programs to work with drivers that do not need the additional
-		 * information.
-		 */
-		if (info->attrs[NL80211_ATTR_SSID]) {
-			params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
-			params.ssid_len =
-				nla_len(info->attrs[NL80211_ATTR_SSID]);
-			if (params.ssid_len == 0 ||
-			    params.ssid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
-		}
-
-		if (info->attrs[NL80211_ATTR_HIDDEN_SSID]) {
-			params.hidden_ssid = nla_get_u32(
-				info->attrs[NL80211_ATTR_HIDDEN_SSID]);
-			if (params.hidden_ssid !=
-			    NL80211_HIDDEN_SSID_NOT_IN_USE &&
-			    params.hidden_ssid !=
-			    NL80211_HIDDEN_SSID_ZERO_LEN &&
-			    params.hidden_ssid !=
-			    NL80211_HIDDEN_SSID_ZERO_CONTENTS)
-				return -EINVAL;
-		}
-
-		params.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
-
-		if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
-			params.auth_type = nla_get_u32(
-				info->attrs[NL80211_ATTR_AUTH_TYPE]);
-			if (!nl80211_valid_auth_type(params.auth_type))
-				return -EINVAL;
-		} else
-			params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-
-		err = nl80211_crypto_settings(rdev, info, &params.crypto,
-					      NL80211_MAX_NR_CIPHER_SUITES);
-		if (err)
-			return err;
-
-		call = rdev->ops->add_beacon;
-		break;
-	case NL80211_CMD_SET_BEACON:
-		call = rdev->ops->set_beacon;
-		break;
-	default:
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-
-	if (!call)
-		return -EOPNOTSUPP;
+	memset(bcn, 0, sizeof(*bcn));
 
 	if (info->attrs[NL80211_ATTR_BEACON_HEAD]) {
-		params.head = nla_data(info->attrs[NL80211_ATTR_BEACON_HEAD]);
-		params.head_len =
-		    nla_len(info->attrs[NL80211_ATTR_BEACON_HEAD]);
-		haveinfo = 1;
+		bcn->head = nla_data(info->attrs[NL80211_ATTR_BEACON_HEAD]);
+		bcn->head_len = nla_len(info->attrs[NL80211_ATTR_BEACON_HEAD]);
+		if (!bcn->head_len)
+			return -EINVAL;
+		haveinfo = true;
 	}
 
 	if (info->attrs[NL80211_ATTR_BEACON_TAIL]) {
-		params.tail = nla_data(info->attrs[NL80211_ATTR_BEACON_TAIL]);
-		params.tail_len =
+		bcn->tail = nla_data(info->attrs[NL80211_ATTR_BEACON_TAIL]);
+		bcn->tail_len =
 		    nla_len(info->attrs[NL80211_ATTR_BEACON_TAIL]);
-		haveinfo = 1;
+		haveinfo = true;
 	}
 
 	if (!haveinfo)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		params.beacon_ies = nla_data(info->attrs[NL80211_ATTR_IE]);
-		params.beacon_ies_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		bcn->beacon_ies = nla_data(info->attrs[NL80211_ATTR_IE]);
+		bcn->beacon_ies_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
 	if (info->attrs[NL80211_ATTR_IE_PROBE_RESP]) {
-		params.proberesp_ies =
+		bcn->proberesp_ies =
 			nla_data(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
-		params.proberesp_ies_len =
+		bcn->proberesp_ies_len =
 			nla_len(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
 	}
 
 	if (info->attrs[NL80211_ATTR_IE_ASSOC_RESP]) {
-		params.assocresp_ies =
+		bcn->assocresp_ies =
 			nla_data(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
-		params.assocresp_ies_len =
+		bcn->assocresp_ies_len =
 			nla_len(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
 	}
 
 	if (info->attrs[NL80211_ATTR_PROBE_RESP]) {
-		params.probe_resp =
+		bcn->probe_resp =
 			nla_data(info->attrs[NL80211_ATTR_PROBE_RESP]);
-		params.probe_resp_len =
+		bcn->probe_resp_len =
 			nla_len(info->attrs[NL80211_ATTR_PROBE_RESP]);
 	}
 
-	err = call(&rdev->wiphy, dev, &params);
-	if (!err && params.interval)
-		wdev->beacon_interval = params.interval;
+	return 0;
+}
+
+static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_ap_settings params;
+	int err;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->start_ap)
+		return -EOPNOTSUPP;
+
+	if (wdev->beacon_interval)
+		return -EALREADY;
+
+	memset(&params, 0, sizeof(params));
+
+	/* these are required for START_AP */
+	if (!info->attrs[NL80211_ATTR_BEACON_INTERVAL] ||
+	    !info->attrs[NL80211_ATTR_DTIM_PERIOD] ||
+	    !info->attrs[NL80211_ATTR_BEACON_HEAD])
+		return -EINVAL;
+
+	err = nl80211_parse_beacon(info, &params.beacon);
+	if (err)
+		return err;
+
+	params.beacon_interval =
+		nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
+	params.dtim_period =
+		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
+
+	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
+	if (err)
+		return err;
+
+	/*
+	 * In theory, some of these attributes should be required here
+	 * but since they were not used when the command was originally
+	 * added, keep them optional for old user space programs to let
+	 * them continue to work with drivers that do not need the
+	 * additional information -- drivers must check!
+	 */
+	if (info->attrs[NL80211_ATTR_SSID]) {
+		params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+		params.ssid_len =
+			nla_len(info->attrs[NL80211_ATTR_SSID]);
+		if (params.ssid_len == 0 ||
+		    params.ssid_len > IEEE80211_MAX_SSID_LEN)
+			return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_HIDDEN_SSID]) {
+		params.hidden_ssid = nla_get_u32(
+			info->attrs[NL80211_ATTR_HIDDEN_SSID]);
+		if (params.hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE &&
+		    params.hidden_ssid != NL80211_HIDDEN_SSID_ZERO_LEN &&
+		    params.hidden_ssid != NL80211_HIDDEN_SSID_ZERO_CONTENTS)
+			return -EINVAL;
+	}
+
+	params.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
+
+	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
+		params.auth_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_AUTH_TYPE]);
+		if (!nl80211_valid_auth_type(params.auth_type))
+			return -EINVAL;
+	} else
+		params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+
+	err = nl80211_crypto_settings(rdev, info, &params.crypto,
+				      NL80211_MAX_NR_CIPHER_SUITES);
+	if (err)
+		return err;
+
+	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
+	if (!err)
+		wdev->beacon_interval = params.beacon_interval;
 	return err;
 }
 
-static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_beacon_data params;
+	int err;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->change_beacon)
+		return -EOPNOTSUPP;
+
+	if (!wdev->beacon_interval)
+		return -EINVAL;
+
+	err = nl80211_parse_beacon(info, &params);
+	if (err)
+		return err;
+
+	return rdev->ops->change_beacon(&rdev->wiphy, dev, &params);
+}
+
+static int nl80211_stop_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
-	if (!rdev->ops->del_beacon)
+	if (!rdev->ops->stop_ap)
 		return -EOPNOTSUPP;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->del_beacon(&rdev->wiphy, dev);
+	if (!wdev->beacon_interval)
+		return -ENOENT;
+
+	err = rdev->ops->stop_ap(&rdev->wiphy, dev);
 	if (!err)
 		wdev->beacon_interval = 0;
 	return err;
@@ -6357,23 +6386,23 @@ static struct genl_ops nl80211_ops[] = {
 		.cmd = NL80211_CMD_SET_BEACON,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.doit = nl80211_addset_beacon,
+		.doit = nl80211_set_beacon,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
-		.cmd = NL80211_CMD_NEW_BEACON,
+		.cmd = NL80211_CMD_START_AP,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.doit = nl80211_addset_beacon,
+		.doit = nl80211_start_ap,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
-		.cmd = NL80211_CMD_DEL_BEACON,
+		.cmd = NL80211_CMD_STOP_AP,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.doit = nl80211_del_beacon,
+		.doit = nl80211_stop_ap,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
--- a/net/mac80211/cfg.c	2012-02-12 17:53:59.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-02-13 15:10:27.000000000 +0100
@@ -489,27 +489,13 @@ static int ieee80211_get_station(struct
 	return ret;
 }
 
-static void ieee80211_config_ap_ssid(struct ieee80211_sub_if_data *sdata,
-				     struct beacon_parameters *params)
-{
-	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
-
-	bss_conf->ssid_len = params->ssid_len;
-
-	if (params->ssid_len)
-		memcpy(bss_conf->ssid, params->ssid, params->ssid_len);
-
-	bss_conf->hidden_ssid =
-		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
-}
-
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
-				    u8 *resp, size_t resp_len)
+				    const u8 *resp, size_t resp_len)
 {
 	struct sk_buff *new, *old;
 
 	if (!resp || !resp_len)
-		return -EINVAL;
+		return 1;
 
 	old = rtnl_dereference(sdata->u.ap.probe_resp);
 
@@ -520,50 +506,28 @@ static int ieee80211_set_probe_resp(stru
 	memcpy(skb_put(new, resp_len), resp, resp_len);
 
 	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
-	synchronize_rcu();
-
-	if (old)
+	if (old) {
+		/* TODO: use call_rcu() */
+		synchronize_rcu();
 		dev_kfree_skb(old);
+	}
 
 	return 0;
 }
 
-/*
- * This handles both adding a beacon and setting new beacon info
- */
-static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
-				   struct beacon_parameters *params)
+static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+				   struct cfg80211_beacon_data *params)
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
-	int size;
-	int err = -EINVAL;
-	u32 changed = 0;
+	int size, err;
+	u32 changed = BSS_CHANGED_BEACON;
 
 	old = rtnl_dereference(sdata->u.ap.beacon);
 
-	/* head must not be zero-length */
-	if (params->head && !params->head_len)
-		return -EINVAL;
-
-	/*
-	 * This is a kludge. beacon interval should really be part
-	 * of the beacon information.
-	 */
-	if (params->interval &&
-	    (sdata->vif.bss_conf.beacon_int != params->interval)) {
-		sdata->vif.bss_conf.beacon_int = params->interval;
-		ieee80211_bss_info_change_notify(sdata,
-						 BSS_CHANGED_BEACON_INT);
-	}
-
 	/* Need to have a beacon head if we don't have one yet */
 	if (!params->head && !old)
-		return err;
-
-	/* sorry, no way to start beaconing without dtim period */
-	if (!params->dtim_period && !old)
-		return err;
+		return -EINVAL;
 
 	/* new or old head? */
 	if (params->head)
@@ -586,12 +550,6 @@ static int ieee80211_config_beacon(struc
 
 	/* start filling the new info now */
 
-	/* new or old dtim period? */
-	if (params->dtim_period)
-		new->dtim_period = params->dtim_period;
-	else
-		new->dtim_period = old->dtim_period;
-
 	/*
 	 * pointers go into the block we allocated,
 	 * memory is | beacon_data | head | tail |
@@ -614,46 +572,37 @@ static int ieee80211_config_beacon(struc
 		if (old)
 			memcpy(new->tail, old->tail, new_tail_len);
 
-	sdata->vif.bss_conf.dtim_period = new->dtim_period;
-
-	rcu_assign_pointer(sdata->u.ap.beacon, new);
-
-	synchronize_rcu();
-
-	kfree(old);
-
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
 				       params->probe_resp_len);
-	if (!err)
+	if (err < 0)
+		return err;
+	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
-	ieee80211_config_ap_ssid(sdata, params);
-	changed |= BSS_CHANGED_BEACON_ENABLED |
-		   BSS_CHANGED_BEACON |
-		   BSS_CHANGED_SSID;
+	rcu_assign_pointer(sdata->u.ap.beacon, new);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-	return 0;
+	if (old)
+		kfree_rcu(old, rcu_head);
+
+	return changed;
 }
 
-static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
-				struct beacon_parameters *params)
+static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_ap_settings *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct beacon_data *old;
 	struct ieee80211_sub_if_data *vlan;
-	int ret;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	u32 changed = BSS_CHANGED_BEACON_INT |
+		      BSS_CHANGED_BEACON_ENABLED |
+		      BSS_CHANGED_BEACON |
+		      BSS_CHANGED_SSID;
+	int err;
 
 	old = rtnl_dereference(sdata->u.ap.beacon);
 	if (old)
 		return -EALREADY;
 
-	ret = ieee80211_config_beacon(sdata, params);
-	if (ret)
-		return ret;
-
 	/*
 	 * Apply control port protocol, this allows us to
 	 * not encrypt dynamic WEP control frames.
@@ -667,14 +616,32 @@ static int ieee80211_add_beacon(struct w
 			params->crypto.control_port_no_encrypt;
 	}
 
+	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
+	sdata->vif.bss_conf.dtim_period = params->dtim_period;
+
+	sdata->vif.bss_conf.ssid_len = params->ssid_len;
+	if (params->ssid_len)
+		memcpy(sdata->vif.bss_conf.ssid, params->ssid,
+		       params->ssid_len);
+	sdata->vif.bss_conf.hidden_ssid =
+		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
+
+	err = ieee80211_assign_beacon(sdata, &params->beacon);
+	if (err < 0)
+		return err;
+	changed |= err;
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
 	return 0;
 }
 
-static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
-				struct beacon_parameters *params)
+static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+				   struct cfg80211_beacon_data *params)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
+	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -682,10 +649,14 @@ static int ieee80211_set_beacon(struct w
 	if (!old)
 		return -ENOENT;
 
-	return ieee80211_config_beacon(sdata, params);
+	err = ieee80211_assign_beacon(sdata, params);
+	if (err < 0)
+		return err;
+	ieee80211_bss_info_change_notify(sdata, err);
+	return 0;
 }
 
-static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
+static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
@@ -697,10 +668,11 @@ static int ieee80211_del_beacon(struct w
 		return -ENOENT;
 
 	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
-	synchronize_rcu();
-	kfree(old);
+
+	kfree_rcu(old, rcu_head);
 
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+
 	return 0;
 }
 
@@ -2699,9 +2671,9 @@ struct cfg80211_ops mac80211_config_ops
 	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
 	.set_default_mgmt_key = ieee80211_config_default_mgmt_key,
-	.add_beacon = ieee80211_add_beacon,
-	.set_beacon = ieee80211_set_beacon,
-	.del_beacon = ieee80211_del_beacon,
+	.start_ap = ieee80211_start_ap,
+	.change_beacon = ieee80211_change_beacon,
+	.stop_ap = ieee80211_stop_ap,
 	.add_station = ieee80211_add_station,
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
--- a/net/mac80211/ieee80211_i.h	2012-02-12 17:53:59.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-02-13 15:10:27.000000000 +0100
@@ -228,7 +228,7 @@ struct ieee80211_rx_data {
 struct beacon_data {
 	u8 *head, *tail;
 	int head_len, tail_len;
-	int dtim_period;
+	struct rcu_head rcu_head;
 };
 
 struct ieee80211_if_ap {
--- a/net/mac80211/tx.c	2012-02-07 23:52:34.000000000 +0100
+++ b/net/mac80211/tx.c	2012-02-13 15:10:27.000000000 +0100
@@ -2206,7 +2206,8 @@ void ieee80211_tx_pending(unsigned long
 
 /* functions for drivers to get certain frames */
 
-static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
+static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_if_ap *bss,
 				     struct sk_buff *skb,
 				     struct beacon_data *beacon)
 {
@@ -2223,7 +2224,7 @@ static void ieee80211_beacon_add_tim(str
 					  IEEE80211_MAX_AID+1);
 
 	if (bss->dtim_count == 0)
-		bss->dtim_count = beacon->dtim_period - 1;
+		bss->dtim_count = sdata->vif.bss_conf.dtim_period - 1;
 	else
 		bss->dtim_count--;
 
@@ -2231,7 +2232,7 @@ static void ieee80211_beacon_add_tim(str
 	*pos++ = WLAN_EID_TIM;
 	*pos++ = 4;
 	*pos++ = bss->dtim_count;
-	*pos++ = beacon->dtim_period;
+	*pos++ = sdata->vif.bss_conf.dtim_period;
 
 	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
 		aid0 = 1;
@@ -2324,12 +2325,14 @@ struct sk_buff *ieee80211_beacon_get_tim
 			 * of the tim bitmap in mac80211 and the driver.
 			 */
 			if (local->tim_in_locked_section) {
-				ieee80211_beacon_add_tim(ap, skb, beacon);
+				ieee80211_beacon_add_tim(sdata, ap, skb,
+							 beacon);
 			} else {
 				unsigned long flags;
 
 				spin_lock_irqsave(&local->tim_lock, flags);
-				ieee80211_beacon_add_tim(ap, skb, beacon);
+				ieee80211_beacon_add_tim(sdata, ap, skb,
+							 beacon);
 				spin_unlock_irqrestore(&local->tim_lock, flags);
 			}
 
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c	2012-02-12 17:53:59.000000000 +0100
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c	2012-02-13 15:13:21.000000000 +0100
@@ -2269,25 +2269,11 @@ static int ath6kl_set_ap_probe_resp_ies(
 	return ret;
 }
 
-static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
-			    struct beacon_parameters *info, bool add)
+static int ath6kl_set_ies(struct ath6kl_vif *vif,
+			  struct cfg80211_beacon_data *info)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
-	struct ath6kl_vif *vif = netdev_priv(dev);
-	struct ieee80211_mgmt *mgmt;
-	u8 *ies;
-	int ies_len;
-	struct wmi_connect_cmd p;
+	struct ath6kl *ar = vif->ar;
 	int res;
-	int i, ret;
-
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: add=%d\n", __func__, add);
-
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
-
-	if (vif->next_mode != AP_NETWORK)
-		return -EOPNOTSUPP;
 
 	if (info->beacon_ies) {
 		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
@@ -2297,12 +2283,14 @@ static int ath6kl_ap_beacon(struct wiphy
 		if (res)
 			return res;
 	}
+
 	if (info->proberesp_ies) {
 		res = ath6kl_set_ap_probe_resp_ies(vif, info->proberesp_ies,
 						   info->proberesp_ies_len);
 		if (res)
 			return res;
 	}
+
 	if (info->assocresp_ies) {
 		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
 					       WMI_FRAME_ASSOC_RESP,
@@ -2312,8 +2300,30 @@ static int ath6kl_ap_beacon(struct wiphy
 			return res;
 	}
 
-	if (!add)
-		return 0;
+	return 0;
+}
+
+static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_ap_settings *info)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ieee80211_mgmt *mgmt;
+	u8 *ies;
+	int ies_len;
+	struct wmi_connect_cmd p;
+	int res;
+	int i, ret;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s:\n", __func__);
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	if (vif->next_mode != AP_NETWORK)
+		return -EOPNOTSUPP;
+
+	res = ath6kl_set_ies(vif, &info->beacon);
 
 	ar->ap_mode_bkey.valid = false;
 
@@ -2322,13 +2332,13 @@ static int ath6kl_ap_beacon(struct wiphy
 	 * info->dtim_period
 	 */
 
-	if (info->head == NULL)
+	if (info->beacon.head == NULL)
 		return -EINVAL;
-	mgmt = (struct ieee80211_mgmt *) info->head;
+	mgmt = (struct ieee80211_mgmt *) info->beacon.head;
 	ies = mgmt->u.beacon.variable;
-	if (ies > info->head + info->head_len)
+	if (ies > info->beacon.head + info->beacon.head_len)
 		return -EINVAL;
-	ies_len = info->head + info->head_len - ies;
+	ies_len = info->beacon.head + info->beacon.head_len - ies;
 
 	if (info->ssid == NULL)
 		return -EINVAL;
@@ -2436,19 +2446,21 @@ static int ath6kl_ap_beacon(struct wiphy
 	return 0;
 }
 
-static int ath6kl_add_beacon(struct wiphy *wiphy, struct net_device *dev,
-			     struct beacon_parameters *info)
+static int ath6kl_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+				struct cfg80211_beacon_data *beacon)
 {
-	return ath6kl_ap_beacon(wiphy, dev, info, true);
-}
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
-static int ath6kl_set_beacon(struct wiphy *wiphy, struct net_device *dev,
-			     struct beacon_parameters *info)
-{
-	return ath6kl_ap_beacon(wiphy, dev, info, false);
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	if (vif->next_mode != AP_NETWORK)
+		return -EOPNOTSUPP;
+
+	return ath6kl_set_ies(vif, beacon);
 }
 
-static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
+static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
@@ -2783,9 +2795,9 @@ static struct cfg80211_ops ath6kl_cfg802
 	.resume = __ath6kl_cfg80211_resume,
 #endif
 	.set_channel = ath6kl_set_channel,
-	.add_beacon = ath6kl_add_beacon,
-	.set_beacon = ath6kl_set_beacon,
-	.del_beacon = ath6kl_del_beacon,
+	.start_ap = ath6kl_start_ap,
+	.change_beacon = ath6kl_change_beacon,
+	.stop_ap = ath6kl_stop_ap,
 	.del_station = ath6kl_del_station,
 	.change_station = ath6kl_change_station,
 	.remain_on_channel = ath6kl_remain_on_channel,


