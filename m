Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49810 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbZCSLsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 07:48:21 -0400
Message-Id: <20090319114808.301521477@atheros.com> (sfid-20090319_124825_103710_5892E175)
References: <20090319113918.555693846@atheros.com>
Date: Thu, 19 Mar 2009 13:39:22 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 4/4] nl80211: Add MLME primitives to support external SME
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new nl80211 commands to allow user space to request
authentication and association (and also deauthentication and
disassociation). The commands are structured to allow separate
authentication and association steps, i.e., the interface between
kernel and user space is similar to the MLME SAP interface in IEEE
802.11 standard and an user space application takes the role of the
SME.

The patch introduces MLME-AUTHENTICATE.request,
MLME-{,RE}ASSOCIATE.request, MLME-DEAUTHENTICATE.request, and
MLME-DISASSOCIATE.request primitives. The authentication and
association commands request the actual operations in two steps
(assuming the driver supports this; if not, separate authentication
step is skipped; this could end up being a separate "connect"
command).

The initial implementation for mac80211 uses the current
net/mac80211/mlme.c for actual sending and processing of management
frames and the new nl80211 commands will just stop the current state
machine from moving automatically from authentication to association.
Future cleanup may move more of the MLME operations into cfg80211.

The goal of this design is to provide more control of authentication and
association process to user space without having to move the full MLME
implementation. This should be enough to allow IEEE 802.11r FT protocol
and 802.11s SAE authentication to be implemented. Obviously, this will
also bring the extra benefit of not having to use WEXT for association
requests with mac80211. An example implementation of a user space SME
using the new nl80211 commands is available for wpa_supplicant.

This patch is enough to get IEEE 802.11r FT protocol working with
over-the-air mechanism (over-the-DS will need additional MLME
primitives for handling the FT Action frames).

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/ieee80211.h  |    1 
 include/linux/nl80211.h    |   58 ++++++++--
 include/net/cfg80211.h     |  113 +++++++++++++++++++
 net/mac80211/cfg.c         |  140 ++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    7 +
 net/mac80211/mlme.c        |   45 ++++++-
 net/mac80211/wext.c        |    3 
 net/wireless/nl80211.c     |  255 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 601 insertions(+), 21 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-03-19 12:01:16.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-03-19 12:01:47.000000000 +0200
@@ -161,24 +161,37 @@
  * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
  * 	to (%NL80211_ATTR_REG_ALPHA2).
  *
- * @NL80211_CMD_AUTHENTICATE: authentication notification (on the "mlme"
- *	multicast group). This event reports reception of an Authentication
+ * @NL80211_CMD_AUTHENTICATE: authentication request and notification.
+ *	This command is used both as a command (request to authenticate) and
+ *	as an event on the "mlme" multicast group indicating completion of the
+ *	authentication process.
+ *	When used as a command, %NL80211_ATTR_IFINDEX is used to identify the
+ *	interface. %NL80211_ATTR_MAC is used to specify PeerSTAAddress (and
+ *	BSSID in case of station mode). %NL80211_ATTR_SSID is used to specify
+ *	the SSID (mainly for association, but is included in authentication
+ *	request, too, to help BSS selection. %NL80211_ATTR_WIPHY_FREQ is used
+ *	to specify the frequence of the channel in MHz. %NL80211_ATTR_AUTH_TYPE
+ *	is used to specify the authentication type. %NL80211_ATTR_IE is used to
+ *	define IEs (VendorSpecificInfo, but also including RSN IE and FT IEs)
+ *	to be added to the frame.
+ *	When used as an event, this reports reception of an Authentication
  *	frame in station and IBSS modes when the local MLME processed the
  *	frame, i.e., it was for the local STA and was received in correct
  *	state. This is similar to MLME-AUTHENTICATE.confirm primitive in the
  *	MLME SAP interface (kernel providing MLME, userspace SME). The
  *	included NL80211_ATTR_FRAME attribute contains the management frame
  *	(including both the header and frame body, but not FCS).
- * @NL80211_CMD_ASSOCIATE: association notification; like
- *	NL80211_CMD_AUTHENTICATE but for Association Response and Reassociation
- *	Response frames (similar to MLME-ASSOCIATE.confirm or
- *	MLME-REASSOCIATE.confirm primitives).
- * @NL80211_CMD_DEAUTHENTICATE: deauthentication notification; like
+ * @NL80211_CMD_ASSOCIATE: association request and notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Association and Reassociation
+ *	(similar to MLME-ASSOCIATE.request, MLME-REASSOCIATE.request,
+ *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitives).
+ * @NL80211_CMD_DEAUTHENTICATE: deauthentication request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
- *	MLME-DEAUTHENTICATE.indication primitive).
- * @NL80211_CMD_DISASSOCIATE: disassociation notification; like
+ *	MLME-DEAUTHENTICATION.request and MLME-DEAUTHENTICATE.indication
+ *	primitives).
+ * @NL80211_CMD_DISASSOCIATE: disassociation request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Disassociation frames (similar to
- *	MLME-DISASSOCIATE.indication primitive).
+ *	MLME-DISASSOCIATE.request and MLME-DISASSOCIATE.indication primitives).
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -383,6 +396,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame header
  *	and body, but not FCS; used, e.g., with NL80211_CMD_AUTHENTICATE and
  *	NL80211_CMD_ASSOCIATE events
+ * @NL80211_ATTR_SSID: SSID (binary attribute, 0..32 octets)
+ * @NL80211_ATTR_AUTH_TYPE: AuthenticationType, see &enum nl80211_auth_type,
+ *	represented as a u32
+ * @NL80211_ATTR_REASON_CODE: ReasonCode for %NL80211_CMD_DEAUTHENTICATE and
+ *	%NL80211_CMD_DISASSOCIATE, u16
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -464,6 +482,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_SUPPORTED_COMMANDS,
 
 	NL80211_ATTR_FRAME,
+	NL80211_ATTR_SSID,
+	NL80211_ATTR_AUTH_TYPE,
+	NL80211_ATTR_REASON_CODE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -485,6 +506,9 @@ enum nl80211_attrs {
 #define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
 #define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
 #define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
+#define NL80211_ATTR_SSID NL80211_ATTR_SSID
+#define NL80211_ATTR_AUTH_TYPE NL80211_ATTR_AUTH_TYPE
+#define NL80211_ATTR_REASON_CODE NL80211_ATTR_REASON_CODE
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -1018,4 +1042,18 @@ enum nl80211_bss {
 	NL80211_BSS_MAX = __NL80211_BSS_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_auth_type - AuthenticationType
+ *
+ * @NL80211_AUTHTYPE_OPEN_SYSTEM: Open System authentication
+ * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
+ * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
+ * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ */
+enum nl80211_auth_type {
+	NL80211_AUTHTYPE_OPEN_SYSTEM,
+	NL80211_AUTHTYPE_SHARED_KEY,
+	NL80211_AUTHTYPE_FT,
+	NL80211_AUTHTYPE_NETWORK_EAP,
+};
 #endif /* __LINUX_NL80211_H */
--- uml.orig/include/net/cfg80211.h	2009-03-19 12:01:16.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-03-19 12:01:47.000000000 +0200
@@ -579,6 +579,105 @@ struct cfg80211_bss {
 };
 
 /**
+ * struct cfg80211_auth_request - Authentication request data
+ *
+ * This structure provides information needed to complete IEEE 802.11
+ * authentication.
+ * NOTE: This structure will likely change when more code from mac80211 is
+ * moved into cfg80211 so that non-mac80211 drivers can benefit from it, too.
+ * Before using this in a driver that does not use mac80211, it would be better
+ * to check the status of that work and better yet, volunteer to work on it.
+ *
+ * @chan: The channel to use or %NULL if not specified (auto-select based on
+ *	scan results)
+ * @peer_addr: The address of the peer STA (AP BSSID in infrastructure case);
+ *	this field is required to be present; if the driver wants to help with
+ *	BSS selection, it should use (yet to be added) MLME event to allow user
+ *	space SME to be notified of roaming candidate, so that the SME can then
+ *	use the authentication request with the recommended BSSID and whatever
+ *	other data may be needed for authentication/association
+ * @ssid: SSID or %NULL if not yet available
+ * @ssid_len: Length of ssid in octets
+ * @auth_type: Authentication type (algorithm)
+ * @ie: Extra IEs to add to Authentication frame or %NULL
+ * @ie_len: Length of ie buffer in octets
+ */
+struct cfg80211_auth_request {
+	struct ieee80211_channel *chan;
+	u8 *peer_addr;
+	const u8 *ssid;
+	size_t ssid_len;
+	enum nl80211_auth_type auth_type;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+/**
+ * struct cfg80211_assoc_request - (Re)Association request data
+ *
+ * This structure provides information needed to complete IEEE 802.11
+ * (re)association.
+ * NOTE: This structure will likely change when more code from mac80211 is
+ * moved into cfg80211 so that non-mac80211 drivers can benefit from it, too.
+ * Before using this in a driver that does not use mac80211, it would be better
+ * to check the status of that work and better yet, volunteer to work on it.
+ *
+ * @chan: The channel to use or %NULL if not specified (auto-select based on
+ *	scan results)
+ * @peer_addr: The address of the peer STA (AP BSSID); this field is required
+ *	to be present and the STA must be in State 2 (authenticated) with the
+ *	peer STA
+ * @ssid: SSID
+ * @ssid_len: Length of ssid in octets
+ * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
+ * @ie_len: Length of ie buffer in octets
+ */
+struct cfg80211_assoc_request {
+	struct ieee80211_channel *chan;
+	u8 *peer_addr;
+	const u8 *ssid;
+	size_t ssid_len;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+/**
+ * struct cfg80211_deauth_request - Deauthentication request data
+ *
+ * This structure provides information needed to complete IEEE 802.11
+ * deauthentication.
+ *
+ * @peer_addr: The address of the peer STA (AP BSSID); this field is required
+ *	to be present and the STA must be authenticated with the peer STA
+ * @ie: Extra IEs to add to Deauthentication frame or %NULL
+ * @ie_len: Length of ie buffer in octets
+ */
+struct cfg80211_deauth_request {
+	u8 *peer_addr;
+	u16 reason_code;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+/**
+ * struct cfg80211_disassoc_request - Disassociation request data
+ *
+ * This structure provides information needed to complete IEEE 802.11
+ * disassocation.
+ *
+ * @peer_addr: The address of the peer STA (AP BSSID); this field is required
+ *	to be present and the STA must be associated with the peer STA
+ * @ie: Extra IEs to add to Disassociation frame or %NULL
+ * @ie_len: Length of ie buffer in octets
+ */
+struct cfg80211_disassoc_request {
+	u8 *peer_addr;
+	u16 reason_code;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -650,6 +749,11 @@ struct cfg80211_bss {
  *	the driver, and will be valid until passed to cfg80211_scan_done().
  *	For scan results, call cfg80211_inform_bss(); you can call this outside
  *	the scan/scan_done bracket too.
+ *
+ * @auth: Request to authenticate with the specified peer
+ * @assoc: Request to (re)associate with the specified peer
+ * @deauth: Request to deauthenticate from the specified peer
+ * @disassoc: Request to disassociate from the specified peer
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -730,6 +834,15 @@ struct cfg80211_ops {
 
 	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
+
+	int	(*auth)(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_auth_request *req);
+	int	(*assoc)(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_assoc_request *req);
+	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev,
+			  struct cfg80211_deauth_request *req);
+	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
+			    struct cfg80211_disassoc_request *req);
 };
 
 /* temporary wext handlers */
--- uml.orig/net/wireless/nl80211.c	2009-03-19 12:01:16.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-19 12:01:47.000000000 +0200
@@ -111,6 +111,11 @@ static struct nla_policy nl80211_policy[
 			      .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_SCAN_FREQUENCIES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SSIDS] = { .type = NLA_NESTED },
+
+	[NL80211_ATTR_SSID] = { .type = NLA_BINARY,
+				.len = IEEE80211_MAX_SSID_LEN },
+	[NL80211_ATTR_AUTH_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U16 },
 };
 
 /* message building helper */
@@ -265,6 +270,10 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(set_mesh_params, SET_MESH_PARAMS);
 	CMD(change_bss, SET_BSS);
 	CMD(set_mgmt_extra_ie, SET_MGMT_EXTRA_IE);
+	CMD(auth, AUTHENTICATE);
+	CMD(assoc, ASSOCIATE);
+	CMD(deauth, DEAUTHENTICATE);
+	CMD(disassoc, DISASSOCIATE);
 
 #undef CMD
 	nla_nest_end(msg, nl_cmds);
@@ -2635,6 +2644,228 @@ static int nl80211_dump_scan(struct sk_b
 	return err;
 }
 
+static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_auth_request req;
+	struct wiphy *wiphy;
+	int err;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!drv->ops->auth) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		req.chan = ieee80211_get_channel(
+			wiphy,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+		if (!req.chan) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (info->attrs[NL80211_ATTR_SSID]) {
+		req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+		req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+	}
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
+		req.auth_type =
+			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+	}
+
+	err = drv->ops->auth(&drv->wiphy, dev, &req);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_assoc_request req;
+	struct wiphy *wiphy;
+	int err;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!drv->ops->assoc) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_SSID]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		req.chan = ieee80211_get_channel(
+			wiphy,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+		if (!req.chan) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (nla_len(info->attrs[NL80211_ATTR_SSID]) > IEEE80211_MAX_SSID_LEN) {
+		err = -EINVAL;
+		goto out;
+	}
+	req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	err = drv->ops->assoc(&drv->wiphy, dev, &req);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_deauth_request req;
+	struct wiphy *wiphy;
+	int err;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!drv->ops->deauth) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_REASON_CODE])
+		req.reason_code =
+			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	err = drv->ops->deauth(&drv->wiphy, dev, &req);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_disassoc_request req;
+	struct wiphy *wiphy;
+	int err;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!drv->ops->disassoc) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_REASON_CODE])
+		req.reason_code =
+			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	err = drv->ops->disassoc(&drv->wiphy, dev, &req);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -2818,6 +3049,30 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.dumpit = nl80211_dump_scan,
 	},
+	{
+		.cmd = NL80211_CMD_AUTHENTICATE,
+		.doit = nl80211_authenticate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_ASSOCIATE,
+		.doit = nl80211_associate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEAUTHENTICATE,
+		.doit = nl80211_deauthenticate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DISASSOCIATE,
+		.doit = nl80211_disassociate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
--- uml.orig/net/mac80211/cfg.c	2009-03-19 12:01:16.000000000 +0200
+++ uml/net/mac80211/cfg.c	2009-03-19 12:01:47.000000000 +0200
@@ -1300,6 +1300,142 @@ static int ieee80211_scan(struct wiphy *
 	return ieee80211_request_scan(sdata, req);
 }
 
+static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
+			  struct cfg80211_auth_request *req)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	switch (req->auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_OPEN;
+		break;
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_SHARED_KEY;
+		break;
+	case NL80211_AUTHTYPE_FT:
+		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_FT;
+		break;
+	case NL80211_AUTHTYPE_NETWORK_EAP:
+		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_LEAP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
+	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+
+	/* TODO: req->chan */
+	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+
+	if (req->ssid) {
+		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
+		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
+		sdata->u.mgd.ssid_len = req->ssid_len;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
+	}
+
+	kfree(sdata->u.mgd.sme_auth_ie);
+	sdata->u.mgd.sme_auth_ie = NULL;
+	sdata->u.mgd.sme_auth_ie_len = 0;
+	if (req->ie) {
+		sdata->u.mgd.sme_auth_ie = kmalloc(req->ie_len, GFP_KERNEL);
+		if (sdata->u.mgd.sme_auth_ie == NULL)
+			return -ENOMEM;
+		memcpy(sdata->u.mgd.sme_auth_ie, req->ie, req->ie_len);
+		sdata->u.mgd.sme_auth_ie_len = req->ie_len;
+	}
+
+	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
+	sdata->u.mgd.state = IEEE80211_STA_MLME_DIRECT_PROBE;
+	ieee80211_sta_req_auth(sdata);
+	return 0;
+}
+
+static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_assoc_request *req)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int ret;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0 ||
+	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
+		return -ENOLINK; /* not authenticated */
+
+	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+
+	/* TODO: req->chan */
+	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+
+	if (req->ssid) {
+		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
+		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
+		sdata->u.mgd.ssid_len = req->ssid_len;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
+	} else
+		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
+
+	ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
+	if (ret)
+		return ret;
+
+	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
+	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
+	ieee80211_sta_req_auth(sdata);
+	return 0;
+}
+
+static int ieee80211_deauth(struct wiphy *wiphy, struct net_device *dev,
+			    struct cfg80211_deauth_request *req)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	/* TODO: req->ie */
+	return ieee80211_sta_deauthenticate(sdata, req->reason_code);
+}
+
+static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_disassoc_request *req)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	/* TODO: req->ie */
+	return ieee80211_sta_disassociate(sdata, req->reason_code);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1333,4 +1469,8 @@ struct cfg80211_ops mac80211_config_ops 
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
+	.auth = ieee80211_auth,
+	.assoc = ieee80211_assoc,
+	.deauth = ieee80211_deauth,
+	.disassoc = ieee80211_disassoc,
 };
--- uml.orig/net/mac80211/ieee80211_i.h	2009-03-19 12:01:16.000000000 +0200
+++ uml/net/mac80211/ieee80211_i.h	2009-03-19 12:01:47.000000000 +0200
@@ -256,6 +256,7 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
 #define IEEE80211_STA_CSA_RECEIVED	BIT(15)
 #define IEEE80211_STA_MFP_ENABLED	BIT(16)
+#define IEEE80211_STA_EXT_SME		BIT(17)
 /* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_DIRECT_PROBE 1
@@ -266,6 +267,7 @@ struct mesh_preq_queue {
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
 #define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
 #define IEEE80211_AUTH_ALG_LEAP BIT(2)
+#define IEEE80211_AUTH_ALG_FT BIT(3)
 
 struct ieee80211_if_managed {
 	struct timer_list timer;
@@ -335,6 +337,9 @@ struct ieee80211_if_managed {
 	size_t ie_deauth_len;
 	u8 *ie_disassoc;
 	size_t ie_disassoc_len;
+
+	u8 *sme_auth_ie;
+	size_t sme_auth_ie_len;
 };
 
 enum ieee80211_ibss_flags {
@@ -970,7 +975,7 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 		  struct sk_buff *skb,
 		  struct ieee80211_rx_status *rx_status);
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
-			       char *ie, size_t len);
+			       const char *ie, size_t len);
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_scan_failed(struct ieee80211_local *local);
--- uml.orig/net/mac80211/mlme.c	2009-03-19 12:01:42.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-03-19 12:01:47.000000000 +0200
@@ -730,6 +730,8 @@ static void ieee80211_authenticate(struc
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
+	u8 *ies;
+	size_t ies_len;
 
 	ifmgd->auth_tries++;
 	if (ifmgd->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -755,7 +757,14 @@ static void ieee80211_authenticate(struc
 	printk(KERN_DEBUG "%s: authenticate with AP %pM\n",
 	       sdata->dev->name, ifmgd->bssid);
 
-	ieee80211_send_auth(sdata, 1, ifmgd->auth_alg, NULL, 0,
+	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
+		ies = ifmgd->sme_auth_ie;
+		ies_len = ifmgd->sme_auth_ie_len;
+	} else {
+		ies = NULL;
+		ies_len = 0;
+	}
+	ieee80211_send_auth(sdata, 1, ifmgd->auth_alg, ies, ies_len,
 			    ifmgd->bssid, 0);
 	ifmgd->auth_transaction = 2;
 
@@ -870,7 +879,8 @@ static int ieee80211_privacy_mismatch(st
 	int wep_privacy;
 	int privacy_invoked;
 
-	if (!ifmgd || (ifmgd->flags & IEEE80211_STA_MIXED_CELL))
+	if (!ifmgd || (ifmgd->flags & (IEEE80211_STA_MIXED_CELL |
+				       IEEE80211_STA_EXT_SME)))
 		return 0;
 
 	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
@@ -998,7 +1008,11 @@ static void ieee80211_auth_completed(str
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
 	ifmgd->flags |= IEEE80211_STA_AUTHENTICATED;
-	ieee80211_associate(sdata);
+	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
+		/* Wait for SME to request association */
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+	} else
+		ieee80211_associate(sdata);
 }
 
 
@@ -1084,6 +1098,7 @@ static void ieee80211_rx_mgmt_auth(struc
 	switch (ifmgd->auth_alg) {
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
+	case WLAN_AUTH_FT:
 		ieee80211_auth_completed(sdata);
 		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
 		break;
@@ -1117,9 +1132,10 @@ static void ieee80211_rx_mgmt_deauth(str
 		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (ifmgd->state == IEEE80211_STA_MLME_AUTHENTICATE ||
-	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATE ||
-	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
+	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
+	    (ifmgd->state == IEEE80211_STA_MLME_AUTHENTICATE ||
+	     ifmgd->state == IEEE80211_STA_MLME_ASSOCIATE ||
+	     ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)) {
 		ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 		mod_timer(&ifmgd->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
@@ -1150,7 +1166,8 @@ static void ieee80211_rx_mgmt_disassoc(s
 		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
+	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
+	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
 		ifmgd->state = IEEE80211_STA_MLME_ASSOCIATE;
 		mod_timer(&ifmgd->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
@@ -1664,6 +1681,8 @@ static void ieee80211_sta_reset_auth(str
 		ifmgd->auth_alg = WLAN_AUTH_SHARED_KEY;
 	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_LEAP)
 		ifmgd->auth_alg = WLAN_AUTH_LEAP;
+	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_FT)
+		ifmgd->auth_alg = WLAN_AUTH_FT;
 	else
 		ifmgd->auth_alg = WLAN_AUTH_OPEN;
 	ifmgd->auth_transaction = -1;
@@ -1687,7 +1706,8 @@ static int ieee80211_sta_config_auth(str
 	u16 capa_val = WLAN_CAPABILITY_ESS;
 	struct ieee80211_channel *chan = local->oper_channel;
 
-	if (ifmgd->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
+	    ifmgd->flags & (IEEE80211_STA_AUTO_SSID_SEL |
 			    IEEE80211_STA_AUTO_BSSID_SEL |
 			    IEEE80211_STA_AUTO_CHANNEL_SEL)) {
 		capa_mask |= WLAN_CAPABILITY_PRIVACY;
@@ -1884,7 +1904,11 @@ void ieee80211_sta_req_auth(struct ieee8
 			ieee80211_set_disassoc(sdata, true, true,
 					       WLAN_REASON_DEAUTH_LEAVING);
 
-		set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
+		if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) ||
+		    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE)
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
+		else if (ifmgd->flags & IEEE80211_STA_EXT_SME)
+			set_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
 		queue_work(local->hw.workqueue, &ifmgd->work);
 	}
 }
@@ -1953,7 +1977,8 @@ int ieee80211_sta_set_bssid(struct ieee8
 	return ieee80211_sta_commit(sdata);
 }
 
-int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
+			       const char *ie, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
--- uml.orig/net/mac80211/wext.c	2009-03-19 12:01:16.000000000 +0200
+++ uml/net/mac80211/wext.c	2009-03-19 12:01:47.000000000 +0200
@@ -137,6 +137,7 @@ static int ieee80211_ioctl_siwgenie(stru
 		if (ret)
 			return ret;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
@@ -224,6 +225,7 @@ static int ieee80211_ioctl_siwessid(stru
 		if (ret)
 			return ret;
 
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
@@ -287,6 +289,7 @@ static int ieee80211_ioctl_siwap(struct 
 		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 		if (ret)
 			return ret;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
--- uml.orig/include/linux/ieee80211.h	2009-03-19 12:01:16.000000000 +0200
+++ uml/include/linux/ieee80211.h	2009-03-19 12:01:47.000000000 +0200
@@ -867,6 +867,7 @@ struct ieee80211_ht_info {
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
+#define WLAN_AUTH_FT 2
 #define WLAN_AUTH_LEAP 128
 
 #define WLAN_AUTH_CHALLENGE_LEN 128

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
