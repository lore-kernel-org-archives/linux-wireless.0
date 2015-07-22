Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37255 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbGVSRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:49 -0400
Received: by wibud3 with SMTP id ud3so184806030wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:48 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/15] staging: vt6655: fix tagSTxDesc -> next_desc type
Date: Wed, 22 Jul 2015 19:16:39 +0100
Message-Id: <1437589007-5479-7-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201813_686117_6120CB79)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should always be __le32 type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 8dc53bd..26cd3e1 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -267,7 +267,7 @@ typedef struct tagSTxDesc {
 	volatile    STDES0  m_td0TD0;
 	volatile    STDES1  m_td1TD1;
 	volatile    __le32  buff_addr;
-	volatile    u32    next_desc;
+	volatile    __le32  next_desc;
 	struct tagSTxDesc *next __aligned(8);
 	volatile    PDEVICE_TD_INFO pTDInfo __aligned(8);
 } __attribute__ ((__packed__))
-- 
2.1.4

