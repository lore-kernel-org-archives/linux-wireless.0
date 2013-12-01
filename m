Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33936 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LAI5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 03:57:33 -0500
Message-ID: <1385888246.3121.3.camel@canaries32-MCP7A> (sfid-20131201_095754_213933_E07EC9F0)
Subject: [PATCH] [stable back port for <= 3.8] staging: vt6656: [BUG] Fix
 for TX USB resets from vendors driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Sun, 01 Dec 2013 08:57:26 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

upstream commit
9df682927c2e3a92f43803d6b52095992e3b2ab8
back port for 3.8 and less kernels.

This fixes resets on heavy TX data traffic.

Vendor driver
VT6656_Linux_src_v1.21.03_x86_11.04.zip
http://www.viaembedded.com/servlet/downloadSvl?id=1890&download_file_id=14704
This is GPL-licensed code.

original code
BBbVT3184Init
...
//2007-0725, RobertChang add, Enable Squelch detect reset option(SQ_RST_Opt), USB (register4, bit1)
CONTROLnsRequestIn(pDevice,
                                 MESSAGE_TYPE_READ,
                                 (WORD)0x600+4,     // USB's Reg4's bit1
                                 MESSAGE_REQUEST_MEM,
                                 1,
                                 (PBYTE) &byData);
byData = byData|2 ;
CONTROLnsRequestOut(pDevice,
                              MESSAGE_TYPE_WRITE,
                              (WORD)0x600+4,     // USB's Reg4's bit1
                              MESSAGE_REQUEST_MEM,
                              1,
                              (PBYTE) &byData);

return TRUE;//ntStatus;
....

A back port patch is needed for kernels less than 3.10.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # <= v3.8
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/baseband.c | 11 +++++++++++
 drivers/staging/vt6656/rndis.h    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3855015..65503b9 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -976,6 +976,7 @@ BOOL BBbVT3184Init(PSDevice pDevice)
     PBYTE                   pbyAgc;
     WORD                    wLengthAgc;
     BYTE                    abyArray[256];
+	u8 data;
 
     ntStatus = CONTROLnsRequestIn(pDevice,
                                   MESSAGE_TYPE_READ,
@@ -1144,6 +1145,16 @@ else {
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
 
     RFbRFTableDownload(pDevice);
+
+	/* Fix for TX USB resets from vendors driver */
+	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
+	data |= 0x2;
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
     return TRUE;//ntStatus;
 }
 
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index fccf7e9..dcf7bf5 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -69,6 +69,7 @@
 
 #define VIAUSB20_PACKET_HEADER          0x04
 
+#define USB_REG4	0x604
 
 /*---------------------  Export Classes  ----------------------------*/
 
-- 
1.8.4.4

