Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64429 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3KCRtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 12:49:41 -0500
Received: by mail-wi0-f179.google.com with SMTP id hm4so2886595wib.6
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 09:49:40 -0800 (PST)
Message-ID: <1383500972.3758.27.camel@canaries32-MCP7A> (sfid-20131103_184944_275245_AE11F6AD)
Subject: [PATCH 4/5] staging; vt6656: device_init_registers Change
 vnt_cmd_card_int and vnt_rsp_card_int to off stack
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 17:49:32 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move structures to vnt_private and convert to pointers in
device_init_registers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  3 +++
 drivers/staging/vt6656/main_usb.c | 23 +++++++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ef2b922..739cda4 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -75,6 +75,7 @@
 #include "desc.h"
 #include "key.h"
 #include "card.h"
+#include "rndis.h"
 
 #define VNT_USB_VENDOR_ID                     0x160a
 #define VNT_USB_PRODUCT_ID                    0x3184
@@ -465,6 +466,8 @@ struct vnt_private {
 	u8 byOriginalZonetype;
 
 	int bLinkPass; /* link status: OK or fail */
+	struct vnt_cmd_card_init init_command;
+	struct vnt_rsp_card_init init_response;
 	u8 abyCurrentNetAddr[ETH_ALEN];
 	u8 abyPermanentNetAddr[ETH_ALEN];
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d1f923c..ba39aaa 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -67,7 +67,6 @@
 #include "datarate.h"
 #include "rf.h"
 #include "firmware.h"
-#include "rndis.h"
 #include "control.h"
 #include "channel.h"
 #include "int.h"
@@ -299,8 +298,8 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
 static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct vnt_cmd_card_init init_cmd;
-	struct vnt_rsp_card_init init_rsp;
+	struct vnt_cmd_card_init *init_cmd = &pDevice->init_command;
+	struct vnt_rsp_card_init *init_rsp = &pDevice->init_response;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
@@ -343,17 +342,17 @@ static int device_init_registers(struct vnt_private *pDevice)
             return false;
         }
 
-	init_cmd.init_class = DEVICE_INIT_COLD;
-	init_cmd.exist_sw_net_addr = (u8) pDevice->bExistSWNetAddr;
+	init_cmd->init_class = DEVICE_INIT_COLD;
+	init_cmd->exist_sw_net_addr = (u8) pDevice->bExistSWNetAddr;
 	for (ii = 0; ii < 6; ii++)
-		init_cmd.sw_net_addr[ii] = pDevice->abyCurrentNetAddr[ii];
-	init_cmd.short_retry_limit = pDevice->byShortRetryLimit;
-	init_cmd.long_retry_limit = pDevice->byLongRetryLimit;
+		init_cmd->sw_net_addr[ii] = pDevice->abyCurrentNetAddr[ii];
+	init_cmd->short_retry_limit = pDevice->byShortRetryLimit;
+	init_cmd->long_retry_limit = pDevice->byLongRetryLimit;
 
 	/* issue card_init command to device */
 	ntStatus = CONTROLnsRequestOut(pDevice,
 		MESSAGE_TYPE_CARDINIT, 0, 0,
-		sizeof(struct vnt_cmd_card_init), (u8 *)&init_cmd);
+		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
 
     if ( ntStatus != STATUS_SUCCESS ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail \n");
@@ -362,7 +361,7 @@ static int device_init_registers(struct vnt_private *pDevice)
     }
 
 	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
-		sizeof(struct vnt_rsp_card_init), (u8 *)&init_rsp);
+		sizeof(struct vnt_rsp_card_init), (u8 *)init_rsp);
 	if (ntStatus != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Cardinit request in status fail!\n");
@@ -519,7 +518,7 @@ static int device_init_registers(struct vnt_private *pDevice)
         pDevice->byMaxChannel = CB_MAX_CHANNEL;
 
 	/* get RFType */
-	pDevice->byRFType = init_rsp.rf_type;
+	pDevice->byRFType = init_rsp->rf_type;
 
         if ((pDevice->byRFType & RF_EMU) != 0) {
 		/* force change RevID for VT3253 emu */
@@ -570,7 +569,7 @@ static int device_init_registers(struct vnt_private *pDevice)
         CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
 
 	/* get permanent network address */
-	memcpy(pDevice->abyPermanentNetAddr, &init_rsp.net_addr[0], 6);
+	memcpy(pDevice->abyPermanentNetAddr, init_rsp->net_addr, 6);
 	memcpy(pDevice->abyCurrentNetAddr,
 	       pDevice->abyPermanentNetAddr,
 	       ETH_ALEN);
-- 
1.8.3.2




