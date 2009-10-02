Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47629 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZJBVNj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 17:13:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] Make it compile with wireless-testing master-2009-09-30
Date: Fri,  2 Oct 2009 23:13:33 +0200
Message-Id: <1254518013-30223-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DIV_ROUND_CLOSEST is needed by the b44 driver.
Most of the rest is needed because of "wext: refactor"
in wireless-testing.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.h                        |    7 +++
 compat/patches/01-netdev.patch                |   64 ++++++++++++------------
 compat/patches/03-rfkill.patch                |    2 +-
 compat/patches/08-rename-iwl4965-config.patch |    2 +-
 compat/patches/09-threaded-irq.patch          |    2 +-
 compat/patches/98-add-compat-wireless.patch   |    4 +-
 compat/patches/99-change-makefiles.patch      |   17 +++++--
 config.mk                                     |    8 +++
 8 files changed, 64 insertions(+), 42 deletions(-)

diff --git a/compat/compat-2.6.29.h b/compat/compat-2.6.29.h
index 8ea43cb..fc7d983 100644
--- a/compat/compat-2.6.29.h
+++ b/compat/compat-2.6.29.h
@@ -43,6 +43,13 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
 
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(divisor) __divisor = divisor;		\
+	(((x) + ((__divisor) / 2)) / (__divisor));	\
+}							\
+)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 9260bfb..b2e7136 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -157,7 +157,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -770,6 +790,8 @@
+@@ -774,6 +794,8 @@
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -166,7 +166,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -778,6 +800,7 @@
+@@ -782,6 +804,7 @@
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -174,7 +174,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -810,6 +833,10 @@
+@@ -815,6 +838,10 @@
  	if (ret)
  		goto fail;
  
@@ -230,31 +230,17 @@ without creating a headache on maintenance of the pathes.
  	dev->irq = sdev->irq;
  	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
  
---- a/net/wireless/wext.c	2009-08-04 10:50:33.634995059 -0700
-+++ b/net/wireless/wext.c	2009-08-04 10:50:34.175014901 -0700
-@@ -1118,8 +1118,13 @@
- 			return private(dev, iwr, cmd, info, handler);
- 	}
- 	/* Old driver API : call driver ioctl handler */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	if (dev->netdev_ops->ndo_do_ioctl)
- 		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
-+#else
-+	if (dev->do_ioctl)
-+		return dev->do_ioctl(dev, ifr, cmd);
-+#endif
- 	return -EOPNOTSUPP;
- }
+--- a/net/wireless/wext-core.c
++++ b/net/wireless/wext-core.c
+@@ -340,6 +340,7 @@
  
-@@ -1272,6 +1277,7 @@
- }
- #endif
+ /* IW event code */
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
  static int __net_init wext_pernet_init(struct net *net)
  {
  	skb_queue_head_init(&net->wext_nlevents);
-@@ -1314,6 +1320,29 @@
+@@ -382,6 +383,29 @@
  
  static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
  
@@ -284,7 +270,7 @@ without creating a headache on maintenance of the pathes.
  static struct nlmsghdr *rtnetlink_ifinfo_prep(struct net_device *dev,
  					      struct sk_buff *skb)
  {
-@@ -1524,8 +1553,13 @@
+@@ -592,8 +616,13 @@
  
  	skb_shinfo(skb)->frag_list = compskb;
  #endif
@@ -298,6 +284,20 @@ without creating a headache on maintenance of the pathes.
  }
  EXPORT_SYMBOL(wireless_send_event);
  
+@@ -901,8 +930,13 @@
+ 			return private(dev, iwr, cmd, info, handler);
+ 	}
+ 	/* Old driver API : call driver ioctl handler */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	if (dev->netdev_ops->ndo_do_ioctl)
+ 		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
++#else
++	if (dev->do_ioctl)
++		return dev->do_ioctl(dev, ifr, cmd);
++#endif
+ 	return -EOPNOTSUPP;
+ }
+ 
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:00.958117808 -0700
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-09-02 14:12:01.382115761 -0700
 @@ -6008,6 +6008,7 @@
@@ -335,7 +335,7 @@ without creating a headache on maintenance of the pathes.
  	priv->wireless_data.libipw = priv->ieee;
 --- a/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.311291621 -0700
 +++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2009-08-20 13:47:07.783268230 -0700
-@@ -11623,6 +11623,7 @@
+@@ -11624,6 +11624,7 @@
  	return NETDEV_TX_OK;
  }
  
@@ -343,7 +343,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_prom_netdev_ops = {
  	.ndo_open 		= ipw_prom_open,
  	.ndo_stop		= ipw_prom_stop,
-@@ -11631,6 +11632,7 @@
+@@ -11632,6 +11633,7 @@
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -351,7 +351,7 @@ without creating a headache on maintenance of the pathes.
  
  static int ipw_prom_alloc(struct ipw_priv *priv)
  {
-@@ -11651,7 +11653,13 @@
+@@ -11652,7 +11654,13 @@
  	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
  
  	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -365,7 +365,7 @@ without creating a headache on maintenance of the pathes.
  
  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
  	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
-@@ -11679,6 +11687,7 @@
+@@ -11680,6 +11688,7 @@
  
  #endif
  
@@ -373,7 +373,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops ipw_netdev_ops = {
  	.ndo_init		= ipw_net_init,
  	.ndo_open		= ipw_net_open,
-@@ -11689,6 +11698,7 @@
+@@ -11690,6 +11699,7 @@
  	.ndo_change_mtu		= libipw_change_mtu,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -381,7 +381,7 @@ without creating a headache on maintenance of the pathes.
  
  static int __devinit ipw_pci_probe(struct pci_dev *pdev,
  				   const struct pci_device_id *ent)
-@@ -11790,7 +11800,15 @@
+@@ -11791,7 +11801,15 @@
  	priv->ieee->perfect_rssi = -20;
  	priv->ieee->worst_rssi = -85;
  
@@ -464,7 +464,7 @@ without creating a headache on maintenance of the pathes.
  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
  	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
  			sizeof(priv->dev->dev_addr));
-@@ -1665,11 +1686,13 @@
+@@ -1666,11 +1687,13 @@
  	lbs_deb_leave(LBS_DEB_MAIN);
  }
  
@@ -478,7 +478,7 @@ without creating a headache on maintenance of the pathes.
  
  static int lbs_add_rtap(struct lbs_private *priv)
  {
-@@ -1690,7 +1713,13 @@
+@@ -1691,7 +1714,13 @@
  
  	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
  	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -511,7 +511,7 @@ without creating a headache on maintenance of the pathes.
  #define LBS_DEB_LEAVE	0x00000002
 --- a/drivers/net/wireless/mac80211_hwsim.c	2009-08-18 16:18:52.829350750 -0700
 +++ b/drivers/net/wireless/mac80211_hwsim.c	2009-08-18 16:18:52.977352457 -0700
-@@ -812,16 +812,22 @@
+@@ -816,16 +816,22 @@
  	.name = "mac80211_hwsim"
  };
  
diff --git a/compat/patches/03-rfkill.patch b/compat/patches/03-rfkill.patch
index dadcb9a..cfd07ca 100644
--- a/compat/patches/03-rfkill.patch
+++ b/compat/patches/03-rfkill.patch
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c	2009-09-23 10:28:55.875708257 -0700
 +++ b/drivers/net/wireless/ath/ath9k/hw.c	2009-09-23 10:28:56.211707588 -0700
-@@ -3688,7 +3688,7 @@
+@@ -3666,7 +3666,7 @@
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/compat/patches/08-rename-iwl4965-config.patch b/compat/patches/08-rename-iwl4965-config.patch
index c6191f8..75ffbab 100644
--- a/compat/patches/08-rename-iwl4965-config.patch
+++ b/compat/patches/08-rename-iwl4965-config.patch
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-09-02 14:16:08.061113710 -0700
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-09-02 14:16:08.949100601 -0700
-@@ -3008,10 +3008,10 @@
+@@ -3236,10 +3236,10 @@
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static struct pci_device_id iwl_hw_card_ids[] = {
diff --git a/compat/patches/09-threaded-irq.patch b/compat/patches/09-threaded-irq.patch
index 4b9a361..4a23389 100644
--- a/compat/patches/09-threaded-irq.patch
+++ b/compat/patches/09-threaded-irq.patch
@@ -38,7 +38,7 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
  			goto out;
-@@ -4656,6 +4669,10 @@ static int b43_setup_bands(struct b43_wl
+@@ -4658,6 +4671,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
diff --git a/compat/patches/98-add-compat-wireless.patch b/compat/patches/98-add-compat-wireless.patch
index eb83d40..e78c63f 100644
--- a/compat/patches/98-add-compat-wireless.patch
+++ b/compat/patches/98-add-compat-wireless.patch
@@ -20,8 +20,8 @@ added compat.h also for ssb, I forget.
 
 --- a/net/wireless/Makefile	2009-08-07 12:27:50.836497001 -0700
 +++ b/net/wireless/Makefile	2009-08-07 12:27:51.952497240 -0700
-@@ -11,3 +11,16 @@
- cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
+@@ -15,3 +15,16 @@
+ cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
  
  ccflags-y += -D__CHECK_ENDIAN__
 +# Compat-wireless kernel compatibility code
diff --git a/compat/patches/99-change-makefiles.patch b/compat/patches/99-change-makefiles.patch
index b5a0f10..e32f539 100644
--- a/compat/patches/99-change-makefiles.patch
+++ b/compat/patches/99-change-makefiles.patch
@@ -86,8 +86,15 @@ only the wireless stuff.
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
 --- a/net/wireless/Makefile
 +++ b/net/wireless/Makefile
-@@ -1,4 +1,3 @@
--obj-$(CONFIG_WIRELESS_EXT) += wext.o
- obj-$(CONFIG_CFG80211) += cfg80211.o
- obj-$(CONFIG_LIB80211) += lib80211.o
- obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
+@@ -4,11 +4,6 @@
+ obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
+ obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
+ 
+-obj-$(CONFIG_WEXT_CORE) += wext-core.o
+-obj-$(CONFIG_WEXT_PROC) += wext-proc.o
+-obj-$(CONFIG_WEXT_SPY) += wext-spy.o
+-obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
+-
+ cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
+ cfg80211-y += mlme.o ibss.o sme.o chan.o
+ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
diff --git a/config.mk b/config.mk
index b482b68..9985687 100644
--- a/config.mk
+++ b/config.mk
@@ -119,6 +119,14 @@ CONFIG_LIB80211_CRYPT_TKIP=m
 
 CONFIG_WIRELESS_OLD_REGULATORY=n
 
+ifneq ($(CONFIG_WIRELESS_EXT),)
+CONFIG_WEXT_CORE=m
+CONFIG_WEXT_PROC=m
+CONFIG_WEXT_SPY=m
+CONFIG_WEXT_PRIV=m
+CONFIG_CFG80211_WEXT=y
+endif
+
 # mac80211 test driver
 CONFIG_MAC80211_HWSIM=m
 
-- 
1.6.2.1

