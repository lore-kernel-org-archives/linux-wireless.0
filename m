Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52924 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaFYUVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:50 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so2621876wgh.31
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 27/34] staging: vt6656: remove old rx receive list
Date: Wed, 25 Jun 2014 21:20:04 +0100
Message-Id: <1403727611-6825-28-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223015_434183_ACD6AD7A)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 5 +----
 drivers/staging/vt6656/dpc.c      | 4 ++--
 drivers/staging/vt6656/main_usb.c | 2 --
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a145081..5be96ae9 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -245,7 +245,6 @@ struct vnt_rcb {
 	signed long Ref;
 	void *pDevice;
 	struct urb *pUrb;
-	struct vnt_rx_mgmt sMngPacket;
 	struct sk_buff *skb;
 	int bBoolInUse;
 };
@@ -454,9 +453,7 @@ struct vnt_private {
 	struct vnt_rcb *FirstRecvFreeList;
 	struct vnt_rcb *LastRecvFreeList;
 	u32 NumRecvFreeList;
-	struct vnt_rcb *FirstRecvMngList;
-	struct vnt_rcb *LastRecvMngList;
-	u32 NumRecvMngList;
+
 	int bIsRxWorkItemQueued;
 	int bIsRxMngWorkItemQueued;
 	unsigned long ulRcvRefCount; /* packets that have not returned back */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index ceeb3ee..5ac5bcd 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -108,8 +108,8 @@ void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
 		schedule_work(&priv->read_work_item);
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",
-			priv->NumRecvFreeList, priv->NumRecvMngList);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d\n",
+			priv->NumRecvFreeList);
 }
 
 int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 56bdf9d..66f9a54 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -634,8 +634,6 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 
 	priv->FirstRecvFreeList = NULL;
 	priv->LastRecvFreeList = NULL;
-	priv->FirstRecvMngList = NULL;
-	priv->LastRecvMngList = NULL;
 	priv->NumRecvFreeList = 0;
 
 	rcb = (struct vnt_rcb *)priv->pRCBMem;
-- 
1.9.1

