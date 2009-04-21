Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37060 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZDUUoH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 16:44:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Update compat.diff
Date: Tue, 21 Apr 2009 22:43:57 +0200
Message-Id: <1240346638-18755-1-git-send-email-hauke@hauke-m.de> (sfid-20090421_224415_117345_8289AC09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Remove include/net/wireless.h and add include/net/regulatory.h.
* Enable powersave by default.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff      |   42 +++++++++++++++++++++---------------------
 config.mk               |    5 ++++-
 scripts/admin-update.sh |    2 +-
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 5b65c82..e265090 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -295,7 +295,7 @@
  	net_dev->wireless_handlers = &ipw_wx_handler_def;
 --- a/drivers/net/wireless/libertas/if_cs.c
 +++ b/drivers/net/wireless/libertas/if_cs.c
-@@ -791,7 +791,11 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
+@@ -813,7 +813,11 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
  	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
  	if ((ret = pcmcia_get_first_tuple(p_dev, &tuple)) != 0 ||
  	    (ret = pcmcia_get_tuple_data(p_dev, &tuple)) != 0 ||
@@ -429,7 +429,7 @@
  	dev->tx_queue_len = 0;
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -2381,6 +2381,7 @@ static int bcm4320_early_init(struct usbnet *usbdev)
+@@ -2342,6 +2342,7 @@ static int bcm4320_early_init(struct usbnet *usbdev)
  	return 0;
  }
  
@@ -437,7 +437,7 @@
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wext_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2391,6 +2392,7 @@ static const struct net_device_ops rndis_wext_netdev_ops = {
+@@ -2352,6 +2353,7 @@ static const struct net_device_ops rndis_wext_netdev_ops = {
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wext_set_multicast_list,
  };
@@ -445,7 +445,7 @@
  
  
  static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
-@@ -2435,7 +2437,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
+@@ -2396,7 +2398,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wext.
  	 */
@@ -459,17 +459,17 @@
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/include/net/cfg80211.h
 +++ b/include/net/cfg80211.h
-@@ -9,6 +9,7 @@
- #include <linux/wireless.h>
+@@ -23,6 +23,7 @@
+ /* remove once we remove the wext stuff */
  #include <net/iw_handler.h>
- #include <net/genetlink.h>
+ #include <linux/wireless.h>
 +#include <net/compat.h>
- /* remove once we remove the wext stuff */
+ 
  
  /*
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -671,6 +671,7 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
+@@ -669,6 +669,7 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
  	WARN_ON(flushed);
  }
  
@@ -477,7 +477,7 @@
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -690,11 +691,22 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
+@@ -688,11 +689,22 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -500,7 +500,7 @@
  	dev->wireless_handlers = &ieee80211_iw_handler_def;
  	dev->destructor = free_netdev;
  }
-@@ -710,7 +722,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
+@@ -708,7 +720,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -512,7 +512,7 @@
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -733,7 +749,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
+@@ -731,7 +747,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -524,7 +524,7 @@
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -840,6 +860,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
+@@ -838,6 +858,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
  	if (ret)
  		goto fail;
  
@@ -535,9 +535,9 @@
  	if (ieee80211_vif_is_mesh(&sdata->vif) &&
  	    params && params->mesh_id_len)
  		ieee80211_sdata_set_mesh_id(sdata,
---- a/net/mac80211/main.c	2009-04-16 10:01:30.000000000 -0700
-+++ b/net/mac80211/main.c	2009-04-16 10:01:37.000000000 -0700
-@@ -482,6 +482,7 @@
+--- a/net/mac80211/main.c
++++ b/net/mac80211/main.c
+@@ -483,6 +483,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
  		return;
  	}
  
@@ -545,7 +545,7 @@
  	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
  		/* Software retry the packet once */
  		skb->requeue = 1;
-@@ -489,6 +490,7 @@
+@@ -490,6 +491,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
  		dev_queue_xmit(skb);
  		return;
  	}
@@ -553,7 +553,7 @@
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -821,6 +823,7 @@
+@@ -820,6 +822,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -561,7 +561,7 @@
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -828,12 +831,22 @@
+@@ -827,12 +830,22 @@ static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
@@ -664,8 +664,8 @@
  obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
  obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
  
--cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
-+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o compat.o
+-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o
++cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o compat.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  
  ccflags-y += -D__CHECK_ENDIAN__
diff --git a/config.mk b/config.mk
index 08719f9..a3296d3 100644
--- a/config.mk
+++ b/config.mk
@@ -74,6 +74,10 @@ endif # kernel Makefile check
 
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
+
+CONFIG_MAC80211_DEFAULT_PS=y
+CONFIG_MAC80211_DEFAULT_PS_VALUE=1
+
 # CONFIG_MAC80211_DEBUGFS=y
 # CONFIG_MAC80211_DEBUG_MENU=y
 # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
@@ -85,7 +89,6 @@ CONFIG_MAC80211=m
 # CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
 # CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
 # CONFIG_MAC80211_DEBUG_COUNTERS=y
-# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG=y
 
 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=minstrel
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 2f4d31b..ad64b23 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -28,7 +28,7 @@ INCLUDE_LINUX_MMC="sdio_ids.h"
 
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h iw_handler.h"
-INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h wireless.h lib80211.h"
+INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h lib80211.h regulatory.h"
 
 NET_DIRS="wireless mac80211"
 # User exported this variable
-- 
1.6.2.1

