Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37317 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbGVSRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:52 -0400
Received: by wibud3 with SMTP id ud3so184807848wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/15] staging: vt6655: Fix tagSRxDesc -> buff_addr type
Date: Wed, 22 Jul 2015 19:16:41 +0100
Message-Id: <1437589007-5479-9-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201759_096841_CBF4A640)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should always be __le32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 3302d0182..42e005a 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -208,7 +208,7 @@ SRDES1;
 typedef struct tagSRxDesc {
 	volatile SRDES0 m_rd0RD0;
 	volatile SRDES1 m_rd1RD1;
-	volatile u32    buff_addr;
+	volatile __le32 buff_addr;
 	volatile u32    next_desc;
 	struct tagSRxDesc *next __aligned(8);
 	volatile PDEVICE_RD_INFO pRDInfo __aligned(8);
-- 
2.1.4

