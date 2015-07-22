Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35377 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbGVSR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:56 -0400
Received: by wibxm9 with SMTP id xm9so175097270wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/15] staging: vt6655: fix tagTDES1 -> wReqCount type
Date: Wed, 22 Jul 2015 19:16:44 +0100
Message-Id: <1437589007-5479-12-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201800_587837_3946B218)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

should be __le16

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index f6563d3..2374fa5 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -245,7 +245,7 @@ STDES0;
 #endif
 
 typedef struct tagTDES1 {
-	volatile    unsigned short wReqCount;
+	volatile    __le16        wReqCount;
 	volatile    unsigned char byTCR;
 	volatile    unsigned char byReserved;
 } __attribute__ ((__packed__))
-- 
2.1.4

