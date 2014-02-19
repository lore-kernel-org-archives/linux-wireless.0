Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62981 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaBSSjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:39:22 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so4354349wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:39:21 -0800 (PST)
Message-ID: <1392835149.8766.12.camel@canaries64-MCP7A> (sfid-20140219_193926_065952_DE0523B2)
Subject: [PATCH 4/4] staging: vt6656: Replace typedef struct INT_BUFFER,
 *PINT_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 18:39:09 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_interrupt_buffer.

Using only the live member of old structure
pDataBuf -> data_buf
bInUse -> in_use

uDataLen is unused and dropped.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 12 +++++-------
 drivers/staging/vt6656/int.c      |  6 +++---
 drivers/staging/vt6656/main_usb.c |  8 ++++----
 drivers/staging/vt6656/usbpipe.c  | 14 +++++++-------
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e5f0be3..33e5e34 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -206,12 +206,10 @@ typedef struct _DEFAULT_CONFIG {
 /*
  * Structure to keep track of USB interrupt packets
  */
-typedef struct {
-    unsigned int            uDataLen;
-    u8 *           pDataBuf;
-  /* struct urb *pUrb; */
-    bool            bInUse;
-} INT_BUFFER, *PINT_BUFFER;
+struct vnt_interrupt_buffer {
+	u8 *data_buf;
+	bool in_use;
+};
 
 /*++ NDIS related */
 
@@ -420,7 +418,7 @@ struct vnt_private {
 	struct vnt_tx_pkt_info pkt_info[16];
 
 	/* Variables to track resources for the Interrupt In Pipe */
-	INT_BUFFER intBuf;
+	struct vnt_interrupt_buffer int_buf;
 	int bEventAvailable;
 
 	/* default config from file by user setting */
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 34c4528..cca56b2 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -84,7 +84,7 @@ void INTnsProcessData(struct vnt_private *priv)
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
 
-	int_data = (struct vnt_interrupt_data *)priv->intBuf.pDataBuf;
+	int_data = (struct vnt_interrupt_data *)priv->int_buf.data_buf;
 
 	if (int_data->tsr0 & TSR_VALID) {
 		if (int_data->tsr0 & (TSR_TMO | TSR_RETRYTMO))
@@ -178,8 +178,8 @@ void INTnsProcessData(struct vnt_private *priv)
 			bScheduleCommand((void *) priv,
 					WLAN_CMD_RADIO,
 					NULL);
-	priv->intBuf.uDataLen = 0;
-	priv->intBuf.bInUse = false;
+
+	priv->int_buf.in_use = false;
 
 	stats->tx_errors = priv->wstats.discard.retries;
 	stats->tx_dropped = priv->wstats.discard.retries;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index bea1ad9..713844f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -800,8 +800,8 @@ static void usb_device_reset(struct vnt_private *pDevice)
 
 static void device_free_int_bufs(struct vnt_private *pDevice)
 {
-    kfree(pDevice->intBuf.pDataBuf);
-    return;
+	kfree(pDevice->int_buf.data_buf);
+	return;
 }
 
 static bool device_alloc_bufs(struct vnt_private *pDevice)
@@ -873,8 +873,8 @@ static bool device_alloc_bufs(struct vnt_private *pDevice)
 	    goto free_rx_tx;
 	}
 
-    pDevice->intBuf.pDataBuf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
-	if (pDevice->intBuf.pDataBuf == NULL) {
+    pDevice->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
+	if (pDevice->int_buf.data_buf == NULL) {
 	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int buf\n");
 	    usb_free_urb(pDevice->pInterruptURB);
 	    goto free_rx_tx;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9f4d1a2..79e38b7 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -302,16 +302,16 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"---->s_nsStartInterruptUsbRead()\n");
 
-	if (priv->intBuf.bInUse == true)
+	if (priv->int_buf.in_use == true)
 		return STATUS_FAILURE;
 
-	priv->intBuf.bInUse = true;
+	priv->int_buf.in_use = true;
 	priv->ulIntInPosted++;
 
 	usb_fill_int_urb(priv->pInterruptURB,
 		priv->usb,
 		usb_rcvbulkpipe(priv->usb, 1),
-		priv->intBuf.pDataBuf,
+		priv->int_buf.data_buf,
 		MAX_INTERRUPT_SIZE,
 		s_nsInterruptUsbIoCompleteRead,
 		priv,
@@ -321,7 +321,7 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 	if (status) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Submit int URB failed %d\n", status);
-		priv->intBuf.bInUse = false;
+		priv->int_buf.in_use = false;
 	}
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -360,7 +360,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		priv->intBuf.bInUse = false;
+		priv->int_buf.in_use = false;
 		return;
 	default:
 		break;
@@ -373,7 +373,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 
 	if (status != STATUS_SUCCESS) {
 		priv->ulBulkInError++;
-		priv->intBuf.bInUse = false;
+		priv->int_buf.in_use = false;
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"IntUSBIoCompleteControl STATUS = %d\n", status);
@@ -389,7 +389,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Submit int URB failed %d\n", status);
 	} else {
-		priv->intBuf.bInUse = true;
+		priv->int_buf.in_use = true;
 	}
 
 	return;
-- 
1.9.rc1


