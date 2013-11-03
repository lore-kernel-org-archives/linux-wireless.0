Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37862 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3KCRna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 12:43:30 -0500
Received: by mail-wg0-f42.google.com with SMTP id n12so1037284wgh.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 09:43:29 -0800 (PST)
Message-ID: <1383500603.3758.24.camel@canaries32-MCP7A> (sfid-20131103_184333_571184_8D7C4F7C)
Subject: [PATCH 2/5] staging: vt6656: Replace typedef struct _CMD_CARD_INIT
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 17:43:23 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_cmd_card_init init_cmd in
device_init_registers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 27 ++++++++++++---------------
 drivers/staging/vt6656/rndis.h    | 14 +++++++-------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 297dd10..fd8dfe9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -299,13 +299,13 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
 static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_cmd_card_init init_cmd;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
 		= {0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8};
 	u8 byAntenna;
 	int ii;
-	CMD_CARD_INIT sInitCmd;
 	int ntStatus = STATUS_SUCCESS;
 	RSP_CARD_INIT   sInitRsp;
 	u8 byTmp;
@@ -343,20 +343,17 @@ static int device_init_registers(struct vnt_private *pDevice)
             return false;
         }
 
-    sInitCmd.byInitClass = DEVICE_INIT_COLD;
-    sInitCmd.bExistSWNetAddr = (u8) pDevice->bExistSWNetAddr;
-    for (ii = 0; ii < 6; ii++)
-	sInitCmd.bySWNetAddr[ii] = pDevice->abyCurrentNetAddr[ii];
-    sInitCmd.byShortRetryLimit = pDevice->byShortRetryLimit;
-    sInitCmd.byLongRetryLimit = pDevice->byLongRetryLimit;
-
-    /* issue card_init command to device */
-    ntStatus = CONTROLnsRequestOut(pDevice,
-                                    MESSAGE_TYPE_CARDINIT,
-                                    0,
-                                    0,
-                                    sizeof(CMD_CARD_INIT),
-                                    (u8 *) &(sInitCmd));
+	init_cmd.init_class = DEVICE_INIT_COLD;
+	init_cmd.exist_sw_net_addr = (u8) pDevice->bExistSWNetAddr;
+	for (ii = 0; ii < 6; ii++)
+		init_cmd.sw_net_addr[ii] = pDevice->abyCurrentNetAddr[ii];
+	init_cmd.short_retry_limit = pDevice->byShortRetryLimit;
+	init_cmd.long_retry_limit = pDevice->byLongRetryLimit;
+
+	/* issue card_init command to device */
+	ntStatus = CONTROLnsRequestOut(pDevice,
+		MESSAGE_TYPE_CARDINIT, 0, 0,
+		sizeof(struct vnt_cmd_card_init), (u8 *)&init_cmd);
 
     if ( ntStatus != STATUS_SUCCESS ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail \n");
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index 5e07306..5dcc4b4 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -77,14 +77,14 @@ typedef struct _CMD_WRITE_MASK
     u8        byMask;
 } CMD_WRITE_MASK, *PCMD_WRITE_MASK;
 
-typedef struct _CMD_CARD_INIT
+struct vnt_cmd_card_init
 {
-    u8        byInitClass;
-    u8        bExistSWNetAddr;
-    u8        bySWNetAddr[6];
-    u8        byShortRetryLimit;
-    u8        byLongRetryLimit;
-} CMD_CARD_INIT, *PCMD_CARD_INIT;
+	u8 init_class;
+	u8 exist_sw_net_addr;
+	u8 sw_net_addr[6];
+	u8 short_retry_limit;
+	u8 long_retry_limit;
+};
 
 typedef struct _RSP_CARD_INIT
 {
-- 
1.8.3.2


