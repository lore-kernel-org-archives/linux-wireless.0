Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0H3TQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:27 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/10] rt2x00: Add rt2800_wait_csr_ready
Date: Mon, 30 Aug 2010 21:13:08 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302112.48658.IvDoorn@gmail.com>
In-Reply-To: <201008302112.48658.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302113.09605.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to rt2800_wait_wpdma_ready() we can add a
function to waiting until the CSR is ready. This
centralizes some additional code into rt2800lib.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   28 ++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |   12 +-----------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ac92e7c..967f3e5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -255,6 +255,23 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_mcu_request);
 
+int rt2800_wait_csr_ready(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i = 0;
+	u32 reg;
+
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+		if (reg && reg != ~0)
+			return 0;
+		msleep(1);
+	}
+
+	ERROR(rt2x00dev, "Unstable hardware.\n");
+	return -EBUSY;
+}
+EXPORT_SYMBOL_GPL(rt2800_wait_csr_ready);
+
 int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
@@ -370,17 +387,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Wait for stable hardware.
 	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg && reg != ~0)
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "Unstable hardware.\n");
+	if (rt2800_wait_csr_ready(rt2x00dev))
 		return -EBUSY;
-	}
 
 	if (rt2x00_is_pci(rt2x00dev))
 		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index deb10b1..986229c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -140,6 +140,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
 
+int rt2800_wait_csr_ready(struct rt2x00_dev *rt2x00dev);
 int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 82ae58e..b1a8e94 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -122,22 +122,12 @@ static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	int i;
 
 	/*
 	 * Wait until BBP and RF are ready.
 	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg && reg != ~0)
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "Unstable hardware.\n");
+	if (rt2800_wait_csr_ready(rt2x00dev))
 		return -EBUSY;
-	}
 
 	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
-- 
1.7.2.2

