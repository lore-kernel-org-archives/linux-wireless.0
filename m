Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZKSKzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 05:55:45 -0500
Subject: [PATCH 2/3 v2] cfg80211: introduce capability for 4addr mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <20091118235737.696300447@sipsolutions.net>
References: <20091118235627.209099206@sipsolutions.net>
	 <20091118235737.696300447@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 11:55:19 +0100
Message-ID: <1258628119.7094.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's very likely that not many devices will support
four-address mode in station or AP mode so introduce
capability bits for both modes, set them in mac80211
and check them when userspace tries to use the mode.
Also, keep track of 4addr in cfg80211 (wireless_dev)
and not in mac80211 any more. mac80211 can also be
improved for the VLAN case by not looking at the
4addr flag but maintaining the station pointer for
it correctly. However, keep track of use_4addr for
station mode in mac80211 to avoid all the derefs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix logic error

 include/net/cfg80211.h     |   11 +++++++++++
 net/mac80211/cfg.c         |   21 ++++++++-------------
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/iface.c       |   12 ++++++++----
 net/mac80211/main.c        |    4 +++-
 net/mac80211/rx.c          |   14 +++++++++-----
 net/mac80211/tx.c          |    7 +++----
 net/wireless/nl80211.c     |   34 +++++++++++++++++++++++++++++++++-
 net/wireless/util.c        |    5 +++++
 9 files changed, 82 insertions(+), 30 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-11-19 11:15:52.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-11-19 11:16:05.000000000 +0100
@@ -1134,6 +1134,9 @@ struct cfg80211_ops {
  *	by default -- this flag will be set depending on the kernel's default
  *	on wiphy_new(), but can be changed by the driver if it has a good
  *	reason to override the default
+ * @WIPHY_FLAG_4ADDR_AP: supports 4addr mode even on AP (with a single station
+ *	on a VLAN interface)
+ * @WIPHY_FLAG_4ADDR_STATION: supports 4addr mode even as a station
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY	= BIT(0),
@@ -1141,6 +1144,8 @@ enum wiphy_flags {
 	WIPHY_FLAG_DISABLE_BEACON_HINTS	= BIT(2),
 	WIPHY_FLAG_NETNS_OK		= BIT(3),
 	WIPHY_FLAG_PS_ON_BY_DEFAULT	= BIT(4),
+	WIPHY_FLAG_4ADDR_AP		= BIT(5),
+	WIPHY_FLAG_4ADDR_STATION	= BIT(6),
 };
 
 /**
@@ -1366,6 +1371,10 @@ struct cfg80211_cached_keys;
  * @ssid_len: (private) Used by the internal configuration code
  * @wext: (private) Used by the internal wireless extensions compat code
  * @wext_bssid: (private) Used by the internal wireless extensions compat code
+ * @use_4addr: indicates 4addr mode is used on this interface, must be
+ *	set by driver (if supported) on add_interface BEFORE registering the
+ *	netdev and may otherwise be used by driver read-only, will be update
+ *	by cfg80211 on change_interface
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -1379,6 +1388,8 @@ struct wireless_dev {
 
 	struct work_struct cleanup_work;
 
+	bool use_4addr;
+
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
--- wireless-testing.orig/net/wireless/nl80211.c	2009-11-19 11:15:52.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-11-19 11:54:24.000000000 +0100
@@ -968,6 +968,28 @@ static int parse_monitor_flags(struct nl
 	return 0;
 }
 
+static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
+			       u8 use_4addr, enum nl80211_iftype iftype)
+{
+	if (!use_4addr)
+		return 0;
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP_VLAN:
+		if (rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP)
+			return 0;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (rdev->wiphy.flags & WIPHY_FLAG_4ADDR_STATION)
+			return 0;
+		break;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
@@ -1011,6 +1033,9 @@ static int nl80211_set_interface(struct 
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
 		change = true;
+		err = nl80211_valid_4addr(rdev, params.use_4addr, ntype);
+		if (err)
+			goto unlock;
 	} else {
 		params.use_4addr = -1;
 	}
@@ -1034,6 +1059,9 @@ static int nl80211_set_interface(struct 
 	else
 		err = 0;
 
+	if (!err && params.use_4addr != -1)
+		dev->ieee80211_ptr->use_4addr = params.use_4addr;
+
  unlock:
 	dev_put(dev);
 	cfg80211_unlock_rdev(rdev);
@@ -1081,8 +1109,12 @@ static int nl80211_new_interface(struct 
 		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
 	}
 
-	if (info->attrs[NL80211_ATTR_4ADDR])
+	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
+		err = nl80211_valid_4addr(rdev, params.use_4addr, type);
+		if (err)
+			goto unlock;
+	}
 
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
--- wireless-testing.orig/net/mac80211/main.c	2009-11-19 11:15:52.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-19 11:16:05.000000000 +0100
@@ -328,7 +328,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	if (!wiphy)
 		return NULL;
 
-	wiphy->flags |= WIPHY_FLAG_NETNS_OK;
+	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
+			WIPHY_FLAG_4ADDR_AP |
+			WIPHY_FLAG_4ADDR_STATION;
 	wiphy->privid = mac80211_wiphy_privid;
 
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-19 11:16:05.000000000 +0100
@@ -42,15 +42,6 @@ static bool nl80211_params_check(enum nl
 	if (!nl80211_type_check(type))
 		return false;
 
-	if (params->use_4addr > 0) {
-		switch(type) {
-		case NL80211_IFTYPE_AP_VLAN:
-		case NL80211_IFTYPE_STATION:
-			break;
-		default:
-			return false;
-		}
-	}
 	return true;
 }
 
@@ -107,12 +98,16 @@ static int ieee80211_change_iface(struct
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (params->use_4addr >= 0)
-		sdata->use_4addr = !!params->use_4addr;
-
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
 		return 0;
 
+	if (type == NL80211_IFTYPE_AP_VLAN &&
+	    params && params->use_4addr == 0)
+		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
+	else if (type == NL80211_IFTYPE_STATION &&
+		 params && params->use_4addr >= 0)
+		sdata->u.mgd.use_4addr = params->use_4addr;
+
 	sdata->u.mntr_flags = *flags;
 	return 0;
 }
@@ -827,7 +822,7 @@ static int ieee80211_change_station(stru
 			return -EINVAL;
 		}
 
-		if (vlansdata->use_4addr) {
+		if (params->vlan->ieee80211_ptr->use_4addr) {
 			if (vlansdata->u.vlan.sta)
 				return -EBUSY;
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-19 11:16:05.000000000 +0100
@@ -312,6 +312,8 @@ struct ieee80211_if_managed {
 	} mfp; /* management frame protection */
 
 	int wmm_last_param_set;
+
+	u8 use_4addr;
 };
 
 enum ieee80211_ibss_request {
@@ -459,8 +461,6 @@ struct ieee80211_sub_if_data {
 	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
 	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
 
-	bool use_4addr; /* use 4-address frames */
-
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
--- wireless-testing.orig/net/mac80211/iface.c	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-11-19 11:16:05.000000000 +0100
@@ -752,7 +752,8 @@ int ieee80211_if_change_type(struct ieee
 		ieee80211_mandatory_rates(sdata->local,
 			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
-	sdata->use_4addr = 0;
+	if (type == NL80211_IFTYPE_STATION)
+		sdata->u.mgd.use_4addr = false;
 
 	return 0;
 }
@@ -815,6 +816,12 @@ int ieee80211_if_add(struct ieee80211_lo
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
+	if (params) {
+		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
+		if (type == NL80211_IFTYPE_STATION)
+			sdata->u.mgd.use_4addr = params->use_4addr;
+	}
+
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
@@ -825,9 +832,6 @@ int ieee80211_if_add(struct ieee80211_lo
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (params && params->use_4addr >= 0)
-		sdata->use_4addr = !!params->use_4addr;
-
 	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-19 11:50:55.000000000 +0100
@@ -1192,10 +1192,13 @@ __ieee80211_data_to_8023(struct ieee8021
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->use_4addr &&
-	    ieee80211_has_a4(hdr->frame_control))
+	if (ieee80211_has_a4(hdr->frame_control) &&
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.sta)
 		return -1;
-	if (sdata->use_4addr && is_multicast_ether_addr(hdr->addr1))
+
+	if (is_multicast_ether_addr(hdr->addr1) &&
+	    ((sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta) ||
+	     (sdata->vif.type == NL80211_IFTYPE_STATION && sdata->u.mgd.use_4addr)))
 		return -1;
 
 	return ieee80211_data_to_8023(rx->skb, dev->dev_addr, sdata->vif.type);
@@ -1245,7 +1248,8 @@ ieee80211_deliver_skb(struct ieee80211_r
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-	    (rx->flags & IEEE80211_RX_RA_MATCH) && !rx->sdata->use_4addr) {
+	    (rx->flags & IEEE80211_RX_RA_MATCH) &&
+	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
 			 * send multicast frames both to higher layers in
@@ -2007,7 +2011,7 @@ static int prepare_for_handlers(struct i
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
-		if (!bssid && !sdata->use_4addr)
+		if (!bssid && !sdata->u.mgd.use_4addr)
 			return 0;
 		if (!multicast &&
 		    compare_ether_addr(sdata->dev->dev_addr, hdr->addr1) != 0) {
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-19 11:16:05.000000000 +0100
@@ -1051,7 +1051,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
-	if ((sdata->vif.type == NL80211_IFTYPE_AP_VLAN) && sdata->use_4addr)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 	if (!tx->sta)
 		tx->sta = sta_info_get(local, hdr->addr1);
@@ -1632,8 +1632,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		rcu_read_lock();
-		if (sdata->use_4addr)
-			sta = rcu_dereference(sdata->u.vlan.sta);
+		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
@@ -1727,7 +1726,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 #endif
 	case NL80211_IFTYPE_STATION:
 		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-		if (sdata->use_4addr && ethertype != ETH_P_PAE) {
+		if (sdata->u.mgd.use_4addr && ethertype != ETH_P_PAE) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
--- wireless-testing.orig/net/wireless/util.c	2009-11-19 11:04:52.000000000 +0100
+++ wireless-testing/net/wireless/util.c	2009-11-19 11:54:24.000000000 +0100
@@ -659,6 +659,8 @@ int cfg80211_change_iface(struct cfg8021
 		return -EOPNOTSUPP;
 
 	if (ntype != otype) {
+		dev->ieee80211_ptr->use_4addr = false;
+
 		switch (otype) {
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, false);
@@ -682,5 +684,8 @@ int cfg80211_change_iface(struct cfg8021
 
 	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
 
+	if (!err && params && params->use_4addr != -1)
+		dev->ieee80211_ptr->use_4addr = params->use_4addr;
+
 	return err;
 }


