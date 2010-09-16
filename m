Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0IPNAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 09:00:30 -0400
Message-Id: <20100916125926.973743558@sipsolutions.net>
Date: Thu, 16 Sep 2010 14:58:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211/nl80211: introduce p2p device types
References: <20100916125821.369545798@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds P2P-STA and P2P-GO as device types so
we can distinguish between those and normal STA
or AP (respectively) type interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    4 +++
 net/wireless/core.c     |    2 +
 net/wireless/mlme.c     |    3 +-
 net/wireless/nl80211.c  |   56 +++++++++++++++++++++++++++++++++---------------
 net/wireless/sme.c      |    9 +++++--
 net/wireless/util.c     |   15 ++++++++++--
 6 files changed, 65 insertions(+), 24 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-09-16 14:47:13.000000000 +0200
@@ -1020,6 +1020,8 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
  * @NL80211_IFTYPE_MESH_POINT: mesh point
+ * @NL80211_IFTYPE_P2P_CLIENT: P2P client
+ * @NL80211_IFTYPE_P2P_GO: P2P group owner
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -1036,6 +1038,8 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_WDS,
 	NL80211_IFTYPE_MONITOR,
 	NL80211_IFTYPE_MESH_POINT,
+	NL80211_IFTYPE_P2P_CLIENT,
+	NL80211_IFTYPE_P2P_GO,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
--- wireless-testing.orig/net/wireless/util.c	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2010-09-16 14:47:13.000000000 +0200
@@ -326,7 +326,8 @@ int ieee80211_data_to_8023(struct sk_buf
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 	case cpu_to_le16(IEEE80211_FCTL_TODS):
 		if (unlikely(iftype != NL80211_IFTYPE_AP &&
-			     iftype != NL80211_IFTYPE_AP_VLAN))
+			     iftype != NL80211_IFTYPE_AP_VLAN &&
+			     iftype != NL80211_IFTYPE_P2P_GO))
 			return -1;
 		break;
 	case cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
@@ -354,7 +355,8 @@ int ieee80211_data_to_8023(struct sk_buf
 		break;
 	case cpu_to_le16(IEEE80211_FCTL_FROMDS):
 		if ((iftype != NL80211_IFTYPE_STATION &&
-		    iftype != NL80211_IFTYPE_MESH_POINT) ||
+		     iftype != NL80211_IFTYPE_P2P_CLIENT &&
+		     iftype != NL80211_IFTYPE_MESH_POINT) ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, addr)))
 			return -1;
@@ -431,6 +433,7 @@ int ieee80211_data_from_8023(struct sk_b
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -439,6 +442,7 @@ int ieee80211_data_from_8023(struct sk_b
 		hdrlen = 24;
 		break;
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
 		memcpy(hdr.addr1, bssid, ETH_ALEN);
@@ -778,7 +782,9 @@ int cfg80211_change_iface(struct cfg8021
 
 	/* if it's part of a bridge, reject changing type to station/ibss */
 	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
-	    (ntype == NL80211_IFTYPE_ADHOC || ntype == NL80211_IFTYPE_STATION))
+	    (ntype == NL80211_IFTYPE_ADHOC ||
+	     ntype == NL80211_IFTYPE_STATION ||
+	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
 	if (ntype != otype) {
@@ -789,6 +795,7 @@ int cfg80211_change_iface(struct cfg8021
 			cfg80211_leave_ibss(rdev, dev, false);
 			break;
 		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_P2P_CLIENT:
 			cfg80211_disconnect(rdev, dev,
 					    WLAN_REASON_DEAUTH_LEAVING, true);
 			break;
@@ -817,9 +824,11 @@ int cfg80211_change_iface(struct cfg8021
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
 			/* fall through */
+		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 			break;
+		case NL80211_IFTYPE_P2P_GO:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_WDS:
--- wireless-testing.orig/net/wireless/core.c	2010-09-16 14:47:03.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2010-09-16 14:47:13.000000000 +0200
@@ -729,6 +729,7 @@ static int cfg80211_netdev_notifier_call
 			dev->ethtool_ops = &cfg80211_ethtool_ops;
 
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
@@ -737,6 +738,7 @@ static int cfg80211_netdev_notifier_call
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, true);
 			break;
+		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_STATION:
 			wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
--- wireless-testing.orig/net/wireless/mlme.c	2010-09-16 14:47:03.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-09-16 14:47:13.000000000 +0200
@@ -882,7 +882,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 		if (!wdev->current_bss ||
 		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
 			   ETH_ALEN) != 0 ||
-		    (wdev->iftype == NL80211_IFTYPE_STATION &&
+		    ((wdev->iftype == NL80211_IFTYPE_STATION ||
+		      wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 		     memcmp(wdev->current_bss->pub.bssid, mgmt->da,
 			    ETH_ALEN) != 0)) {
 			wdev_unlock(wdev);
--- wireless-testing.orig/net/wireless/nl80211.c	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-09-16 14:47:13.000000000 +0200
@@ -410,12 +410,14 @@ static int nl80211_key_allowed(struct wi
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!wdev->current_bss)
 			return -ENOLINK;
 		break;
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		if (wdev->sme_state != CFG80211_SME_CONNECTED)
 			return -ENOLINK;
 		break;
@@ -766,7 +768,8 @@ static bool nl80211_can_set_dev_channel(
 		wdev->iftype == NL80211_IFTYPE_AP ||
 		wdev->iftype == NL80211_IFTYPE_WDS ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
-		wdev->iftype == NL80211_IFTYPE_MONITOR;
+		wdev->iftype == NL80211_IFTYPE_MONITOR ||
+		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
 static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
@@ -1693,7 +1696,8 @@ static int nl80211_addset_beacon(struct
 	if (err)
 		goto unlock_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1785,7 +1789,8 @@ static int nl80211_del_beacon(struct sk_
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2128,10 +2133,12 @@ static int nl80211_set_station(struct sk
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			err = -EINVAL;
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 		/* disallow everything but AUTHORIZED flag */
 		if (params.plink_action)
@@ -2233,7 +2240,8 @@ static int nl80211_new_station(struct sk
 		goto out_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -2286,7 +2294,8 @@ static int nl80211_del_station(struct sk
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -2660,7 +2669,8 @@ static int nl80211_set_bss(struct sk_buf
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3363,6 +3373,7 @@ static int nl80211_send_bss(struct sk_bu
 	}
 
 	switch (wdev->iftype) {
+	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 		if (intbss == wdev->current_bss)
 			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
@@ -3649,7 +3660,8 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3804,7 +3816,8 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3888,7 +3901,8 @@ static int nl80211_deauthenticate(struct
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3954,7 +3968,8 @@ static int nl80211_disassociate(struct s
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4332,7 +4347,8 @@ static int nl80211_connect(struct sk_buf
 	if (err)
 		goto unlock_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4408,7 +4424,8 @@ static int nl80211_disconnect(struct sk_
 	if (err)
 		goto unlock_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4496,7 +4513,8 @@ static int nl80211_setdel_pmksa(struct s
 	pmksa.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
 	pmksa.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4541,7 +4559,8 @@ static int nl80211_flush_pmksa(struct sk
 	if (err)
 		goto out_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4823,7 +4842,8 @@ static int nl80211_register_mgmt(struct
 		goto unlock_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4875,7 +4895,8 @@ static int nl80211_tx_mgmt(struct sk_buf
 	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -5093,7 +5114,8 @@ static int nl80211_set_cqm_rssi(struct g
 		goto unlock_rdev;
 	}
 
-	if (wdev->iftype != NL80211_IFTYPE_STATION) {
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
 		err = -EOPNOTSUPP;
 		goto unlock_rdev;
 	}
--- wireless-testing.orig/net/wireless/sme.c	2010-09-16 14:47:06.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2010-09-16 14:47:13.000000000 +0200
@@ -411,7 +411,8 @@ void __cfg80211_connect_result(struct ne
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
@@ -548,7 +549,8 @@ void __cfg80211_roamed(struct wireless_d
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)
@@ -644,7 +646,8 @@ void __cfg80211_disconnected(struct net_
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)


