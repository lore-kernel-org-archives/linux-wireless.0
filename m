Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJFMDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:03:52 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:03:51 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/16] rt2x00: Remove duplicate code in MAC & BSSID handling
Date: Sat, 6 Oct 2007 14:11:46 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061411.46547.IvDoorn@gmail.com> (sfid-20071006_130400_576796_401BACA0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The various drivers contained duplicate code to handle the
MAC and BSSID initialization correctly. This moves the
address copy to little endian variables to rt2x00config.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   30 ++++++------------------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   30 ++++++------------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   30 ++++++------------------
 drivers/net/wireless/rt2x00/rt2x00.h       |    4 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |   32 ++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt61pci.c      |   34 ++++++++-------------------
 drivers/net/wireless/rt2x00/rt73usb.c      |   34 ++++++++-------------------
 7 files changed, 76 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4f28662..84f807d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -249,32 +249,18 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 /*
  * Configuration handlers.
  */
-static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
+static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev,
+				      __le32 *mac)
 {
-	__le32 reg[2];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, addr, ETH_ALEN);
-
-	/*
-	 * The MAC address is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, CSR3, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, CSR3, mac,
+				      (2 * sizeof(__le32)));
 }
 
-static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
+static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev,
+				   __le32 *bssid)
 {
-	__le32 reg[2];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, bssid, ETH_ALEN);
-
-	/*
-	 * The BSSID is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, bssid,
+				      (2 * sizeof(__le32)));
 }
 
 static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c0cd60a..87a0988 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -249,32 +249,18 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 /*
  * Configuration handlers.
  */
-static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
+static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev,
+				      __le32 *mac)
 {
-	__le32 reg[2];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, addr, ETH_ALEN);
-
-	/*
-	 * The MAC address is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, CSR3, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, CSR3, mac,
+				      (2 * sizeof(__le32)));
 }
 
-static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
+static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev,
+				   __le32 *bssid)
 {
-	__le32 reg[2];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, bssid, ETH_ALEN);
-
-	/*
-	 * The BSSID is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, CSR5, bssid,
+				      (2 * sizeof(__le32)));
 }
 
 static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index e082961..e24ffe6 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -254,32 +254,18 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 /*
  * Configuration handlers.
  */
-static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
+static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev,
+				      __le32 *mac)
 {
-	__le16 reg[3];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, addr, ETH_ALEN);
-
-	/*
-	 * The MAC address is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
+	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR2, &mac,
+				      (3 * sizeof(__le16)));
 }
 
-static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
+static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev,
+				   __le32 *bssid)
 {
-	__le16 reg[3];
-
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, bssid, ETH_ALEN);
-
-	/*
-	 * The BSSID is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR5, &reg, sizeof(reg));
+	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR5, bssid,
+				      (3 * sizeof(__le16)));
 }
 
 static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6262d4e..5d30ca6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -408,8 +408,8 @@ struct rt2x00lib_ops {
 	/*
 	 * Configuration handlers.
 	 */
-	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, u8 *mac);
-	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, u8 *bssid);
+	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, __le32 *mac);
+	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, __le32 *bssid);
 	void (*config_packet_filter) (struct rt2x00_dev *rt2x00dev,
 				      const unsigned int filter);
 	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type);
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 13b5106..aeeaa0c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -34,16 +34,44 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+
+/*
+ * The MAC and BSSID addressess are simple array of bytes,
+ * these arrays are little endian, so when sending the addressess
+ * to the drivers, copy the it into a endian-signed variable.
+ *
+ * Note that all devices (except rt2500usb) have 32 bits
+ * register word sizes. This means that whatever variable we
+ * pass _must_ be a multiple of 32 bits. Otherwise the device
+ * might not accept what we are sending to it.
+ * This will also make it easier for the driver to write
+ * the data to the device.
+ *
+ * Also note that when NULL is passed as address the
+ * we will send 00:00:00:00:00 to the device to clear the address.
+ * This will prevent the device being confused when it wants
+ * to ACK frames or consideres itself associated.
+ */
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac)
 {
+	__le32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
 	if (mac)
-		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, mac);
+		memcpy(&reg, mac, ETH_ALEN);
+
+	rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, &reg[0]);
 }
 
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
+	__le32 reg[2];
+
+	memset(&reg, 0, sizeof(reg));
 	if (bssid)
-		rt2x00dev->ops->lib->config_bssid(rt2x00dev, bssid);
+		memcpy(&reg, bssid, ETH_ALEN);
+
+	rt2x00dev->ops->lib->config_bssid(rt2x00dev, &reg[0]);
 }
 
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 960af18..2157764 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -274,42 +274,28 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 /*
  * Configuration handlers.
  */
-static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
+static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, __le32 *mac)
 {
-	__le32 reg[2];
 	u32 tmp;
 
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, addr, ETH_ALEN);
-
-	tmp = le32_to_cpu(reg[1]);
+	tmp = le32_to_cpu(mac[1]);
 	rt2x00_set_field32(&tmp, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	reg[1] = cpu_to_le32(tmp);
+	mac[1] = cpu_to_le32(tmp);
 
-	/*
-	 * The MAC address is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR2, mac,
+				      (2 * sizeof(__le32)));
 }
 
-static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
+static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, __le32 *bssid)
 {
-	__le32 reg[2];
 	u32 tmp;
 
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, bssid, ETH_ALEN);
-
-	tmp = le32_to_cpu(reg[1]);
+	tmp = le32_to_cpu(bssid[1]);
 	rt2x00_set_field32(&tmp, MAC_CSR5_BSS_ID_MASK, 3);
-	reg[1] = cpu_to_le32(tmp);
+	bssid[1] = cpu_to_le32(tmp);
 
-	/*
-	 * The BSSID is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
+	rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR4, bssid,
+				      (2 * sizeof(__le32)));
 }
 
 static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7640136..b81ba3d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -255,42 +255,28 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 /*
  * Configuration handlers.
  */
-static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
+static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, __le32 *mac)
 {
-	__le32 reg[2];
 	u32 tmp;
 
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, addr, ETH_ALEN);
-
-	tmp = le32_to_cpu(reg[1]);
+	tmp = le32_to_cpu(mac[1]);
 	rt2x00_set_field32(&tmp, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
-	reg[1] = cpu_to_le32(tmp);
+	mac[1] = cpu_to_le32(tmp);
 
-	/*
-	 * The MAC address is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR2, &reg, sizeof(reg));
+	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR2, mac,
+				    (2 * sizeof(__le32)));
 }
 
-static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
+static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, __le32 *bssid)
 {
-	__le32 reg[2];
 	u32 tmp;
 
-	memset(&reg, 0, sizeof(reg));
-	memcpy(&reg, bssid, ETH_ALEN);
-
-	tmp = le32_to_cpu(reg[1]);
+	tmp = le32_to_cpu(bssid[1]);
 	rt2x00_set_field32(&tmp, MAC_CSR5_BSS_ID_MASK, 3);
-	reg[1] = cpu_to_le32(tmp);
+	bssid[1] = cpu_to_le32(tmp);
 
-	/*
-	 * The BSSID is passed to us as an array of bytes,
-	 * that array is little endian, so no need for byte ordering.
-	 */
-	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR4, &reg, sizeof(reg));
+	rt73usb_register_multiwrite(rt2x00dev, MAC_CSR4, bssid,
+				    (2 * sizeof(__le32)));
 }
 
 static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
-- 
1.5.3.4

