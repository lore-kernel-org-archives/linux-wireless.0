Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:59289 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3KCRpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 12:45:18 -0500
Received: by mail-we0-f180.google.com with SMTP id q59so1255765wes.39
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 09:45:17 -0800 (PST)
Message-ID: <1383500706.3758.25.camel@canaries32-MCP7A> (sfid-20131103_184523_038218_18FEEB54)
Subject: [PATCH 3/5] staging: vt6656: Replace typedef struct _RSP_CARD_INIT.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 17:45:06 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_rsp_card_rsp init_rsp in device_init_registers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |  8 ++++----
 drivers/staging/vt6656/rndis.h    | 14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fd8dfe9..d1f923c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -300,6 +300,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_cmd_card_init init_cmd;
+	struct vnt_rsp_card_init init_rsp;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
@@ -307,7 +308,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	u8 byAntenna;
 	int ii;
 	int ntStatus = STATUS_SUCCESS;
-	RSP_CARD_INIT   sInitRsp;
 	u8 byTmp;
 	u8 byCalibTXIQ = 0, byCalibTXDC = 0, byCalibRXIQ = 0;
 
@@ -362,7 +362,7 @@ static int device_init_registers(struct vnt_private *pDevice)
     }
 
 	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
-			sizeof(RSP_CARD_INIT), (u8 *) &(sInitRsp));
+		sizeof(struct vnt_rsp_card_init), (u8 *)&init_rsp);
 	if (ntStatus != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Cardinit request in status fail!\n");
@@ -519,7 +519,7 @@ static int device_init_registers(struct vnt_private *pDevice)
         pDevice->byMaxChannel = CB_MAX_CHANNEL;
 
 	/* get RFType */
-        pDevice->byRFType = sInitRsp.byRFType;
+	pDevice->byRFType = init_rsp.rf_type;
 
         if ((pDevice->byRFType & RF_EMU) != 0) {
 		/* force change RevID for VT3253 emu */
@@ -570,7 +570,7 @@ static int device_init_registers(struct vnt_private *pDevice)
         CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
 
 	/* get permanent network address */
-	memcpy(pDevice->abyPermanentNetAddr, &sInitRsp.byNetAddr[0], 6);
+	memcpy(pDevice->abyPermanentNetAddr, &init_rsp.net_addr[0], 6);
 	memcpy(pDevice->abyCurrentNetAddr,
 	       pDevice->abyPermanentNetAddr,
 	       ETH_ALEN);
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index 5dcc4b4..08321ad 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -86,14 +86,14 @@ struct vnt_cmd_card_init
 	u8 long_retry_limit;
 };
 
-typedef struct _RSP_CARD_INIT
+struct vnt_rsp_card_init
 {
-    u8        byStatus;
-    u8        byNetAddr[6];
-    u8        byRFType;
-    u8        byMinChannel;
-    u8        byMaxChannel;
-} RSP_CARD_INIT, *PRSP_CARD_INIT;
+	u8 status;
+	u8 net_addr[6];
+	u8 rf_type;
+	u8 min_channel;
+	u8 max_channel;
+};
 
 typedef struct _CMD_SET_KEY
 {
-- 
1.8.3.2


