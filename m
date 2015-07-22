Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38816 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbGVSRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:54 -0400
Received: by wibxm9 with SMTP id xm9so114887002wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/15] staging: vt6655: fix tagSRxDesc -> next_desc type
Date: Wed, 22 Jul 2015 19:16:42 +0100
Message-Id: <1437589007-5479-10-git-send-email-tvboxspy@gmail.com> (sfid-20150722_203715_592461_A3298BF0)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should always be __le32

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 42e005a..251f7bc 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -209,7 +209,7 @@ typedef struct tagSRxDesc {
 	volatile SRDES0 m_rd0RD0;
 	volatile SRDES1 m_rd1RD1;
 	volatile __le32 buff_addr;
-	volatile u32    next_desc;
+	volatile __le32 next_desc;
 	struct tagSRxDesc *next __aligned(8);
 	volatile PDEVICE_RD_INFO pRDInfo __aligned(8);
 } __attribute__ ((__packed__))
-- 
2.1.4

