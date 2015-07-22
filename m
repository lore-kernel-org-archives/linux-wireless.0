Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36484 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbGVSRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:50 -0400
Received: by wicgb10 with SMTP id gb10so109874627wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/15] staging: vt6655: remove unused tagDEVICE_RD_INFO -> curr_desc
Date: Wed, 22 Jul 2015 19:16:40 +0100
Message-Id: <1437589007-5479-8-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201756_906795_3ED89B18)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

variable is assigned a value that is never used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 1 -
 drivers/staging/vt6655/device_main.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 26cd3e1..3302d0182 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -170,7 +170,6 @@
 typedef struct tagDEVICE_RD_INFO {
 	struct sk_buff *skb;
 	dma_addr_t  skb_dma;
-	dma_addr_t  curr_desc;
 } DEVICE_RD_INFO,   *PDEVICE_RD_INFO;
 
 #ifdef __BIG_ENDIAN
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 7409ed2..c82bf48 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -628,7 +628,6 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
 		pDesc->next = &(pDevice->aRD0Ring[(i+1) % pDevice->sOpts.nRxDescs0]);
-		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
 	}
 
@@ -652,7 +651,6 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
 		pDesc->next = &(pDevice->aRD1Ring[(i+1) % pDevice->sOpts.nRxDescs1]);
-		pDesc->pRDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
 	}
 
-- 
2.1.4

