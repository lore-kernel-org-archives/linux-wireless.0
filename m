Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33358 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbGVSRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:46 -0400
Received: by wicmv11 with SMTP id mv11so92401858wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/15] staging: vt6655: Remove unused tagDEVICE_TD_INFO curr_desc
Date: Wed, 22 Jul 2015 19:16:37 +0100
Message-Id: <1437589007-5479-5-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201752_439915_120F4B7A)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable is assigned a value that is never used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 1 -
 drivers/staging/vt6655/device_main.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index d568101..485c6fd 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -257,7 +257,6 @@ typedef struct tagDEVICE_TD_INFO {
 	struct sk_buff *skb;
 	unsigned char *buf;
 	dma_addr_t          buf_dma;
-	dma_addr_t          curr_desc;
 	unsigned long dwReqCount;
 	unsigned long dwHeaderLength;
 	unsigned char byFlags;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 89611a7..7409ed2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -711,7 +711,6 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD0Rings[(i+1) % pDevice->sOpts.nTxDescs[0]]);
-		pDesc->pTDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
 	}
 
@@ -737,7 +736,6 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD1Rings[(i + 1) % pDevice->sOpts.nTxDescs[1]]);
-		pDesc->pTDInfo->curr_desc = cpu_to_le32(curr);
 		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
 	}
 
-- 
2.1.4

