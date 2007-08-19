Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXHSSaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:23 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:21 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/30] rt2x00: Correctly configure packet filter in monitor mode
Date: Sun, 19 Aug 2007 20:21:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192021.12839.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From a065c6ce407b30a02777761794e77ee6cfa8663e Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:50:42 +0200
Subject: [PATCH 01/30] rt2x00: Correctly configure packet filter in monitor mode

If there is a non-monitor interface present
the packet should be strict (even if a monitor interface is present!).
When there is only 1 interface present which is in monitor mode
we should start accepting _all_ frames.
This also means there is no special packet filtering in monitor mode,
so don't check for monitor mode in the set_multicast_list handler.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c    |   19 +++++++++++++------
 drivers/net/wireless/rt2500pci.c    |   19 +++++++++++++------
 drivers/net/wireless/rt2500usb.c    |   19 +++++++++++++------
 drivers/net/wireless/rt2x00config.c |   12 ------------
 drivers/net/wireless/rt2x00mac.c    |    6 ------
 drivers/net/wireless/rt61pci.c      |   21 ++++++++++++++-------
 drivers/net/wireless/rt73usb.c      |   21 ++++++++++++++-------
 7 files changed, 67 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 757d749..d97fa31 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -305,15 +305,22 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 	else
 		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 0);
 
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
-	if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
-	} else {
+	/*
+	 * If there is a non-monitor interface present
+	 * the packet should be strict (even if a monitor interface is present!).
+	 * When there is only 1 interface present which is in monitor mode
+	 * we should start accepting _all_ frames.
+	 */
+	if (is_interface_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	} else if (is_monitor_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
 	}
 
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index dd98aa4..0a0fa22 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -309,15 +309,22 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	else
 		rt2x00_set_field32(&reg, RXCSR0_DROP_TODS, 0);
 
-	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
-	if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
-	} else {
+	/*
+	 * If there is a non-monitor interface present
+	 * the packet should be strict (even if a monitor interface is present!).
+	 * When there is only 1 interface present which is in monitor mode
+	 * we should start accepting _all_ frames.
+	 */
+	if (is_interface_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 1);
 		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
+	} else if (is_monitor_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CRC, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL, 0);
+		rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 0);
 	}
 
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index e09fb9f..ad400dd 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -314,15 +314,22 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	else
 		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS, 0);
 
-	rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC, 1);
-	if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 0);
-	} else {
+	/*
+	 * If there is a non-monitor interface present
+	 * the packet should be strict (even if a monitor interface is present!).
+	 * When there is only 1 interface present which is in monitor mode
+	 * we should start accepting _all_ frames.
+	 */
+	if (is_interface_present(&rt2x00dev->interface)) {
+		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
+	} else if (is_monitor_present(&rt2x00dev->interface)) {
+		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CRC, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_PHYSICAL, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 0);
 	}
 
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
diff --git a/drivers/net/wireless/rt2x00config.c b/drivers/net/wireless/rt2x00config.c
index 11d5646..4fec0af 100644
--- a/drivers/net/wireless/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00config.c
@@ -48,18 +48,6 @@ void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 
 void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter)
 {
-	struct interface *intf = &rt2x00dev->interface;
-
-	/*
-	 * When a monitor interface is present,
-	 * we should force enable all modes.
-	 */
-	if (is_monitor_present(intf)) {
-		filter = IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
-		if (intf->filter != filter)
-			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
-	}
-
 	/*
 	 * Only configure the device when something has changed,
 	 * or if we are in RESET state in which case all configuration
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index 205f10f..c384767 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -333,12 +333,6 @@ void rt2x00mac_set_multicast_list(struct ieee80211_hw *hw,
 	rt2x00dev->interface.filter = flags;
 
 	/*
-	 * No filtering in monitor mode.
-	 */
-	if (is_monitor_present(&rt2x00dev->interface))
-		return;
-
-	/*
 	 * Raise the pending bit to indicate the
 	 * packet filter should be updated.
 	 */
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 00f66e0..7f3a00b 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -338,17 +338,24 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	else
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 0);
 
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
-	if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
-	} else {
+	/*
+	 * If there is a non-monitor interface present
+	 * the packet should be strict (even if a monitor interface is present!).
+	 * When there is only 1 interface present which is in monitor mode
+	 * we should start accepting _all_ frames.
+	 */
+	if (is_interface_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	} else if (is_monitor_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
 	}
 
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 2f0bf29..90e2b29 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -313,17 +313,24 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	else
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS, 0);
 
-	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
-	if (is_monitor_present(&rt2x00dev->interface)) {
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
-	} else {
+	/*
+	 * If there is a non-monitor interface present
+	 * the packet should be strict (even if a monitor interface is present!).
+	 * When there is only 1 interface present which is in monitor mode
+	 * we should start accepting _all_ frames.
+	 */
+	if (is_interface_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 1);
+	} else if (is_monitor_present(&rt2x00dev->interface)) {
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
 	}
 
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-- 
1.5.3.rc5

