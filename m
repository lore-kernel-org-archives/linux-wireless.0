Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760965AbXHNLvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:51:37 -0400
Message-Id: <20070814093409.871817000@sipsolutions.net>
References: <20070814093254.021041000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:32:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] hostapd: use nl80211 for add/remove iface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 hostapd/driver_devicescape.c |  217 +++++++++++++++++++------------------------
 1 file changed, 99 insertions(+), 118 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-14 11:32:35.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 11:32:35.000000000 +0200
@@ -786,56 +786,108 @@ static int i802_set_tx_queue_params(void
 }
 
 
-static int i802_bss_add(void *priv, const char *ifname, const u8 *bssid)
+static void nl80211_remove_iface(struct i802_driver_data *drv, int ifidx)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
+	struct nl_msg *msg;
 
-	param = os_zalloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (param == NULL)
+	msg = nlmsg_alloc();
+	if (!msg)
+		goto nla_put_failure;
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
+		    0, NL80211_CMD_DEL_VIRTUAL_INTERFACE, 0);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifidx);
+	if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
+	    nl_wait_for_ack(drv->nl_handle) < 0)
+	nla_put_failure:
+		printf("Failed to remove interface.\n");
+	nlmsg_free(msg);
+}
+
+
+static int nl80211_create_iface(struct i802_driver_data *drv,
+				const char *ifname,
+				enum nl80211_iftype iftype,
+				const u8 *addr)
+{
+	struct nl_msg *msg;
+	int ifidx;
+	struct ifreq ifreq;
+	struct iwreq iwr;
+
+	msg = nlmsg_alloc();
+	if (!msg)
 		return -1;
 
-	param->cmd = PRISM2_HOSTAPD_ADD_IF;
-	param->u.if_info.type = HOSTAP_IF_BSS;
-	memcpy(param->u.if_info.data, bssid, ETH_ALEN);
-	os_strlcpy((char *) param->u.if_info.name, ifname, IFNAMSIZ);
-
-	if (hostapd_ioctl(drv, param,
-			  sizeof(struct prism2_hostapd_param) + ETH_ALEN)) {
-		printf("Could not add bss iface: %s.\n", ifname);
-		free(param);
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
+		    0, NL80211_CMD_ADD_VIRTUAL_INTERFACE, 0);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX,
+		    if_nametoindex(drv->hapd->conf->iface));
+	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, ifname);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, iftype);
+
+	if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
+	    nl_wait_for_ack(drv->nl_handle) < 0) {
+	nla_put_failure:
+		printf("Failed to create interface %s.\n", ifname);
+		nlmsg_free(msg);
 		return -1;
 	}
 
-	free(param);
+	nlmsg_free(msg);
 
-	return 0;
+	ifidx = if_nametoindex(ifname);
+
+	if (ifidx <= 0)
+		return -1;
+
+	if (addr) switch (iftype) {
+	case NL80211_IFTYPE_AP:
+		/*
+		 * This is how it works in mac80211 right now, but who gets to
+		 * handle multiple AP devices with different BSSIDs but the
+		 * same MAC?
+		 * In fact, I think we should be changing the BSSID here and
+		 * not the MAC address... but mac80211 doesn't support that!
+		 */
+		os_strlcpy(ifreq.ifr_name, ifname, IFNAMSIZ);
+		memcpy(ifreq.ifr_hwaddr.sa_data, addr, ETH_ALEN);
+		ifreq.ifr_hwaddr.sa_family = ARPHRD_ETHER;
+
+		if (ioctl(drv->ioctl_sock, SIOCSIFHWADDR, &ifreq)) {
+			nl80211_remove_iface(drv, ifidx);
+			return -1;
+		}
+		break;
+	case NL80211_IFTYPE_WDS:
+		memset(&iwr, 0, sizeof(iwr));
+		os_strlcpy(iwr.ifr_name, ifname, IFNAMSIZ);
+		iwr.u.addr.sa_family = ARPHRD_ETHER;
+		memcpy(iwr.u.addr.sa_data, addr, ETH_ALEN);
+		if (ioctl(drv->ioctl_sock, SIOCSIWAP, &iwr))
+			return -1;
+		break;
+	default:
+		/* nothing */
+		break;
+	}
+
+	return ifidx;
 }
 
 
-static int i802_bss_remove(void *priv, const char *ifname)
+static int i802_bss_add(void *priv, const char *ifname, const u8 *bssid)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-	int ret = 0;
-
-	param = os_zalloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (param == NULL)
+	if (nl80211_create_iface(priv, ifname, NL80211_IFTYPE_AP, bssid) < 0)
 		return -1;
+	return 0;
+}
 
-	param->cmd = PRISM2_HOSTAPD_REMOVE_IF;
-	param->u.if_info.type = HOSTAP_IF_BSS;
-	os_strlcpy((char *) param->u.if_info.name, ifname, IFNAMSIZ);
-
-	if (hostapd_ioctl(drv, param,
-			  sizeof(struct prism2_hostapd_param) + ETH_ALEN)) {
-		printf("Could not remove iface: %s.\n", ifname);
-		ret = -1;
-	}
-
-	free(param);
 
-	return ret;
+static int i802_bss_remove(void *priv, const char *ifname)
+{
+	nl80211_remove_iface(priv, if_nametoindex(ifname));
+	return 0;
 }
 
 
@@ -970,13 +1022,13 @@ static int i802_set_short_slot_time(void
 }
 
 
-static int i802_if_type(enum hostapd_driver_if_type type)
+static enum nl80211_iftype i802_if_type(enum hostapd_driver_if_type type)
 {
 	switch (type) {
 	case HOSTAPD_IF_VLAN:
-		return HOSTAP_IF_VLAN;
+		return NL80211_IFTYPE_AP_VLAN;
 	case HOSTAPD_IF_WDS:
-		return HOSTAP_IF_WDS;
+		return NL80211_IFTYPE_WDS;
 	}
 	return -1;
 }
@@ -986,32 +1038,8 @@ static int i802_if_add(const char *iface
 		       enum hostapd_driver_if_type type, char *ifname,
 		       const u8 *addr)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-
-	param = malloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (!param)
+	if (nl80211_create_iface(priv, ifname, i802_if_type(type), addr) < 0)
 		return -1;
-	memset(param, 0, sizeof(param));
-
-	param->cmd = PRISM2_HOSTAPD_ADD_IF;
-	param->u.if_info.type = i802_if_type(type);
-	if (addr)
-		memcpy(param->u.if_info.data, addr, ETH_ALEN);
-	else
-		memset(param->u.if_info.data, 0, ETH_ALEN);
-	os_strlcpy((char *) param->u.if_info.name, ifname, IFNAMSIZ);
-
-	/* FIX: should the size have + ETH_ALEN ? */
-	if (hostapd_ioctl_iface(iface, drv, param,
-				sizeof(struct prism2_hostapd_param))) {
-		printf("Could not add iface: %s.\n", ifname);
-		free(param);
-		return -1;
-	}
-
-	os_strlcpy(ifname, (char *) param->u.if_info.name, IFNAMSIZ);
-	free(param);
 	return 0;
 }
 
@@ -1027,28 +1055,7 @@ static int i802_if_update(void *priv, en
 static int i802_if_remove(void *priv, enum hostapd_driver_if_type type,
 			  const char *ifname, const u8 *addr)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-
-	param = malloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (!param)
-		return -1;
-	memset(param, 0, sizeof(param));
-
-	param->cmd = PRISM2_HOSTAPD_REMOVE_IF;
-	param->u.if_info.type = i802_if_type(type);
-	if (addr)
-		memcpy(param->u.if_info.data, addr, ETH_ALEN);
-	else
-		memset(param->u.if_info.data, 0, ETH_ALEN);
-	os_strlcpy((char *) param->u.if_info.name, ifname, IFNAMSIZ);
-	if (hostapd_ioctl(drv, param, sizeof(struct prism2_hostapd_param))) {
-		printf("Could not remove iface: %s.\n", ifname);
-		free(param);
-		return -1;
-	}
-
-	free(param);
+	nl80211_remove_iface(priv, if_nametoindex(ifname));
 	return 0;
 }
 
@@ -1546,7 +1553,6 @@ static int i802_init_sockets(struct i802
 	struct sockaddr_ll addr;
 	struct iwreq iwr;
 	char buf[IFNAMSIZ];
-	struct nl_msg *msg;
 	socklen_t optlen;
 	int optval;
 	int idx;
@@ -1584,28 +1590,14 @@ static int i802_init_sockets(struct i802
 		return -1;
 	}
 
-	/* conjure a monitor interface */
-	msg = nlmsg_alloc();
-	if (!msg) {
-		printf("Failed to allocate netlink message.\n");
-		return -1;
-	}
 	snprintf(buf, IFNAMSIZ, "mon.%s", hapd->conf->iface);
 	buf[IFNAMSIZ-1] = '\0';
-	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
-		    0, NL80211_CMD_ADD_VIRTUAL_INTERFACE, 0);
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX,
-		    if_nametoindex(hapd->conf->iface));
-	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, buf);
-	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, NL80211_IFTYPE_MONITOR);
-	if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
-	    nl_wait_for_ack(drv->nl_handle) < 0) {
-	nla_put_failure:
-		nlmsg_free(msg);
-		printf("Failed to create monitor interface %s.\n", buf);
+
+	drv->monitor_ifidx = nl80211_create_iface(drv, buf,
+						  NL80211_IFTYPE_MONITOR,
+						  NULL);
+	if (drv->monitor_ifidx < 0)
 		return -1;
-	}
-	nlmsg_free(msg);
 
 	/*
 	 * TODO: try disabling receiving control frames on the monitor iface,
@@ -1631,7 +1623,7 @@ static int i802_init_sockets(struct i802
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sll_family = AF_PACKET;
-	drv->monitor_ifidx = addr.sll_ifindex = if_nametoindex(buf);
+	addr.sll_ifindex = drv->monitor_ifidx;
 	HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL,
 		      "Opening raw packet socket for monitor (%d)\n",
 		      addr.sll_ifindex);
@@ -2078,7 +2070,6 @@ failed:
 static void i802_deinit(void *priv)
 {
 	struct i802_driver_data *drv = priv;
-	struct nl_msg *msg;
 
 	(void) hostapd_set_iface_flags(drv, 0);
 
@@ -2088,17 +2079,7 @@ static void i802_deinit(void *priv)
 	eloop_unregister_read_sock(drv->monitor_sock);
 	close(drv->monitor_sock);
 
-	msg = nlmsg_alloc();
-	if (msg) {
-		genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
-			    0, NL80211_CMD_DEL_VIRTUAL_INTERFACE, 0);
-		NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->monitor_ifidx);
-		if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
-		    nl_wait_for_ack(drv->nl_handle) < 0)
-		nla_put_failure:
-			printf("Failed to remove monitor interface.\n");
-		nlmsg_free(msg);
-	}
+	nl80211_remove_iface(drv, drv->monitor_ifidx);
 	nl_cache_free(drv->nl_cache);
 	nl_handle_destroy(drv->nl_handle);
 

-- 

