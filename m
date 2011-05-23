Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:59604 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755330Ab1EWOVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 10:21:41 -0400
Date: 23 May 2011 10:21:39 -0400
Message-ID: <20110523142139.21406.qmail@science.horizon.com> (sfid-20110523_162144_958573_F46A7C61)
From: "George Spelvin" <linux@horizon.com>
To: coelho@ti.com, kvalo@adurom.com
Subject: wl1251_spi_wake memory leak?
Cc: linux@horizon.com, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was working on a patch to the crc7 code (basically, it simplifies
both the CRC code *and* all callers if the CRC is computed left-justified)
when I noticed that wl1251_spi_wake and wl1271_spi_init are *almost*
identical functions.

Except that wl1271_spi_init kfree()s the cmd buffer before returning
(leading to the question of why it's not stack allocated), while
wl1251_spi_wake does not.

I didn't trace the code to see what spi_message_add_tail does with the
buffer, but it seems that *one* of the two functions must have a bug.

Would someone like to suggest the correct fix?  My instincts are
to factor out the common code, but that's a bit more invasive than
a drive-by patch should be.

My patch in progress is appended, FWIW.  I was cleaning up
code surrounding calls to crc7() when I hit the puzzle.

Thank you!


diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index fd877f6..994c8f3 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -470,7 +470,7 @@ mmc_spi_command_send(struct mmc_spi_host *host,
 	*cp++ = (u8)(arg >> 16);
 	*cp++ = (u8)(arg >> 8);
 	*cp++ = (u8)arg;
-	*cp++ = (crc7(0, &data->status[1], 5) << 1) | 0x01;
+	*cp++ = crc7_be(0, &data->status[1], 5) | 0x01;
 
 	/* Then, read up to 13 bytes (while writing all-ones):
 	 *  - N(CR) (== 1..8) bytes of all-ones
diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index 64a0214..9844546 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/crc7.h>
 
 #include "wl1251.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/wl1251/cmd.c
index 0ade4bd..5eaaa50 100644
--- a/drivers/net/wireless/wl1251/cmd.c
+++ b/drivers/net/wireless/wl1251/cmd.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/crc7.h>
 
 #include "wl1251.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl1251/spi.c
index ac872b3..3aaa95b 100644
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -86,7 +86,6 @@ static void wl1251_spi_wake(struct wl1251 *wl)
 		return;
 	}
 
-	memset(crc, 0, sizeof(crc));
 	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 
@@ -99,25 +98,23 @@ static void wl1251_spi_wake(struct wl1251 *wl)
 	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
 	cmd[0] = 0;
 	cmd[7] = 0;
-	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
-	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+	cmd[6] = HW_ACCESS_WSPI_INIT_CMD_MASK << 3 |
+		HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
 
+	cmd[5] = WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
 	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
-		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+		cmd[5] |= WSPI_INIT_CMD_DIS_FIXEDBUSY;
 	else
 		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
 
-	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
-		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
-
 	crc[0] = cmd[1];
 	crc[1] = cmd[0];
 	crc[2] = cmd[7];
 	crc[3] = cmd[6];
 	crc[4] = cmd[5];
 
-	cmd[4] |= crc7(0, crc, WSPI_INIT_CMD_CRC_LEN) << 1;
-	cmd[4] |= WSPI_INIT_CMD_END;
+	cmd[4] = crc7_be(0, crc, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
 
 	t.tx_buf = cmd;
 	t.len = WSPI_INIT_CMD_LEN;
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index cc4068d..c37d818 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 0106628..9c50bbb 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index d557f73..27c72dd 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
 #include "wl12xx.h"
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 93cbb8d..c04ac1a 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -23,7 +23,6 @@
 
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/crc7.h>
 #include <linux/vmalloc.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index 9fcbd3d..18bc4f1 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -25,7 +25,6 @@
 
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/crc7.h>
 #include <linux/vmalloc.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 7145ea5..63045db 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -126,7 +126,6 @@ static void wl1271_spi_init(struct wl1271 *wl)
 		return;
 	}
 
-	memset(crc, 0, sizeof(crc));
 	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 
@@ -139,25 +138,23 @@ static void wl1271_spi_init(struct wl1271 *wl)
 	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
 	cmd[0] = 0;
 	cmd[7] = 0;
-	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
-	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+	cmd[6] = HW_ACCESS_WSPI_INIT_CMD_MASK << 3 |
+		HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
 
+	cmd[5] = WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
 	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
-		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+		cmd[5] |= WSPI_INIT_CMD_DIS_FIXEDBUSY;
 	else
 		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
 
-	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
-		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
-
 	crc[0] = cmd[1];
 	crc[1] = cmd[0];
 	crc[2] = cmd[7];
 	crc[3] = cmd[6];
 	crc[4] = cmd[5];
 
-	cmd[4] |= crc7(0, crc, WSPI_INIT_CMD_CRC_LEN) << 1;
-	cmd[4] |= WSPI_INIT_CMD_END;
+	cmd[4] = crc7_be(0, crc, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
 
 	t.tx_buf = cmd;
 	t.len = WSPI_INIT_CMD_LEN;
diff --git a/include/linux/crc7.h b/include/linux/crc7.h
index 1786e77..b0e48d3 100644
--- a/include/linux/crc7.h
+++ b/include/linux/crc7.h
@@ -4,11 +4,15 @@
 
 extern const u8 crc7_syndrome_table[256];
 
-static inline u8 crc7_byte(u8 crc, u8 data)
+/*
+ * The CRC is maintained left-justified, in the most significant 7 bits
+ * of the crc variable.  Thus the _be (big-endian) suffix.
+ */
+static inline u8 crc7_byte_be(u8 crc, u8 data)
 {
-	return crc7_syndrome_table[(crc << 1) ^ data];
+	return crc7_syndrome_table[crc ^ data];
 }
 
-extern u8 crc7(u8 crc, const u8 *buffer, size_t len);
+extern u8 crc7_be(u8 crc, const u8 *buffer, size_t len);
 
 #endif
diff --git a/lib/crc7.c b/lib/crc7.c
index f1c3a14..b8fa048 100644
--- a/lib/crc7.c
+++ b/lib/crc7.c
@@ -12,38 +12,38 @@
 
 /* Table for CRC-7 (polynomial x^7 + x^3 + 1) */
 const u8 crc7_syndrome_table[256] = {
-	0x00, 0x09, 0x12, 0x1b, 0x24, 0x2d, 0x36, 0x3f,
-	0x48, 0x41, 0x5a, 0x53, 0x6c, 0x65, 0x7e, 0x77,
-	0x19, 0x10, 0x0b, 0x02, 0x3d, 0x34, 0x2f, 0x26,
-	0x51, 0x58, 0x43, 0x4a, 0x75, 0x7c, 0x67, 0x6e,
-	0x32, 0x3b, 0x20, 0x29, 0x16, 0x1f, 0x04, 0x0d,
-	0x7a, 0x73, 0x68, 0x61, 0x5e, 0x57, 0x4c, 0x45,
-	0x2b, 0x22, 0x39, 0x30, 0x0f, 0x06, 0x1d, 0x14,
-	0x63, 0x6a, 0x71, 0x78, 0x47, 0x4e, 0x55, 0x5c,
-	0x64, 0x6d, 0x76, 0x7f, 0x40, 0x49, 0x52, 0x5b,
-	0x2c, 0x25, 0x3e, 0x37, 0x08, 0x01, 0x1a, 0x13,
-	0x7d, 0x74, 0x6f, 0x66, 0x59, 0x50, 0x4b, 0x42,
-	0x35, 0x3c, 0x27, 0x2e, 0x11, 0x18, 0x03, 0x0a,
-	0x56, 0x5f, 0x44, 0x4d, 0x72, 0x7b, 0x60, 0x69,
-	0x1e, 0x17, 0x0c, 0x05, 0x3a, 0x33, 0x28, 0x21,
-	0x4f, 0x46, 0x5d, 0x54, 0x6b, 0x62, 0x79, 0x70,
-	0x07, 0x0e, 0x15, 0x1c, 0x23, 0x2a, 0x31, 0x38,
-	0x41, 0x48, 0x53, 0x5a, 0x65, 0x6c, 0x77, 0x7e,
-	0x09, 0x00, 0x1b, 0x12, 0x2d, 0x24, 0x3f, 0x36,
-	0x58, 0x51, 0x4a, 0x43, 0x7c, 0x75, 0x6e, 0x67,
-	0x10, 0x19, 0x02, 0x0b, 0x34, 0x3d, 0x26, 0x2f,
-	0x73, 0x7a, 0x61, 0x68, 0x57, 0x5e, 0x45, 0x4c,
-	0x3b, 0x32, 0x29, 0x20, 0x1f, 0x16, 0x0d, 0x04,
-	0x6a, 0x63, 0x78, 0x71, 0x4e, 0x47, 0x5c, 0x55,
-	0x22, 0x2b, 0x30, 0x39, 0x06, 0x0f, 0x14, 0x1d,
-	0x25, 0x2c, 0x37, 0x3e, 0x01, 0x08, 0x13, 0x1a,
-	0x6d, 0x64, 0x7f, 0x76, 0x49, 0x40, 0x5b, 0x52,
-	0x3c, 0x35, 0x2e, 0x27, 0x18, 0x11, 0x0a, 0x03,
-	0x74, 0x7d, 0x66, 0x6f, 0x50, 0x59, 0x42, 0x4b,
-	0x17, 0x1e, 0x05, 0x0c, 0x33, 0x3a, 0x21, 0x28,
-	0x5f, 0x56, 0x4d, 0x44, 0x7b, 0x72, 0x69, 0x60,
-	0x0e, 0x07, 0x1c, 0x15, 0x2a, 0x23, 0x38, 0x31,
-	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
+	0x00, 0x12, 0x24, 0x36, 0x48, 0x5a, 0x6c, 0x7e,
+	0x90, 0x82, 0xb4, 0xa6, 0xd8, 0xca, 0xfc, 0xee,
+	0x32, 0x20, 0x16, 0x04, 0x7a, 0x68, 0x5e, 0x4c,
+	0xa2, 0xb0, 0x86, 0x94, 0xea, 0xf8, 0xce, 0xdc,
+	0x64, 0x76, 0x40, 0x52, 0x2c, 0x3e, 0x08, 0x1a,
+	0xf4, 0xe6, 0xd0, 0xc2, 0xbc, 0xae, 0x98, 0x8a,
+	0x56, 0x44, 0x72, 0x60, 0x1e, 0x0c, 0x3a, 0x28,
+	0xc6, 0xd4, 0xe2, 0xf0, 0x8e, 0x9c, 0xaa, 0xb8,
+	0xc8, 0xda, 0xec, 0xfe, 0x80, 0x92, 0xa4, 0xb6,
+	0x58, 0x4a, 0x7c, 0x6e, 0x10, 0x02, 0x34, 0x26,
+	0xfa, 0xe8, 0xde, 0xcc, 0xb2, 0xa0, 0x96, 0x84,
+	0x6a, 0x78, 0x4e, 0x5c, 0x22, 0x30, 0x06, 0x14,
+	0xac, 0xbe, 0x88, 0x9a, 0xe4, 0xf6, 0xc0, 0xd2,
+	0x3c, 0x2e, 0x18, 0x0a, 0x74, 0x66, 0x50, 0x42,
+	0x9e, 0x8c, 0xba, 0xa8, 0xd6, 0xc4, 0xf2, 0xe0,
+	0x0e, 0x1c, 0x2a, 0x38, 0x46, 0x54, 0x62, 0x70,
+	0x82, 0x90, 0xa6, 0xb4, 0xca, 0xd8, 0xee, 0xfc,
+	0x12, 0x00, 0x36, 0x24, 0x5a, 0x48, 0x7e, 0x6c,
+	0xb0, 0xa2, 0x94, 0x86, 0xf8, 0xea, 0xdc, 0xce,
+	0x20, 0x32, 0x04, 0x16, 0x68, 0x7a, 0x4c, 0x5e,
+	0xe6, 0xf4, 0xc2, 0xd0, 0xae, 0xbc, 0x8a, 0x98,
+	0x76, 0x64, 0x52, 0x40, 0x3e, 0x2c, 0x1a, 0x08,
+	0xd4, 0xc6, 0xf0, 0xe2, 0x9c, 0x8e, 0xb8, 0xaa,
+	0x44, 0x56, 0x60, 0x72, 0x0c, 0x1e, 0x28, 0x3a,
+	0x4a, 0x58, 0x6e, 0x7c, 0x02, 0x10, 0x26, 0x34,
+	0xda, 0xc8, 0xfe, 0xec, 0x92, 0x80, 0xb6, 0xa4,
+	0x78, 0x6a, 0x5c, 0x4e, 0x30, 0x22, 0x14, 0x06,
+	0xe8, 0xfa, 0xcc, 0xde, 0xa0, 0xb2, 0x84, 0x96,
+	0x2e, 0x3c, 0x0a, 0x18, 0x66, 0x74, 0x42, 0x50,
+	0xbe, 0xac, 0x9a, 0x88, 0xf6, 0xe4, 0xd2, 0xc0,
+	0x1c, 0x0e, 0x38, 0x2a, 0x54, 0x46, 0x70, 0x62,
+	0x8c, 0x9e, 0xa8, 0xba, 0xc4, 0xd6, 0xe0, 0xf2
 };
 EXPORT_SYMBOL(crc7_syndrome_table);
 
@@ -56,13 +56,13 @@ EXPORT_SYMBOL(crc7_syndrome_table);
  *
  * Returns the updated CRC7 value.
  */
-u8 crc7(u8 crc, const u8 *buffer, size_t len)
+u8 crc7_be(u8 crc, const u8 *buffer, size_t len)
 {
 	while (len--)
-		crc = crc7_byte(crc, *buffer++);
+		crc = crc7_byte_be(crc, *buffer++);
 	return crc;
 }
-EXPORT_SYMBOL(crc7);
+EXPORT_SYMBOL(crc7_be);
 
 MODULE_DESCRIPTION("CRC7 calculations");
 MODULE_LICENSE("GPL");
