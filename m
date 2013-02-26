Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47296 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3BZKiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 05:38:25 -0500
Date: Tue, 26 Feb 2013 12:38:19 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCHv2] cfg80211: Extend support for IEEE 802.11r Fast BSS
 Transition
Message-ID: <20130226103819.GA5630@jouni.qca.qualcomm.com> (sfid-20130226_113830_685187_38051A01)
References: <20130221060843.GA24491@w1.fi>
 <1361565394.3420.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1361565394.3420.17.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_CMD_UPDATE_FT_IES to support update of FT IEs to the WLAN
driver and NL80211_CMD_FT_EVENT to send FT events from the WLAN driver.
This will carry the target AP's MAC address along with the relevant
Information Elements. This event is used to report received FT IEs
(MDIE, FTIE, RSN IE, TIE, RICIE). These changes allow FT to be supported
with drivers that use an internal SME instead of user space option (like
FT implementation in wpa_supplicant with mac80211-based drivers).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   41 +++++++++++++++++++++++
 include/uapi/linux/nl80211.h |   19 +++++++++++
 net/wireless/nl80211.c       |   74 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

v2 - Updates based on comments from Johannes:
- Remove return value from cfg80211_ft_event()
  (caller cannot do much with it)
- add is_valid_ie_attr() validation
- merge cfg80211_ft_event() into nl80211_ft_event()
- require target_ap in ft_event


diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa26129..57aa540 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1722,6 +1722,21 @@ struct cfg80211_gtk_rekey_data {
 };
 
 /**
+ * struct cfg80211_update_ft_ies_params - FT IE Information
+ *
+ * This structure provides information needed to update the fast transition IE
+ *
+ * @md: The Mobility Domain ID, 2 Octet value
+ * @ie: Fast Transition IEs
+ * @ie_len: Length of ft_ie in octets
+ */
+struct cfg80211_update_ft_ies_params {
+	u16 md;
+	u8 *ie;
+	size_t ie_len;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2168,6 +2183,8 @@ struct cfg80211_ops {
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 struct cfg80211_chan_def *chandef);
+	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
+				 struct cfg80211_update_ft_ies_params *ftie);
 };
 
 /*
@@ -4002,6 +4019,30 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate);
 void cfg80211_unregister_wdev(struct wireless_dev *wdev);
 
 /**
+ * struct cfg80211_ft_event - FT Information Elements
+ * @ies: FT IEs
+ * @ies_len: length of the FT IE in bytes
+ * @target_ap: target AP's MAC address
+ * @ric_ies: RIC IE
+ * @ric_ies_len: length of the RIC IE in bytes
+ */
+struct cfg80211_ft_event_params {
+	u8 *ies;
+	size_t ies_len;
+	u8 *target_ap;
+	u8 *ric_ies;
+	size_t ric_ies_len;
+};
+
+/**
+ * cfg80211_ft_event - notify userspace about FT IE and RIC IE
+ * @netdev: network device
+ * @ft_event: IE information
+ */
+void cfg80211_ft_event(struct net_device *netdev,
+		       struct cfg80211_ft_event_params *ft_event);
+
+/**
  * cfg80211_get_p2p_attr - find and copy a P2P attribute from IE buffer
  * @ies: the input IE buffer
  * @len: the input length
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c46bb01..9abb3df 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -611,6 +611,14 @@
  *	%NL80211_ATTR_RADAR_EVENT is used to inform about the type of the
  *	event.
  *
+ * @NL80211_CMD_UPDATE_FT_IES: Pass down the most up-to-date Fast Transition
+ *	Information Element to the WLAN driver
+ *
+ * @NL80211_CMD_FT_EVENT: Send a Fast transition event from the WLAN driver
+ *	to the supplicant. This will carry the target AP's MAC address along
+ *	with the relevant Information Elements. This event is used to report
+ *	received FT IEs (MDIE, FTIE, RSN IE, TIE, RICIE).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -765,6 +773,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_RADAR_DETECT,
 
+	NL80211_CMD_UPDATE_FT_IES,
+	NL80211_CMD_FT_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1368,6 +1379,11 @@ enum nl80211_commands {
  *	advertised to the driver, e.g., to enable TDLS off channel operations
  *	and PU-APSD.
  *
+ * @NL80211_ATTR_MDID: Mobility Domain Identifier
+ *
+ * @NL80211_ATTR_IE_RIC: Resource Information Container Information
+ *	Element
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1654,6 +1670,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_CAPABILITY,
 	NL80211_ATTR_STA_EXT_CAPABILITY,
 
+	NL80211_ATTR_MDID,
+	NL80211_ATTR_IE_RIC,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 35545cc..4c61c5e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -370,6 +370,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_CAPABILITY] = { .type = NLA_U16 },
 	[NL80211_ATTR_STA_EXT_CAPABILITY] = { .type = NLA_BINARY, },
+	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
+	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
+				  .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -7823,6 +7826,27 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_update_ft_ies_params ft_params;
+	struct net_device *dev = info->user_ptr[1];
+
+	if (!rdev->ops->update_ft_ies)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MDID] ||
+	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	memset(&ft_params, 0, sizeof(ft_params));
+	ft_params.md = nla_get_u16(info->attrs[NL80211_ATTR_MDID]);
+	ft_params.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+	ft_params.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+
+	return rdev->ops->update_ft_ies(&rdev->wiphy, dev, &ft_params);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -8499,6 +8523,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_UPDATE_FT_IES,
+		.doit = nl80211_update_ft_ies,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -10075,6 +10107,48 @@ static struct notifier_block nl80211_netlink_notifier = {
 	.notifier_call = nl80211_netlink_notify,
 };
 
+void cfg80211_ft_event(struct net_device *netdev,
+		       struct cfg80211_ft_event_params *ft_event)
+{
+	struct wiphy *wiphy = netdev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	if (!ft_event->target_ap)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FT_EVENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, ft_event->target_ap);
+	if (ft_event->ies)
+		nla_put(msg, NL80211_ATTR_IE, ft_event->ies_len, ft_event->ies);
+	if (ft_event->ric_ies)
+		nla_put(msg, NL80211_ATTR_IE_RIC, ft_event->ric_ies_len,
+			ft_event->ric_ies);
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+}
+EXPORT_SYMBOL(cfg80211_ft_event);
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
-- 
1.7.9.5

-- 
Jouni Malinen                                            PGP id EFC895FA
