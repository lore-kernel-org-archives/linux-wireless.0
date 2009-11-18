Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZKSAEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 19:04:44 -0500
Message-Id: <20091118235737.914219360@sipsolutions.net>
Date: Thu, 19 Nov 2009 00:56:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 3/3] cfg80211: disallow bridging managed/adhoc interfaces
References: <20091118235627.209099206@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of people have tried to add a wireless interface
(in managed mode) to a bridge and then complained that it
doesn't work. It cannot work, however, because in 802.11
networks all packets need to be acknowledged and as such
need to be sent to the right address. Promiscuous doesn't
help here. The wireless address format used for these
links has only space for three addresses, the
 * transmitter, which must be equal to the sender (origin)
 * receiver (on the wireless medium), which is the AP in
   the case of managed mode
 * the recipient (destination), which is on the APs local
   network segment

In an IBSS, it is similar, but the receiver and recipient
must match and the third address is used as the BSSID.

To avoid such mistakes in the future, disallow adding a
wireless interface to a bridge.

Felix has recently added a four-address mode to the AP
and client side that can be used (after negotiating that
it is possible, which must happen out-of-band by setting
up both sides) for bridging, so allow that case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 include/linux/if.h     |    1 +
 net/bridge/br_if.c     |    4 ++++
 net/wireless/core.c    |    4 ++++
 net/wireless/nl80211.c |   12 ++++++++----
 net/wireless/util.c    |   31 +++++++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 4 deletions(-)

--- wireless-testing.orig/include/linux/if.h	2009-11-19 00:22:18.000000000 +0100
+++ wireless-testing/include/linux/if.h	2009-11-19 00:23:17.000000000 +0100
@@ -70,6 +70,7 @@
 #define IFF_XMIT_DST_RELEASE 0x400	/* dev_hard_start_xmit() is allowed to
 					 * release skb->dst
 					 */
+#define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 
 #define IF_GET_IFACE	0x0001		/* for querying only */
 #define IF_GET_PROTO	0x0002
--- wireless-testing.orig/net/bridge/br_if.c	2009-11-19 00:22:18.000000000 +0100
+++ wireless-testing/net/bridge/br_if.c	2009-11-19 00:23:17.000000000 +0100
@@ -390,6 +390,10 @@ int br_add_if(struct net_bridge *br, str
 	if (dev->br_port != NULL)
 		return -EBUSY;
 
+	/* No bridging devices that dislike that (e.g. wireless) */
+	if (dev->priv_flags & IFF_DONT_BRIDGE)
+		return -EOPNOTSUPP;
+
 	p = new_nbp(br, dev);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
--- wireless-testing.orig/net/wireless/util.c	2009-11-19 00:22:18.000000000 +0100
+++ wireless-testing/net/wireless/util.c	2009-11-19 00:23:17.000000000 +0100
@@ -658,6 +658,11 @@ int cfg80211_change_iface(struct cfg8021
 	    !(rdev->wiphy.interface_modes & (1 << ntype)))
 		return -EOPNOTSUPP;
 
+	/* if it's part of a bridge, reject changing type to station/ibss */
+	if (dev->br_port && (ntype == NL80211_IFTYPE_ADHOC ||
+			     ntype == NL80211_IFTYPE_STATION))
+		return -EBUSY;
+
 	if (ntype != otype) {
 		dev->ieee80211_ptr->use_4addr = false;
 
@@ -687,5 +692,31 @@ int cfg80211_change_iface(struct cfg8021
 	if (!err && params && params->use_4addr != -1)
 		dev->ieee80211_ptr->use_4addr = params->use_4addr;
 
+	if (!err) {
+		dev->priv_flags &= ~IFF_DONT_BRIDGE;
+		switch (ntype) {
+		case NL80211_IFTYPE_STATION:
+			if (dev->ieee80211_ptr->use_4addr)
+				break;
+			/* fall through */
+		case NL80211_IFTYPE_ADHOC:
+			dev->priv_flags |= IFF_DONT_BRIDGE;
+			break;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			/* bridging OK */
+			break;
+		case NL80211_IFTYPE_MONITOR:
+			/* monitor can't bridge anyway */
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case __NL80211_IFTYPE_AFTER_LAST:
+			/* not happening */
+			break;
+		}
+	}
+
 	return err;
 }
--- wireless-testing.orig/net/wireless/core.c	2009-11-19 00:22:18.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-11-19 00:23:17.000000000 +0100
@@ -691,6 +691,10 @@ static int cfg80211_netdev_notifier_call
 #endif
 		if (!dev->ethtool_ops)
 			dev->ethtool_ops = &cfg80211_ethtool_ops;
+
+		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
+			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
 	case NETDEV_GOING_DOWN:
 		switch (wdev->iftype) {
--- wireless-testing.orig/net/wireless/nl80211.c	2009-11-19 00:23:43.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-11-19 00:26:04.000000000 +0100
@@ -969,10 +969,14 @@ static int parse_monitor_flags(struct nl
 }
 
 static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
-			       u8 use_4addr, enum nl80211_iftype iftype)
+			       struct net_device *netdev, u8 use_4addr,
+			       enum nl80211_iftype iftype)
 {
-	if (!use_4addr)
+	if (!use_4addr) {
+		if (netdev && netdev->br_port)
+			return -EBUSY;
 		return 0;
+	}
 
 	switch (iftype) {
 	case NL80211_IFTYPE_AP_VLAN:
@@ -1033,7 +1037,7 @@ static int nl80211_set_interface(struct 
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
 		change = true;
-		err = nl80211_valid_4addr(rdev, params.use_4addr, ntype);
+		err = nl80211_valid_4addr(rdev, dev, params.use_4addr, ntype);
 		if (err)
 			goto unlock;
 	} else {
@@ -1111,7 +1115,7 @@ static int nl80211_new_interface(struct 
 
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
-		err = nl80211_valid_4addr(rdev, params.use_4addr, type);
+		err = nl80211_valid_4addr(rdev, NULL, params.use_4addr, type);
 		if (err)
 			goto unlock;
 	}


