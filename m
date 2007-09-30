Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46658 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbXI3Sir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:38:47 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 01/26] at76_usb: Use USB_DEVICE_DATA to improve readability of  the device table
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:38:45 -0400
Message-ID: <20070930183845.23921.57275.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  100 ++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 49 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 9b418bf..9ef401e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -60,127 +60,129 @@ static struct fwentry firmwares[] = {
 	[BOARD_505AMX] = {"atmel_at76c505amx-rfmd.bin"},
 };
 
+#define USB_DEVICE_DATA(__ops)	.driver_info = (kernel_ulong_t)(__ops)
+
 static struct usb_device_id dev_table[] = {
 	/*
 	 * at76c503-i3861
 	 */
 	/* Generic AT76C503/3861 device */
-	{USB_DEVICE(0x03eb, 0x7603), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x03eb, 0x7603), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Linksys WUSB11 v2.1/v2.6 */
-	{USB_DEVICE(0x066b, 0x2211), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x066b, 0x2211), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Netgear MA 101 Rev. A */
-	{USB_DEVICE(0x0864, 0x4100), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0864, 0x4100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Tekram U-300C / Allnet ALL0193 */
-	{USB_DEVICE(0x0b3b, 0x1612), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0b3b, 0x1612), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* HP HN210W PKW-J7801A */
-	{USB_DEVICE(0x03f0, 0x011c), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x03f0, 0x011c), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Sitecom/Z-Com/Zyxel M4Y-750 */
-	{USB_DEVICE(0x0cde, 0x0001), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0cde, 0x0001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Dynalink/Askey WLL013 (intersil) */
-	{USB_DEVICE(0x069a, 0x0320), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x069a, 0x0320), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* EZ connect 11Mpbs Wireless USB Adapter SMC2662W (v1) */
-	{USB_DEVICE(0x0d5c, 0xa001), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0d5c, 0xa001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* AWL-300 */
-	{USB_DEVICE(0x04a5, 0x9000), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x04a5, 0x9000), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* AWU-120, Compex WLU11 */
-	{USB_DEVICE(0x05dd, 0xff31), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x05dd, 0xff31), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* AP310 AnyPoint II USB */
-	{USB_DEVICE(0x8086, 0x0200), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x8086, 0x0200), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Dynalink L11U */
-	{USB_DEVICE(0x0d8e, 0x7100), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0d8e, 0x7100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Arescom WL-210, FCC id 07J-GL2411USB */
-	{USB_DEVICE(0x0d8e, 0x7110), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x0d8e, 0x7110), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* IO-DATA WN-B11/USB */
-	{USB_DEVICE(0x04bb, 0x0919), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x04bb, 0x0919), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* BT Voyager 1010 */
-	{USB_DEVICE(0x069a, 0x0821), .driver_info = BOARD_503_ISL3861},
+	{USB_DEVICE(0x069a, 0x0821), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* at76c503-i3863 */
 	/* Generic AT76C503/3863 device */
-	{USB_DEVICE(0x03eb, 0x7604), .driver_info = BOARD_503_ISL3863},
+	{USB_DEVICE(0x03eb, 0x7604), USB_DEVICE_DATA(BOARD_503_ISL3863)},
 	/* Samsung SWL-2100U */
-	{USB_DEVICE(0x055d, 0xa000), .driver_info = BOARD_503_ISL3863},
+	{USB_DEVICE(0x055d, 0xa000), USB_DEVICE_DATA(BOARD_503_ISL3863)},
 	/*
 	 * at76c503-rfmd
 	 */
 	/* Generic AT76C503/RFMD device */
-	{USB_DEVICE(0x03eb, 0x7605), .driver_info = BOARD_503},
+	{USB_DEVICE(0x03eb, 0x7605), USB_DEVICE_DATA(BOARD_503)},
 	/* Dynalink/Askey WLL013 (rfmd) */
-	{USB_DEVICE(0x069a, 0x0321), .driver_info = BOARD_503},
+	{USB_DEVICE(0x069a, 0x0321), USB_DEVICE_DATA(BOARD_503)},
 	/* Linksys WUSB11 v2.6 */
-	{USB_DEVICE(0x077b, 0x2219), .driver_info = BOARD_503},
+	{USB_DEVICE(0x077b, 0x2219), USB_DEVICE_DATA(BOARD_503)},
 	/* Network Everywhere NWU11B */
-	{USB_DEVICE(0x077b, 0x2227), .driver_info = BOARD_503},
+	{USB_DEVICE(0x077b, 0x2227), USB_DEVICE_DATA(BOARD_503)},
 	/* Netgear MA 101 Rev. B */
-	{USB_DEVICE(0x0864, 0x4102), .driver_info = BOARD_503},
+	{USB_DEVICE(0x0864, 0x4102), USB_DEVICE_DATA(BOARD_503)},
 	/* DWL-120 rev. E */
-	{USB_DEVICE(0x2001, 0x3200), .driver_info = BOARD_503},
+	{USB_DEVICE(0x2001, 0x3200), USB_DEVICE_DATA(BOARD_503)},
 	/* Actiontec 802UAT1, HWU01150-01UK */
-	{USB_DEVICE(0x1668, 0x7605), .driver_info = BOARD_503},
+	{USB_DEVICE(0x1668, 0x7605), USB_DEVICE_DATA(BOARD_503)},
 	/* AirVast W-Buddie WN210 */
-	{USB_DEVICE(0x03eb, 0x4102), .driver_info = BOARD_503},
+	{USB_DEVICE(0x03eb, 0x4102), USB_DEVICE_DATA(BOARD_503)},
 	/* XH1153 802.11b USB adapter */
-	{USB_DEVICE(0x1371, 0x5743), .driver_info = BOARD_503},
+	{USB_DEVICE(0x1371, 0x5743), USB_DEVICE_DATA(BOARD_503)},
 	/* WL-200U */
-	{USB_DEVICE(0x1371, 0x0002), .driver_info = BOARD_503},
+	{USB_DEVICE(0x1371, 0x0002), USB_DEVICE_DATA(BOARD_503)},
 	/* BenQ AWL-400 USB stick */
-	{USB_DEVICE(0x04a5, 0x9001), .driver_info = BOARD_503},
+	{USB_DEVICE(0x04a5, 0x9001), USB_DEVICE_DATA(BOARD_503)},
 	/* 3COM 3CRSHEW696 */
-	{USB_DEVICE(0x0506, 0x0a01), .driver_info = BOARD_503},
+	{USB_DEVICE(0x0506, 0x0a01), USB_DEVICE_DATA(BOARD_503)},
 	/* Siemens Santis ADSL WLAN USB adapter WLL 013 */
-	{USB_DEVICE(0x0681, 0x001b), .driver_info = BOARD_503},
+	{USB_DEVICE(0x0681, 0x001b), USB_DEVICE_DATA(BOARD_503)},
 	/* Belkin F5D6050, version 2 */
-	{USB_DEVICE(0x050d, 0x0050), .driver_info = BOARD_503},
+	{USB_DEVICE(0x050d, 0x0050), USB_DEVICE_DATA(BOARD_503)},
 	/* iBlitzz, BWU613 (not *B or *SB) */
-	{USB_DEVICE(0x07b8, 0xb000), .driver_info = BOARD_503},
+	{USB_DEVICE(0x07b8, 0xb000), USB_DEVICE_DATA(BOARD_503)},
 	/* Gigabyte GN-WLBM101 */
-	{USB_DEVICE(0x1044, 0x8003), .driver_info = BOARD_503},
+	{USB_DEVICE(0x1044, 0x8003), USB_DEVICE_DATA(BOARD_503)},
 	/* Planex GW-US11S */
-	{USB_DEVICE(0x2019, 0x3220), .driver_info = BOARD_503},
+	{USB_DEVICE(0x2019, 0x3220), USB_DEVICE_DATA(BOARD_503)},
 	/* Internal WLAN adapter in h5[4,5]xx series iPAQs */
-	{USB_DEVICE(0x049f, 0x0032), .driver_info = BOARD_503},
+	{USB_DEVICE(0x049f, 0x0032), USB_DEVICE_DATA(BOARD_503)},
 	/*
 	 * at76c503-rfmd-acc
 	 */
 	/* SMC 2664W */
-	{USB_DEVICE(0x083a, 0x3501), .driver_info = BOARD_503_ACC},
+	{USB_DEVICE(0x083a, 0x3501), USB_DEVICE_DATA(BOARD_503_ACC)},
 	/* Belkin F5D6050, SMC 2662W v2, SMC 2662W-AR */
-	{USB_DEVICE(0x0d5c, 0xa002), .driver_info = BOARD_503_ACC},
+	{USB_DEVICE(0x0d5c, 0xa002), USB_DEVICE_DATA(BOARD_503_ACC)},
 	/*
 	 * at76c505-rfmd
 	 */
 	/* Generic AT76C505/RFMD */
-	{USB_DEVICE(0x03eb, 0x7606), .driver_info = BOARD_505},
+	{USB_DEVICE(0x03eb, 0x7606), USB_DEVICE_DATA(BOARD_505)},
 	/*
 	 * at76c505-rfmd2958
 	 */
 	/* Generic AT76C505/RFMD, OvisLink WL-1130USB */
-	{USB_DEVICE(0x03eb, 0x7613), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x03eb, 0x7613), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Fiberline WL-240U */
-	{USB_DEVICE(0x1371, 0x0014), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x1371, 0x0014), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* CNet CNUSB 611G */
-	{USB_DEVICE(0x1371, 0x0013), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x1371, 0x0013), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Linksys WUSB11 v2.8 */
-	{USB_DEVICE(0x1915, 0x2233), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x1915, 0x2233), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Xterasys XN-2122B, IBlitzz BWU613B/BWU613SB */
-	{USB_DEVICE(0x12fd, 0x1001), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x12fd, 0x1001), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Corega WLAN USB Stick 11 */
-	{USB_DEVICE(0x07aa, 0x7613), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x07aa, 0x7613), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Microstar MSI Box MS6978 */
-	{USB_DEVICE(0x0db0, 0x1020), .driver_info = BOARD_505_2958},
+	{USB_DEVICE(0x0db0, 0x1020), USB_DEVICE_DATA(BOARD_505_2958)},
 	/*
 	 * at76c505a-rfmd2958
 	 */
 	/* Generic AT76C505A device */
-	{USB_DEVICE(0x03eb, 0x7614), .driver_info = BOARD_505A},
+	{USB_DEVICE(0x03eb, 0x7614), USB_DEVICE_DATA(BOARD_505A)},
 	/* Generic AT76C505AS device */
-	{USB_DEVICE(0x03eb, 0x7617), .driver_info = BOARD_505A},
+	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
 	/* Siemens Gigaset USB WLAN Adapter 11 */
-	{USB_DEVICE(0x1690, 0x0701), .driver_info = BOARD_505A},
+	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
 	/*
 	 * at76c505amx-rfmd
 	 */
 	/* Generic AT76C505AMX device */
-	{USB_DEVICE(0x03eb, 0x7615), .driver_info = BOARD_505AMX},
+	{USB_DEVICE(0x03eb, 0x7615), USB_DEVICE_DATA(BOARD_505AMX)},
 	{}
 };
 
