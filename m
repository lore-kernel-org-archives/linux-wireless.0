Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55630 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0LIAPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 19:15:37 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Thu,  9 Dec 2010 01:15:27 +0100
Message-Id: <1291853727-7919-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uninit is already set in netdev_attach_ops so it is not needed an extra time.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch           |   23 ++++++-----------------
 patches/99-change-makefiles.patch |    5 +++--
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index c1833e3..fd0139e 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -23,7 +23,7 @@ without creating a headache on maintenance of the pathes.
  	if (unlikely(retval < 0)) {
 --- a/drivers/net/usb/usbnet.c
 +++ b/drivers/net/usb/usbnet.c
-@@ -1343,7 +1343,7 @@ usbnet_probe (struct usb_interface *udev
+@@ -1360,7 +1360,7 @@ usbnet_probe (struct usb_interface *udev
  		net->features |= NETIF_F_HIGHDMA;
  #endif
  
@@ -45,7 +45,7 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -711,7 +711,12 @@ static const struct net_device_ops ieee8
+@@ -689,7 +689,12 @@ static const struct net_device_ops ieee8
  static void ieee80211_if_setup(struct net_device *dev)
  {
  	ether_setup(dev);
@@ -59,7 +59,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -858,7 +863,7 @@ static void ieee80211_setup_sdata(struct
+@@ -836,7 +841,7 @@ static void ieee80211_setup_sdata(struct
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
  	sdata->vif.p2p = false;
@@ -68,7 +68,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
-@@ -897,7 +902,7 @@ static void ieee80211_setup_sdata(struct
+@@ -875,7 +880,7 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -77,7 +77,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -1148,6 +1153,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1126,6 +1131,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -86,7 +86,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -1156,6 +1163,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1134,6 +1141,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -94,17 +94,6 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -1204,6 +1212,10 @@ int ieee80211_if_add(struct ieee80211_lo
- 	if (ret)
- 		goto fail;
- 
-+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28))
-+	ndev->uninit = ieee80211_teardown_sdata;
-+#endif
-+
- 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
- 	    params && params->mesh_id_len)
- 		ieee80211_sdata_set_mesh_id(sdata,
 --- a/drivers/net/b44.c
 +++ b/drivers/net/b44.c
 @@ -2163,7 +2163,7 @@ static int __devinit b44_init_one(struct
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index c75f4f2..5114869 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,28 +2,7 @@
+@@ -2,29 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -41,6 +41,7 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
 -obj-$(CONFIG_USB_SIERRA_NET)	+= sierra_net.o
 -obj-$(CONFIG_USB_NET_CX82310_ETH)	+= cx82310_eth.o
+-obj-$(CONFIG_USB_NET_CDC_NCM)	+= cdc_ncm.o
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
@@ -88,5 +89,5 @@ only the wireless stuff.
 -obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 -
  cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
- cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o
+ cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o
  cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
-- 
1.7.1

