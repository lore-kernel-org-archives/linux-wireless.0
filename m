Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47243 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaATUdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 15:33:51 -0500
Received: by mail-wg0-f48.google.com with SMTP id x13so7185041wgg.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 12:33:50 -0800 (PST)
Message-ID: <1390250019.3533.42.camel@canaries32-MCP7A> (sfid-20140120_213354_950454_EB60E76B)
Subject: [PATCH] staging: vt6656: device_set_multi: covert mc_filter to u64
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, linux-wireless@vger.kernel.org
Date: Mon, 20 Jan 2014 20:33:39 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert mc_filter to u64, preform netdev_for_each_mc_addr
mask filtering.

In MACvWriteMultiAddr endian correct mc_filter and write
the entire multicast once.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c      | 16 +++++-----------
 drivers/staging/vt6656/mac.h      |  2 +-
 drivers/staging/vt6656/main_usb.c | 18 ++++++++----------
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 54414ed27..3ce19dd 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -47,25 +47,19 @@ static int          msglevel                =MSG_LEVEL_INFO;
  *
  * Parameters:
  *  In:
- *      uByteidx    - Index of Mask
- *      byData      - Mask Value to write
+ *	mc_filter (multi cast mask filter)
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
+void MACvWriteMultiAddr(struct vnt_private *pDevice, u64 mc_filter)
 {
-	u8 byData1;
+	__le64 le_mc = cpu_to_le64(mc_filter);
 
-    byData1 = byData;
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        (u16) (MAC_REG_MAR0 + uByteIdx),
-                        MESSAGE_REQUEST_MACREG,
-                        1,
-                        &byData1);
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, MAC_REG_MAR0,
+		MESSAGE_REQUEST_MACREG, sizeof(le_mc), (u8 *)&le_mc);
 }
 
 /*
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 0db1be5..4053e43 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -403,7 +403,7 @@
 #define MAC_REVISION_A0     0x00
 #define MAC_REVISION_A1     0x01
 
-void MACvWriteMultiAddr(struct vnt_private *, u32, u8);
+void MACvWriteMultiAddr(struct vnt_private *, u64);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 58edcae..c5e9dee2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1353,8 +1353,7 @@ static void device_set_multi(struct net_device *dev)
 	struct vnt_private *pDevice = netdev_priv(dev);
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct netdev_hw_addr *ha;
-	u32 mc_filter[2];
-	int ii;
+	u64 mc_filter = 0;
 	u8 pbyData[8] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	u8 byTmpMode = 0;
 	int rc;
@@ -1388,15 +1387,14 @@ static void device_set_multi(struct net_device *dev)
         pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
     }
     else {
-        memset(mc_filter, 0, sizeof(mc_filter));
 	netdev_for_each_mc_addr(ha, dev) {
-            int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
-            mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));
-        }
-        for (ii = 0; ii < 4; ii++) {
-             MACvWriteMultiAddr(pDevice, ii, *((u8 *)&mc_filter[0] + ii));
-             MACvWriteMultiAddr(pDevice, ii+ 4, *((u8 *)&mc_filter[1] + ii));
-        }
+		int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+
+		mc_filter |= 1ULL << (bit_nr & 0x3f);
+	}
+
+	MACvWriteMultiAddr(pDevice, mc_filter);
+
         pDevice->byRxMode &= ~(RCR_UNICAST);
         pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
     }
-- 
1.8.5.3

