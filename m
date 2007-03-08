Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:9792 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbXCHVPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 16:15:05 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1088710uga
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 13:14:59 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4] rt2x00: multiread/multiwrite should accept void*
Date: Thu, 8 Mar 2007 22:14:46 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703082214.46398.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will make rt2x00_register_multiread/multiwrite
accept void* pointers. This could prevent possible byte
ordering issues during unneeded casts. Since we are
at it anyway also cleanup those casts. ;)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 93da031..ff5d67a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -68,7 +68,7 @@ static inline void rt2x00_register_read(
 
 static inline void rt2x00_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr_addr + offset, length);
 }
@@ -82,7 +82,7 @@ static inline void rt2x00_register_write(
 
 static inline void rt2x00_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	memcpy_toio(rt2x00dev->csr_addr + offset, value, length);
 }
@@ -206,19 +206,19 @@ static void rt2400pci_write_csr(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+	rt2x00_eeprom_read(rt2x00dev, word, data);
 }
 
 static void rt2400pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
 }
 
 static void rt2400pci_read_bbp(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+	rt2x00_bbp_read(rt2x00dev, word, data);
 }
 
 static void rt2400pci_write_bbp(struct rt2x00_dev *rt2x00dev,
@@ -276,7 +276,7 @@ static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, bssid, ETH_ALEN);
 }
 
 static void rt2400pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -631,7 +631,7 @@ static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, (u32*)addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 1e659aa..7a1d924 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -68,7 +68,7 @@ static inline void rt2x00_register_read(
 
 static inline void rt2x00_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr_addr + offset, length);
 }
@@ -82,7 +82,7 @@ static inline void rt2x00_register_write(
 
 static inline void rt2x00_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	memcpy_toio(rt2x00dev->csr_addr + offset, value, length);
 }
@@ -206,19 +206,19 @@ static void rt2500pci_write_csr(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+	rt2x00_eeprom_read(rt2x00dev, word, data);
 }
 
 static void rt2500pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
 }
 
 static void rt2500pci_read_bbp(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+	rt2x00_bbp_read(rt2x00dev, word, data);
 }
 
 static void rt2500pci_write_bbp(struct rt2x00_dev *rt2x00dev,
@@ -276,7 +276,7 @@ static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, bssid, ETH_ALEN);
 }
 
 static void rt2500pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -706,7 +706,7 @@ static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, (u32*)addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index b9eda8d..82d5d1b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -95,7 +95,7 @@ static inline void rt2x00_register_read(
 
 static inline void rt2x00_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u16 *value, const u16 length)
+	const u16 offset, void *value, const u16 length)
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
@@ -115,7 +115,7 @@ static inline void rt2x00_register_write(
 
 static inline void rt2x00_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u16 *value, const u16 length)
+	const u16 offset, void *value, const u16 length)
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
@@ -248,19 +248,19 @@ static void rt2500usb_write_csr(struct rt2x00_dev *rt2x00dev,
 static void rt2500usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+	rt2x00_eeprom_read(rt2x00dev, word, data);
 }
 
 static void rt2500usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
 }
 
 static void rt2500usb_read_bbp(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+	rt2x00_bbp_read(rt2x00dev, word, data);
 }
 
 static void rt2500usb_write_bbp(struct rt2x00_dev *rt2x00dev,
@@ -318,7 +318,7 @@ static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, (u16*)bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, bssid, ETH_ALEN);
 }
 
 static void rt2500usb_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -714,7 +714,7 @@ static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u16*)addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 21278c6..2de9201 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -71,7 +71,7 @@ static inline void rt2x00_register_read(
 
 static inline void rt2x00_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	readl(rt2x00dev->csr_addr + MAC_CSR0);
 	memcpy_fromio(value, rt2x00dev->csr_addr + offset, length);
@@ -87,7 +87,7 @@ static inline void rt2x00_register_write(
 
 static inline void rt2x00_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const unsigned long offset, u32 *value, const u16 length)
+	const unsigned long offset, void *value, const u16 length)
 {
 	readl(rt2x00dev->csr_addr + MAC_CSR0);
 	memcpy_toio(rt2x00dev->csr_addr + offset, value, length);
@@ -237,19 +237,19 @@ static void rt61pci_write_csr(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+	rt2x00_eeprom_read(rt2x00dev, word, data);
 }
 
 static void rt61pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
 }
 
 static void rt61pci_read_bbp(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+	rt2x00_bbp_read(rt2x00dev, word, data);
 }
 
 static void rt61pci_write_bbp(struct rt2x00_dev *rt2x00dev,
@@ -310,7 +310,7 @@ static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	 * that array is little endian, so no need for byte ordering.
 	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, (u32*)bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, bssid, ETH_ALEN);
 
 	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
@@ -927,7 +927,7 @@ static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
 	 * at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u32*)addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
 
 	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
@@ -2960,7 +2960,7 @@ static void rt61pci_load_firmware(const struct firmware *fw, void *context)
 	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
 
 	rt2x00_register_multiwrite(
-		rt2x00dev, FIRMWARE_IMAGE_BASE, (u32*)fw->data, fw->size);
+		rt2x00dev, FIRMWARE_IMAGE_BASE, fw->data, fw->size);
 
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 0);
 	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 9ede5fa..5a187e6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -97,7 +97,7 @@ static inline void rt2x00_register_read(
 
 static inline void rt2x00_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u32 *value, const u32 length)
+	const u16 offset, void *value, const u32 length)
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
@@ -117,7 +117,7 @@ static inline void rt2x00_register_write(
 
 static inline void rt2x00_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u32 *value, const u32 length)
+	const u16 offset, void *value, const u32 length)
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
@@ -244,19 +244,19 @@ static void rt73usb_write_csr(struct rt2x00_dev *rt2x00dev,
 static void rt73usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+	rt2x00_eeprom_read(rt2x00dev, word, data);
 }
 
 static void rt73usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
 }
 
 static void rt73usb_read_bbp(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data)
 {
-	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+	rt2x00_bbp_read(rt2x00dev, word, data);
 }
 
 static void rt73usb_write_bbp(struct rt2x00_dev *rt2x00dev,
@@ -317,7 +317,7 @@ static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	 * that array is little endian, so no need for byte ordering.
 	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, (u32*)bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, bssid, ETH_ALEN);
 
 	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
@@ -822,7 +822,7 @@ static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
 	 * at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u32*)addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
 
 	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
