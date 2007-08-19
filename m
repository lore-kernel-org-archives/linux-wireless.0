Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXHSSbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:41 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/30] rt2x00: Add byte-ordering annotation for MAC and BSSID
Date: Sun, 19 Aug 2007 20:28:54 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192028.55043.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 3194744aba3738ec948c338ed488b4b4639063b9 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:22:01 +0200
Subject: [PATCH 21/30] rt2x00: Add byte-ordering annotation for MAC and BSSID

By adding byte-ordering annotation for the temporary
register values for MAC and BSSID writing we enhance
typesafety and uncover a bug:
When rt73usb and rt61 touch the MAC/BSSID and treat
it as a register they need to perform byteordering
to prevent the bytes to get mixed up.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    4 ++--
 drivers/net/wireless/rt2500pci.c |    4 ++--
 drivers/net/wireless/rt2500usb.c |    4 ++--
 drivers/net/wireless/rt61pci.c   |   14 ++++++++++----
 drivers/net/wireless/rt73usb.c   |   14 ++++++++++----
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index e5622d6..ffd41a6 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -251,7 +251,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg[2];
+	__le32 reg[2];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, addr, ETH_ALEN);
@@ -265,7 +265,7 @@ static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 
 static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2];
+	__le32 reg[2];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index bfcedfd..fce91ed 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -251,7 +251,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg[2];
+	__le32 reg[2];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, addr, ETH_ALEN);
@@ -265,7 +265,7 @@ static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 
 static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2];
+	__le32 reg[2];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 9670330..9ece4af 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -256,7 +256,7 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
  */
 static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u16 reg[3];
+	__le16 reg[3];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, addr, ETH_ALEN);
@@ -270,7 +270,7 @@ static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 
 static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u16 reg[3];
+	__le16 reg[3];
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index e179702..0e7a528 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -276,12 +276,15 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
  */
 static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg[2];
+	__le32 reg[2];
+	u32 tmp;
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, addr, ETH_ALEN);
 
-	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	tmp = le32_to_cpu(reg[1]);
+	rt2x00_set_field32(&tmp, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	reg[1] = cpu_to_le32(tmp);
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -292,12 +295,15 @@ static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 
 static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2];
+	__le32 reg[2];
+	u32 tmp;
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, bssid, ETH_ALEN);
 
-	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
+	tmp = le32_to_cpu(reg[1]);
+	rt2x00_set_field32(&tmp, MAC_CSR5_BSS_ID_MASK, 3);
+	reg[1] = cpu_to_le32(tmp);
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 1e8b88e..057e5a0 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -257,12 +257,15 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
  */
 static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
-	u32 reg[2];
+	__le32 reg[2];
+	u32 tmp;
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, addr, ETH_ALEN);
 
-	rt2x00_set_field32(&reg[1], MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	tmp = le32_to_cpu(reg[1]);
+	rt2x00_set_field32(&tmp, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
+	reg[1] = cpu_to_le32(tmp);
 
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -273,12 +276,15 @@ static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 
 static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
-	u32 reg[2];
+	__le32 reg[2];
+	u32 tmp;
 
 	memset(&reg, 0, sizeof(reg));
 	memcpy(&reg, bssid, ETH_ALEN);
 
-	rt2x00_set_field32(&reg[1], MAC_CSR5_BSS_ID_MASK, 3);
+	tmp = le32_to_cpu(reg[1]);
+	rt2x00_set_field32(&tmp, MAC_CSR5_BSS_ID_MASK, 3);
+	reg[1] = cpu_to_le32(tmp);
 
 	/*
 	 * The BSSID is passed to us as an array of bytes,
-- 
1.5.3.rc5

