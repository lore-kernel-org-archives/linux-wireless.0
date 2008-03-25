Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:21572 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYCYNOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 09:14:06 -0400
Received: by fk-out-0910.google.com with SMTP id 19so4155125fkr.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 06:14:04 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 2/2] rt2x00: Fix in_atomic() usage
Date: Tue, 25 Mar 2008 14:13:18 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200803251412.45853.IvDoorn@gmail.com>
In-Reply-To: <200803251412.45853.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803251413.18398.IvDoorn@gmail.com> (sfid-20080325_131411_259932_FE71BCA0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt73usb and rt2500usb used in_atomic to determine
if a configuration step should be rescheduled or not.
Since in_atomic() is not a valid method to determine
if sleeping is allowed we should fix the way this is handled
by adding a new flag to rt2x00.

In addition mark LED class support for the drivers broken
since that also uses the broken in_atomic() method but
so far no solution exists to have LED triggers work only
in scheduled context.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig        |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c    |   92 +++++++--------------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  101 ++++++++---------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  118 ++++++++-------------------
 drivers/net/wireless/rt2x00/rt2x00.h       |   11 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c |   10 +--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   57 +++++++++++++-
 drivers/net/wireless/rt2x00/rt61pci.c      |  105 ++++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.c      |  122 ++++++++-------------------
 9 files changed, 234 insertions(+), 386 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 4709c11..ad15495 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -134,7 +134,7 @@ config RT2500USB
 
 config RT2500USB_LEDS
 	bool "RT2500 leds support"
-	depends on RT2500USB
+	depends on RT2500USB && BROKEN
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -152,7 +152,7 @@ config RT73USB
 
 config RT73USB_LEDS
 	bool "RT73 leds support"
-	depends on RT73USB
+	depends on RT73USB && BROKEN
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index c58b1c0..a6e9c89 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -270,6 +270,31 @@ static void rt2400pci_led_brightness(struct led_classdev *led_cdev,
 /*
  * Configuration handlers.
  */
+static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int filter_flags)
+{
+	u32 reg;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * since there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
+			   !(filter_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
+			   !(filter_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				  struct rt2x00_intf *intf,
 				  struct rt2x00intf_conf *conf,
@@ -306,8 +331,8 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 					      conf->bssid, sizeof(conf->bssid));
 }
 
-static int rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
-				struct rt2x00lib_erp *erp)
+static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
+				 struct rt2x00lib_erp *erp)
 {
 	int preamble_mask;
 	u32 reg;
@@ -347,8 +372,6 @@ static int rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
 	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 110));
 	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
-
-	return 0;
 }
 
 static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
@@ -1397,64 +1420,6 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt2400pci_configure_filter(struct ieee80211_hw *hw,
-				       unsigned int changed_flags,
-				       unsigned int *total_flags,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Mask off any flags we are going to ignore from
-	 * the total_flags field.
-	 */
-	*total_flags &=
-	    FIF_ALLMULTI |
-	    FIF_FCSFAIL |
-	    FIF_PLCPFAIL |
-	    FIF_CONTROL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
-
-	/*
-	 * Apply some rules to the filters:
-	 * - Some filters imply different filters to be set.
-	 * - Some things we can't filter out at all.
-	 */
-	*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-
-	/*
-	 * Check if there is any work left for us.
-	 */
-	if (rt2x00dev->packet_filter == *total_flags)
-		return;
-	rt2x00dev->packet_filter = *total_flags;
-
-	/*
-	 * Start configuration steps.
-	 * Note that the version error will always be dropped
-	 * since there is no filter for it at this time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
-			   !(*total_flags & FIF_FCSFAIL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
-			   !(*total_flags & FIF_PLCPFAIL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static int rt2400pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1580,7 +1545,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.configure_filter	= rt2400pci_configure_filter,
+	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2400pci_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
@@ -1608,6 +1573,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
+	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
 	.config_erp		= rt2400pci_config_erp,
 	.config			= rt2400pci_config,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 9468dde..1bdb873 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -270,6 +270,35 @@ static void rt2500pci_led_brightness(struct led_classdev *led_cdev,
 /*
  * Configuration handlers.
  */
+static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int filter_flags)
+{
+	u32 reg;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
+			   !(filter_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
+			   !(filter_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
+			   !(filter_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, 0);
+	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				  struct rt2x00_intf *intf,
 				  struct rt2x00intf_conf *conf,
@@ -309,8 +338,8 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 					      conf->bssid, sizeof(conf->bssid));
 }
 
-static int rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
-				struct rt2x00lib_erp *erp)
+static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
+				 struct rt2x00lib_erp *erp)
 {
 	int preamble_mask;
 	u32 reg;
@@ -350,8 +379,6 @@ static int rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
 	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 110));
 	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
-
-	return 0;
 }
 
 static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
@@ -1731,69 +1758,6 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt2500pci_configure_filter(struct ieee80211_hw *hw,
-				       unsigned int changed_flags,
-				       unsigned int *total_flags,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Mask off any flags we are going to ignore from
-	 * the total_flags field.
-	 */
-	*total_flags &=
-	    FIF_ALLMULTI |
-	    FIF_FCSFAIL |
-	    FIF_PLCPFAIL |
-	    FIF_CONTROL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
-
-	/*
-	 * Apply some rules to the filters:
-	 * - Some filters imply different filters to be set.
-	 * - Some things we can't filter out at all.
-	 */
-	if (mc_count)
-		*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-
-	/*
-	 * Check if there is any work left for us.
-	 */
-	if (rt2x00dev->packet_filter == *total_flags)
-		return;
-	rt2x00dev->packet_filter = *total_flags;
-
-	/*
-	 * Start configuration steps.
-	 * Note that the version error will always be dropped
-	 * and broadcast frames will always be accepted since
-	 * there is no filter for it at this time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
-			   !(*total_flags & FIF_FCSFAIL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
-			   !(*total_flags & FIF_PLCPFAIL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
-	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
-			   !(*total_flags & FIF_ALLMULTI));
-	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, 0);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static int rt2500pci_set_retry_limit(struct ieee80211_hw *hw,
 				     u32 short_retry, u32 long_retry)
 {
@@ -1894,7 +1858,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.configure_filter	= rt2500pci_configure_filter,
+	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2500pci_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
@@ -1922,6 +1886,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
+	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
 	.config_erp		= rt2500pci_config_erp,
 	.config			= rt2500pci_config,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8959a68..f5c18f0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -316,6 +316,35 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 /*
  * Configuration handlers.
  */
+static void rt2500usb_config_filter(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int filter_flags)
+{
+	u16 reg;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC,
+			   !(filter_flags & FIF_FCSFAIL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL,
+			   !(filter_flags & FIF_PLCPFAIL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
+			   !(filter_flags & FIF_ALLMULTI));
+	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_BROADCAST, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
+}
+
 static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 				  struct rt2x00_intf *intf,
 				  struct rt2x00intf_conf *conf,
@@ -358,18 +387,11 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 					      (3 * sizeof(__le16)));
 }
 
-static int rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
-				struct rt2x00lib_erp *erp)
+static void rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
+				 struct rt2x00lib_erp *erp)
 {
 	u16 reg;
 
-	/*
-	 * When in atomic context, we should let rt2x00lib
-	 * try this configuration again later.
-	 */
-	if (in_atomic())
-		return -EAGAIN;
-
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR1, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR1_ACK_TIMEOUT, erp->ack_timeout);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR1, reg);
@@ -378,8 +400,6 @@ static int rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE,
 			   !!erp->short_preamble);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR10, reg);
-
-	return 0;
 }
 
 static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
@@ -1644,6 +1664,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1656,78 +1677,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt2500usb_configure_filter(struct ieee80211_hw *hw,
-				       unsigned int changed_flags,
-				       unsigned int *total_flags,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u16 reg;
-
-	/*
-	 * Mask off any flags we are going to ignore from
-	 * the total_flags field.
-	 */
-	*total_flags &=
-	    FIF_ALLMULTI |
-	    FIF_FCSFAIL |
-	    FIF_PLCPFAIL |
-	    FIF_CONTROL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
-
-	/*
-	 * Apply some rules to the filters:
-	 * - Some filters imply different filters to be set.
-	 * - Some things we can't filter out at all.
-	 */
-	if (mc_count)
-		*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-
-	/*
-	 * Check if there is any work left for us.
-	 */
-	if (rt2x00dev->packet_filter == *total_flags)
-		return;
-	rt2x00dev->packet_filter = *total_flags;
-
-	/*
-	 * When in atomic context, reschedule and let rt2x00lib
-	 * call this function again.
-	 */
-	if (in_atomic()) {
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
-		return;
-	}
-
-	/*
-	 * Start configuration steps.
-	 * Note that the version error will always be dropped
-	 * and broadcast frames will always be accepted since
-	 * there is no filter for it at this time.
-	 */
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC,
-			   !(*total_flags & FIF_FCSFAIL));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL,
-			   !(*total_flags & FIF_PLCPFAIL));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
-			   !(*total_flags & FIF_ALLMULTI));
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_BROADCAST, 0);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
-}
-
 static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 				   struct sk_buff *skb,
 				   struct ieee80211_tx_control *control)
@@ -1824,7 +1773,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.configure_filter	= rt2500usb_configure_filter,
+	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
@@ -1848,6 +1797,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
+	.config_filter		= rt2500usb_config_filter,
 	.config_intf		= rt2500usb_config_intf,
 	.config_erp		= rt2500usb_config_erp,
 	.config			= rt2500usb_config,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0a8505a..a9ff75b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -560,6 +560,8 @@ struct rt2x00lib_ops {
 	/*
 	 * Configuration handlers.
 	 */
+	void (*config_filter) (struct rt2x00_dev *rt2x00dev,
+			       const unsigned int filter_flags);
 	void (*config_intf) (struct rt2x00_dev *rt2x00dev,
 			     struct rt2x00_intf *intf,
 			     struct rt2x00intf_conf *conf,
@@ -568,8 +570,8 @@ struct rt2x00lib_ops {
 #define CONFIG_UPDATE_MAC		( 1 << 2 )
 #define CONFIG_UPDATE_BSSID		( 1 << 3 )
 
-	int (*config_erp) (struct rt2x00_dev *rt2x00dev,
-			   struct rt2x00lib_erp *erp);
+	void (*config_erp) (struct rt2x00_dev *rt2x00dev,
+			    struct rt2x00lib_erp *erp);
 	void (*config) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_conf *libconf,
 			const unsigned int flags);
@@ -624,6 +626,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_FIRMWARE,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
+	DRIVER_REQUIRE_SCHEDULED,
 
 	/*
 	 * Driver configuration
@@ -988,6 +991,10 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_if_conf *conf);
+void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
+				unsigned int changed_flags,
+				unsigned int *total_flags,
+				int mc_count, struct dev_addr_list *mc_list);
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats);
 int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 5e2d81a..a9930a0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -80,7 +80,6 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct ieee80211_bss_conf *bss_conf)
 {
 	struct rt2x00lib_erp erp;
-	int retval;
 
 	memset(&erp, 0, sizeof(erp));
 
@@ -101,14 +100,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 		erp.ack_consume_time += PREAMBLE;
 	}
 
-	retval = rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
-
-	if (retval) {
-		spin_lock(&intf->lock);
-		intf->delayed_flags |= DELAYED_CONFIG_ERP;
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
-		spin_unlock(&intf->lock);
-	}
+	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 0a11c27..17b6bb0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -380,6 +380,50 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config_interface);
 
+void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
+				unsigned int changed_flags,
+				unsigned int *total_flags,
+				int mc_count, struct dev_addr_list *mc_list)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Mask off any flags we are going to ignore
+	 * from the total_flags field.
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
+	 * - Multicast filter seems to kill broadcast traffic so never use it.
+	 */
+	*total_flags |= FIF_ALLMULTI;
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_PROMISC_IN_BSS)
+		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
+
+	/*
+	 * Check if there is any work left for us.
+	 */
+	if (rt2x00dev->packet_filter == *total_flags)
+		return;
+	rt2x00dev->packet_filter = *total_flags;
+
+	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
+	else
+		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
+
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats)
 {
@@ -419,6 +463,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
+	unsigned int delayed = 0;
 
 	/*
 	 * When the association status has changed we must reset the link
@@ -439,11 +484,19 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & BSS_CHANGED_ERP_PREAMBLE)
-		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
+			rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
+		else
+			delayed |= DELAYED_CONFIG_ERP;
+	}
 
 	spin_lock(&intf->lock);
 	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
+	if (delayed) {
+		intf->delayed_flags |= delayed;
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
+	}
 	spin_unlock(&intf->lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6e643c8..0d2e6f7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -321,6 +321,37 @@ static void rt61pci_led_brightness(struct led_classdev *led_cdev,
 /*
  * Configuration handlers.
  */
+static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
+				  const unsigned int filter_flags)
+{
+	u32 reg;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
+			   !(filter_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
+			   !(filter_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
+			   !(filter_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00_intf *intf,
 				struct rt2x00intf_conf *conf,
@@ -368,8 +399,8 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static int rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
-			      struct rt2x00lib_erp *erp)
+static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
+			       struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
@@ -381,8 +412,6 @@ static int rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
 			   !!erp->short_preamble);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
-
-	return 0;
 }
 
 static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
@@ -2284,71 +2313,6 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt61pci_configure_filter(struct ieee80211_hw *hw,
-				     unsigned int changed_flags,
-				     unsigned int *total_flags,
-				     int mc_count,
-				     struct dev_addr_list *mc_list)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Mask off any flags we are going to ignore from
-	 * the total_flags field.
-	 */
-	*total_flags &=
-	    FIF_ALLMULTI |
-	    FIF_FCSFAIL |
-	    FIF_PLCPFAIL |
-	    FIF_CONTROL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
-
-	/*
-	 * Apply some rules to the filters:
-	 * - Some filters imply different filters to be set.
-	 * - Some things we can't filter out at all.
-	 * - Multicast filter seems to kill broadcast traffic so never use it.
-	 */
-	*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-
-	/*
-	 * Check if there is any work left for us.
-	 */
-	if (rt2x00dev->packet_filter == *total_flags)
-		return;
-	rt2x00dev->packet_filter = *total_flags;
-
-	/*
-	 * Start configuration steps.
-	 * Note that the version error will always be dropped
-	 * and broadcast frames will always be accepted since
-	 * there is no filter for it at this time.
-	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
-			   !(*total_flags & FIF_FCSFAIL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
-			   !(*total_flags & FIF_PLCPFAIL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
-			   !(*total_flags & FIF_ALLMULTI));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static int rt61pci_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -2457,7 +2421,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.configure_filter	= rt61pci_configure_filter,
+	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt61pci_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
@@ -2487,6 +2451,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
+	.config_filter		= rt61pci_config_filter,
 	.config_intf		= rt61pci_config_intf,
 	.config_erp		= rt61pci_config_erp,
 	.config			= rt61pci_config,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 83f8287..b3c8462 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -333,6 +333,37 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 /*
  * Configuration handlers.
  */
+static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
+				  const unsigned int filter_flags)
+{
+	u32 reg;
+
+	/*
+	 * Start configuration steps.
+	 * Note that the version error will always be dropped
+	 * and broadcast frames will always be accepted since
+	 * there is no filter for it at this time.
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
+			   !(filter_flags & FIF_FCSFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
+			   !(filter_flags & FIF_PLCPFAIL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
+			   !(filter_flags & FIF_PROMISC_IN_BSS));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
+			   !(filter_flags & FIF_ALLMULTI));
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
+			   !(filter_flags & FIF_CONTROL));
+	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00_intf *intf,
 				struct rt2x00intf_conf *conf,
@@ -380,18 +411,11 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static int rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
-			      struct rt2x00lib_erp *erp)
+static void rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
+			       struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
-	/*
-	 * When in atomic context, we should let rt2x00lib
-	 * try this configuration again later.
-	 */
-	if (in_atomic())
-		return -EAGAIN;
-
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, erp->ack_timeout);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
@@ -400,8 +424,6 @@ static int rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
 			   !!erp->short_preamble);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR4, reg);
-
-	return 0;
 }
 
 static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
@@ -1872,6 +1894,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1884,80 +1907,6 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt73usb_configure_filter(struct ieee80211_hw *hw,
-				     unsigned int changed_flags,
-				     unsigned int *total_flags,
-				     int mc_count,
-				     struct dev_addr_list *mc_list)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-
-	/*
-	 * Mask off any flags we are going to ignore from
-	 * the total_flags field.
-	 */
-	*total_flags &=
-	    FIF_ALLMULTI |
-	    FIF_FCSFAIL |
-	    FIF_PLCPFAIL |
-	    FIF_CONTROL |
-	    FIF_OTHER_BSS |
-	    FIF_PROMISC_IN_BSS;
-
-	/*
-	 * Apply some rules to the filters:
-	 * - Some filters imply different filters to be set.
-	 * - Some things we can't filter out at all.
-	 * - Multicast filter seems to kill broadcast traffic so never use it.
-	 */
-	*total_flags |= FIF_ALLMULTI;
-	if (*total_flags & FIF_OTHER_BSS ||
-	    *total_flags & FIF_PROMISC_IN_BSS)
-		*total_flags |= FIF_PROMISC_IN_BSS | FIF_OTHER_BSS;
-
-	/*
-	 * Check if there is any work left for us.
-	 */
-	if (rt2x00dev->packet_filter == *total_flags)
-		return;
-	rt2x00dev->packet_filter = *total_flags;
-
-	/*
-	 * When in atomic context, reschedule and let rt2x00lib
-	 * call this function again.
-	 */
-	if (in_atomic()) {
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
-		return;
-	}
-
-	/*
-	 * Start configuration steps.
-	 * Note that the version error will always be dropped
-	 * and broadcast frames will always be accepted since
-	 * there is no filter for it at this time.
-	 */
-	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
-			   !(*total_flags & FIF_FCSFAIL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
-			   !(*total_flags & FIF_PLCPFAIL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
-			   !(*total_flags & FIF_CONTROL));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
-			   !(*total_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
-			   !(*total_flags & FIF_ALLMULTI));
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
-			   !(*total_flags & FIF_CONTROL));
-	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static int rt73usb_set_retry_limit(struct ieee80211_hw *hw,
 				   u32 short_retry, u32 long_retry)
 {
@@ -2067,7 +2016,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
-	.configure_filter	= rt73usb_configure_filter,
+	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
@@ -2096,6 +2045,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
+	.config_filter		= rt73usb_config_filter,
 	.config_intf		= rt73usb_config_intf,
 	.config_erp		= rt73usb_config_erp,
 	.config			= rt73usb_config,
-- 
1.5.4.4

