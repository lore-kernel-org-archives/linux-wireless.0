Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXGaSeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:23 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
Date: Tue, 31 Jul 2007 20:37:32 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.33060.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ed0b806ae27bbd5f8b9b5a92f7420e3c6670e64e Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Mon, 30 Jul 2007 16:59:00 +0200
Subject: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering

Expand support for Promisc mode filtering,
and also support Multicast and Broadcast filtering
using the same method.
This requires renaming some variables and methods.
As usual, monitor mode filters nothing and accept
as much frames as possible.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c    |    7 +++--
 drivers/net/wireless/rt2500pci.c    |   14 +++++++-----
 drivers/net/wireless/rt2500usb.c    |   15 ++++++++----
 drivers/net/wireless/rt2500usb.h    |    4 +-
 drivers/net/wireless/rt2x00.h       |   25 +++++++++++----------
 drivers/net/wireless/rt2x00config.c |   25 ++++++++++++---------
 drivers/net/wireless/rt2x00lib.h    |    2 +-
 drivers/net/wireless/rt2x00mac.c    |   40 +++++++++++++++++++++-------------
 drivers/net/wireless/rt61pci.c      |   14 +++++++-----
 drivers/net/wireless/rt73usb.c      |   18 ++++++++-------
 10 files changed, 95 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 49dc1aa..e9bf565 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -276,9 +276,10 @@ static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
-static void rt2400pci_config_promisc(struct rt2x00_dev *rt2x00dev,
-				     const int promisc)
+static void rt2400pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
+					   const int filter)
 {
+	int promisc = !!(filter & IFF_PROMISC);
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
@@ -1633,7 +1634,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_mac_addr	= rt2400pci_config_mac_addr,
 	.config_bssid		= rt2400pci_config_bssid,
-	.config_promisc		= rt2400pci_config_promisc,
+	.config_packet_filter	= rt2400pci_config_packet_filter,
 	.config_type		= rt2400pci_config_type,
 	.config			= rt2400pci_config,
 };
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index f493a9c..7661a82 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -276,13 +276,18 @@ static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
-static void rt2500pci_config_promisc(struct rt2x00_dev *rt2x00dev,
-				     const int promisc)
+static void rt2500pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
+					   const int filter)
 {
+	int promisc = !!(filter & IFF_PROMISC);
+	int multicast = !!(filter & IFF_MULTICAST);
+	int broadcast = !!(filter & IFF_BROADCAST);
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, !promisc);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST, !multicast);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, !broadcast);
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
 
@@ -314,9 +319,6 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
 	}
 
-	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST, 0);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, 0);
-
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 
 	/*
@@ -1859,7 +1861,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_mac_addr	= rt2500pci_config_mac_addr,
 	.config_bssid		= rt2500pci_config_bssid,
-	.config_promisc		= rt2500pci_config_promisc,
+	.config_packet_filter	= rt2500pci_config_packet_filter,
 	.config_type		= rt2500pci_config_type,
 	.config			= rt2500pci_config,
 };
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 8626e55..2e19634 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -281,13 +281,18 @@ static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR5, &reg, sizeof(reg));
 }
 
-static void rt2500usb_config_promisc(struct rt2x00_dev *rt2x00dev,
-				     const int promisc)
+static void rt2500usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
+					   const int filter)
 {
+	int promisc = !!(filter & IFF_PROMISC);
+	int multicast = !!(filter & IFF_MULTICAST);
+	int broadcast = !!(filter & IFF_BROADCAST);
 	u16 reg;
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME, !promisc);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST, !multicast);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_BROADCAST, !broadcast);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
 }
 
@@ -1469,10 +1474,10 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * USB devices require scheduled promisc mode toggling
+	 * USB devices require scheduled packet filter toggling
 	 * This device supports ATIM
 	 */
-	__set_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags);
+	__set_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags);
 	__set_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
 
 	/*
@@ -1533,7 +1538,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_mac_addr	= rt2500usb_config_mac_addr,
 	.config_bssid		= rt2500usb_config_bssid,
-	.config_promisc		= rt2500usb_config_promisc,
+	.config_packet_filter	= rt2500usb_config_packet_filter,
 	.config_type		= rt2500usb_config_type,
 	.config			= rt2500usb_config,
 };
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index 5feb34e..9df67fb 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -247,8 +247,8 @@
 #define TXRX_CSR2_DROP_NOT_TO_ME	FIELD16(0x0010)
 #define TXRX_CSR2_DROP_TODS		FIELD16(0x0020)
 #define TXRX_CSR2_DROP_VERSION_ERROR	FIELD16(0x0040)
-#define TXRX_CSR2_DROP_MCAST		FIELD16(0x0200)
-#define TXRX_CSR2_DROP_BCAST		FIELD16(0x0400)
+#define TXRX_CSR2_DROP_MULTICAST	FIELD16(0x0200)
+#define TXRX_CSR2_DROP_BROADCAST	FIELD16(0x0400)
 
 /*
  * RX BBP ID registers
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 7f3febc..9a52251 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -276,11 +276,13 @@ struct interface {
 	u8 bssid[ETH_ALEN];
 
 	/*
-	 * Store the promisc mode for the current interface.
-	 * monitor mode always forces promisc mode to be enabled,
-	 * so we need to store the promisc mode seperately.
+	 * Store the packet filter mode for the current interface.
+	 * monitor mode always disabled filtering. But in such
+	 * cases we still need to store the value here in case
+	 * the monitor mode interfaces are removed, while a
+	 * non-monitor mode interface remains.
 	 */
-	char promisc;
+	char filter;
 
 	/*
 	 * Monitor mode count, the number of interfaces
@@ -384,10 +386,9 @@ struct rt2x00lib_ops {
 	 */
 	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, u8 *mac);
 	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, u8 *bssid);
-	void (*config_promisc) (struct rt2x00_dev *rt2x00dev,
-				const int promisc);
+	void (*config_packet_filter) (struct rt2x00_dev *rt2x00dev,
+				      const int filter);
 	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type);
-
 	void (*config) (struct rt2x00_dev *rt2x00dev, const int flags,
 			struct ieee80211_conf *conf);
 #define CONFIG_UPDATE_PHYMODE		( 1 << 1 )
@@ -473,11 +474,11 @@ struct rt2x00_dev {
 #define DEVICE_INITIALIZED		3
 #define DEVICE_INITIALIZED_HW		4
 #define REQUIRE_FIRMWARE		5
-#define REQUIRE_SCHEDULE_PROMISC	6
-#define INTERFACE_RESET			7
-#define INTERFACE_ENABLED		8
-#define INTERFACE_ENABLED_MONITOR	9
-#define INTERFACE_ENABLED_PROMISC	10
+#define PACKET_FILTER_SCHEDULED		6
+#define PACKET_FILTER_PENDING		7
+#define INTERFACE_RESET			8
+#define INTERFACE_ENABLED		9
+#define INTERFACE_ENABLED_MONITOR	10
 #define DEVICE_SUPPORT_ATIM		11
 #define DEVICE_SUPPORT_HW_BUTTON	12
 #define CONFIG_FRAME_TYPE		13
diff --git a/drivers/net/wireless/rt2x00config.c b/drivers/net/wireless/rt2x00config.c
index 22e13d0..3733a84 100644
--- a/drivers/net/wireless/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00config.c
@@ -46,16 +46,19 @@ void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, bssid);
 }
 
-void rt2x00lib_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
+void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter)
 {
 	struct interface *intf = &rt2x00dev->interface;
 
 	/*
 	 * When a monitor interface is present,
-	 * we should force promisc mode.
+	 * we should force enable all modes.
 	 */
-	if (is_monitor_present(intf))
-		promisc = 1;
+	if (is_monitor_present(intf)) {
+		filter = IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
+		if (intf->filter != filter)
+			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
+	}
 
 	/*
 	 * Only configure the device when something has changed,
@@ -63,14 +66,14 @@ void rt2x00lib_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
 	 * will be forced upon the device.
 	 */
 	if (!test_bit(INTERFACE_RESET, &rt2x00dev->flags) &&
-	    test_bit(INTERFACE_ENABLED_PROMISC, &rt2x00dev->flags) == !!promisc)
-
-	rt2x00dev->ops->lib->config_promisc(rt2x00dev, promisc);
+	    !test_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags))
+		return;
 
-	if (promisc)
-		__set_bit(INTERFACE_ENABLED_PROMISC, &rt2x00dev->flags);
-	else
-		__clear_bit(INTERFACE_ENABLED_PROMISC, &rt2x00dev->flags);
+	/*
+	 * Write configuration to device and clear the update flag.
+	 */
+	rt2x00dev->ops->lib->config_packet_filter(rt2x00dev, filter);
+	__clear_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
 }
 
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
diff --git a/drivers/net/wireless/rt2x00lib.h b/drivers/net/wireless/rt2x00lib.h
index 4484381..1a28292 100644
--- a/drivers/net/wireless/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00lib.h
@@ -50,7 +50,7 @@ void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev);
  */
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
-void rt2x00lib_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc);
+void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter);
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf);
 
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index 0261fdc..c36ac4a 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -148,7 +148,7 @@ int rt2x00mac_reset(struct ieee80211_hw *hw)
 	 */
 	rt2x00lib_config(rt2x00dev, &hw->conf);
 	rt2x00lib_config_type(rt2x00dev, intf->type);
-	rt2x00lib_config_promisc(rt2x00dev, intf->promisc);
+	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 
 	/*
@@ -192,7 +192,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		if (conf->type == IEEE80211_IF_TYPE_AP)
 			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
 		intf->mac = conf->mac_addr;
-		intf->promisc = 0;
+		intf->filter = 0;
 	}
 
 	return rt2x00lib_init_interface(rt2x00dev);
@@ -222,7 +222,7 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 		intf->type = INVALID_INTERFACE;
 		memset(&intf->bssid, 0x00, ETH_ALEN);
 		intf->mac = NULL;
-		intf->promisc = 0;
+		intf->filter = 0;
 	}
 
 	rt2x00lib_deinit_interface(rt2x00dev);
@@ -250,9 +250,9 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	 * If promisc mode cannot be configured in irq context,
 	 * then it is now the time to configure it.
 	 */
-	if (test_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags))
-		rt2x00lib_config_promisc(rt2x00dev,
-					 rt2x00dev->interface.promisc);
+	if (test_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags))
+		rt2x00lib_config_packet_filter(rt2x00dev,
+					       rt2x00dev->interface.filter);
 
 	/*
 	 * Reenable RX only if the radio should be on.
@@ -295,7 +295,7 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 	 * Enable configuration.
 	 */
 	rt2x00lib_config_type(rt2x00dev, conf->type);
-	rt2x00lib_config_promisc(rt2x00dev, intf->promisc);
+	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 
 	/*
@@ -318,25 +318,35 @@ void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
 				  unsigned short flags, int mc_count)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int promisc = !!(flags & IFF_PROMISC);
 
 	/*
-	 * Promisc mode is forced on for Monitor interfaces.
+	 * Check if the new state is different then the old state.
 	 */
-	if (is_monitor_present(&rt2x00dev->interface))
+	if (rt2x00dev->interface.filter == flags)
 		return;
 
+	rt2x00dev->interface.filter = flags;
+
 	/*
-	 * Check if the new state is different then the old state.
+	 * No filtering in monitor mode.
 	 */
-	if (test_bit(INTERFACE_ENABLED_PROMISC, &rt2x00dev->flags) == promisc)
+	if (is_monitor_present(&rt2x00dev->interface))
 		return;
 
-	rt2x00dev->interface.promisc = promisc;
+	/*
+	 * Raise the pending bit to indicate the
+	 * packet filter should be updated.
+	 */
+	__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
 
-	if (!test_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags) ||
+	/*
+	 * Check if Packet filter actions are allowed in
+	 * atomic context. If not, raise the pending flag and
+	 * let it be.
+	 */
+	if (!test_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags) ||
 	    !in_atomic())
-		rt2x00lib_config_promisc(rt2x00dev, promisc);
+		rt2x00lib_config_packet_filter(rt2x00dev, flags);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_set_multicast_list);
 
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 436b73c..d574297 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -305,13 +305,18 @@ static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
-static void rt61pci_config_promisc(struct rt2x00_dev *rt2x00dev,
-				   const int promisc)
+static void rt61pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
+					 const int filter)
 {
+	int promisc = !!(filter & IFF_PROMISC);
+	int multicast = !!(filter & IFF_MULTICAST);
+	int broadcast = !!(filter & IFF_BROADCAST);
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, !promisc);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, !multicast);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, !broadcast);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -345,9 +350,6 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
 	}
 
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, 0);
-
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	/*
@@ -2376,7 +2378,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_mac_addr	= rt61pci_config_mac_addr,
 	.config_bssid		= rt61pci_config_bssid,
-	.config_promisc		= rt61pci_config_promisc,
+	.config_packet_filter	= rt61pci_config_packet_filter,
 	.config_type		= rt61pci_config_type,
 	.config			= rt61pci_config,
 };
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index e67f358..9875e39 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -280,13 +280,18 @@ static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
-static void rt73usb_config_promisc(struct rt2x00_dev *rt2x00dev,
-				   const int promisc)
+static void rt73usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
+					 const int filter)
 {
+	int promisc = !!(filter & IFF_PROMISC);
+	int multicast = !!(filter & IFF_MULTICAST);
+	int broadcast = !!(filter & IFF_BROADCAST);
 	u32 reg;
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, !promisc);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, !multicast);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, !broadcast);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -320,9 +325,6 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
 	}
 
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, 0);
-
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	/*
@@ -1732,11 +1734,11 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt73usb_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * USB devices require scheduled promisc mode toggling
+	 * USB devices require scheduled packet filter toggling
 	 * This device requires firmware
 	 */
 	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags);
+	__set_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1850,7 +1852,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_mac_addr	= rt73usb_config_mac_addr,
 	.config_bssid		= rt73usb_config_bssid,
-	.config_promisc		= rt73usb_config_promisc,
+	.config_packet_filter	= rt73usb_config_packet_filter,
 	.config_type		= rt73usb_config_type,
 	.config			= rt73usb_config,
 };
-- 
1.5.2.4

