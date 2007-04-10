Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:54073 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030724AbXDJWkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 18:40:42 -0400
Received: by ug-out-1314.google.com with SMTP id 44so166508uga
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2007 15:40:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull from "upstream" branch of rt2x00
Date: Wed, 11 Apr 2007 00:39:48 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704110039.49042.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

It took some time, but thanks to your and Jiri's help on IRC
rt2x00 finally has a rt2x00 tree. :)

Please pull from  http://git.serialmonkey.com/rt2x00.git/ upstream
to get some important fixes. This will get PCI and USB devices back
into a somewhat more usefull state.

Ivo

---

The following changes since commit f4e2dd4a8b9ff1d14c3fffc36d578d12f8cb8da3:
  John W. Linville (1):
        wext-old: fixup copyright info

are found in the git repository at:

  http://git.serialmonkey.com/rt2x00.git/ upstream

Ivo van Doorn (8):
      Don't use magical values for the length with rt2x00_vendor_request,
      Make rt2x00 debugfs support depend on mac80211 support.
      rt2x00: rt2x00_register_multiwrite should use correct length
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      rt2x00: Use correct length in descriptor
      rt2x00: new USB ID for rt73usb
      rt2x00: Correctly enable the radio
      Merge with http://git.serialmonkey.com/rt2x00.git

 drivers/net/wireless/mac80211/rt2x00/Kconfig     |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c |   17 ++++++++--
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |   17 ++++++++--
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |   21 +++++++++----
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |   32 +++++++++----------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |   36 +++++++++++-----------
 7 files changed, 76 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 0528431..31541ed 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -73,7 +73,7 @@ config RT73USB
 
 config RT2X00_DEBUGFS
 	tristate "Ralink debugfs support"
-	depends on RT2X00 && RT2X00_LIB && DEBUG_FS
+	depends on RT2X00 && RT2X00_LIB && MAC80211_DEBUGFS
 	---help---
 	Enable creation of debugfs files for the rt2x00 drivers.
 	These debugfs files support both reading and writing of the
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index f8a9867..4b1afb9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -272,11 +272,16 @@ static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, bssid, ETH_ALEN);
+
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
 static void rt2400pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -627,11 +632,16 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 
 static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, addr, ETH_ALEN);
+
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, &reg, sizeof(reg));
 }
 
 /*
@@ -1228,8 +1238,7 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice.
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index bddbbf9..b052220 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -272,11 +272,16 @@ static inline void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, bssid, ETH_ALEN);
+
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
 }
 
 static void rt2500pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -702,11 +707,16 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 
 static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, addr, ETH_ALEN);
+
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, &reg, sizeof(reg));
 }
 
 /*
@@ -1354,8 +1364,7 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice,
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 187076d..e023711 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -89,7 +89,7 @@ static inline void rt2x00_register_read(
 	__le16 reg;
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
-		offset, 0x00, &reg, 2, REGISTER_TIMEOUT);
+		offset, 0x00, &reg, sizeof(u16), REGISTER_TIMEOUT);
 	*value = le16_to_cpu(reg);
 }
 
@@ -110,7 +110,7 @@ static inline void rt2x00_register_write(
 	__le16 reg = cpu_to_le16(value);
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
-		offset, 0x00, &reg, 2, REGISTER_TIMEOUT);
+		offset, 0x00, &reg, sizeof(u16), REGISTER_TIMEOUT);
 }
 
 static inline void rt2x00_register_multiwrite(
@@ -314,11 +314,16 @@ static inline void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
+	u16 reg[3];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, bssid, ETH_ALEN);
+
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, bssid, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, &reg, sizeof(reg));
 }
 
 static void rt2500usb_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -710,11 +715,16 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 
 static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
+	u16 reg[3];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, addr, ETH_ALEN);
+
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
 }
 
 /*
@@ -1555,8 +1565,7 @@ static int rt2500usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
 	txd = (struct data_desc*)skb->data;
-	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
+	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index cea6bb1..38fae66 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -777,7 +777,7 @@ struct rt2x00_dev {
 	 */
 	unsigned int flags;
 #define DEVICE_ENABLED_RADIO		0x00000001
-#define DEVICE_ENABLED_RADIO_HW		0x00000002
+
 #define DEVICE_INITIALIZED		0x00000004
 #define DEVICE_INITIALIZED_HW		0x00000008
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 9cee93f..d2ee3f5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -303,18 +303,18 @@ static inline void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg;
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, bssid, ETH_ALEN);
+
+	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
-	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, bssid, ETH_ALEN);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
-	rt2x00_register_write(rt2x00dev, MAC_CSR5, reg);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
 static void rt61pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -919,19 +919,18 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 
 static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg;
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, addr, ETH_ALEN);
+
+	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
-	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
-	 * at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	rt2x00_register_write(rt2x00dev, MAC_CSR3, reg);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
 }
 
 /*
@@ -1635,8 +1634,7 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice.
 	 * or if the hardware button has been disabled.
 	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
-	    !GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO_HW))
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 9c9fbce..837ceb1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -91,7 +91,7 @@ static inline void rt2x00_register_read(
 	__le32 reg;
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
-		offset, 0x00, &reg, 4, REGISTER_TIMEOUT);
+		offset, 0x00, &reg, sizeof(u32), REGISTER_TIMEOUT);
 	*value = le32_to_cpu(reg);
 }
 
@@ -112,7 +112,7 @@ static inline void rt2x00_register_write(
 	__le32 reg = cpu_to_le32(value);
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
-		offset, 0x00, &reg, 4, REGISTER_TIMEOUT);
+		offset, 0x00, &reg, sizeof(u32), REGISTER_TIMEOUT);
 }
 
 static inline void rt2x00_register_multiwrite(
@@ -310,18 +310,18 @@ static inline void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg;
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, bssid, ETH_ALEN);
+
+	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
-	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, bssid, ETH_ALEN);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
-	rt2x00_register_write(rt2x00dev, MAC_CSR5, reg);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
 }
 
 static void rt73usb_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -814,19 +814,18 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 
 static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg;
+	u32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
+	memcpy(&reg, addr, ETH_ALEN);
+
+	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
-	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
-	 * at the correct offset.
 	 */
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, addr, ETH_ALEN);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	rt2x00_register_write(rt2x00dev, MAC_CSR3, reg);
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
 }
 
 /*
@@ -1714,7 +1713,7 @@ static int rt73usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
 	txd = (struct data_desc*)skb->data;
-	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, skb->len, control);
+	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
@@ -2938,6 +2937,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x1690, 0x0722) },
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1723) },
+	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x7050) },
 	{ USB_DEVICE(0x050d, 0x705a) },
