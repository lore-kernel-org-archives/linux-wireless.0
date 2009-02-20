Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56512 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZBTT0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:26:10 -0500
Date: Fri, 20 Feb 2009 21:25:57 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Authentication and association events
Message-ID: <20090220192557.GA17914@jm.kir.nu> (sfid-20090220_202634_407195_F5954741)
References: <20090218200210.GA13955@jm.kir.nu> <1234988740.4023.51.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234988740.4023.51.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:25:40PM +0100, Johannes Berg wrote:
> 
> > + * @NL80211_CMD_RX_AUTH: authentication notification (on the "mlme" multicast

> Shouldn't this specify that we send only frames that actually matter to
> us?

Yes.

> > +void cfg80211_send_rx_auth(struct wiphy *wiphy, struct net_device *dev,
> > +			   struct sk_buff *skb);

> The wiphy parameter is somewhat useless, you can get it from
> dev->ieee80211_ptr->wiphy. I'd also prefer to not pass the skb but
> rather data/len separately since (a) that is all we use, and (b) in case
> some fullmac driver later doesn't actually have this in skb form it can
> still "build" a frame and then pass it.

OK.

> > @@ -1592,12 +1593,15 @@ static void ieee80211_sta_rx_queued_mgmt
> >  		break;
> >  	case IEEE80211_STYPE_AUTH:
> >  		ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
> > +		cfg80211_send_rx_auth(local->hw.wiphy, sdata->dev, skb);
> >  		break;

> This seems somewhat wrong... imho we shouldn't be sending these events
> to userspace if we didn't act on the frames.

Agreed.

Here's an update version of the MLME event patch. In addition, I started
working on the MLME commands. The current work version of the changes is
included after the event patch. At this point, it is very early (i.e.,
builds, have not tested at all and there are known missing parts).
Anyway, it should show more details on how I was planning on getting the
initial version working.


nl80211: Event notifications for MLME events

Add new nl80211 event notifications (and a new multicast group, "mlme")
for informing user space about received and processed Authentication,
(Re)Association Response, Deauthentication, and Disassociation frames in
station and IBSS modes (i.e., MLME SAP interface primitives
MLME-AUTHENTICATE.confirm, MLME-ASSOCIATE.confirm,
MLME-REASSOCIATE.confirm, MLME-DEAUTHENTICATE.indicate, and
MLME-DISASSOCIATE.indication). The event data is encapsulated as the 802.11
management frame since we already have the frame in that format and it
includes all the needed information.

This is the first step in providing MLME SAP interface for
authentication and association with nl80211. In other words, kernel code
will act as the MLME and a user space application can control it as SME.

The next goal is to introduce MLME-AUTHENTICATE.request,
MLME-{,RE}ASSOCIATE.request, MLME-DEAUTHENTICATE.request, and
MLME-DISASSOCIATE.request primitives. The authentication and association
commands will request the actual operations in two steps (assuming the
driver supports this; if not, separate authentication step is skipped).

The initial implementation will likely end up using the current
net/mac80211/mlme.c for actual sending and processing of management
frames and the new nl80211 commands will just stop the current state
machine from moving automatically from authentication to association.
Future cleanup may move more of the MLME operations into cfg80211.

The goal of this design is to provide more control of authentication and
association process to user space without having to move the full MLME
implementation. This should be enough to allow IEEE 802.11r FT protocol
and 802.11s SAE authentication to be implemented. Obviously, this will
also bring the extra benefit of not having to use WEXT for association
requests with mac80211.

---
 include/linux/nl80211.h |   35 +++++++++++++++++++++++
 include/net/cfg80211.h  |   46 ++++++++++++++++++++++++++++++
 net/mac80211/mlme.c     |   10 +++++-
 net/wireless/Makefile   |    2 -
 net/wireless/mlme.c     |   46 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |   32 +++++++++++++++++++++
 7 files changed, 240 insertions(+), 3 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-02-18 20:48:00.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-02-20 20:45:34.000000000 +0200
@@ -150,6 +150,25 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
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
@@ -204,6 +223,11 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_AUTHENTICATE,
+	NL80211_CMD_ASSOCIATE,
+	NL80211_CMD_DEAUTHENTICATE,
+	NL80211_CMD_DISASSOCIATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -217,6 +241,10 @@ enum nl80211_commands {
  */
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
+#define NL80211_CMD_AUTHENTICATE NL80211_CMD_AUTHENTICATE
+#define NL80211_CMD_ASSOCIATE NL80211_CMD_ASSOCIATE
+#define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
+#define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -329,6 +357,10 @@ enum nl80211_commands {
  *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
+ * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame header
+ *	and body, but not FCS; used, e.g., with NL80211_CMD_AUTHENTICATE and
+ *	NL80211_CMD_ASSOCIATE events
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -403,6 +435,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCAN_GENERATION,
 	NL80211_ATTR_BSS,
 
+	NL80211_ATTR_FRAME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -420,6 +454,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_WIPHY_CHANNEL_TYPE NL80211_ATTR_WIPHY_CHANNEL_TYPE
 #define NL80211_ATTR_MGMT_SUBTYPE NL80211_ATTR_MGMT_SUBTYPE
 #define NL80211_ATTR_IE NL80211_ATTR_IE
+#define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
--- uml.orig/include/net/cfg80211.h	2009-02-18 21:07:00.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-02-20 20:45:15.000000000 +0200
@@ -825,4 +825,50 @@ void cfg80211_put_bss(struct cfg80211_bs
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
--- uml.orig/net/mac80211/mlme.c	2009-02-18 21:26:36.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-02-19 20:27:42.000000000 +0200
@@ -1066,11 +1066,13 @@ static void ieee80211_rx_mgmt_auth(struc
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
@@ -1106,6 +1108,7 @@ static void ieee80211_rx_mgmt_deauth(str
 
 	ieee80211_set_disassoc(sdata, true, false, 0);
 	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
+	cfg80211_send_rx_deauth(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1135,6 +1138,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 	}
 
 	ieee80211_set_disassoc(sdata, false, false, reason_code);
+	cfg80211_send_rx_disassoc(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1350,6 +1354,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	ieee80211_set_associated(sdata, changed);
 
 	ieee80211_associated(sdata);
+	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1598,6 +1603,7 @@ static void ieee80211_sta_rx_queued_mgmt
 		break;
 	case IEEE80211_STYPE_REASSOC_RESP:
 		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 1);
+		cfg80211_send_rx_assoc(sdata->dev, skb->data, skb->len);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
 		ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
--- uml.orig/net/wireless/Makefile	2009-02-18 21:20:47.000000000 +0200
+++ uml/net/wireless/Makefile	2009-02-18 21:21:07.000000000 +0200
@@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o mlme.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ uml/net/wireless/mlme.c	2009-02-19 20:08:28.000000000 +0200
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
--- uml.orig/net/wireless/nl80211.c	2009-02-18 21:07:07.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-02-20 20:45:15.000000000 +0200
@@ -2699,6 +2699,9 @@ static struct genl_multicast_group nl802
 static struct genl_multicast_group nl80211_scan_mcgrp = {
 	.name = "scan",
 };
+static struct genl_multicast_group nl80211_mlme_mcgrp = {
+	.name = "mlme",
+};
 
 /* notification functions */
 
@@ -2778,6 +2781,71 @@ void nl80211_send_scan_aborted(struct cf
 	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
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
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
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
@@ -2802,6 +2870,10 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_mlme_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
--- uml.orig/net/wireless/nl80211.h	2009-02-18 21:07:08.000000000 +0200
+++ uml/net/wireless/nl80211.h	2009-02-19 20:09:32.000000000 +0200
@@ -11,6 +11,18 @@ extern void nl80211_send_scan_done(struc
 				   struct net_device *netdev);
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
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
 #else
 static inline int nl80211_init(void)
 {
@@ -31,6 +43,26 @@ static inline void nl80211_send_scan_abo
 					struct cfg80211_registered_device *rdev,
 					struct net_device *netdev)
 {}
+static inline void
+nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+		     struct net_device *netdev, const u8 *buf, size_t len)
+{
+}
+static inline void
+nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+		      struct net_device *netdev, const u8 *buf, size_t len)
+{
+}
+static inline void
+nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
+		       struct net_device *netdev, const u8 *buf, size_t len)
+{
+}
+static inline void
+nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, const u8 *buf, size_t len)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */



Very preliminary MLME commands:

---
 include/linux/nl80211.h    |   61 ++++++++++--
 include/net/cfg80211.h     |   42 ++++++++
 net/mac80211/cfg.c         |  136 +++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/mlme.c        |    7 +
 net/mac80211/wext.c        |    3 
 net/wireless/nl80211.c     |  221 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 460 insertions(+), 12 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-02-20 20:45:34.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-02-20 20:47:35.000000000 +0200
@@ -150,24 +150,37 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
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
@@ -360,6 +373,11 @@ enum nl80211_commands {
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
@@ -436,6 +454,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_BSS,
 
 	NL80211_ATTR_FRAME,
+	NL80211_ATTR_SSID,
+	NL80211_ATTR_AUTH_TYPE,
+	NL80211_ATTR_REASON_CODE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -455,6 +476,9 @@ enum nl80211_attrs {
 #define NL80211_ATTR_MGMT_SUBTYPE NL80211_ATTR_MGMT_SUBTYPE
 #define NL80211_ATTR_IE NL80211_ATTR_IE
 #define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
+#define NL80211_ATTR_SSID NL80211_ATTR_SSID
+#define NL80211_ATTR_AUTH_TYPE NL80211_ATTR_AUTH_TYPE
+#define NL80211_ATTR_REASON_CODE NL80211_ATTR_REASON_CODE
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -946,4 +970,21 @@ enum nl80211_bss {
 	NL80211_BSS_MAX = __NL80211_BSS_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_auth_type - AuthenticationType
+ *
+ * @NL80211_AUTHTYPE_OPEN_SYSTEM
+ */
+enum nl80211_auth_type {
+	NL80211_AUTHTYPE_UNSPECIFIED,
+	NL80211_AUTHTYPE_OPEN_SYSTEM,
+	NL80211_AUTHTYPE_SHARED_KEY,
+	NL80211_AUTHTYPE_FT,
+	NL80211_AUTHTYPE_NETWORK_EAP,
+	NL80211_AUTHTYPE_AUTO,
+
+	/* keep last */
+	__NL80211_AUTHTYPE_AFTER_LAST,
+	NL80211_AUTHTYPE_MAX = __NL80211_AUTHTYPE_AFTER_LAST - 1
+};
 #endif /* __LINUX_NL80211_H */
--- uml.orig/include/net/cfg80211.h	2009-02-20 20:45:15.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-02-20 20:56:17.000000000 +0200
@@ -599,6 +599,39 @@ struct cfg80211_bss {
 	u8 priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
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
+struct cfg80211_assoc_request {
+	struct ieee80211_channel *chan;
+	u8 *peer_addr;
+	const u8 *ssid;
+	size_t ssid_len;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+struct cfg80211_deauth_request {
+	u8 *peer_addr;
+	u16 reason_code;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+struct cfg80211_disassoc_request {
+	u8 *peer_addr;
+	u16 reason_code;
+	const u8 *ie;
+	size_t ie_len;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -751,6 +784,15 @@ struct cfg80211_ops {
 
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
--- uml.orig/net/wireless/nl80211.c	2009-02-20 20:45:15.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-02-20 20:52:03.000000000 +0200
@@ -133,6 +133,11 @@ static struct nla_policy nl80211_policy[
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
@@ -2506,6 +2511,198 @@ static int nl80211_dump_scan(struct sk_b
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
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->auth) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
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
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->assoc) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
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
+		if (nla_len(info->attrs[NL80211_ATTR_SSID]) >
+		    IEEE80211_MAX_SSID_LEN) {
+			err = -EINVAL;
+			goto out;
+		}
+		req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+		req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+	}
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
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->deauth) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
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
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->disassoc) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+	memset(&req, 0, sizeof(req));
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
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
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -2690,6 +2887,30 @@ static struct genl_ops nl80211_ops[] = {
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
 
 /* multicast groups */
--- uml.orig/net/mac80211/cfg.c	2009-02-20 20:52:42.000000000 +0200
+++ uml/net/mac80211/cfg.c	2009-02-20 21:20:27.000000000 +0200
@@ -1299,6 +1299,138 @@ static int ieee80211_scan(struct wiphy *
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
+	if (req->peer_addr) {
+		memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+	} else {
+		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
+	}
+
+	/* TODO: req->chan */
+	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
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
+	case NL80211_AUTHTYPE_AUTO:
+	default:
+		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_OPEN |
+			IEEE80211_AUTH_ALG_SHARED_KEY |
+			IEEE80211_AUTH_ALG_LEAP;
+		break;
+	}
+
+	if (req->ssid) {
+		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
+		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
+		sdata->u.mgd.ssid_len = req->ssid_len;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
+	}
+
+	/* TODO: req->ie */
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
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (req->peer_addr) {
+		memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+	} else {
+		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
+	}
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
+	/* TODO: req->ie */
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
@@ -1332,4 +1464,8 @@ struct cfg80211_ops mac80211_config_ops 
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
+	.auth = ieee80211_auth,
+	.assoc = ieee80211_assoc,
+	.deauth = ieee80211_deauth,
+	.disassoc = ieee80211_disassoc,
 };
--- uml.orig/net/mac80211/ieee80211_i.h	2009-02-20 20:58:06.000000000 +0200
+++ uml/net/mac80211/ieee80211_i.h	2009-02-20 21:19:12.000000000 +0200
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
--- uml.orig/net/mac80211/mlme.c	2009-02-20 20:58:12.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-02-20 21:07:33.000000000 +0200
@@ -979,7 +979,8 @@ static void ieee80211_auth_completed(str
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
 	ifmgd->flags |= IEEE80211_STA_AUTHENTICATED;
-	ieee80211_associate(sdata);
+	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME))
+		ieee80211_associate(sdata);
 }
 
 
@@ -1856,7 +1857,9 @@ void ieee80211_sta_req_auth(struct ieee8
 			ieee80211_set_disassoc(sdata, true, true,
 					       WLAN_REASON_DEAUTH_LEAVING);
 
-		set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
+		if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) ||
+		    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE)
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
 		queue_work(local->hw.workqueue, &ifmgd->work);
 	}
 }
--- uml.orig/net/mac80211/wext.c	2009-02-20 20:58:10.000000000 +0200
+++ uml/net/mac80211/wext.c	2009-02-20 21:03:37.000000000 +0200
@@ -137,6 +137,7 @@ static int ieee80211_ioctl_siwgenie(stru
 		if (ret)
 			return ret;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
@@ -328,6 +329,7 @@ static int ieee80211_ioctl_siwessid(stru
 		if (ret)
 			return ret;
 
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
@@ -391,6 +393,7 @@ static int ieee80211_ioctl_siwap(struct 
 		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 		if (ret)
 			return ret;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {

-- 
Jouni Malinen                                            PGP id EFC895FA
