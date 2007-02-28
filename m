Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXB1OHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:22 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:22 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/28] rt2x00: optimize mac/bssid writing
Date: Wed, 28 Feb 2007 15:07:11 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.11726.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handling the mac and bssid configuration can be done much easier
by writing the passed data directly into the register instead
of moving it to a local variable first.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 27e151d..b6bf9f3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -319,14 +319,11 @@ static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2] = { 0, 0 };
-
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, bssid, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
 }
 
 static void rt2400pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -674,14 +671,11 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	void *addr)
 {
-	u32 reg[2] = { 0, 0 };
-
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, addr, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, (u32*)addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 6234d20..69ada0e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -319,14 +319,11 @@ static inline void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2] = { 0, 0 };
-
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, bssid, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
 }
 
 static void rt2500pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -749,14 +746,11 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	void *addr)
 {
-	u32 reg[2] = { 0, 0 };
-
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, addr, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, CSR3, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, CSR3, (u32*)addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index c8c0f5a..86c06ac 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -373,14 +373,11 @@ static inline void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u16 reg[3] = { 0, 0, 0 };
-
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, bssid, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR5, (u16*)bssid, ETH_ALEN);
 }
 
 static void rt2500usb_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -781,14 +778,11 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 static void rt2500usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	void *addr)
 {
-	u16 reg[3] = { 0, 0, 0 };
-
 	/*
 	 * The MAC address is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 */
-	memcpy(&reg, addr, ETH_ALEN);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u16*)addr, ETH_ALEN);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 4224a57..2f7d18e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -351,16 +351,18 @@ static inline void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2] = { 0, 0 };
+	u32 reg;
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	memcpy(&reg, bssid, ETH_ALEN);
-	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, (u32*)bssid, ETH_ALEN);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
+	rt2x00_register_write(rt2x00dev, MAC_CSR5, reg);
 }
 
 static void rt61pci_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -970,7 +972,7 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	void *addr)
 {
-	u32 reg[2] = { 0, 0 };
+	u32 reg;
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -978,9 +980,11 @@ static void rt61pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
 	 * at the correct offset.
 	 */
-	memcpy(&reg, addr, ETH_ALEN);
-	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u32*)addr, ETH_ALEN);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	rt2x00_register_write(rt2x00dev, MAC_CSR3, reg);
 }
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index ef16d82..f0fff49 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -358,16 +358,18 @@ static inline void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
  */
 static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2] = { 0, 0 };
+	u32 reg;
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
 	 * that array is little endian, so no need for byte ordering.
 	 * We only need to set the BSS ID MASK at the correct offset.
 	 */
-	memcpy(&reg, bssid, ETH_ALEN);
-	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR4, (u32*)bssid, ETH_ALEN);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR5, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
+	rt2x00_register_write(rt2x00dev, MAC_CSR5, reg);
 }
 
 static void rt73usb_config_promisc(struct rt2x00_dev *rt2x00dev, int promisc)
@@ -868,7 +870,7 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 static void rt73usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	void *addr)
 {
-	u32 reg[2] = { 0, 0 };
+	u32 reg;
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -876,9 +878,11 @@ static void rt73usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
 	 * We only need to set the MAC_CSR3_UNICAST_TO_ME_MASK
 	 * at the correct offset.
 	 */
-	memcpy(&reg, addr, ETH_ALEN);
-	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, &reg[0], sizeof(reg));
+	rt2x00_register_multiwrite(rt2x00dev, MAC_CSR2, (u32*)addr, ETH_ALEN);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR3, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	rt2x00_register_write(rt2x00dev, MAC_CSR3, reg);
 }
 
 /*
