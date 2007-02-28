Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbXB1OHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:16 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:15 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 22/28] rt2x00: Fix big endian problems for the pci drivers
Date: Wed, 28 Feb 2007 15:07:08 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.08544.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix big endian problems for the pci drivers. Register access
does not need to be byteordered.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 3b6f503..3226d76 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -69,8 +69,7 @@ static inline void rt2x00_register_read(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 *value)
 {
-	__le32 reg = (__force __le32)readl(rt2x00dev->csr_addr + offset);
-	*value = le32_to_cpu(reg);
+	*value = readl(rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiread(
@@ -84,8 +83,7 @@ static inline void rt2x00_register_write(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 value)
 {
-	__le32 reg = cpu_to_le32(value);
-	writel((__force u32)reg, rt2x00dev->csr_addr + offset);
+	writel(value, rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiwrite(
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 59faa33..5554b3e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -69,8 +69,7 @@ static inline void rt2x00_register_read(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 *value)
 {
-	__le32 reg = (__force __le32)readl(rt2x00dev->csr_addr + offset);
-	*value = le32_to_cpu(reg);
+	*value = readl(rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiread(
@@ -84,8 +83,7 @@ static inline void rt2x00_register_write(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 value)
 {
-	__le32 reg = cpu_to_le32(value);
-	writel((__force u32)reg, rt2x00dev->csr_addr + offset);
+	writel(value, rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiwrite(
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index f451ae6..abbe032 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -105,7 +105,8 @@ static inline void rt2x00_register_multiread(
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
-		offset, 0x00, value, length, REGISTER_TIMEOUT);
+		offset, 0x00, value, length,
+		REGISTER_TIMEOUT * (length / sizeof(u16)));
 }
 
 static inline void rt2x00_register_write(
@@ -124,7 +125,8 @@ static inline void rt2x00_register_multiwrite(
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
-		offset, 0x00, value, length, REGISTER_TIMEOUT);
+		offset, 0x00, value, length,
+		REGISTER_TIMEOUT * (length / sizeof(u16)));
 }
 
 static u16 rt2x00_bbp_check(const struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 5718005..267f39e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -71,10 +71,8 @@ static inline void rt2x00_register_read(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 *value)
 {
-	__le32 reg;
 	readl(rt2x00dev->csr_addr + MAC_CSR0);
-	reg = (__force __le32)readl(rt2x00dev->csr_addr + offset);
-	*value = le32_to_cpu(reg);
+	*value = readl(rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiread(
@@ -89,9 +87,8 @@ static inline void rt2x00_register_write(
 	const struct rt2x00_dev *rt2x00dev,
 	const unsigned long offset, u32 value)
 {
-	__le32 reg = cpu_to_le32(value);
 	readl(rt2x00dev->csr_addr + MAC_CSR0);
-	writel((__force u32)reg, rt2x00dev->csr_addr + offset);
+	writel(value, rt2x00dev->csr_addr + offset);
 }
 
 static inline void rt2x00_register_multiwrite(
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index a991be4..b24ecea 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -107,7 +107,8 @@ static inline void rt2x00_register_multiread(
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
-		offset, 0x00, value, length, REGISTER_TIMEOUT);
+		offset, 0x00, value, length,
+		REGISTER_TIMEOUT * (length / sizeof(u32)));
 }
 
 static inline void rt2x00_register_write(
@@ -126,7 +127,8 @@ static inline void rt2x00_register_multiwrite(
 {
 	rt2x00_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
-		offset, 0x00, value, length, REGISTER_TIMEOUT);
+		offset, 0x00, value, length,
+		REGISTER_TIMEOUT * (length / sizeof(u32)));
 }
 
 static u32 rt2x00_bbp_check(const struct rt2x00_dev *rt2x00dev)
