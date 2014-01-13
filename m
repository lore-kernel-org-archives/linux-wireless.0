Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63027 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaAMQ31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:29:27 -0500
Received: by mail-wi0-f169.google.com with SMTP id e4so1382566wiv.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:29:25 -0800 (PST)
Message-ID: <1389630555.2590.6.camel@canaries32-MCP7A> (sfid-20140113_172937_639990_1B187FA1)
Subject: [PATCH 6/6] staging: vt6656: sparse fixes: aes_ccmp.c missing
 header.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:29:15 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing aes_ccmp.h header and move device.h to
aes_ccmp.h

sparse warning
aes_ccmp.c:221:6: warning: symbol 'AESbGenCCMP' was not declared. Should it be static?

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/aes_ccmp.c | 2 +-
 drivers/staging/vt6656/aes_ccmp.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
index 61b9f7b..3dbf458 100644
--- a/drivers/staging/vt6656/aes_ccmp.c
+++ b/drivers/staging/vt6656/aes_ccmp.c
@@ -30,7 +30,7 @@
  * Revision History:
  */
 
-#include "device.h"
+#include "aes_ccmp.h"
 #include "80211hdr.h"
 
 /*
diff --git a/drivers/staging/vt6656/aes_ccmp.h b/drivers/staging/vt6656/aes_ccmp.h
index ed6a9ae..4cac3ec 100644
--- a/drivers/staging/vt6656/aes_ccmp.h
+++ b/drivers/staging/vt6656/aes_ccmp.h
@@ -30,6 +30,8 @@
 #ifndef __AES_H__
 #define __AES_H__
 
+#include "device.h"
+
 bool AESbGenCCMP(u8 * pbyRxKey, u8 * pbyFrame, u16 wFrameSize);
 
 #endif /* __AES_CCMP_H__ */
-- 
1.8.5.2

