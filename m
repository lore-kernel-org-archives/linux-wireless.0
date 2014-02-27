Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48217 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaB0XHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:18 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so3452159wgh.6
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:17 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/7] staging: vt6656: Remove unused variables packets*
Date: Thu, 27 Feb 2014 23:06:13 +0000
Message-Id: <1393542375-13110-5-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000728_119163_9EC9B282)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These variables are unused and don't reach user.

Remove them all.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 5 -----
 drivers/staging/vt6656/usbpipe.c | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 1124aa4..1aad3d3 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -441,11 +441,6 @@ struct vnt_private {
 	int bExistSWNetAddr;
 
 	/* Maintain statistical debug info. */
-	unsigned long packetsReceived;
-	unsigned long packetsReceivedDropped;
-	unsigned long packetsReceivedOverflow;
-	unsigned long packetsSent;
-	unsigned long packetsSentDropped;
 	unsigned long SendContextsInUse;
 	unsigned long RcvBuffersInUse;
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 5ce583e..fb9200e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -627,14 +627,10 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 
 		priv->dev->trans_start = jiffies;
 
-		if (status == STATUS_SUCCESS) {
-			priv->packetsSent++;
-		} else {
+		if (status != STATUS_SUCCESS) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"Send USB error! [%08xh]\n", status);
-			priv->packetsSentDropped++;
 		}
-
 	}
 
 	if (priv->bLinkPass == true) {
-- 
1.9.0

