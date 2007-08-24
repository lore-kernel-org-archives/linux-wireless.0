Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbXHYHzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 03:55:20 -0400
Subject: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 22:37:30 +0200
Message-Id: <1187987850.24933.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes hostapd use nl80211 (via libnl) to create/remove interfaces.
Also lays the foundation for using nl80211 in hostapd.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I have tested this code with the patch to use monitor interfaces instead
of the management interface, but wasn't able to test exactly these code
paths because none of the cards we have drivers for currently allow
multiple BSSes.

 hostapd/Makefile             |    1 
 hostapd/defconfig            |    5 
 hostapd/driver_devicescape.c |  221 ++++++++++++++++++++++++-------------------
 3 files changed, 133 insertions(+), 94 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-24 22:34:17.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-24 22:34:19.000000000 +0200
@@ -16,24 +16,22 @@
 
 #include "includes.h"
 #include <sys/ioctl.h>
-
-#ifdef USE_KERNEL_HEADERS
-#include <asm/types.h>
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+#include <linux/nl80211.h>
+#include <net/if.h>
 #include <linux/if_packet.h>
 #include <linux/if_ether.h>   /* The L2 protocols */
-#include <linux/if_arp.h>
 #include <linux/wireless.h>
-#else /* USE_KERNEL_HEADERS */
 #include <net/if_arp.h>
-#include <netpacket/packet.h>
-#include "wireless_copy.h"
-#endif /* USE_KERNEL_HEADERS */
 
 #include "hostapd.h"
 #include "driver.h"
 #include "ieee802_1x.h"
 #include "eloop.h"
-#include "priv_netlink.h"
 #include "ieee802_11.h"
 #include "sta_info.h"
 #include "hw_features.h"
@@ -67,6 +65,9 @@ struct i802_driver_data {
 	int wext_sock; /* socket for wireless events */
 
 	int we_version;
+	struct nl_handle *nl_handle;
+	struct nl_cache *nl_cache;
+	struct genl_family *nl80211;
 };
 
 
@@ -787,56 +788,103 @@ static int i802_set_tx_queue_params(void
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
+ nla_put_failure:
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
+	if (addr) {
+		switch (iftype) {
+		case NL80211_IFTYPE_AP:
+			os_strlcpy(ifreq.ifr_name, ifname, IFNAMSIZ);
+			memcpy(ifreq.ifr_hwaddr.sa_data, addr, ETH_ALEN);
+			ifreq.ifr_hwaddr.sa_family = ARPHRD_ETHER;
+
+			if (ioctl(drv->ioctl_sock, SIOCSIFHWADDR, &ifreq)) {
+				nl80211_remove_iface(drv, ifidx);
+				return -1;
+			}
+			break;
+		case NL80211_IFTYPE_WDS:
+			memset(&iwr, 0, sizeof(iwr));
+			os_strlcpy(iwr.ifr_name, ifname, IFNAMSIZ);
+			iwr.u.addr.sa_family = ARPHRD_ETHER;
+			memcpy(iwr.u.addr.sa_data, addr, ETH_ALEN);
+			if (ioctl(drv->ioctl_sock, SIOCSIWAP, &iwr))
+				return -1;
+			break;
+		default:
+			/* nothing */
+			break;
+		}
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
 
 
@@ -961,13 +1009,13 @@ static int i802_set_short_slot_time(void
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
@@ -977,32 +1025,8 @@ static int i802_if_add(const char *iface
 		       enum hostapd_driver_if_type type, char *ifname,
 		       const u8 *addr)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-
-	param = malloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (!param)
-		return -1;
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
+	if (nl80211_create_iface(priv, ifname, i802_if_type(type), addr) < 0)
 		return -1;
-	}
-
-	os_strlcpy(ifname, (char *) param->u.if_info.name, IFNAMSIZ);
-	free(param);
 	return 0;
 }
 
@@ -1018,28 +1042,7 @@ static int i802_if_update(void *priv, en
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
 
@@ -1525,6 +1528,32 @@ static int i802_init_sockets(struct i802
 		return -1;
 	}
 
+	/*
+	 * initialise generic netlink and nl80211
+	 */
+	drv->nl_handle = nl_handle_alloc();
+	if (!drv->nl_handle) {
+		printf("Failed to allocate netlink handle.\n");
+		return -1;
+	}
+
+	if (genl_connect(drv->nl_handle)) {
+		printf("Failed to connect to generic netlink.\n");
+		return -1;
+	}
+
+	drv->nl_cache = genl_ctrl_alloc_cache(drv->nl_handle);
+	if (!drv->nl_cache) {
+		printf("Failed to allocate generic netlink cache.\n");
+		return -1;
+	}
+
+	drv->nl80211 = genl_ctrl_search_by_name(drv->nl_cache, "nl80211");
+	if (!drv->nl80211) {
+		printf("nl80211 not found.\n");
+		return -1;
+	}
+
 	/* Enable management interface */
 	if (hostap_ioctl_prism2param(drv, PRISM2_PARAM_MGMT_IF, 1) < 0) {
 		printf("Failed to enable management interface.\n");
@@ -1952,6 +1981,10 @@ static void i802_deinit(void *priv)
 	if (drv->ioctl_sock >= 0)
 		close(drv->ioctl_sock);
 
+	genl_family_put(drv->nl80211);
+	nl_cache_free(drv->nl_cache);
+	nl_handle_destroy(drv->nl_handle);
+
 	free(drv);
 }
 
--- hostap.orig/hostapd/Makefile	2007-08-24 22:34:10.000000000 +0200
+++ hostap/hostapd/Makefile	2007-08-24 22:34:19.000000000 +0200
@@ -118,6 +118,7 @@ endif
 ifdef CONFIG_DRIVER_DEVICESCAPE
 CFLAGS += -DCONFIG_DRIVER_DEVICESCAPE
 OBJS += driver_devicescape.o
+LIBS += -lnl
 endif
 
 ifdef CONFIG_DRIVER_BSD
--- hostap.orig/hostapd/defconfig	2007-08-24 22:34:10.000000000 +0200
+++ hostap/hostapd/defconfig	2007-08-24 22:34:19.000000000 +0200
@@ -30,6 +30,11 @@ CONFIG_DRIVER_HOSTAP=y
 # wireless-dev.git tree).
 #WIRELESS_DEV=/usr/src/wireless-dev
 #CFLAGS += -I$(WIRELESS_DEV)/net/mac80211
+# driver_devicescape.c requires a rather new libnl, probably not
+# shipped with your distribution yet
+#LIBNL=/usr/src/libnl
+#CFLAGS += -I$(LIBNL)/include
+#LIBS += -L$(LIBNL)/lib
 
 # Driver interface for FreeBSD net80211 layer (e.g., Atheros driver)
 #CONFIG_DRIVER_BSD=y


