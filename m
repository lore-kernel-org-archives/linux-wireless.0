Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f187.google.com ([209.85.216.187]:53348 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZFHGIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 02:08:34 -0400
Received: by mail-px0-f187.google.com with SMTP id 17so213970pxi.33
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 23:08:36 -0700 (PDT)
Message-ID: <4A2CA986.3070500@gmail.com>
Date: Mon, 08 Jun 2009 16:02:46 +1000
From: Julian Calaby <julian.calaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] compat-wireless: update for 2009-06-08
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update to match wireless-testing v2.6.30-rc8-25759-g00f7164

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 compat/compat.diff |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index d89ea98..846e8f5 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -181,6 +181,12 @@
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
+@@ -60,5 +34,3 @@
+ obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
+ 
+ obj-$(CONFIG_WL12XX)	+= wl12xx/
+-
+-obj-$(CONFIG_IWM)	+= iwmc3200wifi/
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
@@ -405,7 +411,7 @@
  
 --- a/drivers/net/wireless/mac80211_hwsim.c	2009-05-18 14:35:29.000000000 -0700
 +++ b/drivers/net/wireless/mac80211_hwsim.c	2009-05-18 14:35:29.000000000 -0700
-@@ -744,16 +744,22 @@
+@@ -733,16 +733,22 @@
  	.name = "mac80211_hwsim"
  };
  
@@ -430,30 +436,30 @@
  	dev->tx_queue_len = 0;
 --- a/drivers/net/wireless/rndis_wlan.c	2009-04-28 15:35:05.000000000 -0700
 +++ b/drivers/net/wireless/rndis_wlan.c	2009-04-28 15:35:06.000000000 -0700
-@@ -2342,6 +2342,7 @@
+@@ -2362,6 +2362,7 @@
  	return 0;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  /* same as rndis_netdev_ops but with local multicast handler */
- static const struct net_device_ops rndis_wext_netdev_ops = {
+ static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2352,6 +2353,7 @@
+@@ -2372,6 +2373,7 @@
  	.ndo_validate_addr	= eth_validate_addr,
- 	.ndo_set_multicast_list	= rndis_wext_set_multicast_list,
+ 	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
  };
 +#endif
  
  
- static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
-@@ -2402,7 +2404,11 @@
+ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
+@@ -2422,7 +2424,11 @@
  	 * rndis_host wants to avoid all OID as much as possible
- 	 * so do promisc/multicast handling in rndis_wext.
+ 	 * so do promisc/multicast handling in rndis_wlan.
  	 */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	usbdev->net->netdev_ops = &rndis_wext_netdev_ops;
+ 	usbdev->net->netdev_ops = &rndis_wlan_netdev_ops;
 +#else
-+	usbdev->net->set_multicast_list = rndis_wext_set_multicast_list;
++	usbdev->net->set_multicast_list = rndis_wlan_set_multicast_list;
 +#endif
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
@@ -675,7 +681,7 @@
  	return sent;
 --- a/net/mac80211/wme.c
 +++ b/net/mac80211/wme.c
-@@ -125,6 +125,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
+@@ -97,6 +97,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
  	if (unlikely(queue >= local->hw.queues))
  		queue = local->hw.queues - 1;
  
@@ -683,7 +689,7 @@
  	/*
  	 * Now we know the 1d priority, fill in the QoS header if
  	 * there is one (and we haven't done this before).
-@@ -140,6 +141,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
+@@ -112,6 +113,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
  		*p++ = ack_policy | tid;
  		*p = 0;
  	}
@@ -693,7 +699,7 @@
  }
 --- a/net/wireless/Makefile
 +++ b/net/wireless/Makefile
-@@ -1,12 +1,11 @@
+@@ -1,11 +1,10 @@
 -obj-$(CONFIG_WIRELESS_EXT) += wext.o
  obj-$(CONFIG_CFG80211) += cfg80211.o
  obj-$(CONFIG_LIB80211) += lib80211.o
@@ -706,11 +712,9 @@
  cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  
- ccflags-y += -D__CHECK_ENDIAN__
---- a/net/wireless/core.h
 --- a/net/wireless/core.h	2009-05-18 14:36:20.000000000 -0700
 +++ b/net/wireless/core.h	2009-05-18 14:36:20.000000000 -0700
-@@ -97,7 +97,11 @@
+@@ -104,7 +104,11 @@
  	struct rb_node rbn;
  	unsigned long ts;
  	struct kref ref;
@@ -724,7 +728,7 @@
  	struct cfg80211_bss pub;
 --- a/net/wireless/scan.c	2009-04-28 15:34:48.000000000 -0700
 +++ b/net/wireless/scan.c	2009-04-28 15:35:06.000000000 -0700
-@@ -58,10 +58,12 @@
+@@ -59,10 +59,12 @@
  	bss = container_of(ref, struct cfg80211_internal_bss, ref);
  	if (bss->pub.free_priv)
  		bss->pub.free_priv(&bss->pub);
@@ -737,7 +741,7 @@
  	kfree(bss);
  }
  
-@@ -364,13 +366,26 @@
+@@ -365,13 +367,26 @@
  
  	found = rb_find_bss(dev, res);
  
@@ -764,7 +768,7 @@
  
  		/* overwrite IEs */
  		if (overwrite) {
-@@ -398,6 +413,7 @@
+@@ -399,6 +414,7 @@
  			}
  		}
  
