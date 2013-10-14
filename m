Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42842 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3JNSoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 14:44:22 -0400
Received: by mail-wi0-f177.google.com with SMTP id ey11so2229102wid.16
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 11:44:21 -0700 (PDT)
Message-ID: <1381776253.2470.1.camel@canaries32-MCP7A> (sfid-20131014_204425_200751_CD82C6D2)
Subject: [PATCH] staging: vt6656: return if pControlURB->hcpriv not NULL
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 19:44:13 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes occasional urb submitted while active.

Even thought the fMP_CONTROL_WRITES/fMP_CONTROL_READS flags
are cleared in the return context urb->hcpriv is not NULL.

check for hcpriv and return STATUS_FAILURE if not NULL.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 3a03f1d..37bcb18 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -118,6 +118,9 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 	if (pDevice->Flags & fMP_CONTROL_READS)
 		return STATUS_FAILURE;
 
+	if (pDevice->pControlURB->hcpriv)
+		return STATUS_FAILURE;
+
 	MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
 
 	pDevice->sUsbCtlRequest.bRequestType = 0x40;
@@ -177,6 +180,9 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 	if (pDevice->Flags & fMP_CONTROL_WRITES)
 		return STATUS_FAILURE;
 
+	if (pDevice->pControlURB->hcpriv)
+		return STATUS_FAILURE;
+
 	MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
 
 	pDevice->sUsbCtlRequest.bRequestType = 0xC0;
-- 
1.8.3.2

