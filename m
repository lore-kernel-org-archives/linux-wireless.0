Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38726 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaGRFhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:21 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so2954042wgh.33
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/9] staging: vt6656: struct vnt_rcb remove unused members
Date: Fri, 18 Jul 2014 06:36:10 +0100
Message-Id: <1405661776-3345-3-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073729_122962_B945BA45)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove Next and Ref

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 2 --
 drivers/staging/vt6656/usbpipe.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f08f7de..ad43c6f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -219,8 +219,6 @@ enum {
 
 /* RCB (Receive Control Block) */
 struct vnt_rcb {
-	void *Next;
-	signed long Ref;
 	void *pDevice;
 	struct urb *pUrb;
 	struct sk_buff *skb;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 59e508c..d994b1b 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -207,7 +207,6 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 		return STATUS_FAILURE ;
 	}
 
-	rcb->Ref = 1;
 	rcb->bBoolInUse = true;
 
 	return status;
-- 
2.0.1

