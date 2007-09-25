Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:19600 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbXIYSor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:47 -0400
Received: by ug-out-1314.google.com with SMTP id z38so993592ugc
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:46 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/12] rt2x00: adapt to filter configuration API
Date: Tue, 25 Sep 2007 20:55:09 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252055.10078.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make sure rt2x00 will follow the new mac80211 API
concerning the packet filter.
This new API cleans up quite a lot of code in rt2x00.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |  155 +++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  165 ++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  179 ++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00.h       |   37 ++----
 drivers/net/wireless/rt2x00/rt2x00config.c |   60 +---------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   33 ++++--
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  104 ++--------------
 drivers/net/wireless/rt2x00/rt2x00pci.c    |   31 ++---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h   |   17 +++-
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   16 +--
 drivers/net/wireless/rt2x00/rt61pci.c      |  164 ++++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.c      |  175 +++++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.h      |    2 +-
 15 files changed, 556 insertions(+), 589 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 398c201..03a94a3 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -277,55 +277,14 @@ static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
-static void rt2400pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const unsigned int filter)
-{
-	int promisc = !!(filter & IFF_PROMISC);
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, !promisc);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 {
+	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
 
 	/*
-	 * Apply hardware packet filter.
-	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-
-	if (!is_monitor_present(&rt2x00dev->interface) &&
-	    (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 1);
-	else
-		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 0);
-
-	/*
-	 * If there is a non-monitor interface present
-	 * the packet should be strict (even if a monitor interface is present!).
-	 * When there is only 1 interface present which is in monitor mode
-	 * we should start accepting _all_ frames.
-	 */
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
-	} else if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
-	}
-
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-
-	/*
 	 * Enable beacon config
 	 */
 	rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
@@ -337,20 +296,16 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 	 * Enable synchronisation.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
-	}
-
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
+	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-	else if (type == IEEE80211_IF_TYPE_STA)
+	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-	else if (is_monitor_present(&rt2x00dev->interface) &&
-		 !is_interface_present(&rt2x00dev->interface))
+	else
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
@@ -1104,7 +1059,7 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct data_desc *txd,
-				    struct data_entry_desc *desc,
+				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
 				    struct ieee80211_tx_control *control)
@@ -1200,8 +1155,8 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 /*
  * RX control handlers
  */
-static int rt2400pci_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm, int *size)
+static void rt2400pci_fill_rxdone(struct data_entry *entry,
+				  struct rxdata_entry_desc *desc)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1210,20 +1165,20 @@ static int rt2400pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 2, &word2);
 
-	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
-		return -EINVAL;
+	desc->flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
+		desc->flags |= RX_FLAG_FAILED_FCS_CRC;
+	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+		desc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
 	/*
 	 * Obtain the status about this packet.
 	 */
-	*signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
-	*rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
+	desc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+	desc->rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
-	*ofdm = 0;
-	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-
-	return 0;
+	desc->ofdm = 0;
+	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 }
 
 /*
@@ -1460,10 +1415,7 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_NO_PROBE_FILTERING;
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
@@ -1530,6 +1482,68 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static void rt2400pci_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed_flags,
+				       unsigned int *total_flags,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	u32 reg;
+
+	/*
+	 * Mask off any flags we are going to ignore from
+	 * the total_flags field.
+	 */
+	*total_flags &=
+	    FIF_ALLMULTI |
+	    FIF_FCSFAIL |
+	    FIF_PLCPFAIL |
+	    FIF_CONTROL |
+	    FIF_OTHER_BSS |
+	    FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Apply some rules to the filters:
+	 * - Some filters imply different filters to be set.
+	 * - Some things we can't filter out at all.
+	 * - Some filters are set based on interface type.
+	 */
+	*total_flags |= FIF_ALLMULTI;
+	if (changed_flags & FIF_OTHER_BSS ||
+	    changed_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
+		*total_flags |= FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (intf->filter == *total_flags)
+		return;
+	intf->filter = *total_flags;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * since there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
+			   !(*total_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
+			   !(*total_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
+			   !(*total_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static int rt2400pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1602,11 +1616,13 @@ static int rt2400pci_tx_last_beacon(struct ieee80211_hw *hw)
 
 static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.set_multicast_list	= rt2x00mac_set_multicast_list,
+	.configure_filter	= rt2400pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2400pci_set_retry_limit,
 	.conf_tx		= rt2400pci_conf_tx,
@@ -1635,7 +1651,6 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_mac_addr	= rt2400pci_config_mac_addr,
 	.config_bssid		= rt2400pci_config_bssid,
-	.config_packet_filter	= rt2400pci_config_packet_filter,
 	.config_type		= rt2400pci_config_type,
 	.config			= rt2400pci_config,
 };
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index e8d63aa..892baa9 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -277,59 +277,14 @@ static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
-static void rt2500pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const unsigned int filter)
-{
-	int promisc = !!(filter & IFF_PROMISC);
-	int multicast = !!(filter & IFF_MULTICAST);
-	int broadcast = !!(filter & IFF_BROADCAST);
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, !promisc);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST, !multicast);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, !broadcast);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
+	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
 
 	/*
-	 * Apply hardware packet filter.
-	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-
-	if (!is_monitor_present(&rt2x00dev->interface) &&
-	    (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 1);
-	else
-		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 0);
-
-	/*
-	 * If there is a non-monitor interface present
-	 * the packet should be strict (even if a monitor interface is present!).
-	 * When there is only 1 interface present which is in monitor mode
-	 * we should start accepting _all_ frames.
-	 */
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 1);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
-	} else if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
-	}
-
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-
-	/*
 	 * Enable beacon config
 	 */
 	rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
@@ -345,20 +300,16 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	 * Enable synchronisation.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
-	}
-
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
+	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-	else if (type == IEEE80211_IF_TYPE_STA)
+	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-	else if (is_monitor_present(&rt2x00dev->interface) &&
-		 !is_interface_present(&rt2x00dev->interface))
+	else
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
@@ -1269,7 +1220,7 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct data_desc *txd,
-				    struct data_entry_desc *desc,
+				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
 				    struct ieee80211_tx_control *control)
@@ -1349,8 +1300,8 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 /*
  * RX control handlers
  */
-static int rt2500pci_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm, int *size)
+static void rt2500pci_fill_rxdone(struct data_entry *entry,
+				  struct rxdata_entry_desc *desc)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1359,18 +1310,17 @@ static int rt2500pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 2, &word2);
 
-	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR))
-		return -EINVAL;
+	desc->flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
+		desc->flags |= RX_FLAG_FAILED_FCS_CRC;
+	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+		desc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
-	*signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
-	*rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
+	desc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+	desc->rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
-	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
-	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-
-	return 0;
+	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 }
 
 /*
@@ -1779,10 +1729,7 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_NO_PROBE_FILTERING;
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
@@ -1867,6 +1814,73 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static void rt2500pci_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed_flags,
+				       unsigned int *total_flags,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	u32 reg;
+
+	/*
+	 * Mask off any flags we are going to ignore from
+	 * the total_flags field.
+	 */
+	*total_flags &=
+	    FIF_ALLMULTI |
+	    FIF_FCSFAIL |
+	    FIF_PLCPFAIL |
+	    FIF_CONTROL |
+	    FIF_OTHER_BSS |
+	    FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Apply some rules to the filters:
+	 * - Some filters imply different filters to be set.
+	 * - Some things we can't filter out at all.
+	 * - Some filters are set based on interface type.
+	 */
+	if (mc_count)
+		*total_flags |= FIF_ALLMULTI;
+	if (changed_flags & FIF_OTHER_BSS ||
+	    changed_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
+		*total_flags |= FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (intf->filter == *total_flags)
+		return;
+	intf->filter = *total_flags;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
+			   !(*total_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
+			   !(*total_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
+			   !(*total_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
+			   !(*total_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, 0);
+	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static int rt2500pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1914,11 +1928,13 @@ static int rt2500pci_tx_last_beacon(struct ieee80211_hw *hw)
 
 static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.set_multicast_list	= rt2x00mac_set_multicast_list,
+	.configure_filter	= rt2500pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2500pci_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
@@ -1947,7 +1963,6 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_mac_addr	= rt2500pci_config_mac_addr,
 	.config_bssid		= rt2500pci_config_bssid,
-	.config_packet_filter	= rt2500pci_config_packet_filter,
 	.config_type		= rt2500pci_config_type,
 	.config			= rt2500pci_config,
 };
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 614600c..f4e6f6e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -282,65 +282,20 @@ static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR5, &reg, sizeof(reg));
 }
 
-static void rt2500usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const unsigned int filter)
-{
-	int promisc = !!(filter & IFF_PROMISC);
-	int multicast = !!(filter & IFF_MULTICAST);
-	int broadcast = !!(filter & IFF_BROADCAST);
-	u16 reg;
-
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME, !promisc);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST, !multicast);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_BROADCAST, !broadcast);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
-}
-
 static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
+	struct interface *intf = &rt2x00dev->interface;
 	u16 reg;
 
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, 0);
 
 	/*
-	 * Apply hardware packet filter.
-	 */
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
-
-	if (!is_monitor_present(&rt2x00dev->interface) &&
-	    (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS, 1);
-	else
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS, 0);
-
-	/*
-	 * If there is a non-monitor interface present
-	 * the packet should be strict (even if a monitor interface is present!).
-	 * When there is only 1 interface present which is in monitor mode
-	 * we should start accepting _all_ frames.
-	 */
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
-	} else if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 0);
-	}
-
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
-
-	/*
 	 * Enable beacon config
 	 */
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR20, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR20_OFFSET,
 			   (PREAMBLE + get_duration(IEEE80211_HEADER, 2)) >> 6);
-	if (type == IEEE80211_IF_TYPE_STA)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW, 0);
 	else
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW, 2);
@@ -354,20 +309,16 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
-	}
-
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
+	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 2);
-	else if (type == IEEE80211_IF_TYPE_STA)
+	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 1);
-	else if (is_monitor_present(&rt2x00dev->interface) &&
-		 !is_interface_present(&rt2x00dev->interface))
+	else
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 0);
-
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 }
 
@@ -1084,7 +1035,7 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct data_desc *txd,
-				    struct data_entry_desc *desc,
+				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
 				    struct ieee80211_tx_control *control)
@@ -1156,8 +1107,8 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 /*
  * RX control handlers
  */
-static int rt2500usb_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm, int *size)
+static void rt2500usb_fill_rxdone(struct data_entry *entry,
+				  struct rxdata_entry_desc *desc)
 {
 	struct urb *urb = entry->priv;
 	struct data_desc *rxd = (struct data_desc *)(entry->skb->data +
@@ -1169,21 +1120,22 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
-		return -EINVAL;
+	desc->flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
+		desc->flags |= RX_FLAG_FAILED_FCS_CRC;
+	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+		desc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
 	/*
 	 * Obtain the status about this packet.
 	 */
-	*signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	*rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
+	desc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	desc->rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
-	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
-	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return 0;
+	return;
 }
 
 /*
@@ -1549,9 +1501,7 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_NO_PROBE_FILTERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
@@ -1621,10 +1571,8 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * USB devices require scheduled packet filter toggling
-	 *This device requires the beacon ring
+	 * This device requires the beacon ring
 	 */
-	__set_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags);
 	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
@@ -1638,6 +1586,82 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static void rt2500usb_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed_flags,
+				       unsigned int *total_flags,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	u16 reg;
+
+	/*
+	 * Mask off any flags we are going to ignore from
+	 * the total_flags field.
+	 */
+	*total_flags &=
+	    FIF_ALLMULTI |
+	    FIF_FCSFAIL |
+	    FIF_PLCPFAIL |
+	    FIF_CONTROL |
+	    FIF_OTHER_BSS |
+	    FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Apply some rules to the filters:
+	 * - Some filters imply different filters to be set.
+	 * - Some things we can't filter out at all.
+	 * - Some filters are set based on interface type.
+	 */
+	if (mc_count)
+		*total_flags |= FIF_ALLMULTI;
+	if (changed_flags & FIF_OTHER_BSS ||
+	    changed_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
+		*total_flags |= FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (intf->filter == *total_flags)
+		return;
+	intf->filter = *total_flags;
+
+	/*
+	 * When in atomic context, reschedule and let rt2x00lib
+	 * call this function again.
+	 */
+	if (in_atomic()) {
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
+		return;
+	}
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC,
+			   !(*total_flags & FIF_FCSFAIL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL,
+			   !(*total_flags & FIF_PLCPFAIL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL,
+			   !(*total_flags & FIF_CONTROL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
+			   !(*total_flags & FIF_ALLMULTI));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_BROADCAST, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
+}
+
 static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 				   struct sk_buff *skb,
 				   struct ieee80211_tx_control *control)
@@ -1714,11 +1738,13 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.set_multicast_list	= rt2x00mac_set_multicast_list,
+	.configure_filter	= rt2500usb_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
@@ -1739,7 +1765,6 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_mac_addr	= rt2500usb_config_mac_addr,
 	.config_bssid		= rt2500usb_config_bssid,
-	.config_packet_filter	= rt2500usb_config_packet_filter,
 	.config_type		= rt2500usb_config_type,
 	.config			= rt2500usb_config,
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2609d4a..5f05c7e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -294,9 +294,6 @@ struct interface {
 
 	/*
 	 * Current working type (IEEE80211_IF_TYPE_*).
-	 * This excludes the type IEEE80211_IF_TYPE_MNTR
-	 * since that is counted seperately in the monitor_count
-	 * field.
 	 * When set to INVALID_INTERFACE, no interface is configured.
 	 */
 	int type;
@@ -314,18 +311,8 @@ struct interface {
 
 	/*
 	 * Store the packet filter mode for the current interface.
-	 * monitor mode always disabled filtering. But in such
-	 * cases we still need to store the value here in case
-	 * the monitor mode interfaces are removed, while a
-	 * non-monitor mode interface remains.
 	 */
-	unsigned short filter;
-
-	/*
-	 * Monitor mode count, the number of interfaces
-	 * in monitor mode that that have been added.
-	 */
-	unsigned short monitor_count;
+	unsigned int filter;
 };
 
 static inline int is_interface_present(struct interface *intf)
@@ -333,9 +320,9 @@ static inline int is_interface_present(struct interface *intf)
 	return !!intf->id;
 }
 
-static inline int is_monitor_present(struct interface *intf)
+static inline int is_interface_type(struct interface *intf, int type)
 {
-	return !!intf->monitor_count;
+	return intf->type == type;
 }
 
 /*
@@ -402,7 +389,7 @@ struct rt2x00lib_ops {
 	 */
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
 			       struct data_desc *txd,
-			       struct data_entry_desc *desc,
+			       struct txdata_entry_desc *desc,
 			       struct ieee80211_hdr *ieee80211hdr,
 			       unsigned int length,
 			       struct ieee80211_tx_control *control);
@@ -415,8 +402,8 @@ struct rt2x00lib_ops {
 	/*
 	 * RX control handlers
 	 */
-	int (*fill_rxdone) (struct data_entry *entry,
-			    int *signal, int *rssi, int *ofdm, int *size);
+	void (*fill_rxdone) (struct data_entry *entry,
+			     struct rxdata_entry_desc *desc);
 
 	/*
 	 * Configuration handlers.
@@ -511,11 +498,10 @@ struct rt2x00_dev {
 #define DEVICE_INITIALIZED		3
 #define DEVICE_INITIALIZED_HW		4
 #define REQUIRE_FIRMWARE		5
-#define PACKET_FILTER_SCHEDULED		6
-#define PACKET_FILTER_PENDING		7
+/* Hole: Add new Flag here */
 #define INTERFACE_RESUME		8
 #define INTERFACE_ENABLED		9
-#define INTERFACE_ENABLED_MONITOR	10
+/* Hole: Add new Flag here */
 #define REQUIRE_BEACON_RING		11
 #define DEVICE_SUPPORT_HW_BUTTON	12
 #define CONFIG_FRAME_TYPE		13
@@ -606,9 +592,10 @@ struct rt2x00_dev {
 	struct ieee80211_rx_status rx_status;
 
 	/*
-	 * Beacon scheduled work.
+	 * Scheduled work.
 	 */
 	struct work_struct beacon_work;
+	struct work_struct filter_work;
 
 	/*
 	 * Data ring arrays for RX, TX and Beacon.
@@ -760,7 +747,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct data_entry *entry,
 		      const int status, const int retry);
 void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
-		      const int signal, const int rssi, const int ofdm);
+		      struct rxdata_entry_desc *desc);
 
 /*
  * TX descriptor initializer
@@ -785,8 +772,6 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 			       struct ieee80211_if_conf *conf);
-void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
-				  unsigned short flags, int mc_count);
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats);
 int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index de890a1..f962ce4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -46,72 +46,24 @@ void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 		rt2x00dev->ops->lib->config_bssid(rt2x00dev, bssid);
 }
 
-void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter)
-{
-	/*
-	 * Only configure the device when something has changed,
-	 * or if we are in RESUME state in which case all configuration
-	 * will be forced upon the device.
-	 */
-	if (!test_bit(INTERFACE_RESUME, &rt2x00dev->flags) &&
-	    !test_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags))
-		return;
-
-	/*
-	 * Write configuration to device and clear the update flag.
-	 */
-	rt2x00dev->ops->lib->config_packet_filter(rt2x00dev, filter);
-	__clear_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
-}
-
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
 {
 	struct interface *intf = &rt2x00dev->interface;
 
-	/*
-	 * Fallback when a invalid interface is attempted to
-	 * be configured. If a monitor interface is present,
-	 * we are going configure that, otherwise exit.
-	 */
-	if (type == INVALID_INTERFACE) {
-		if (is_monitor_present(intf))
-			type = IEEE80211_IF_TYPE_MNTR;
-		else
-			return;
-	}
-
-	/*
-	 * Only configure the device when something has changed,
-	 * or if we are in RESUME state in which case all configuration
-	 * will be forced upon the device.
-	 */
 	if (!test_bit(INTERFACE_RESUME, &rt2x00dev->flags) &&
-	    (!(is_interface_present(intf) ^
-	       test_bit(INTERFACE_ENABLED, &rt2x00dev->flags)) &&
-	     !(is_monitor_present(intf) ^
-	       test_bit(INTERFACE_ENABLED_MONITOR, &rt2x00dev->flags))))
+	    (!!test_bit(INTERFACE_ENABLED, &rt2x00dev->flags) ==
+	     !!is_interface_present(intf)))
 		return;
 
-	/*
-	 * Configure device.
-	 */
 	rt2x00dev->ops->lib->config_type(rt2x00dev, type);
 
 	/*
 	 * Update the configuration flags.
 	 */
-	if (type != IEEE80211_IF_TYPE_MNTR) {
-		if (is_interface_present(intf))
-			__set_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
-		else
-			__clear_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
-	} else {
-		if (is_monitor_present(intf))
-			__set_bit(INTERFACE_ENABLED_MONITOR, &rt2x00dev->flags);
-		else
-			__clear_bit(INTERFACE_ENABLED_MONITOR,
-				    &rt2x00dev->flags);
-	}
+	if (is_interface_present(intf))
+		__set_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
+	else
+		__clear_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf)
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5780d6a..4f66adc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -135,10 +135,12 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Stop beacon generation.
+	 * Stop all scheduled work.
 	 */
 	if (work_pending(&rt2x00dev->beacon_work))
 		cancel_work_sync(&rt2x00dev->beacon_work);
+	if (work_pending(&rt2x00dev->filter_work))
+		cancel_work_sync(&rt2x00dev->filter_work);
 
 	/*
 	 * Stop the TX queues.
@@ -261,6 +263,17 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 			   LINK_TUNE_INTERVAL);
 }
 
+static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, filter_work);
+
+	rt2x00dev->ops->hw->configure_filter(rt2x00dev->hw,
+					     rt2x00dev->interface.filter,
+					     &rt2x00dev->interface.filter,
+					     0, NULL);
+}
+
 /*
  * Interrupt context handlers.
  */
@@ -341,7 +354,7 @@ void rt2x00lib_txdone(struct data_entry *entry,
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
 void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
-		      const int signal, const int rssi, const int ofdm)
+		      struct rxdata_entry_desc *desc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
@@ -362,22 +375,24 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		 * the signal is the PLCP value. If it was received with
 		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
 		 */
-		if (!ofdm)
+		if (!desc->ofdm)
 			val = DEVICE_GET_RATE_FIELD(rate->val, RATE);
 		else
 			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
 
-		if (val == signal) {
+		if (val == desc->signal) {
 			val = rate->val;
 			break;
 		}
 	}
 
-	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
+	rt2x00_update_link_rssi(&rt2x00dev->link, desc->rssi);
 	rt2x00dev->link.rx_success++;
 	rx_status->rate = val;
-	rx_status->signal = rt2x00lib_calculate_link_signal(rt2x00dev, rssi);
-	rx_status->ssi = rssi;
+	rx_status->signal =
+	    rt2x00lib_calculate_link_signal(rt2x00dev, desc->rssi);
+	rx_status->ssi = desc->rssi;
+	rx_status->flag = desc->flags;
 
 	/*
 	 * Send frame to mac80211
@@ -395,7 +410,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			     unsigned int length,
 			     struct ieee80211_tx_control *control)
 {
-	struct data_entry_desc desc;
+	struct txdata_entry_desc desc;
 	struct data_ring *ring;
 	int tx_rate;
 	int bitrate;
@@ -960,6 +975,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 * Initialize configuration work.
 	 */
 	INIT_WORK(&rt2x00dev->beacon_work, rt2x00lib_beacondone_scheduled);
+	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
 
 	/*
@@ -1102,7 +1118,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 	rt2x00lib_config_type(rt2x00dev, intf->type);
-	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 
 	/*
 	 * When in Master or Ad-hoc mode,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 3324090..fcc2ffd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -51,7 +51,6 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
  */
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
-void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter);
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 778ed41..17802f6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -176,46 +176,26 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct interface *intf = &rt2x00dev->interface;
-	int retval;
 
 	/*
 	 * We only support 1 non-monitor interface.
 	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR && is_interface_present(intf))
+	if (is_interface_present(intf))
 		return -ENOBUFS;
 
-	/*
-	 * HACK: Placeholder until start/stop handler has been
-	 * added to the mac80211 callback functions structure.
-	 */
-	retval = rt2x00mac_start(hw);
-	if (retval)
-		return retval;
-
-	/*
-	 * We support muliple monitor mode interfaces.
-	 * All we need to do is increase the monitor_count.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count++;
-	} else {
-		intf->id = conf->if_id;
-		intf->type = conf->type;
-		if (conf->type == IEEE80211_IF_TYPE_AP)
-			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
-		memcpy(&intf->mac, conf->mac_addr, ETH_ALEN);
-		intf->filter = 0;
-	}
+	intf->id = conf->if_id;
+	intf->type = conf->type;
+	if (conf->type == IEEE80211_IF_TYPE_AP)
+		memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
+	memcpy(&intf->mac, conf->mac_addr, ETH_ALEN);
 
 	/*
-	 * Configure interface.
 	 * The MAC adddress must be configured after the device
-	 * has been initialized. Else the device can reset the
-	 * MAC registers.
+	 * has been initialized. Otherwise the device can reset
+	 * the MAC registers.
 	 */
 	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
 	rt2x00lib_config_type(rt2x00dev, conf->type);
-	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 
 	return 0;
 }
@@ -230,22 +210,13 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	/*
 	 * We only support 1 non-monitor interface.
 	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR && !is_interface_present(intf))
+	if (!is_interface_present(intf))
 		return;
 
-	/*
-	 * When removing an monitor interface, decrease monitor_count.
-	 * For non-monitor interfaces, all interface data needs to be reset.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count--;
-	} else if (intf->type == conf->type) {
-		intf->id = 0;
-		intf->type = INVALID_INTERFACE;
-		memset(&intf->bssid, 0x00, ETH_ALEN);
-		memset(&intf->mac, 0x00, ETH_ALEN);
-		intf->filter = 0;
-	}
+	intf->id = 0;
+	intf->type = INVALID_INTERFACE;
+	memset(&intf->bssid, 0x00, ETH_ALEN);
+	memset(&intf->mac, 0x00, ETH_ALEN);
 
 	/*
 	 * Make sure the bssid and mac address registers
@@ -254,12 +225,6 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 	rt2x00lib_config_type(rt2x00dev, intf->type);
-
-	/*
-	 * HACK: Placeholder untill start/stop handler has been
-	 * added to the mac80211 callback functions structure.
-	 */
-	rt2x00mac_stop(hw);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 
@@ -290,14 +255,6 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	rt2x00lib_config(rt2x00dev, conf);
 
 	/*
-	 * If promisc mode cannot be configured in irq context,
-	 * then it is now the time to configure it.
-	 */
-	if (test_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags))
-		rt2x00lib_config_packet_filter(rt2x00dev,
-					       rt2x00dev->interface.filter);
-
-	/*
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
@@ -326,13 +283,10 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 		return 0;
 
 	/*
-	 * Monitor mode does not need configuring.
 	 * If the given type does not match the configured type,
 	 * there has been a problem.
 	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR)
-		return 0;
-	else if (conf->type != intf->type)
+	if (conf->type != intf->type)
 		return -EINVAL;
 
 	/*
@@ -360,36 +314,6 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config_interface);
 
-void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
-				  unsigned short flags, int mc_count)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	/*
-	 * Check if the new state is different then the old state.
-	 */
-	if (rt2x00dev->interface.filter == flags)
-		return;
-
-	rt2x00dev->interface.filter = flags;
-
-	/*
-	 * Raise the pending bit to indicate the
-	 * packet filter should be updated.
-	 */
-	__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
-
-	/*
-	 * Check if Packet filter actions are allowed in
-	 * atomic context. If not, raise the pending flag and
-	 * let it be.
-	 */
-	if (!test_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags) ||
-	    !in_atomic())
-		rt2x00lib_config_packet_filter(rt2x00dev, flags);
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_set_multicast_list);
-
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 85629f1..2780df0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -124,47 +124,40 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_entry *entry;
 	struct data_desc *rxd;
 	struct sk_buff *skb;
-	u32 desc;
-	int retval;
-	int signal;
-	int rssi;
-	int ofdm;
-	int size;
+	struct rxdata_entry_desc desc;
+	u32 word;
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
 		rxd = entry->priv;
-		rt2x00_desc_read(rxd, 0, &desc);
+		rt2x00_desc_read(rxd, 0, &word);
 
-		if (rt2x00_get_field32(desc, RXD_ENTRY_OWNER_NIC))
+		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
 			break;
 
-		retval = rt2x00dev->ops->lib->fill_rxdone(entry, &signal,
-							  &rssi, &ofdm, &size);
-		if (retval)
-			goto skip_entry;
+		memset(&desc, 0x00, sizeof(desc));
+		rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
 		/*
 		 * Allocate the sk_buffer, initialize it and copy
 		 * all data into it.
 		 */
-		skb = dev_alloc_skb(size + NET_IP_ALIGN);
+		skb = dev_alloc_skb(desc.size + NET_IP_ALIGN);
 		if (!skb)
 			return;
 
 		skb_reserve(skb, NET_IP_ALIGN);
-		skb_put(skb, size);
-		memcpy(skb->data, entry->data_addr, size);
+		skb_put(skb, desc.size);
+		memcpy(skb->data, entry->data_addr, desc.size);
 
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(entry, skb, signal, rssi, ofdm);
+		rt2x00lib_rxdone(entry, skb, &desc);
 
-skip_entry:
 		if (test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags)) {
-			rt2x00_set_field32(&desc, RXD_ENTRY_OWNER_NIC, 1);
-			rt2x00_desc_write(rxd, 0, desc);
+			rt2x00_set_field32(&word, RXD_ENTRY_OWNER_NIC, 1);
+			rt2x00_desc_write(rxd, 0, word);
 		}
 
 		rt2x00_ring_index_inc(ring);
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index dc5b696..b54457c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -45,11 +45,9 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 		return 0;
 
 	/*
-	 * Only continue if we have an active interface,
-	 * either monitor or non-monitor should be present.
+	 * Only continue if we have an active interface.
 	 */
-	if (!is_interface_present(&rt2x00dev->interface) &&
-	    !is_monitor_present(&rt2x00dev->interface))
+	if (!is_interface_present(&rt2x00dev->interface))
 		return 0;
 
 	if (state == RFKILL_STATE_ON) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 122c752..1a864d3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -41,11 +41,24 @@ struct data_desc {
 };
 
 /*
- * data_entry_desc
+ * rxdata_entry_desc
+ * Summary of information that has been read from the
+ * RX frame descriptor.
+ */
+struct rxdata_entry_desc {
+	int signal;
+	int rssi;
+	int ofdm;
+	int size;
+	int flags;
+};
+
+/*
+ * txdata_entry_desc
  * Summary of information that should be written into the
  * descriptor for sending a TX frame.
  */
-struct data_entry_desc {
+struct txdata_entry_desc {
 	unsigned long flags;
 #define ENTRY_TXDONE		1
 #define ENTRY_TXD_RTS_FRAME	2
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 248144f..66e4761 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -218,11 +218,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
 	struct sk_buff *skb;
-	int retval;
-	int signal;
-	int rssi;
-	int ofdm;
-	int size;
+	struct rxdata_entry_desc desc;
 	int frame_size;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -237,10 +233,8 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	if (urb->actual_length < entry->ring->desc_size || urb->status)
 		goto skip_entry;
 
-	retval = rt2x00dev->ops->lib->fill_rxdone(entry, &signal, &rssi,
-						  &ofdm, &size);
-	if (retval)
-		goto skip_entry;
+	memset(&desc, 0x00, sizeof(desc));
+	rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
 	/*
 	 * Allocate a new sk buffer to replace the current one.
@@ -259,12 +253,12 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Trim the skb_buffer to only contain the valid
 	 * frame data (so ignore the device's descriptor).
 	 */
-	skb_trim(entry->skb, size);
+	skb_trim(entry->skb, desc.size);
 
 	/*
 	 * Send the frame to rt2x00lib for further processing.
 	 */
-	rt2x00lib_rxdone(entry, entry->skb, signal, rssi, ofdm);
+	rt2x00lib_rxdone(entry, entry->skb, &desc);
 
 	/*
 	 * Replace current entry's skb with the newly allocated one,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 69ed178..3edcd74 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -312,23 +312,9 @@ static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
-static void rt61pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int filter)
-{
-	int promisc = !!(filter & IFF_PROMISC);
-	int multicast = !!(filter & IFF_MULTICAST);
-	int broadcast = !!(filter & IFF_BROADCAST);
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, !promisc);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, !multicast);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, !broadcast);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
+	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -344,56 +330,19 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
 
 	/*
-	 * Apply hardware packet filter.
-	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-
-	if (!is_monitor_present(&rt2x00dev->interface) &&
-	    (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 0);
-
-	/*
-	 * If there is a non-monitor interface present
-	 * the packet should be strict (even if a monitor interface is present!).
-	 * When there is only 1 interface present which is in monitor mode
-	 * we should start accepting _all_ frames.
-	 */
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
-	} else if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
-	}
-
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
-
-	/*
 	 * Enable synchronisation.
 	 */
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
-	}
-
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
+	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
-	else if (type == IEEE80211_IF_TYPE_STA)
+	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
-	else if (is_monitor_present(&rt2x00dev->interface) &&
-		 !is_interface_present(&rt2x00dev->interface))
+	else
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
-
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
@@ -1686,7 +1635,7 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				  struct data_desc *txd,
-				  struct data_entry_desc *desc,
+				  struct txdata_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
 				  unsigned int length,
 				  struct ieee80211_tx_control *control)
@@ -1826,8 +1775,8 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 	return rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_AGC) * 2 - offset;
 }
 
-static int rt61pci_fill_rxdone(struct data_entry *entry,
-			       int *signal, int *rssi, int *ofdm, int *size)
+static void rt61pci_fill_rxdone(struct data_entry *entry,
+			        struct rxdata_entry_desc *desc)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1836,19 +1785,19 @@ static int rt61pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
-		return -EINVAL;
+	desc->flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
+		desc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
 	/*
 	 * Obtain the status about this packet.
 	 */
-	*signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	*rssi = rt61pci_agc_to_rssi(entry->ring->rt2x00dev, word1);
-	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
-	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	desc->rssi = rt61pci_agc_to_rssi(entry->ring->rt2x00dev, word1);
+	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return 0;
+	return;
 }
 
 /*
@@ -2340,9 +2289,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_NO_PROBE_FILTERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
@@ -2426,6 +2373,74 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static void rt61pci_configure_filter(struct ieee80211_hw *hw,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     int mc_count,
+				     struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	u32 reg;
+
+	/*
+	 * Mask off any flags we are going to ignore from
+	 * the total_flags field.
+	 */
+	*total_flags &=
+	    FIF_ALLMULTI |
+	    FIF_FCSFAIL |
+	    FIF_PLCPFAIL |
+	    FIF_CONTROL |
+	    FIF_OTHER_BSS |
+	    FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Apply some rules to the filters:
+	 * - Some filters imply different filters to be set.
+	 * - Some things we can't filter out at all.
+	 * - Some filters are set based on interface type.
+	 */
+	if (mc_count)
+		*total_flags |= FIF_ALLMULTI;
+	if (changed_flags & FIF_OTHER_BSS ||
+	    changed_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
+		*total_flags |= FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (intf->filter == *total_flags)
+		return;
+	intf->filter = *total_flags;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
+			   !(*total_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
+			   !(*total_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
+			   !(*total_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
+			   !(*total_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static int rt61pci_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -2506,11 +2521,13 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.set_multicast_list	= rt2x00mac_set_multicast_list,
+	.configure_filter	= rt61pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt61pci_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
@@ -2540,7 +2557,6 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_mac_addr	= rt61pci_config_mac_addr,
 	.config_bssid		= rt61pci_config_bssid,
-	.config_packet_filter	= rt61pci_config_packet_filter,
 	.config_type		= rt61pci_config_type,
 	.config			= rt61pci_config,
 };
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 890b449..b18cc93 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -293,23 +293,9 @@ static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
-static void rt73usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int filter)
-{
-	int promisc = !!(filter & IFF_PROMISC);
-	int multicast = !!(filter & IFF_MULTICAST);
-	int broadcast = !!(filter & IFF_BROADCAST);
-	u32 reg;
-
-	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, !promisc);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST, !multicast);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BORADCAST, !broadcast);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
+	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -325,56 +311,19 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt73usb_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
 
 	/*
-	 * Apply hardware packet filter.
-	 */
-	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-
-	if (!is_monitor_present(&rt2x00dev->interface) &&
-	    (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 0);
-
-	/*
-	 * If there is a non-monitor interface present
-	 * the packet should be strict (even if a monitor interface is present!).
-	 * When there is only 1 interface present which is in monitor mode
-	 * we should start accepting _all_ frames.
-	 */
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
-	} else if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
-	}
-
-	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-
-	/*
 	 * Enable synchronisation.
 	 */
 	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	if (is_interface_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
-	}
-
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
+	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
-	else if (type == IEEE80211_IF_TYPE_STA)
+	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
-	else if (is_monitor_present(&rt2x00dev->interface) &&
-		 !is_interface_present(&rt2x00dev->interface))
+	else
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
-
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
@@ -1301,7 +1250,7 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				  struct data_desc *txd,
-				  struct data_entry_desc *desc,
+				  struct txdata_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
 				  unsigned int length,
 				  struct ieee80211_tx_control *control)
@@ -1429,8 +1378,8 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 	return rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_AGC) * 2 - offset;
 }
 
-static int rt73usb_fill_rxdone(struct data_entry *entry,
-			       int *signal, int *rssi, int *ofdm, int *size)
+static void rt73usb_fill_rxdone(struct data_entry *entry,
+			        struct rxdata_entry_desc *desc)
 {
 	struct data_desc *rxd = (struct data_desc *)entry->skb->data;
 	u32 word0;
@@ -1439,24 +1388,24 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
-		return -EINVAL;
+	desc->flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
+		desc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
 	/*
 	 * Obtain the status about this packet.
 	 */
-	*signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	*rssi = rt73usb_agc_to_rssi(entry->ring->rt2x00dev, word1);
-	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
-	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	desc->rssi = rt73usb_agc_to_rssi(entry->ring->rt2x00dev, word1);
+	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
 	/*
 	 * Pull the skb to clear the descriptor area.
 	 */
 	skb_pull(entry->skb, entry->ring->desc_size);
 
-	return 0;
+	return;
 }
 
 /*
@@ -1802,9 +1751,7 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_NO_PROBE_FILTERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
@@ -1878,11 +1825,9 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt73usb_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * USB devices require scheduled packet filter toggling
 	 * This device requires firmware
 	 */
 	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1895,6 +1840,83 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static void rt73usb_configure_filter(struct ieee80211_hw *hw,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     int mc_count,
+				     struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	u32 reg;
+
+	/*
+	 * Mask off any flags we are going to ignore from
+	 * the total_flags field.
+	 */
+	*total_flags &=
+	    FIF_ALLMULTI |
+	    FIF_FCSFAIL |
+	    FIF_PLCPFAIL |
+	    FIF_CONTROL |
+	    FIF_OTHER_BSS |
+	    FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Apply some rules to the filters:
+	 * - Some filters imply different filters to be set.
+	 * - Some things we can't filter out at all.
+	 * - Some filters are set based on interface type.
+	 */
+	if (mc_count)
+		*total_flags |= FIF_ALLMULTI;
+	if (changed_flags & FIF_OTHER_BSS ||
+	    changed_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+	if (is_interface_type(intf, IEEE80211_IF_TYPE_AP))
+		*total_flags |= FIF_PROMISC_IN_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (intf->filter == *total_flags)
+		return;
+	intf->filter = *total_flags;
+
+	/*
+	 * When in atomic context, reschedule and let rt2x00lib
+	 * call this function again.
+	 */
+	if (in_atomic()) {
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
+		return;
+	}
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
+			   !(*total_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
+			   !(*total_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
+			   !(*total_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
+			   !(*total_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
+			   !(*total_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static int rt73usb_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -1977,11 +1999,13 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.set_multicast_list	= rt2x00mac_set_multicast_list,
+	.configure_filter	= rt73usb_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.conf_tx		= rt2x00mac_conf_tx,
@@ -2012,7 +2036,6 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_mac_addr	= rt73usb_config_mac_addr,
 	.config_bssid		= rt73usb_config_bssid,
-	.config_packet_filter	= rt73usb_config_packet_filter,
 	.config_type		= rt73usb_config_type,
 	.config			= rt73usb_config,
 };
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 5d63a1a..f095151 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -290,7 +290,7 @@ struct hw_pairwise_ta_entry {
 #define TXRX_CSR0_DROP_TO_DS		FIELD32(0x00200000)
 #define TXRX_CSR0_DROP_VERSION_ERROR	FIELD32(0x00400000)
 #define TXRX_CSR0_DROP_MULTICAST	FIELD32(0x00800000)
-#define TXRX_CSR0_DROP_BORADCAST	FIELD32(0x01000000)
+#define TXRX_CSR0_DROP_BROADCAST	FIELD32(0x01000000)
 #define TXRX_CSR0_DROP_ACK_CTS		FIELD32(0x02000000)
 #define TXRX_CSR0_TX_WITHOUT_WAITING	FIELD32(0x04000000)
 
-- 
1.5.3.2

