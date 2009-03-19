Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49807 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbZCSLsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 07:48:15 -0400
Message-Id: <20090319114804.269481347@atheros.com> (sfid-20090319_124820_882892_7E7C08A4)
References: <20090319113918.555693846@atheros.com>
Date: Thu, 19 Mar 2009 13:39:21 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 3/4] nl80211: Event notifications for MLME events
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new nl80211 event notifications (and a new multicast group, "mlme")
for informing user space about received and processed Authentication,
(Re)Association Response, Deauthentication, and Disassociation frames in
station and IBSS modes (i.e., MLME SAP interface primitives
MLME-AUTHENTICATE.confirm, MLME-ASSOCIATE.confirm,
MLME-REASSOCIATE.confirm, MLME-DEAUTHENTICATE.indicate, and
MLME-DISASSOCIATE.indication). The event data is encapsulated as the 802.11
management frame since we already have the frame in that format and it
includes all the needed information.

This is the initial step in providing MLME SAP interface for
authentication and association with nl80211. In other words, kernel code
will act as the MLME and a user space application can control it as the
SME.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h |   36 +++++++++++++++++++++++-
 include/net/cfg80211.h  |   46 ++++++++++++++++++++++++++++++
 net/mac80211/mlme.c     |    9 ++++--
 net/wireless/Makefile   |    2 -
 net/wireless/mlme.c     |   46 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |   12 ++++++++
 7 files changed, 219 insertions(+), 4 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-03-19 00:18:28.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-03-19 12:01:16.000000000 +0200
@@ -161,6 +161,25 @@
  * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
  * 	to (%NL80211_ATTR_REG_ALPHA2).
  *
+ * @NL80211_CMD_AUTHENTICATE: authentication notification (on the "mlme"
+ *	multicast group). This event reports reception of an Authentication
+ *	frame in station and IBSS modes when the local MLME processed the
+ *	frame, i.e., it was for the local STA and was received in correct
+ *	state. This is similar to MLME-AUTHENTICATE.confirm primitive in the
+ *	MLME SAP interface (kernel providing MLME, userspace SME). The
+ *	included NL80211_ATTR_FRAME attribute contains the management frame
+ *	(including both the header and frame body, but not FCS).
+ * @NL80211_CMD_ASSOCIATE: association notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Association Response and Reassociation
+ *	Response frames (similar to MLME-ASSOCIATE.confirm or
+ *	MLME-REASSOCIATE.confirm primitives).
+ * @NL80211_CMD_DEAUTHENTICATE: deauthentication notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
+ *	MLME-DEAUTHENTICATE.indication primitive).
+ * @NL80211_CMD_DISASSOCIATE: disassociation notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Disassociation frames (similar to
+ *	MLME-DISASSOCIATE.indication primitive).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -217,6 +236,11 @@ enum nl80211_commands {
 
 	NL80211_CMD_REG_CHANGE,
 
+	NL80211_CMD_AUTHENTICATE,
+	NL80211_CMD_ASSOCIATE,
+	NL80211_CMD_DEAUTHENTICATE,
+	NL80211_CMD_DISASSOCIATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -230,8 +254,11 @@ enum nl80211_commands {
  */
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
-
 #define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+#define NL80211_CMD_AUTHENTICATE NL80211_CMD_AUTHENTICATE
+#define NL80211_CMD_ASSOCIATE NL80211_CMD_ASSOCIATE
+#define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
+#define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -353,6 +380,10 @@ enum nl80211_commands {
  *	an array of command numbers (i.e. a mapping index to command number)
  *	that the driver for the given wiphy supports.
  *
+ * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame header
+ *	and body, but not FCS; used, e.g., with NL80211_CMD_AUTHENTICATE and
+ *	NL80211_CMD_ASSOCIATE events
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -432,6 +463,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORTED_COMMANDS,
 
+	NL80211_ATTR_FRAME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -451,6 +484,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_IE NL80211_ATTR_IE
 #define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
 #define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
+#define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
--- uml.orig/include/net/cfg80211.h	2009-03-19 00:18:28.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-03-19 12:01:16.000000000 +0200
@@ -807,4 +807,50 @@ void cfg80211_put_bss(struct cfg80211_bs
  */
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 
+/**
+ * cfg80211_send_rx_auth - notification of processed authentication
+ * @dev: network device
+ * @buf: authentication frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever an authentication has been processed in
+ * station mode.
+ */
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
+
+/**
+ * cfg80211_send_rx_assoc - notification of processed association
+ * @dev: network device
+ * @buf: (re)association response frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever a (re)association response has been
+ * processed in station mode.
+ */
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
+
+/**
+ * cfg80211_send_rx_deauth - notification of processed deauthentication
+ * @dev: network device
+ * @buf: deauthentication frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever deauthentication has been processed in
+ * station mode.
+ */
+void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf,
+			     size_t len);
+
+/**
+ * cfg80211_send_rx_disassoc - notification of processed disassociation
+ * @dev: network device
+ * @buf: disassociation response frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever disassociation has been processed in
+ * station mode.
+ */
+void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
+			       size_t len);
+
 #endif /* __NET_CFG80211_H */
--- uml.orig/net/mac80211/mlme.c	2009-03-19 00:20:52.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-03-19 12:01:42.000000000 +0200
@@ -1085,11 +1085,13 @@ static void ieee80211_rx_mgmt_auth(struc
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
 		ieee80211_auth_completed(sdata);
+		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
 		break;
 	case WLAN_AUTH_SHARED_KEY:
-		if (ifmgd->auth_transaction == 4)
+		if (ifmgd->auth_transaction == 4) {
 			ieee80211_auth_completed(sdata);
-		else
+			cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
+		} else
 			ieee80211_auth_challenge(sdata, mgmt, len);
 		break;
 	}
@@ -1125,6 +1127,7 @@ static void ieee80211_rx_mgmt_deauth(str
 
 	ieee80211_set_disassoc(sdata, true, false, 0);
 	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
+	cfg80211_send_rx_deauth(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1154,6 +1157,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 	}
 
 	ieee80211_set_disassoc(sdata, false, false, reason_code);
+	cfg80211_send_rx_disassoc(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1370,6 +1374,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	ieee80211_set_associated(sdata, changed);
 
 	ieee80211_associated(sdata);
+	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
 }
 
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ uml/net/wireless/mlme.c	2009-03-19 00:20:59.000000000 +0200
@@ -0,0 +1,46 @@
+/*
+ * cfg80211 MLME SAP interface
+ *
+ * Copyright (c) 2009, Jouni Malinen <j@w1.fi>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/nl80211.h>
+#include <net/cfg80211.h>
+#include "core.h"
+#include "nl80211.h"
+
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_auth(rdev, dev, buf, len);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_auth);
+
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_assoc(rdev, dev, buf, len);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_assoc);
+
+void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_deauth(rdev, dev, buf, len);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_deauth);
+
+void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
+			       size_t len)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_disassoc(rdev, dev, buf, len);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_disassoc);
--- uml.orig/net/wireless/nl80211.c	2009-03-19 00:18:28.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-19 12:01:16.000000000 +0200
@@ -2819,6 +2819,9 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_scan,
 	},
 };
+static struct genl_multicast_group nl80211_mlme_mcgrp = {
+	.name = "mlme",
+};
 
 /* multicast groups */
 static struct genl_multicast_group nl80211_config_mcgrp = {
@@ -2964,6 +2967,71 @@ nla_put_failure:
 	nlmsg_free(msg);
 }
 
+static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev,
+				    const u8 *buf, size_t len,
+				    enum nl80211_commands cmd)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+			  struct net_device *netdev, const u8 *buf, size_t len)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_AUTHENTICATE);
+}
+
+void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev, const u8 *buf,
+			   size_t len)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len, NL80211_CMD_ASSOCIATE);
+}
+
+void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *buf,
+			    size_t len)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_DEAUTHENTICATE);
+}
+
+void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
+			      struct net_device *netdev, const u8 *buf,
+			      size_t len)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_DISASSOCIATE);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
@@ -2992,6 +3060,10 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_mlme_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
--- uml.orig/net/wireless/Makefile	2009-03-19 00:18:28.000000000 +0200
+++ uml/net/wireless/Makefile	2009-03-19 00:20:59.000000000 +0200
@@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- uml.orig/net/wireless/nl80211.h	2009-03-19 00:18:28.000000000 +0200
+++ uml/net/wireless/nl80211.h	2009-03-19 00:20:59.000000000 +0200
@@ -11,5 +11,17 @@ extern void nl80211_send_scan_done(struc
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
 extern void nl80211_send_reg_change_event(struct regulatory_request *request);
+extern void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev,
+				 const u8 *buf, size_t len);
+extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+				  struct net_device *netdev,
+				  const u8 *buf, size_t len);
+extern void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev,
+				   const u8 *buf, size_t len);
+extern void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     const u8 *buf, size_t len);
 
 #endif /* __NET_WIRELESS_NL80211_H */

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
