Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39326 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2LJWOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:14:54 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2052315wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:14:53 -0800 (PST)
Message-ID: <1355177676.4680.24.camel@canaries64> (sfid-20121210_231458_454729_C3E7E5DC)
Subject: [PATCH 08/11] staging: vt6656: channel/control/firmware/int/usbpipe
 to new structures
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:14:36 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch cleans up function declarations, definitions and local variables
where appropriate replacing types defined in "ttype.h" with linux/types.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/channel.c  |   7 +-
 drivers/staging/vt6656/channel.h  |   3 +-
 drivers/staging/vt6656/control.c  |  55 ++++++--------
 drivers/staging/vt6656/control.h  |  26 ++-----
 drivers/staging/vt6656/firmware.c |  17 +----
 drivers/staging/vt6656/firmware.h |  17 +----
 drivers/staging/vt6656/int.c      |   7 +-
 drivers/staging/vt6656/int.h      |   4 +-
 drivers/staging/vt6656/usbpipe.c  | 156 +++++++++++---------------------------
 drivers/staging/vt6656/usbpipe.h  |  40 +++-------
 drivers/staging/vt6656/wpactl.c   |   4 +-
 drivers/staging/vt6656/wpactl.h   |   2 +-
 12 files changed, 104 insertions(+), 234 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 6502176..95f00ba 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -436,11 +436,10 @@ CHvChannelGetList (
 }
 

-void CHvInitChannelTable(void *pDeviceHandler)
+void CHvInitChannelTable(struct vnt_private *pDevice)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bMultiBand = FALSE;
-    unsigned int ii;
+	int bMultiBand = FALSE;
+	int ii;
 
     for (ii = 1; ii <= CB_MAX_CHANNEL; ii++)
 	sChannelTbl[ii].bValid = FALSE;
diff --git a/drivers/staging/vt6656/channel.h b/drivers/staging/vt6656/channel.h
index e7b3c12..8031491 100644
--- a/drivers/staging/vt6656/channel.h
+++ b/drivers/staging/vt6656/channel.h
@@ -30,6 +30,7 @@
 #ifndef _CHANNEL_H_
 #define _CHANNEL_H_
 
+#include "device.h"
 #include "ttype.h"
 
 /*---------------------  Export Definitions -------------------------*/
@@ -47,7 +48,7 @@ typedef struct tagSChannelTblElement {
 /*---------------------  Export Functions  --------------------------*/
 
 BOOL    ChannelValid(unsigned int CountryCode, unsigned int ChannelNum);
-void    CHvInitChannelTable(void *pDeviceHandler);
+void    CHvInitChannelTable(struct vnt_private *pDevice);
 BYTE    CHbyGetChannelMapping(BYTE byChannelNumber);
 
 BOOL CHvChannelGetList(unsigned int uCountryCodeIdx, PBYTE pbyChannelTable);
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 5d8c571..743ef5f 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -56,43 +56,34 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-void ControlvWriteByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
-			BYTE byData)
+void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
+			u8 data)
 {
-	BYTE	byData1;
-	byData1 = byData;
-	CONTROLnsRequestOut(pDevice,
-		MESSAGE_TYPE_WRITE,
-		byRegOfs,
-		byRegType,
-		1,
-		&byData1);
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, reg_off, reg,
+		sizeof(u8), &data);
+
+	return;
 }
 
-void ControlvReadByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
-			PBYTE pbyData)
+void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
+			u8 *data)
 {
-	int ntStatus;
-	BYTE	byData1;
-	ntStatus = CONTROLnsRequestIn(pDevice,
-					MESSAGE_TYPE_READ,
-					byRegOfs,
-					byRegType,
-					1,
-					&byData1);
-	*pbyData = byData1;
+	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+			reg_off, reg, sizeof(u8), data);
+	return;
 }
 
-void ControlvMaskByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
-			BYTE byMask, BYTE byData)
+void ControlvMaskByte(struct vnt_private *pDevice, u8 reg_type, u8 reg_off,
+			u8 reg_mask, u8 data)
 {
-	BYTE	pbyData[2];
-	pbyData[0] = byData;
-	pbyData[1] = byMask;
-	CONTROLnsRequestOut(pDevice,
-				MESSAGE_TYPE_WRITE_MASK,
-				byRegOfs,
-				byRegType,
-				2,
-				pbyData);
+	u8 reg_data[2];
+
+	reg_data[0] = data;
+	reg_data[1] = reg_mask;
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE_MASK, reg_off,
+			reg_type, ARRAY_SIZE(reg_data), reg_data);
+
+	return;
 }
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index bbe610f..76ce024 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -51,28 +51,14 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-void ControlvWriteByte(
-     PSDevice pDevice,
-     BYTE byRegType,
-     BYTE byRegOfs,
-     BYTE byData
-    );
+void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
+			u8 data);
 
+void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
+			u8 *data);
 
-void ControlvReadByte(
-     PSDevice pDevice,
-     BYTE byRegType,
-     BYTE byRegOfs,
-     PBYTE pbyData
-    );
+void ControlvMaskByte(struct vnt_private *pDevice, u8 reg_type, u8 reg_off,
+			u8 reg_mask, u8 data);
 

-void ControlvMaskByte(
-     PSDevice pDevice,
-     BYTE byRegType,
-     BYTE byRegOfs,
-     BYTE byMask,
-     BYTE byData
-    );
-
 #endif /* __CONTROL_H__ */
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 8831ea0..93d7301 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -56,10 +56,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 /*---------------------  Export Functions  --------------------------*/
 

-BOOL
-FIRMWAREbDownload(
-     PSDevice pDevice
-    )
+int FIRMWAREbDownload(struct vnt_private *pDevice)
 {
 	struct device *dev = &pDevice->usb->dev;
 	const struct firmware *fw;
@@ -114,12 +111,9 @@ out:
 }
 MODULE_FIRMWARE(FIRMWARE_NAME);
 
-BOOL
-FIRMWAREbBrach2Sram(
-     PSDevice pDevice
-    )
+int FIRMWAREbBrach2Sram(struct vnt_private *pDevice)
 {
-    int NdisStatus;
+	int NdisStatus;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Branch to Sram\n");
 
@@ -139,10 +133,7 @@ FIRMWAREbBrach2Sram(
 }
 

-BOOL
-FIRMWAREbCheckVersion(
-     PSDevice pDevice
-    )
+int FIRMWAREbCheckVersion(struct vnt_private *pDevice)
 {
 	int ntStatus;
 
diff --git a/drivers/staging/vt6656/firmware.h b/drivers/staging/vt6656/firmware.h
index b2f5b58..ebab3a6 100644
--- a/drivers/staging/vt6656/firmware.h
+++ b/drivers/staging/vt6656/firmware.h
@@ -41,19 +41,8 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL
-FIRMWAREbDownload(
-     PSDevice pDevice
-    );
-
-BOOL
-FIRMWAREbBrach2Sram(
-     PSDevice pDevice
-    );
-
-BOOL
-FIRMWAREbCheckVersion(
-     PSDevice pDevice
-    );
+int FIRMWAREbDownload(struct vnt_private *);
+int FIRMWAREbBrach2Sram(struct vnt_private *);
+int FIRMWAREbCheckVersion(struct vnt_private *);
 
 #endif /* __FIRMWARE_H__ */
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 7718ac2..97c6896 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -75,9 +75,8 @@ static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
  *  if we've gotten no data
  *
 -*/
-void INTvWorkItem(void *Context)
+void INTvWorkItem(struct vnt_private *pDevice)
 {
-	PSDevice pDevice = Context;
 	int ntStatus;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
@@ -88,10 +87,10 @@ void INTvWorkItem(void *Context)
 	spin_unlock_irq(&pDevice->lock);
 }
 
-void INTnsProcessData(PSDevice pDevice)
+void INTnsProcessData(struct vnt_private *pDevice)
 {
 	PSINTData pINTData;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct net_device_stats *pStats = &pDevice->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index ffc243f..444b6c2 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -65,7 +65,7 @@ SINTData, *PSINTData;
 
 /*---------------------  Export Functions  --------------------------*/
 
-void INTvWorkItem(void *Context);
-void INTnsProcessData(PSDevice pDevice);
+void INTvWorkItem(struct vnt_private *);
+void INTnsProcessData(struct vnt_private *);
 
 #endif /* __INT_H__ */
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index fc68518..2a02067 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -67,51 +67,18 @@ static int          msglevel                =MSG_LEVEL_INFO;
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-static
-void
-s_nsInterruptUsbIoCompleteRead(
-     struct urb *urb
-    );
-
-
-static
-void
-s_nsBulkInUsbIoCompleteRead(
-     struct urb *urb
-    );
-
-
-static
-void
-s_nsBulkOutIoCompleteWrite(
-     struct urb *urb
-    );
-
-
-static
-void
-s_nsControlInUsbIoCompleteRead(
-     struct urb *urb
-    );
-
-static
-void
-s_nsControlInUsbIoCompleteWrite(
-     struct urb *urb
-    );
+static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
+static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
+static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
+static void s_nsControlInUsbIoCompleteRead(struct urb *urb);
+static void s_nsControlInUsbIoCompleteWrite(struct urb *urb);
 
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
 
-int PIPEnsControlOutAsyn(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-     PBYTE        pbyBuffer
-    )
+int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
+	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer)
 {
 	int ntStatus;
 
@@ -147,17 +114,11 @@ int PIPEnsControlOutAsyn(
     return ntStatus;
 }
 
-int PIPEnsControlOut(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-     PBYTE        pbyBuffer
-    )
+int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
+		u16 wIndex, u16 wLength, u8 *pbyBuffer)
 {
 	int ntStatus = 0;
-    int ii;
+	int ii;
 
     if (pDevice->Flags & fMP_DISCONNECTED)
         return STATUS_FAILURE;
@@ -206,17 +167,11 @@ int PIPEnsControlOut(
     return STATUS_SUCCESS;
 }
 
-int PIPEnsControlIn(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-       PBYTE   pbyBuffer
-    )
+int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
+	u16 wIndex, u16 wLength,  u8 *pbyBuffer)
 {
 	int ntStatus = 0;
-    int ii;
+	int ii;
 
     if (pDevice->Flags & fMP_DISCONNECTED)
         return STATUS_FAILURE;
@@ -263,13 +218,9 @@ int PIPEnsControlIn(
     return ntStatus;
 }
 
-static
-void
-s_nsControlInUsbIoCompleteWrite(
-     struct urb *urb
-    )
+static void s_nsControlInUsbIoCompleteWrite(struct urb *urb)
 {
-    PSDevice        pDevice;
+	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
 
 	pDevice = urb->context;
 	switch (urb->status) {
@@ -304,15 +255,11 @@ s_nsControlInUsbIoCompleteWrite(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-static
-void
-s_nsControlInUsbIoCompleteRead(
-     struct urb *urb
-    )
+
+static void s_nsControlInUsbIoCompleteRead(struct urb *urb)
 {
-    PSDevice        pDevice;
+	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
 
-	pDevice = urb->context;
 	switch (urb->status) {
 	case 0:
 		break;
@@ -345,9 +292,10 @@ s_nsControlInUsbIoCompleteRead(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-int PIPEnsInterruptRead(PSDevice pDevice)
+
+int PIPEnsInterruptRead(struct vnt_private *pDevice)
 {
-    int ntStatus = STATUS_FAILURE;
+	int ntStatus = STATUS_FAILURE;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartInterruptUsbRead()\n");
 
@@ -396,21 +344,16 @@ usb_fill_bulk_urb(pDevice->pInterruptURB,
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-static
-void
-s_nsInterruptUsbIoCompleteRead(
-     struct urb *urb
-    )
 
+static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 {
-    PSDevice        pDevice;
-    int ntStatus;
+	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
+	int ntStatus;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptUsbIoCompleteRead\n");
     //
     // The context given to IoSetCompletionRoutine is the receive buffer object
     //
-    pDevice = (PSDevice)urb->context;
 
     //
     // We have a number of cases:
@@ -483,10 +426,11 @@ s_nsInterruptUsbIoCompleteRead(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-int PIPEnsBulkInUsbRead(PSDevice pDevice, PRCB pRCB)
+
+int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, PRCB pRCB)
 {
 	int ntStatus = 0;
-    struct urb          *pUrb;
+	struct urb *pUrb;
 

     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartBulkInUsbRead\n");
@@ -543,19 +487,15 @@ int PIPEnsBulkInUsbRead(PSDevice pDevice, PRCB pRCB)
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-static
-void
-s_nsBulkInUsbIoCompleteRead(
-     struct urb *urb
-    )
 
+static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
-    PRCB    pRCB = (PRCB)urb->context;
-    PSDevice pDevice = (PSDevice)pRCB->pDevice;
-    unsigned long   bytesRead;
-    BOOL    bIndicateReceive = FALSE;
-    BOOL    bReAllocSkb = FALSE;
-    int status;
+	PRCB pRCB = (PRCB)urb->context;
+	struct vnt_private *pDevice = pRCB->pDevice;
+	unsigned long   bytesRead;
+	int bIndicateReceive = FALSE;
+	int bReAllocSkb = FALSE;
+	int status;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
     status = urb->status;
@@ -618,14 +558,11 @@ s_nsBulkInUsbIoCompleteRead(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-int
-PIPEnsSendBulkOut(
-      PSDevice pDevice,
-      PUSB_SEND_CONTEXT pContext
-    )
+
+int PIPEnsSendBulkOut(struct vnt_private *pDevice, PUSB_SEND_CONTEXT pContext)
 {
-    int status;
-    struct urb          *pUrb;
+	int status;
+	struct urb          *pUrb;
 


@@ -699,17 +636,14 @@ PIPEnsSendBulkOut(
  *               (IofCompleteRequest) to stop working on the irp.
  *
  */
-static
-void
-s_nsBulkOutIoCompleteWrite(
-     struct urb *urb
-    )
+
+static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
-    PSDevice            pDevice;
-    int status;
-    CONTEXT_TYPE        ContextType;
-    unsigned long               ulBufLen;
-    PUSB_SEND_CONTEXT   pContext;
+	struct vnt_private *pDevice;
+	int status;
+	CONTEXT_TYPE ContextType;
+	unsigned long ulBufLen;
+	PUSB_SEND_CONTEXT pContext;
 

     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index b367347..b302355 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -41,35 +41,15 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-int PIPEnsControlOut(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-     PBYTE        pbyBuffer
-    );
-
-int PIPEnsControlOutAsyn(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-     PBYTE        pbyBuffer
-    );
-
-int PIPEnsControlIn(
-     PSDevice     pDevice,
-     BYTE         byRequest,
-     WORD         wValue,
-     WORD         wIndex,
-     WORD         wLength,
-       PBYTE   pbyBuffer
-    );
-
-int PIPEnsInterruptRead(PSDevice pDevice);
-int PIPEnsBulkInUsbRead(PSDevice pDevice, PRCB pRCB);
-int PIPEnsSendBulkOut(PSDevice pDevice, PUSB_SEND_CONTEXT pContext);
+int PIPEnsControlOut(struct vnt_private *, u8 byRequest, u16 wValue,
+		u16 wIndex, u16 wLength, u8 *pbyBuffer);
+int PIPEnsControlOutAsyn(struct vnt_private *, u8 byRequest,
+	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer);
+int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
+	u16 wIndex, u16 wLength,  u8 *pbyBuffer);
+
+int PIPEnsInterruptRead(struct vnt_private *);
+int PIPEnsBulkInUsbRead(struct vnt_private *, PRCB pRCB);
+int PIPEnsSendBulkOut(struct vnt_private *, PUSB_SEND_CONTEXT pContext);
 
 #endif /* __USBPIPE_H__ */
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 3afbb61..569d1a7 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -67,10 +67,10 @@ static int msglevel = MSG_LEVEL_INFO;
  * Return Value:
  *
  */
-int wpa_set_keys(PSDevice pDevice, void *ctx)
+int wpa_set_keys(struct vnt_private *pDevice, void *ctx)
 {
 	struct viawget_wpa_param *param = ctx;
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	DWORD dwKeyIndex = 0;
 	BYTE abyKey[MAX_KEY_LEN];
 	BYTE abySeq[MAX_KEY_LEN];
diff --git a/drivers/staging/vt6656/wpactl.h b/drivers/staging/vt6656/wpactl.h
index b4ec6b0..2235ee9 100644
--- a/drivers/staging/vt6656/wpactl.h
+++ b/drivers/staging/vt6656/wpactl.h
@@ -52,6 +52,6 @@ typedef unsigned long long NDIS_802_11_KEY_RSC;
 
 /*---------------------  Export Functions  --------------------------*/
 
-int wpa_set_keys(PSDevice pDevice, void *ctx);
+int wpa_set_keys(struct vnt_private *, void *ctx);
 
 #endif /* __WPACL_H__ */
-- 
1.8.0




