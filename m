Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33491 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755524AbcHYIT3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 04:19:29 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so6298104wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 01:19:29 -0700 (PDT)
Received: from desktop.wvd.kresin.me (p200300454B4D5C0058F68CFDF8018812.dip0.t-ipconnect.de. [2003:45:4b4d:5c00:58f6:8cfd:f801:8812])
        by smtp.gmail.com with ESMTPSA id g184sm37649155wme.15.2016.08.25.01.19.27
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Aug 2016 01:19:27 -0700 (PDT)
From: Mathias Kresin <dev@kresin.me>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: add support for mac addr from device tree
Date: Thu, 25 Aug 2016 10:19:22 +0200
Message-Id: <1472113162-26915-1-git-send-email-dev@kresin.me> (sfid-20160825_102220_356390_AF26662D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The EEPROM used on some CPEs has for every device the same generic
ralink mac in EEPROM and needs to be overridden.

Signed-off-by: Mathias Kresin <dev@kresin.me>
---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c |  5 +----
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c |  5 +----
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c |  5 +----
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  5 +----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 17 +++++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt61pci.c   |  5 +----
 drivers/net/wireless/ralink/rt2x00/rt73usb.c   |  5 +----
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 155f343..085c5b4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1459,10 +1459,7 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 2553cdd..9832fd5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1585,10 +1585,7 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index 2d64611..cd3ab5a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -1349,10 +1349,7 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index bf3f0a3..59c49af 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6919,10 +6919,7 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2800_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &word);
 	if (word == 0xffff) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index f68d492..aa3d4cee 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1403,6 +1403,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
  */
 u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
 			 struct ieee80211_vif *vif);
+void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr);
 
 /*
  * Interrupt context handlers.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4e0c565..d659250 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -26,6 +26,8 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
@@ -931,6 +933,21 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 		entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
 }
 
+void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr)
+{
+	const char *mac_addr;
+
+	mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);
+	if (mac_addr)
+		ether_addr_copy(eeprom_mac_addr, mac_addr);
+
+	if (!is_valid_ether_addr(eeprom_mac_addr)) {
+		eth_random_addr(eeprom_mac_addr);
+		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", eeprom_mac_addr);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_set_mac_address);
+
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 				    struct hw_mode_spec *spec)
 {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 03013eb..5306a3b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2413,10 +2413,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index c1397a6..1a29c4d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -1766,10 +1766,7 @@ static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Start validation of the data that has been read.
 	 */
 	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
-	if (!is_valid_ether_addr(mac)) {
-		eth_random_addr(mac);
-		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
-	}
+	rt2x00lib_set_mac_address(rt2x00dev, mac);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &word);
 	if (word == 0xffff) {
-- 
2.7.4
