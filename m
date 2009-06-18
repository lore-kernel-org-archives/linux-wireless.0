Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51478 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZFRTin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 15:38:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Update compat.diff
Date: Thu, 18 Jun 2009 21:38:35 +0200
Message-Id: <1245353915-30400-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1245353915-30400-1-git-send-email-hauke@hauke-m.de>
References: <1245353915-30400-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__dev_addr_sync and __dev_addr_unsync are not exported in older kernels.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.c    |  112 +++++++++++++++++++++++++++++++
 compat/compat.diff |  188 +++++++++++++++++++++++++---------------------------
 config.mk          |    3 +-
 3 files changed, 204 insertions(+), 99 deletions(-)

diff --git a/compat/compat.c b/compat/compat.c
index 585c070..5c4ccdc 100644
--- a/compat/compat.c
+++ b/compat/compat.c
@@ -37,3 +37,115 @@ EXPORT_SYMBOL_GPL(pci_ioremap_bar);
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
+
+#include <linux/netdevice.h>
+
+int __dev_addr_add(struct dev_addr_list **list, int *count,
+		   void *addr, int alen, int glbl)
+{
+	struct dev_addr_list *da;
+
+	for (da = *list; da != NULL; da = da->next) {
+		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
+		    da->da_addrlen == alen) {
+			if (glbl) {
+				int old_glbl = da->da_gusers;
+				da->da_gusers = 1;
+				if (old_glbl)
+					return 0;
+			}
+			da->da_users++;
+			return 0;
+		}
+	}
+
+	da = kzalloc(sizeof(*da), GFP_ATOMIC);
+	if (da == NULL)
+		return -ENOMEM;
+	memcpy(da->da_addr, addr, alen);
+	da->da_addrlen = alen;
+	da->da_users = 1;
+	da->da_gusers = glbl ? 1 : 0;
+	da->next = *list;
+	*list = da;
+	(*count)++;
+	return 0;
+}
+
+int __dev_addr_delete(struct dev_addr_list **list, int *count,
+		      void *addr, int alen, int glbl)
+{
+	struct dev_addr_list *da;
+
+	for (; (da = *list) != NULL; list = &da->next) {
+		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
+		    alen == da->da_addrlen) {
+			if (glbl) {
+				int old_glbl = da->da_gusers;
+				da->da_gusers = 0;
+				if (old_glbl == 0)
+					break;
+			}
+			if (--da->da_users)
+				return 0;
+
+			*list = da->next;
+			kfree(da);
+			(*count)--;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+int __dev_addr_sync(struct dev_addr_list **to, int *to_count,
+		    struct dev_addr_list **from, int *from_count)
+{
+	struct dev_addr_list *da, *next;
+	int err = 0;
+
+	da = *from;
+	while (da != NULL) {
+		next = da->next;
+		if (!da->da_synced) {
+			err = __dev_addr_add(to, to_count,
+					     da->da_addr, da->da_addrlen, 0);
+			if (err < 0)
+				break;
+			da->da_synced = 1;
+			da->da_users++;
+		} else if (da->da_users == 1) {
+			__dev_addr_delete(to, to_count,
+					  da->da_addr, da->da_addrlen, 0);
+			__dev_addr_delete(from, from_count,
+					  da->da_addr, da->da_addrlen, 0);
+		}
+		da = next;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(__dev_addr_sync);
+
+void __dev_addr_unsync(struct dev_addr_list **to, int *to_count,
+		       struct dev_addr_list **from, int *from_count)
+{
+	struct dev_addr_list *da, *next;
+
+	da = *from;
+	while (da != NULL) {
+		next = da->next;
+		if (da->da_synced) {
+			__dev_addr_delete(to, to_count,
+					  da->da_addr, da->da_addrlen, 0);
+			da->da_synced = 0;
+			__dev_addr_delete(from, from_count,
+					  da->da_addr, da->da_addrlen, 0);
+		}
+		da = next;
+	}
+}
+EXPORT_SYMBOL_GPL(__dev_addr_unsync);
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
+
diff --git a/compat/compat.diff b/compat/compat.diff
index fe99dec..cff2479 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -107,7 +107,7 @@
  	if (unlikely(retval < 0)) {
 --- a/drivers/net/usb/usbnet.c
 +++ b/drivers/net/usb/usbnet.c
-@@ -1106,6 +1106,7 @@ void usbnet_disconnect (struct usb_interface *intf)
+@@ -1120,6 +1120,7 @@ void usbnet_disconnect (struct usb_interface *intf)
  }
  EXPORT_SYMBOL_GPL(usbnet_disconnect);
  
@@ -115,7 +115,7 @@
  static const struct net_device_ops usbnet_netdev_ops = {
  	.ndo_open		= usbnet_open,
  	.ndo_stop		= usbnet_stop,
-@@ -1115,6 +1116,7 @@ static const struct net_device_ops usbnet_netdev_ops = {
+@@ -1129,6 +1130,7 @@ static const struct net_device_ops usbnet_netdev_ops = {
  	.ndo_set_mac_address 	= eth_mac_addr,
  	.ndo_validate_addr	= eth_validate_addr,
  };
@@ -123,7 +123,7 @@
  
  /*-------------------------------------------------------------------------*/
  
-@@ -1184,8 +1186,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
+@@ -1198,8 +1200,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
  		net->features |= NETIF_F_HIGHDMA;
  #endif
  
@@ -440,9 +440,9 @@
  	rtap_dev->ml_priv = priv;
  	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
  
---- a/drivers/net/wireless/mac80211_hwsim.c	2009-05-18 14:35:29.000000000 -0700
-+++ b/drivers/net/wireless/mac80211_hwsim.c	2009-05-18 14:35:29.000000000 -0700
-@@ -733,16 +733,22 @@
+--- a/drivers/net/wireless/mac80211_hwsim.c
++++ b/drivers/net/wireless/mac80211_hwsim.c
+@@ -734,16 +734,22 @@ static struct device_driver mac80211_hwsim_driver = {
  	.name = "mac80211_hwsim"
  };
  
@@ -465,9 +465,9 @@
  	dev->destructor = free_netdev;
  	ether_setup(dev);
  	dev->tx_queue_len = 0;
---- a/drivers/net/wireless/rndis_wlan.c	2009-04-28 15:35:05.000000000 -0700
-+++ b/drivers/net/wireless/rndis_wlan.c	2009-04-28 15:35:06.000000000 -0700
-@@ -2362,6 +2362,7 @@
+--- a/drivers/net/wireless/rndis_wlan.c
++++ b/drivers/net/wireless/rndis_wlan.c
+@@ -2335,6 +2335,7 @@ static int bcm4320b_early_init(struct usbnet *usbdev)
  	return 0;
  }
  
@@ -475,7 +475,7 @@
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2372,6 +2373,7 @@
+@@ -2345,6 +2346,7 @@ static const struct net_device_ops rndis_wlan_netdev_ops = {
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
  };
@@ -483,7 +483,7 @@
  
  
  static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
-@@ -2422,7 +2424,11 @@
+@@ -2395,7 +2397,11 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wlan.
  	 */
@@ -495,8 +495,8 @@
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
---- a/drivers/net/wireless/wl12xx/main.c
-+++ b/drivers/net/wireless/wl12xx/main.c
+--- a/drivers/net/wireless/wl12xx/wl1251_main.c
++++ b/drivers/net/wireless/wl12xx/wl1251_main.c
 @@ -26,6 +26,9 @@
  #include <linux/firmware.h>
  #include <linux/delay.h>
@@ -507,8 +507,8 @@
  #include <linux/spi/spi.h>
  #include <linux/crc32.h>
  #include <linux/etherdevice.h>
---- a/drivers/net/wireless/wl12xx/spi.c
-+++ b/drivers/net/wireless/wl12xx/spi.c
+--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
++++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
 @@ -23,6 +23,9 @@
  
  #include <linux/module.h>
@@ -518,7 +518,7 @@
 +#endif
  #include <linux/spi/spi.h>
  
- #include "wl12xx.h"
+ #include "wl1251.h"
 --- a/include/linux/rfkill_backport.h
 +++ b/include/linux/rfkill_backport.h
 @@ -134,7 +134,7 @@ struct rfkill_ops {
@@ -539,7 +539,7 @@
  					  struct device *parent,
  					  const enum rfkill_type type,
  					  const struct rfkill_ops *ops,
-@@ -166,7 +166,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
+@@ -167,7 +167,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
   * If the hardware blocked state is not set before registration,
   * it is assumed to be unblocked.
   */
@@ -548,7 +548,7 @@
  
  /**
   * rfkill_pause_polling(struct rfkill *rfkill)
-@@ -175,7 +175,7 @@ int __must_check rfkill_register(struct rfkill *rfkill);
+@@ -176,7 +176,7 @@ int __must_check rfkill_register(struct rfkill *rfkill);
   * NOTE: not necessary for suspend/resume -- in that case the
   * core stops polling anyway
   */
@@ -557,7 +557,7 @@
  
  /**
   * rfkill_resume_polling(struct rfkill *rfkill)
-@@ -184,7 +184,7 @@ void rfkill_pause_polling(struct rfkill *rfkill);
+@@ -185,7 +185,7 @@ void rfkill_pause_polling(struct rfkill *rfkill);
   * NOTE: not necessary for suspend/resume -- in that case the
   * core stops polling anyway
   */
@@ -566,7 +566,7 @@
  
  
  /**
-@@ -195,7 +195,7 @@ void rfkill_resume_polling(struct rfkill *rfkill);
+@@ -196,7 +196,7 @@ void rfkill_resume_polling(struct rfkill *rfkill);
   * teardown to destroy rfkill structure. Until it returns, the driver
   * needs to be able to service method calls.
   */
@@ -575,7 +575,7 @@
  
  /**
   * rfkill_destroy - free rfkill structure
-@@ -203,7 +203,7 @@ void rfkill_unregister(struct rfkill *rfkill);
+@@ -204,7 +204,7 @@ void rfkill_unregister(struct rfkill *rfkill);
   *
   * Destroys the rfkill structure.
   */
@@ -584,7 +584,7 @@
  
  /**
   * rfkill_set_hw_state - Set the internal rfkill hardware block state
-@@ -224,7 +224,7 @@ void rfkill_destroy(struct rfkill *rfkill);
+@@ -225,7 +225,7 @@ void rfkill_destroy(struct rfkill *rfkill);
   * should be blocked) so that drivers need not keep track of the soft
   * block state -- which they might not be able to.
   */
@@ -593,7 +593,7 @@
  
  /**
   * rfkill_set_sw_state - Set the internal rfkill software block state
-@@ -244,7 +244,7 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+@@ -247,7 +247,7 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
   * The function returns the combined block state (true if transmitter
   * should be blocked).
   */
@@ -601,8 +601,17 @@
 +bool backport_rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
  
  /**
+  * rfkill_init_sw_state - Initialize persistent software block state
+@@ -263,7 +263,7 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
+  * can be read by userspace.  Persistent devices are expected to preserve
+  * preserve their own state when suspended.
+  */
+-void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
++void backport_rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
+ 
+ /**
   * rfkill_set_states - Set the internal rfkill block states
-@@ -255,17 +255,17 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
+@@ -274,17 +274,17 @@ void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
   * This function can be called in any context, even from within rfkill
   * callbacks.
   */
@@ -624,7 +633,7 @@
  	     struct device *parent,
  	     const enum rfkill_type type,
  	     const struct rfkill_ops *ops,
-@@ -274,57 +274,57 @@ rfkill_alloc(const char *name,
+@@ -293,18 +293,18 @@ rfkill_alloc(const char *name,
  	return ERR_PTR(-ENODEV);
  }
  
@@ -646,8 +655,7 @@
  {
  }
  
--static inline void rfkill_unregister(struct rfkill *rfkill)
-+static inline void backport_rfkill_unregister(struct rfkill *rfkill)
+@@ -312,42 +312,42 @@ static inline void rfkill_unregister(struct rfkill *rfkill)
  {
  }
  
@@ -668,6 +676,11 @@
  	return blocked;
  }
  
+-static inline void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
++static inline void backport_rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
+ {
+ }
+ 
 -static inline void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 +static inline void backport_rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
  {
@@ -694,7 +707,7 @@
  
  /**
   * rfkill_set_led_trigger_name -- set the LED trigger name
-@@ -335,15 +335,15 @@ const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
+@@ -358,15 +358,15 @@ const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
   * trigger that rfkill creates. It is optional, but if called
   * must be called before rfkill_register() to be effective.
   */
@@ -723,9 +736,9 @@
  
  
  /*
---- a/net/mac80211/iface.c	2009-04-28 15:34:50.000000000 -0700
-+++ b/net/mac80211/iface.c	2009-04-28 15:35:06.000000000 -0700
-@@ -671,6 +671,7 @@
+--- a/net/mac80211/iface.c
++++ b/net/mac80211/iface.c
+@@ -670,6 +670,7 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
  	WARN_ON(flushed);
  }
  
@@ -733,7 +746,7 @@
  static const struct net_device_ops ieee80211_dataif_ops = {
  	.ndo_open		= ieee80211_open,
  	.ndo_stop		= ieee80211_stop,
-@@ -690,11 +691,22 @@
+@@ -689,11 +690,22 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
  	.ndo_change_mtu 	= ieee80211_change_mtu,
  	.ndo_set_mac_address 	= eth_mac_addr,
  };
@@ -756,7 +769,7 @@
  	dev->wireless_handlers = &ieee80211_iw_handler_def;
  	dev->destructor = free_netdev;
  }
-@@ -710,7 +722,11 @@
+@@ -709,7 +721,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
@@ -768,7 +781,7 @@
  	sdata->wdev.iftype = type;
  
  	/* only monitor differs */
-@@ -733,7 +749,11 @@
+@@ -732,7 +748,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -780,7 +793,7 @@
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -840,6 +860,10 @@
+@@ -839,6 +859,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
  	if (ret)
  		goto fail;
  
@@ -803,39 +816,6 @@
  
  /**
   * DOC: Key handling basics
---- a/net/mac80211/main.c
-+++ b/net/mac80211/main.c
-@@ -759,6 +759,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
- }
- EXPORT_SYMBOL(ieee80211_alloc_hw);
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- static const struct net_device_ops ieee80211_master_ops = {
- 	.ndo_start_xmit = ieee80211_master_start_xmit,
- 	.ndo_open = ieee80211_master_open,
-@@ -766,12 +767,22 @@ static const struct net_device_ops ieee80211_master_ops = {
- 	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
- 	.ndo_select_queue = ieee80211_select_queue,
- };
-+#endif
- 
- static void ieee80211_master_setup(struct net_device *mdev)
- {
- 	mdev->type = ARPHRD_IEEE80211;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	mdev->netdev_ops = &ieee80211_master_ops;
- 	mdev->header_ops = &ieee80211_header_ops;
-+#else
-+	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-+	mdev->open = ieee80211_master_open;
-+	mdev->stop = ieee80211_master_stop;
-+	mdev->header_ops = &ieee80211_header_ops;
-+	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
-+	mdev->select_queue = ieee80211_select_queue;
-+#endif
- 	mdev->tx_queue_len = 1000;
- 	mdev->addr_len = ETH_ALEN;
- }
 --- a/net/mac80211/rate.c
 +++ b/net/mac80211/rate.c
 @@ -22,7 +22,7 @@ struct rate_control_alg {
@@ -881,7 +861,7 @@
  #include <linux/spinlock.h>
  #include <linux/miscdevice.h>
  #include <linux/wait.h>
-@@ -62,7 +62,7 @@ struct rfkill {
+@@ -61,7 +61,7 @@ struct rfkill {
  	const struct rfkill_ops	*ops;
  	void			*data;
  
@@ -890,7 +870,7 @@
  	struct led_trigger	led_trigger;
  	const char		*ledtrigname;
  #endif
-@@ -123,7 +123,7 @@ static struct {
+@@ -122,7 +122,7 @@ static struct {
  static bool rfkill_epo_lock_active;
  
  
@@ -899,7 +879,7 @@
  static void rfkill_led_trigger_event(struct rfkill *rfkill)
  {
  	struct led_trigger *trigger;
-@@ -148,19 +148,19 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
+@@ -147,19 +147,19 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
  	rfkill_led_trigger_event(rfkill);
  }
  
@@ -923,7 +903,7 @@
  
  static int rfkill_led_trigger_register(struct rfkill *rfkill)
  {
-@@ -187,7 +187,7 @@ static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
+@@ -186,7 +186,7 @@ static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
  static inline void rfkill_led_trigger_unregister(struct rfkill *rfkill)
  {
  }
@@ -932,7 +912,7 @@
  
  static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
  			      enum rfkill_operation op)
-@@ -317,7 +317,7 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
+@@ -316,7 +316,7 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
  	rfkill_event(rfkill);
  }
  
@@ -941,7 +921,7 @@
  static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
  
  /**
-@@ -464,7 +464,7 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
+@@ -463,7 +463,7 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
  #endif
  
  
@@ -950,7 +930,7 @@
  {
  	bool ret, change;
  
-@@ -478,7 +478,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+@@ -477,7 +477,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
  
  	return ret;
  }
@@ -959,7 +939,7 @@
  
  static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
  {
-@@ -494,7 +494,7 @@ static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+@@ -493,7 +493,7 @@ static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
  		rfkill->state &= ~bit;
  }
  
@@ -968,19 +948,31 @@
  {
  	unsigned long flags;
  	bool prev, hwblock;
-@@ -519,9 +519,9 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+@@ -517,9 +517,9 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
  
  	return blocked;
  }
 -EXPORT_SYMBOL(rfkill_set_sw_state);
 +EXPORT_SYMBOL(backport_rfkill_set_sw_state);
  
+-void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
++void backport_rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
+ {
+ 	unsigned long flags;
+ 
+@@ -531,9 +531,9 @@ void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
+ 	rfkill->persistent = true;
+ 	spin_unlock_irqrestore(&rfkill->lock, flags);
+ }
+-EXPORT_SYMBOL(rfkill_init_sw_state);
++EXPORT_SYMBOL(backport_rfkill_init_sw_state);
+ 
 -void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 +void backport_rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
  {
  	unsigned long flags;
  	bool swprev, hwprev;
-@@ -549,7 +549,7 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
+@@ -561,7 +561,7 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
  		rfkill_led_trigger_event(rfkill);
  	}
  }
@@ -989,7 +981,7 @@
  
  static ssize_t rfkill_name_show(struct device *dev,
  				struct device_attribute *attr,
-@@ -690,7 +690,7 @@ static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
+@@ -712,7 +712,7 @@ static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
  	return error;
  }
  
@@ -998,7 +990,7 @@
  {
  	BUG_ON(!rfkill);
  
-@@ -699,9 +699,9 @@ void rfkill_pause_polling(struct rfkill *rfkill)
+@@ -721,9 +721,9 @@ void rfkill_pause_polling(struct rfkill *rfkill)
  
  	cancel_delayed_work_sync(&rfkill->poll_work);
  }
@@ -1010,7 +1002,7 @@
  {
  	BUG_ON(!rfkill);
  
-@@ -710,13 +710,13 @@ void rfkill_resume_polling(struct rfkill *rfkill)
+@@ -732,13 +732,13 @@ void rfkill_resume_polling(struct rfkill *rfkill)
  
  	schedule_work(&rfkill->poll_work.work);
  }
@@ -1024,11 +1016,11 @@
 -	rfkill_pause_polling(rfkill);
 +	backport_rfkill_pause_polling(rfkill);
  
- 	rfkill->suspended = true;
- 
-@@ -733,13 +733,13 @@ static int rfkill_resume(struct device *dev)
- 
- 	rfkill->suspended = false;
+ 	return 0;
+ }
+@@ -753,13 +753,13 @@ static int rfkill_resume(struct device *dev)
+ 		rfkill_set_block(rfkill, cur);
+ 	}
  
 -	rfkill_resume_polling(rfkill);
 +	backport_rfkill_resume_polling(rfkill);
@@ -1042,7 +1034,7 @@
  	.dev_release	= rfkill_release,
  	.dev_attrs	= rfkill_dev_attrs,
  	.dev_uevent	= rfkill_dev_uevent,
-@@ -747,7 +747,7 @@ static struct class rfkill_class = {
+@@ -767,7 +767,7 @@ static struct class rfkill_class = {
  	.resume		= rfkill_resume,
  };
  
@@ -1051,7 +1043,7 @@
  {
  	unsigned long flags;
  	u32 state;
-@@ -758,10 +758,10 @@ bool rfkill_blocked(struct rfkill *rfkill)
+@@ -778,10 +778,10 @@ bool rfkill_blocked(struct rfkill *rfkill)
  
  	return !!(state & RFKILL_BLOCK_ANY);
  }
@@ -1064,7 +1056,7 @@
  					  struct device *parent,
  					  const enum rfkill_type type,
  					  const struct rfkill_ops *ops,
-@@ -800,7 +800,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
+@@ -820,7 +820,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
  
  	return rfkill;
  }
@@ -1073,7 +1065,7 @@
  
  static void rfkill_poll(struct work_struct *work)
  {
-@@ -843,7 +843,7 @@ static void rfkill_sync_work(struct work_struct *work)
+@@ -863,7 +863,7 @@ static void rfkill_sync_work(struct work_struct *work)
  	mutex_unlock(&rfkill_global_mutex);
  }
  
@@ -1082,7 +1074,7 @@
  {
  	static unsigned long rfkill_no;
  	struct device *dev = &rfkill->dev;
-@@ -885,7 +885,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
+@@ -905,7 +905,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
  	if (!rfkill->persistent || rfkill_epo_lock_active) {
  		schedule_work(&rfkill->sync_work);
  	} else {
@@ -1091,7 +1083,7 @@
  		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
  
  		if (!atomic_read(&rfkill_input_disabled))
-@@ -906,9 +906,9 @@ int __must_check rfkill_register(struct rfkill *rfkill)
+@@ -926,9 +926,9 @@ int __must_check rfkill_register(struct rfkill *rfkill)
  	mutex_unlock(&rfkill_global_mutex);
  	return error;
  }
@@ -1103,7 +1095,7 @@
  {
  	BUG_ON(!rfkill);
  
-@@ -929,14 +929,14 @@ void rfkill_unregister(struct rfkill *rfkill)
+@@ -949,14 +949,14 @@ void rfkill_unregister(struct rfkill *rfkill)
  
  	rfkill_led_trigger_unregister(rfkill);
  }
@@ -1121,7 +1113,7 @@
  
  static int rfkill_fop_open(struct inode *inode, struct file *file)
  {
-@@ -1107,7 +1107,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
+@@ -1127,7 +1127,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
  	list_for_each_entry_safe(ev, tmp, &data->events, list)
  		kfree(ev);
  
@@ -1130,7 +1122,7 @@
  	if (data->input_handler)
  		if (atomic_dec_return(&rfkill_input_disabled) == 0)
  			printk(KERN_DEBUG "rfkill: input handler enabled\n");
-@@ -1118,7 +1118,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
+@@ -1138,7 +1138,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
  	return 0;
  }
  
@@ -1139,7 +1131,7 @@
  static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
  			     unsigned long arg)
  {
-@@ -1150,14 +1150,14 @@ static const struct file_operations rfkill_fops = {
+@@ -1170,14 +1170,14 @@ static const struct file_operations rfkill_fops = {
  	.write		= rfkill_fop_write,
  	.poll		= rfkill_fop_poll,
  	.release	= rfkill_fop_release,
@@ -1156,7 +1148,7 @@
  	.fops	= &rfkill_fops,
  	.minor	= MISC_DYNAMIC_MINOR,
  };
-@@ -1180,7 +1180,7 @@ static int __init rfkill_init(void)
+@@ -1200,7 +1200,7 @@ static int __init rfkill_init(void)
  		goto out;
  	}
  
@@ -1165,7 +1157,7 @@
  	error = rfkill_handler_init();
  	if (error) {
  		misc_deregister(&rfkill_miscdev);
-@@ -1196,7 +1196,7 @@ subsys_initcall(rfkill_init);
+@@ -1216,7 +1216,7 @@ subsys_initcall(rfkill_init);
  
  static void __exit rfkill_exit(void)
  {
diff --git a/config.mk b/config.mk
index 55d5627..809e275 100644
--- a/config.mk
+++ b/config.mk
@@ -295,7 +295,7 @@ endif # end of USB driver list
 
 ifneq ($(CONFIG_SPI_MASTER),)
 
-CONFIG_WL12XX=m
+CONFIG_WL1251=m
 CONFIG_P54_SPI=m
 CONFIG_LIBERTAS_SPI=m
 NEED_LIBERTAS=y
@@ -340,6 +340,7 @@ CONFIG_P54_LEDS=y
 # Atheros
 CONFIG_ATH_COMMON=m
 
+CONFIG_WL12XX=y
 
 # Sonics Silicon Backplane
 CONFIG_SSB_POSSIBLE=y
-- 
1.6.2.1

