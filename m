Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60906 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3KZUpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:45:55 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so5823323wib.9
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 12:45:54 -0800 (PST)
Message-ID: <1385498747.10545.7.camel@canaries32-MCP7A> (sfid-20131126_214558_440965_9B5E0CE2)
Subject: [PATCH v3] staging: vt6656: mac.c MACvWriteMultiAddr: Remove
 secondary variables
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 20:45:47 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Covert to pointer, point to callers buffer and remove casting in callers.

CONTROLnsRequestOut is called with sizeof u8.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c      | 9 +++------
 drivers/staging/vt6656/mac.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 54414ed27..5392f7c 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -55,17 +55,14 @@ static int          msglevel                =MSG_LEVEL_INFO;
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
+void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 *data)
 {
-	u8 byData1;
-
-    byData1 = byData;
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_WRITE,
                         (u16) (MAC_REG_MAR0 + uByteIdx),
                         MESSAGE_REQUEST_MACREG,
-                        1,
-                        &byData1);
+			sizeof(u8),
+			data);
 }
 
 /*
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 0db1be5..e0af29e 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -403,7 +403,7 @@
 #define MAC_REVISION_A0     0x00
 #define MAC_REVISION_A1     0x01
 
-void MACvWriteMultiAddr(struct vnt_private *, u32, u8);
+void MACvWriteMultiAddr(struct vnt_private *, u32, u8 *);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4cb7aa7..45d2bf3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1394,8 +1394,8 @@ static void device_set_multi(struct net_device *dev)
             mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));
         }
         for (ii = 0; ii < 4; ii++) {
-             MACvWriteMultiAddr(pDevice, ii, *((u8 *)&mc_filter[0] + ii));
-             MACvWriteMultiAddr(pDevice, ii+ 4, *((u8 *)&mc_filter[1] + ii));
+		MACvWriteMultiAddr(pDevice, ii, (u8 *)&mc_filter[0] + ii);
+		MACvWriteMultiAddr(pDevice, ii + 4, (u8 *)&mc_filter[1] + ii);
         }
         pDevice->byRxMode &= ~(RCR_UNICAST);
         pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
-- 
1.8.4.4

