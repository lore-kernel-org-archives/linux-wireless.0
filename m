Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbXLSPrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:22 -0500
Message-Id: <20071219003239.517557000@sipsolutions.net> (sfid-20071219_154732_694081_7C0AE11E)
References: <20071219003121.508296000@sipsolutions.net>
Date: Wed, 19 Dec 2007 01:31:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/6]  mac80211: move interface type to vif structure
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that support mixed AP/STA operation may well need to
know the type of a virtual interface when iterating over them.
The easiest way to support that is to move the interface type
variable into the vif structure.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h         |    2 +
 net/mac80211/cfg.c             |    2 -
 net/mac80211/debugfs_netdev.c  |    4 +-
 net/mac80211/ieee80211.c       |   36 +++++++++++-----------
 net/mac80211/ieee80211_i.h     |    1 
 net/mac80211/ieee80211_iface.c |   10 +++---
 net/mac80211/ieee80211_ioctl.c |   65 ++++++++++++++++++++---------------------
 net/mac80211/ieee80211_sta.c   |   46 ++++++++++++++---------------
 net/mac80211/key.c             |    6 +--
 net/mac80211/rx.c              |   32 ++++++++++----------
 net/mac80211/sta_info.c        |    4 +-
 net/mac80211/tx.c              |   17 +++++-----
 net/mac80211/util.c            |    2 -
 13 files changed, 114 insertions(+), 113 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-19 00:50:11.193025987 +0100
+++ everything/include/net/mac80211.h	2007-12-19 00:50:13.963022840 +0100
@@ -535,10 +535,12 @@ enum ieee80211_if_types {
  * Data in this structure is continually present for driver
  * use during the life of a virtual interface.
  *
+ * @type: type of this virtual interface
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
 struct ieee80211_vif {
+	enum ieee80211_if_types type;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
--- everything.orig/net/mac80211/cfg.c	2007-12-18 23:29:55.493043131 +0100
+++ everything/net/mac80211/cfg.c	2007-12-19 00:50:13.963022840 +0100
@@ -90,7 +90,7 @@ static int ieee80211_change_iface(struct
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-        if (sdata->type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 		return -EOPNOTSUPP;
 
 	ieee80211_if_reinit(dev);
--- everything.orig/net/mac80211/debugfs_netdev.c	2007-12-19 00:40:00.863027777 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2007-12-19 00:50:13.963022840 +0100
@@ -226,7 +226,7 @@ static void add_files(struct ieee80211_s
 	if (!sdata->debugfsdir)
 		return;
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		add_sta_files(sdata);
@@ -353,7 +353,7 @@ void ieee80211_debugfs_add_netdev(struct
 
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	del_files(sdata, sdata->type);
+	del_files(sdata, sdata->vif.type);
 	debugfs_remove(sdata->debugfsdir);
 	sdata->debugfsdir = NULL;
 }
--- everything.orig/net/mac80211/ieee80211.c	2007-12-19 00:50:11.203023546 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-19 00:50:13.963022840 +0100
@@ -177,21 +177,21 @@ static int ieee80211_open(struct net_dev
 			/*
 			 * check whether it may have the same address
 			 */
-			if (!identical_mac_addr_allowed(sdata->type,
-							nsdata->type))
+			if (!identical_mac_addr_allowed(sdata->vif.type,
+							nsdata->vif.type))
 				return -ENOTUNIQ;
 
 			/*
 			 * can only add VLANs to enabled APs
 			 */
-			if (sdata->type == IEEE80211_IF_TYPE_VLAN &&
-			    nsdata->type == IEEE80211_IF_TYPE_AP &&
+			if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN &&
+			    nsdata->vif.type == IEEE80211_IF_TYPE_AP &&
 			    netif_running(nsdata->dev))
 				sdata->u.vlan.ap = nsdata;
 		}
 	}
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_WDS:
 		if (is_zero_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
@@ -221,7 +221,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_hw_config(local);
 	}
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
 		/* no need to tell driver */
@@ -243,7 +243,7 @@ static int ieee80211_open(struct net_dev
 		/* fall through */
 	default:
 		conf.vif = &sdata->vif;
-		conf.type = sdata->type;
+		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
 		res = local->ops->add_interface(local_to_hw(local), &conf);
 		if (res && !local->open_count && local->ops->stop)
@@ -255,7 +255,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_reset_erp_info(dev);
 		ieee80211_enable_keys(sdata);
 
-		if (sdata->type == IEEE80211_IF_TYPE_STA &&
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
 		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 			netif_carrier_off(dev);
 		else
@@ -312,7 +312,7 @@ static int ieee80211_stop(struct net_dev
 	dev_mc_unsync(local->mdev, dev);
 
 	/* down all dependent devices, that is VLANs */
-	if (sdata->type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmp;
 
 		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
@@ -323,7 +323,7 @@ static int ieee80211_stop(struct net_dev
 
 	local->open_count--;
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_del(&sdata->u.vlan.list);
 		sdata->u.vlan.ap = NULL;
@@ -369,7 +369,7 @@ static int ieee80211_stop(struct net_dev
 		/* fall through */
 	default:
 		conf.vif = &sdata->vif;
-		conf.type = sdata->type;
+		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
@@ -490,13 +490,13 @@ static int __ieee80211_if_config(struct 
 		return 0;
 
 	memset(&conf, 0, sizeof(conf));
-	conf.type = sdata->type;
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	conf.type = sdata->vif.type;
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
-	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
 		conf.beacon = beacon;
@@ -691,7 +691,7 @@ static void ieee80211_tasklet_handler(un
 		case IEEE80211_RX_MSG:
 			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
-			/* Clear skb->type in order to not confuse kernel
+			/* Clear skb->pkt_type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type = 0;
 			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
@@ -952,7 +952,7 @@ void ieee80211_tx_status(struct ieee8021
 		if (!monitors || !skb)
 			goto out;
 
-		if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MNTR) {
 			if (!netif_running(sdata->dev))
 				continue;
 			monitors--;
@@ -1074,7 +1074,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mdev->header_ops = &ieee80211_header_ops;
 	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
 
-	sdata->type = IEEE80211_IF_TYPE_AP;
+	sdata->vif.type = IEEE80211_IF_TYPE_AP;
 	sdata->dev = mdev;
 	sdata->local = local;
 	sdata->u.ap.force_unicast_rateidx = -1;
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-12-19 00:50:11.533049315 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-12-19 00:50:13.973022461 +0100
@@ -66,7 +66,7 @@ int ieee80211_if_add(struct net_device *
 	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
 	ndev->ieee80211_ptr = &sdata->wdev;
 	sdata->wdev.wiphy = local->hw.wiphy;
-	sdata->type = IEEE80211_IF_TYPE_AP;
+	sdata->vif.type = IEEE80211_IF_TYPE_AP;
 	sdata->dev = ndev;
 	sdata->local = local;
 	ieee80211_if_sdata_init(sdata);
@@ -98,7 +98,7 @@ fail:
 void ieee80211_if_set_type(struct net_device *dev, int type)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int oldtype = sdata->type;
+	int oldtype = sdata->vif.type;
 
 	/*
 	 * We need to call this function on the master interface
@@ -116,7 +116,7 @@ void ieee80211_if_set_type(struct net_de
 
 	/* most have no BSS pointer */
 	sdata->bss = NULL;
-	sdata->type = type;
+	sdata->vif.type = type;
 
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
@@ -181,7 +181,7 @@ void ieee80211_if_reinit(struct net_devi
 
 	ieee80211_if_sdata_deinit(sdata);
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_INVALID:
 		/* cannot happen */
 		WARN_ON(1);
@@ -279,7 +279,7 @@ int ieee80211_if_remove(struct net_devic
 	ASSERT_RTNL();
 
 	list_for_each_entry_safe(sdata, n, &local->interfaces, list) {
-		if ((sdata->type == id || id == -1) &&
+		if ((sdata->vif.type == id || id == -1) &&
 		    strcmp(name, sdata->dev->name) == 0 &&
 		    sdata->dev != local->mdev) {
 			list_del_rcu(&sdata->list);
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2007-12-18 23:29:55.693022786 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2007-12-19 00:50:13.973022461 +0100
@@ -111,8 +111,8 @@ static int ieee80211_ioctl_siwgenie(stru
 	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
 		return -EOPNOTSUPP;
 
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		int ret = ieee80211_sta_set_extra_ie(dev, extra, data->length);
 		if (ret)
 			return ret;
@@ -231,7 +231,7 @@ static int ieee80211_ioctl_siwmode(struc
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int type;
 
-	if (sdata->type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 		return -EOPNOTSUPP;
 
 	switch (*mode) {
@@ -248,7 +248,7 @@ static int ieee80211_ioctl_siwmode(struc
 		return -EINVAL;
 	}
 
-	if (type == sdata->type)
+	if (type == sdata->vif.type)
 		return 0;
 	if (netif_running(dev))
 		return -EBUSY;
@@ -267,7 +267,7 @@ static int ieee80211_ioctl_giwmode(struc
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_AP:
 		*mode = IW_MODE_MASTER;
 		break;
@@ -335,13 +335,13 @@ static int ieee80211_ioctl_siwfreq(struc
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->type == IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->type == IEEE80211_IF_TYPE_STA)
+			if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
 				sdata->u.sta.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
@@ -387,8 +387,8 @@ static int ieee80211_ioctl_siwessid(stru
 		len--;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		int ret;
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			if (len > IEEE80211_MAX_SSID_LEN)
@@ -408,7 +408,7 @@ static int ieee80211_ioctl_siwessid(stru
 		return 0;
 	}
 
-	if (sdata->type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		memcpy(sdata->u.ap.ssid, ssid, len);
 		memset(sdata->u.ap.ssid + len, 0,
 		       IEEE80211_MAX_SSID_LEN - len);
@@ -427,8 +427,8 @@ static int ieee80211_ioctl_giwessid(stru
 
 	struct ieee80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		int res = ieee80211_sta_get_ssid(dev, ssid, &len);
 		if (res == 0) {
 			data->length = len;
@@ -438,7 +438,7 @@ static int ieee80211_ioctl_giwessid(stru
 		return res;
 	}
 
-	if (sdata->type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		len = sdata->u.ap.ssid_len;
 		if (len > IW_ESSID_MAX_SIZE)
 			len = IW_ESSID_MAX_SIZE;
@@ -458,8 +458,8 @@ static int ieee80211_ioctl_siwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		int ret;
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
@@ -478,7 +478,7 @@ static int ieee80211_ioctl_siwap(struct 
 			return ret;
 		ieee80211_sta_req_auth(dev, &sdata->u.sta);
 		return 0;
-	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
 		if (memcmp(sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
 			   ETH_ALEN) == 0)
 			return 0;
@@ -496,12 +496,12 @@ static int ieee80211_ioctl_giwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		return 0;
-	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
 		return 0;
@@ -523,11 +523,10 @@ static int ieee80211_ioctl_siwscan(struc
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS &&
-	    sdata->type != IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_AP)
 		return -EOPNOTSUPP;
-	}
 
 	/* if SSID was specified explicitly then use that */
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
@@ -605,7 +604,7 @@ static int ieee80211_ioctl_giwrate(struc
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
 	else
 		return -EOPNOTSUPP;
@@ -818,8 +817,8 @@ static int ieee80211_ioctl_siwmlme(struc
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
 	switch (mlme->cmd) {
@@ -936,7 +935,7 @@ static int ieee80211_ioctl_siwauth(struc
 		sdata->drop_unencrypted = !!data->value;
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
+		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 			ret = -EINVAL;
 		else {
 			sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
@@ -951,8 +950,8 @@ static int ieee80211_ioctl_siwauth(struc
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->type == IEEE80211_IF_TYPE_STA ||
-		    sdata->type == IEEE80211_IF_TYPE_IBSS)
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
 			sdata->u.sta.auth_algs = data->value;
 		else
 			ret = -EOPNOTSUPP;
@@ -972,8 +971,8 @@ static struct iw_statistics *ieee80211_g
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
 	if (!sta) {
 		wstats->discard.fragment = 0;
@@ -1001,8 +1000,8 @@ static int ieee80211_ioctl_giwauth(struc
 
 	switch (data->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->type == IEEE80211_IF_TYPE_STA ||
-		    sdata->type == IEEE80211_IF_TYPE_IBSS)
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
 			data->value = sdata->u.sta.auth_algs;
 		else
 			ret = -EOPNOTSUPP;
--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-19 00:48:26.783024250 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-19 00:50:13.983023871 +0100
@@ -464,7 +464,7 @@ static void ieee80211_set_associated(str
 		ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
+		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
@@ -1017,7 +1017,7 @@ static void ieee80211_send_addba_resp(st
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	if (sdata->type == IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
 		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
@@ -1090,7 +1090,7 @@ static void ieee80211_rx_mgmt_auth(struc
 	DECLARE_MAC_BUF(mac);
 
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
 		printk(KERN_DEBUG "%s: authentication frame received from "
 		       "%s, but not in authenticate state - ignored\n",
 		       dev->name, print_mac(mac, mgmt->sa));
@@ -1104,7 +1104,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		return;
 	}
 
-	if (sdata->type != IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 	    memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0) {
 		printk(KERN_DEBUG "%s: authentication frame received from "
 		       "unknown AP (SA=%s BSSID=%s) - "
@@ -1113,7 +1113,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		return;
 	}
 
-	if (sdata->type != IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0) {
 		printk(KERN_DEBUG "%s: authentication frame received from "
 		       "unknown BSSID (SA=%s BSSID=%s) - "
@@ -1131,7 +1131,7 @@ static void ieee80211_rx_mgmt_auth(struc
 	       dev->name, print_mac(mac, mgmt->sa), auth_alg,
 	       auth_transaction, status_code);
 
-	if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		/* IEEE 802.11 standard does not require authentication in IBSS
 		 * networks and most implementations do not seem to use it.
 		 * However, try to reply to authentication attempts if someone
@@ -1624,7 +1624,7 @@ static void ieee80211_rx_bss_info(struct
 
 	timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 
-	if (sdata->type == IEEE80211_IF_TYPE_IBSS && beacon &&
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		static unsigned long last_tsf_debug = 0;
@@ -1649,7 +1649,7 @@ static void ieee80211_rx_bss_info(struct
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	if (sdata->type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
 		struct ieee80211_hw_mode *mode;
@@ -1878,7 +1878,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return;
 	ifsta = &sdata->u.sta;
 
@@ -1938,7 +1938,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	DECLARE_MAC_BUF(mac3);
 #endif
 
-	if (sdata->type != IEEE80211_IF_TYPE_IBSS ||
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS ||
 	    ifsta->state != IEEE80211_IBSS_JOINED ||
 	    len < 24 + 2 || !ifsta->probe_resp)
 		return;
@@ -2243,10 +2243,10 @@ void ieee80211_sta_work(struct work_stru
 	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return;
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
 		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
-		       "(type=%d)\n", dev->name, sdata->type);
+		       "(type=%d)\n", dev->name, sdata->vif.type);
 		return;
 	}
 	ifsta = &sdata->u.sta;
@@ -2341,7 +2341,7 @@ void ieee80211_sta_req_auth(struct net_d
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return;
 
 	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
@@ -2811,7 +2811,7 @@ int ieee80211_sta_set_ssid(struct net_de
 		ifsta->flags |= IEEE80211_STA_SSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
-	if (sdata->type == IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
 	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_IBSS_SEARCH;
@@ -2929,7 +2929,7 @@ void ieee80211_scan_completed(struct iee
 		if (sdata->dev == local->mdev)
 			continue;
 
-		if (sdata->type == IEEE80211_IF_TYPE_STA) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
 				ieee80211_send_nullfunc(local, sdata, 0);
 			ieee80211_sta_timer((unsigned long)sdata);
@@ -2941,7 +2941,7 @@ void ieee80211_scan_completed(struct iee
 
 done:
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
 		    (!ifsta->state == IEEE80211_IBSS_JOINED &&
@@ -2976,7 +2976,7 @@ void ieee80211_sta_scan_work(struct work
 		skip = !(local->enabled_modes & (1 << mode->mode));
 		chan = &mode->channels[local->scan_channel_idx];
 		if (!(chan->flag & IEEE80211_CHAN_W_SCAN) ||
-		    (sdata->type == IEEE80211_IF_TYPE_IBSS &&
+		    (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
 		     !(chan->flag & IEEE80211_CHAN_W_IBSS)) ||
 		    (local->hw_modes & local->enabled_modes &
 		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
@@ -3084,7 +3084,7 @@ static int ieee80211_sta_start_scan(stru
 			continue;
 
 		netif_stop_queue(sdata->dev);
-		if (sdata->type == IEEE80211_IF_TYPE_STA &&
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
 		    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
 			ieee80211_send_nullfunc(local, sdata, 1);
 	}
@@ -3125,7 +3125,7 @@ int ieee80211_sta_req_scan(struct net_de
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
 
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
@@ -3348,8 +3348,8 @@ int ieee80211_sta_deauthenticate(struct 
 	printk(KERN_DEBUG "%s: deauthenticate(reason=%d)\n",
 	       dev->name, reason);
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return -EINVAL;
 
 	ieee80211_send_deauth(dev, ifsta, reason);
@@ -3366,7 +3366,7 @@ int ieee80211_sta_disassociate(struct ne
 	printk(KERN_DEBUG "%s: disassociate(reason=%d)\n",
 	       dev->name, reason);
 
-	if (sdata->type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return -EINVAL;
 
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
--- everything.orig/net/mac80211/key.c	2007-12-18 23:29:55.803040906 +0100
+++ everything/net/mac80211/key.c	2007-12-19 00:50:13.983023871 +0100
@@ -49,8 +49,8 @@ static const u8 *get_mac_for_key(struct 
 	 * address to indicate a transmit-only key.
 	 */
 	if (key->conf.alg != ALG_WEP &&
-	    (key->sdata->type == IEEE80211_IF_TYPE_AP ||
-	     key->sdata->type == IEEE80211_IF_TYPE_VLAN))
+	    (key->sdata->vif.type == IEEE80211_IF_TYPE_AP ||
+	     key->sdata->vif.type == IEEE80211_IF_TYPE_VLAN))
 		addr = zero_addr;
 
 	if (key->sta)
@@ -172,7 +172,7 @@ struct ieee80211_key *ieee80211_key_allo
 		if (sta->flags & WLAN_STA_WME)
 			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
 	} else {
-		if (sdata->type == IEEE80211_IF_TYPE_STA) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 			struct sta_info *ap;
 
 			/* same here, the AP could be using QoS */
--- everything.orig/net/mac80211/rx.c	2007-12-19 00:40:00.863027777 +0100
+++ everything/net/mac80211/rx.c	2007-12-19 00:50:13.983023871 +0100
@@ -215,7 +215,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->type != IEEE80211_IF_TYPE_MNTR)
+		if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR)
 			continue;
 
 		if (prev_dev) {
@@ -414,7 +414,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
-		     rx->sdata->type != IEEE80211_IF_TYPE_IBSS &&
+		     rx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 		     (!rx->sta || !(rx->sta->flags & WLAN_STA_ASSOC)))) {
 		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
 		     !(rx->fc & IEEE80211_FCTL_TODS) &&
@@ -634,13 +634,13 @@ ieee80211_rx_h_sta_process(struct ieee80
 	/* Update last_rx only for IBSS packets which are for the current
 	 * BSSID to avoid keeping the current IBSS network alive in cases where
 	 * other STAs are using different BSSID. */
-	if (rx->sdata->type == IEEE80211_IF_TYPE_IBSS) {
+	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len);
 		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
-	    rx->sdata->type == IEEE80211_IF_TYPE_STA) {
+	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 		/* Update last_rx only for unicast frames in order to prevent
 		 * the Probe Request frames (the only broadcast frames from a
 		 * STA in infrastructure mode) from keeping a connection alive.
@@ -1047,8 +1047,8 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
-		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
-			     sdata->type != IEEE80211_IF_TYPE_VLAN)) {
+		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
+			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: dropped ToDS frame "
 				       "(BSSID=%s SA=%s DA=%s)\n",
@@ -1064,7 +1064,7 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr4, ETH_ALEN);
 
-		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS)) {
+		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
 				       "frame (RA=%s TA=%s DA=%s SA=%s)\n",
@@ -1081,7 +1081,7 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
 
-		if (sdata->type != IEEE80211_IF_TYPE_STA ||
+		if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, dev->dev_addr)))
 			return -1;
@@ -1091,7 +1091,7 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
-		if (sdata->type != IEEE80211_IF_TYPE_IBSS) {
+		if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: dropped IBSS frame "
 				       "(DA=%s SA=%s BSSID=%s)\n",
@@ -1179,8 +1179,8 @@ ieee80211_deliver_skb(struct ieee80211_t
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP ||
-				      sdata->type == IEEE80211_IF_TYPE_VLAN) &&
+	if (local->bridge_packets && (sdata->vif.type == IEEE80211_IF_TYPE_AP ||
+				      sdata->vif.type == IEEE80211_IF_TYPE_VLAN) &&
 	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
@@ -1381,8 +1381,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 		return TXRX_DROP;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
-	if ((sdata->type == IEEE80211_IF_TYPE_STA ||
-	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
+	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
@@ -1474,7 +1474,7 @@ static void ieee80211_rx_michael_mic_rep
 		goto ignore;
 	}
 
-	if (rx->sdata->type == IEEE80211_IF_TYPE_AP && keyidx) {
+	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP && keyidx) {
 		/*
 		 * APs with pairwise keys should never receive Michael MIC
 		 * errors for non-zero keyidx because these are reserved for
@@ -1535,7 +1535,7 @@ static int prepare_for_handlers(struct i
 {
 	int multicast = is_multicast_ether_addr(hdr->addr1);
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_STA:
 		if (!bssid)
 			return 0;
@@ -1703,7 +1703,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MNTR)
 			continue;
 
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
--- everything.orig/net/mac80211/tx.c	2007-12-19 00:50:11.223023816 +0100
+++ everything/net/mac80211/tx.c	2007-12-19 00:50:13.993023057 +0100
@@ -237,7 +237,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 
 	if (likely(tx->flags & IEEE80211_TXRXD_TXUNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
-			     tx->sdata->type != IEEE80211_IF_TYPE_IBSS &&
+			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 			     (tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			DECLARE_MAC_BUF(mac);
@@ -251,7 +251,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	} else {
 		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 			     tx->local->num_sta == 0 &&
-			     tx->sdata->type != IEEE80211_IF_TYPE_IBSS)) {
+			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS)) {
 			/*
 			 * No associated STAs - no need to send multicast
 			 * frames.
@@ -294,7 +294,7 @@ static void purge_old_ps_buffers(struct 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ieee80211_if_ap *ap;
 		if (sdata->dev == local->mdev ||
-		    sdata->type != IEEE80211_IF_TYPE_AP)
+		    sdata->vif.type != IEEE80211_IF_TYPE_AP)
 			continue;
 		ap = &sdata->u.ap;
 		skb = skb_dequeue(&ap->ps_bc_buf);
@@ -954,7 +954,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (unlikely(sdata->type == IEEE80211_IF_TYPE_MNTR)) {
+	if (unlikely(sdata->vif.type == IEEE80211_IF_TYPE_MNTR)) {
 		if (__ieee80211_parse_tx_radiotap(tx, skb) == TXRX_DROP)
 			return TXRX_DROP;
 
@@ -1257,7 +1257,7 @@ int ieee80211_master_start_xmit(struct s
 	}
 
 	control.vif = &osdata->vif;
-	control.type = osdata->type;
+	control.type = osdata->vif.type;
 	if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
 		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
 	if (pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT)
@@ -1376,7 +1376,7 @@ int ieee80211_subif_start_xmit(struct sk
 	ethertype = (skb->data[12] << 8) | skb->data[13];
 	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
 
-	switch (sdata->type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_AP:
 	case IEEE80211_IF_TYPE_VLAN:
 		fc |= IEEE80211_FCTL_FROMDS;
@@ -1713,7 +1713,7 @@ struct sk_buff *ieee80211_beacon_get(str
 	bdev = sdata->dev;
 	ap = &sdata->u.ap;
 
-	if (!ap || sdata->type != IEEE80211_IF_TYPE_AP ||
+	if (!ap || sdata->vif.type != IEEE80211_IF_TYPE_AP ||
 	    !ap->beacon_head) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
@@ -1826,7 +1826,8 @@ ieee80211_get_buffered_bc(struct ieee802
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
 
-	if (!bss || sdata->type != IEEE80211_IF_TYPE_AP || !bss->beacon_head)
+	if (!bss || sdata->vif.type != IEEE80211_IF_TYPE_AP ||
+	    !bss->beacon_head)
 		return NULL;
 
 	if (bss->dtim_count != 0)
--- everything.orig/net/mac80211/util.c	2007-12-19 00:50:11.213056044 +0100
+++ everything/net/mac80211/util.c	2007-12-19 00:50:13.993023057 +0100
@@ -453,7 +453,7 @@ void ieee80211_iterate_active_interfaces
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		switch (sdata->type) {
+		switch (sdata->vif.type) {
 		case IEEE80211_IF_TYPE_INVALID:
 		case IEEE80211_IF_TYPE_MNTR:
 		case IEEE80211_IF_TYPE_VLAN:
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-19 00:50:11.213056044 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-19 00:50:14.003022188 +0100
@@ -294,7 +294,6 @@ struct ieee80211_if_sta {
 #define IEEE80211_SDATA_USERSPACE_MLME	BIT(4)
 struct ieee80211_sub_if_data {
 	struct list_head list;
-	enum ieee80211_if_types type;
 
 	struct wireless_dev wdev;
 
--- everything.orig/net/mac80211/sta_info.c	2007-12-19 00:50:11.533049315 +0100
+++ everything/net/mac80211/sta_info.c	2007-12-19 00:50:14.003022188 +0100
@@ -164,7 +164,7 @@ struct sta_info * sta_info_add(struct ie
 		struct ieee80211_sub_if_data *sdata;
 
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-		if (sdata->type == IEEE80211_IF_TYPE_VLAN)
+		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
@@ -242,7 +242,7 @@ void sta_info_free(struct sta_info *sta)
 
 		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
-		if (sdata->type == IEEE80211_IF_TYPE_VLAN)
+		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,

-- 

