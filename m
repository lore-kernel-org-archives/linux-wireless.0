Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54536 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbZBRUCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:02:18 -0500
Date: Wed, 18 Feb 2009 22:02:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] nl80211: Authentication and association events
Message-ID: <20090218200210.GA13955@jm.kir.nu> (sfid-20090218_210221_613739_554C5409)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds new nl80211 event notifications (and a new multicast group,
"mlme") for informing user space about received Authentication and
(Re)Association Response frames in station and IBSS modes (i.e., MLME
SAP interface primitives MLME-AUTHENTICATE.confirm,
MLME-RESOURCE_REQUEST.confirm, MLME-ASSOCIATE.confirm, and
MLME-REASSOCIATE.confirm). The event data is encapsulated as the 802.11
management frame since we already have the frame in that format and it
includes all the needed information.

This is the first step in providing MLME SAP interface for
authentication and association with nl80211. In other words, kernel code
will act as the MLME and a user space application can control it as SME.

The next goal is to introduce MLME-AUTHENTICATE.request and
MLME-{,RE}ASSOCIATE.request primitives that will request the actual
operations in two steps (assuming driver supports this; if not,
separate authentication step is skipped).

The initial implementation will likely end up using the current
net/mac80211/mlme.c for actual sending and processing of management
frames and the new nl80211 commands will just stop the current state
machine from moving automatically from authentication to association.
Future cleanup may move more of the MLME operations into cfg80211.

The goal of this design is to provide more control of authentication and
association process to user space without having to move the full MLME
implementation. This should be enough to allow IEEE 802.11r FT protocol
and 802.11s SAE authentication to be implemented. Obviously this will
also bring the extra benefit of not having to use WEXT for association
requests with mac80211.


---
 include/linux/nl80211.h |   25 ++++++++++++++++++++++
 include/net/cfg80211.h  |    5 ++++
 net/mac80211/mlme.c     |    4 +++
 net/wireless/Makefile   |    2 -
 net/wireless/mlme.c     |   29 +++++++++++++++++++++++++
 net/wireless/nl80211.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |   16 ++++++++++++++
 7 files changed, 134 insertions(+), 1 deletion(-)

--- uml.orig/include/linux/nl80211.h	2009-02-18 20:48:00.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-02-18 21:02:42.000000000 +0200
@@ -150,6 +150,22 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_RX_AUTH: authentication notification (on the "mlme" multicast
+ *	group). This event reports reception of an Authentication frame in
+ *	station and IBSS modes similarly to MLME-AUTHENTICATE.confirm primitive
+ *	in the MLME SAP interface (kernel providing MLME, userspace SME). In
+ *	addition, this event is used as MLME-RESOURCE_REQUEST.confirm primitive
+ *	which is also reporting a reception of an Authentication frame. The
+ *	included NL80211_ATTR_FRAME attribute contains the management frame
+ *	(including both the header and frame body, but not FCS).
+ * @NL80211_CMD_RX_ASSOC: association notification (on the "mlme" multicast
+ *	group). This event reports reception of an Association Response or
+ *	Reassociation Response frame in station and IBSS modes similarly to
+ *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitive in the
+ *	MLME SAP interface (kernel providing MLME, userspace SME). The included
+ *	NL80211_ATTR_FRAME contains the management frame (including both the
+ *	header and frame body, but not FCS).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -204,6 +220,9 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_RX_AUTH,
+	NL80211_CMD_RX_ASSOC,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -329,6 +348,10 @@ enum nl80211_commands {
  *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
+ * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame header
+ *	and body, but not FCS; used, e.g., with NL80211_CMD_RX_AUTH and
+ *	NL80211_CMD_RX_ASSOC events
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -403,6 +426,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCAN_GENERATION,
 	NL80211_ATTR_BSS,
 
+	NL80211_ATTR_FRAME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-02-18 21:07:00.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-02-18 21:29:26.000000000 +0200
@@ -825,4 +825,9 @@ void cfg80211_put_bss(struct cfg80211_bs
  */
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 
+void cfg80211_send_rx_auth(struct wiphy *wiphy, struct net_device *dev,
+			   struct sk_buff *skb);
+void cfg80211_send_rx_assoc(struct wiphy *wiphy, struct net_device *dev,
+			    struct sk_buff *skb);
+
 #endif /* __NET_CFG80211_H */
--- uml.orig/net/mac80211/mlme.c	2009-02-18 21:26:36.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-02-18 21:28:42.000000000 +0200
@@ -1573,6 +1573,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
@@ -1592,12 +1593,15 @@ static void ieee80211_sta_rx_queued_mgmt
 		break;
 	case IEEE80211_STYPE_AUTH:
 		ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
+		cfg80211_send_rx_auth(local->hw.wiphy, sdata->dev, skb);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
 		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 0);
+		cfg80211_send_rx_assoc(local->hw.wiphy, sdata->dev, skb);
 		break;
 	case IEEE80211_STYPE_REASSOC_RESP:
 		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 1);
+		cfg80211_send_rx_assoc(local->hw.wiphy, sdata->dev, skb);
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
+++ uml/net/wireless/mlme.c	2009-02-18 21:32:40.000000000 +0200
@@ -0,0 +1,29 @@
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
+void cfg80211_send_rx_auth(struct wiphy *wiphy, struct net_device *dev,
+			   struct sk_buff *skb)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_auth(rdev, dev, skb);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_auth);
+
+void cfg80211_send_rx_assoc(struct wiphy *wiphy, struct net_device *dev,
+			    struct sk_buff *skb)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_rx_assoc(rdev, dev, skb);
+}
+EXPORT_SYMBOL(cfg80211_send_rx_assoc);
--- uml.orig/net/wireless/nl80211.c	2009-02-18 21:07:07.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-02-18 21:19:11.000000000 +0200
@@ -2699,6 +2699,9 @@ static struct genl_multicast_group nl802
 static struct genl_multicast_group nl80211_scan_mcgrp = {
 	.name = "scan",
 };
+static struct genl_multicast_group nl80211_mlme_mcgrp = {
+	.name = "mlme",
+};
 
 /* notification functions */
 
@@ -2778,6 +2781,53 @@ void nl80211_send_scan_aborted(struct cf
 	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev,
+				    struct sk_buff *skb,
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
+	NLA_PUT(msg, NL80211_ATTR_FRAME, skb->len, skb->data);
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
+			  struct net_device *netdev, struct sk_buff *skb)
+{
+	nl80211_send_mlme_event(rdev, netdev, skb, NL80211_CMD_RX_AUTH);
+}
+
+void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev, struct sk_buff *skb)
+{
+	nl80211_send_mlme_event(rdev, netdev, skb, NL80211_CMD_RX_ASSOC);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
@@ -2802,6 +2852,10 @@ int nl80211_init(void)
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
+++ uml/net/wireless/nl80211.h	2009-02-18 21:13:59.000000000 +0200
@@ -11,6 +11,12 @@ extern void nl80211_send_scan_done(struc
 				   struct net_device *netdev);
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
+extern void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev,
+				 struct sk_buff *skb);
+extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+				  struct net_device *netdev,
+				  struct sk_buff *skb);
 #else
 static inline int nl80211_init(void)
 {
@@ -31,6 +37,16 @@ static inline void nl80211_send_scan_abo
 					struct cfg80211_registered_device *rdev,
 					struct net_device *netdev)
 {}
+static inline void
+nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
+		     struct net_device *netdev, struct sk_buff *skb)
+{
+}
+static inline void
+nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
+		      struct net_device *netdev, struct sk_buff *skb)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */

-- 
Jouni Malinen                                            PGP id EFC895FA
