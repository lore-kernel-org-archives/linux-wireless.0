Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50862 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3JNSvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 14:51:53 -0400
Received: by mail-wi0-f175.google.com with SMTP id hm4so1631171wib.14
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 11:51:52 -0700 (PDT)
Message-ID: <1381776705.2470.4.camel@canaries32-MCP7A> (sfid-20131014_205156_759999_24E4E896)
Subject: [PATCH] staging: vt6656: return from workqueues on fMP_DISCONNECTED
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 19:51:45 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return from work queues on flag fMP_DISCONNECTED to prevent
any scheduling threads past closing of device.  

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 3 +++
 drivers/staging/vt6656/dpc.c   | 6 ++++++
 drivers/staging/vt6656/wcmd.c  | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index ef654c0..dad3f8c 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -825,6 +825,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 	u32 uNonShortSlotSTACnt = 0;
 	u32 uLongPreambleSTACnt = 0;
 
+	if (pDevice->Flags & fMP_DISCONNECTED)
+		return;
+
     spin_lock_irq(&pDevice->lock);
 
     pDevice->uAssocCount = 0;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 82d7c1d..75dc92d 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1339,6 +1339,9 @@ void RXvWorkItem(struct work_struct *work)
 	int ntStatus;
 	struct vnt_rcb *pRCB = NULL;
 
+	if (pDevice->Flags & fMP_DISCONNECTED)
+		return;
+
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
     spin_lock_irq(&pDevice->lock);
 
@@ -1398,6 +1401,9 @@ void RXvMngWorkItem(struct work_struct *work)
 	struct vnt_rx_mgmt *pRxPacket;
 	int bReAllocSkb = false;
 
+	if (pDevice->Flags & fMP_DISCONNECTED)
+		return;
+
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
 
     spin_lock_irq(&pDevice->lock);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 4f45a7f..2f8e2a8 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -286,6 +286,9 @@ void vRunCommand(struct work_struct *work)
 	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
 	u8 byData;
 
+	if (pDevice->Flags & fMP_DISCONNECTED)
+		return;
+
     if (pDevice->dwDiagRefCount != 0)
         return;
     if (pDevice->bCmdRunning != true)
-- 
1.8.3.2

