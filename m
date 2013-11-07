Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56337 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3KGVtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 16:49:12 -0500
Received: by mail-wg0-f50.google.com with SMTP id n12so1157158wgh.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 13:49:10 -0800 (PST)
Message-ID: <1383860944.6016.3.camel@canaries32-MCP7A> (sfid-20131107_224932_939297_06AF886A)
Subject: [PATCH] staging: vt6656: [BUG] Fix for TX USB resets from vendors
 driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Nov 2013 21:49:04 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
Cc: stable@vger.kernel.org # v3.10+
---
 drivers/staging/vt6656/baseband.c | 11 +++++++++++
 drivers/staging/vt6656/rndis.h    |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 1e8b841..4aa5ef5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -939,6 +939,7 @@ int BBbVT3184Init(struct vnt_private *pDevice)
     u8 *                   pbyAgc;
     u16                    wLengthAgc;
     u8                    abyArray[256];
+	u8 data;
 
     ntStatus = CONTROLnsRequestIn(pDevice,
                                   MESSAGE_TYPE_READ,
@@ -1104,6 +1105,16 @@ else {
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
     return true;//ntStatus;
 }
 
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index 5e07306..5cf5e73 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -66,6 +66,8 @@
 
 #define VIAUSB20_PACKET_HEADER          0x04
 
+#define USB_REG4	0x604
+
 typedef struct _CMD_MESSAGE
 {
     u8        byData[256];
-- 
1.8.3.2

