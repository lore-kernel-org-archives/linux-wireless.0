Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40774 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3JVT0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 15:26:21 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so6336589wid.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 12:26:19 -0700 (PDT)
Message-ID: <1382469974.6738.8.camel@canaries64-MCP7A> (sfid-20131022_212624_501730_B493326F)
Subject: [PATCH] staging: vt6656: device.h  Remove typedef enum
 __device_init_type.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Oct 2013 20:26:14 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since typedef enum __device_init_type is only ever called
in one state.

Remove the typedef from main_usb.c:device_init_registers
and if braces and just apply the enum value to sInitCmd.byInitClass.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  4 ++--
 drivers/staging/vt6656/main_usb.c | 31 ++++++++++++++-----------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 62b7de1..8921305 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -149,11 +149,11 @@ typedef enum __device_msg_level {
 	MSG_LEVEL_DEBUG = 4           /* Only for debug purpose. */
 } DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
 
-typedef enum __device_init_type {
+enum vnt_init_type {
 	DEVICE_INIT_COLD = 0,       /* cold init */
 	DEVICE_INIT_RESET,          /* reset init or Dx to D0 power remain */
 	DEVICE_INIT_DXPL            /* Dx to D0 power lost init */
-} DEVICE_INIT_TYPE, *PDEVICE_INIT_TYPE;
+};
 
 /* USB */
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index aae228c..3a2beaa 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -215,8 +215,7 @@ static void device_set_multi(struct net_device *dev);
 static int  device_close(struct net_device *dev);
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
-static int device_init_registers(struct vnt_private *pDevice,
-	DEVICE_INIT_TYPE InitType);
+static int device_init_registers(struct vnt_private *pDevice);
 static bool device_init_defrag_cb(struct vnt_private *pDevice);
 static void device_init_diversity_timer(struct vnt_private *pDevice);
 static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
@@ -297,8 +296,7 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
  * initialization of MAC & BBP registers
  */
 
-static int device_init_registers(struct vnt_private *pDevice,
-	DEVICE_INIT_TYPE InitType)
+static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -313,12 +311,14 @@ static int device_init_registers(struct vnt_private *pDevice,
 	u8 byTmp;
 	u8 byCalibTXIQ = 0, byCalibTXDC = 0, byCalibRXIQ = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n", InitType, pDevice->byPacketType);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
+				DEVICE_INIT_COLD, pDevice->byPacketType);
+
 	spin_lock_irq(&pDevice->lock);
-	if (InitType == DEVICE_INIT_COLD) {
-		memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
-		memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
-		memcpy(pDevice->abySNAP_Bridgetunnel,
+
+	memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
+	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
+	memcpy(pDevice->abySNAP_Bridgetunnel,
 		       abySNAP_Bridgetunnel,
 		       ETH_ALEN);
 
@@ -342,9 +342,8 @@ static int device_init_registers(struct vnt_private *pDevice,
             spin_unlock_irq(&pDevice->lock);
             return false;
         }
-    }
 
-    sInitCmd.byInitClass = (u8)InitType;
+    sInitCmd.byInitClass = DEVICE_INIT_COLD;
     sInitCmd.bExistSWNetAddr = (u8) pDevice->bExistSWNetAddr;
     for (ii = 0; ii < 6; ii++)
 	sInitCmd.bySWNetAddr[ii] = pDevice->abyCurrentNetAddr[ii];
@@ -364,7 +363,6 @@ static int device_init_registers(struct vnt_private *pDevice,
         spin_unlock_irq(&pDevice->lock);
         return false;
     }
-    if (InitType == DEVICE_INIT_COLD) {
 
         ntStatus = CONTROLnsRequestIn(pDevice,MESSAGE_TYPE_INIT_RSP,0,0,sizeof(RSP_CARD_INIT), (u8 *) &(sInitRsp));
 
@@ -574,7 +572,6 @@ static int device_init_registers(struct vnt_private *pDevice,
 	/* if exist SW network address, use it */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
 		pDevice->abyCurrentNetAddr);
-    }
 
     /*
      * set BB and packet type at the same time
@@ -962,10 +959,10 @@ static int  device_open(struct net_device *dev)
     /* read config file */
     Read_config_file(pDevice);
 
-    if (device_init_registers(pDevice, DEVICE_INIT_COLD) == false) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " init register fail\n");
-        goto free_all;
-    }
+	if (device_init_registers(pDevice) == false) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " init register fail\n");
+		goto free_all;
+	}
 
     device_set_multi(pDevice->dev);
 
-- 
1.8.3.2

