Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63793 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJYT5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:57:33 -0400
Received: by mail-wg0-f44.google.com with SMTP id y10so3091411wgg.3
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:57:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 31/31] staging: vt6655: fifo & frag control remove big endian values
Date: Sat, 25 Oct 2014 09:20:41 +0100
Message-Id: <1414225241-5480-32-git-send-email-tvboxspy@gmail.com> (sfid-20141025_215735_971702_1104D9EC)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endian conversion now happens at run time only little endian
values are valid.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index b972645..ba735ea 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -124,37 +124,7 @@
 // we should try to resend it
 #define CB_MAX_TX_ABORT_RETRY   3
 
-#ifdef __BIG_ENDIAN
-
-// WMAC definition FIFO Control
-#define FIFOCTL_AUTO_FB_1   0x0010
-#define FIFOCTL_AUTO_FB_0   0x0008
-#define FIFOCTL_GRPACK      0x0004
-#define FIFOCTL_11GA        0x0003
-#define FIFOCTL_11GB        0x0002
-#define FIFOCTL_11B         0x0001
-#define FIFOCTL_11A         0x0000
-#define FIFOCTL_RTS         0x8000
-#define FIFOCTL_ISDMA0      0x4000
-#define FIFOCTL_GENINT      0x2000
-#define FIFOCTL_TMOEN       0x1000
-#define FIFOCTL_LRETRY      0x0800
-#define FIFOCTL_CRCDIS      0x0400
-#define FIFOCTL_NEEDACK     0x0200
-#define FIFOCTL_LHEAD       0x0100
-
-//WMAC definition Frag Control
-#define FRAGCTL_AES         0x0003
-#define FRAGCTL_TKIP        0x0002
-#define FRAGCTL_LEGACY      0x0001
-#define FRAGCTL_NONENCRYPT  0x0000
-#define FRAGCTL_ENDFRAG     0x0300
-#define FRAGCTL_MIDFRAG     0x0200
-#define FRAGCTL_STAFRAG     0x0100
-#define FRAGCTL_NONFRAG     0x0000
-
-#else
-
+/* WMAC definition FIFO Control */
 #define FIFOCTL_AUTO_FB_1   0x1000
 #define FIFOCTL_AUTO_FB_0   0x0800
 #define FIFOCTL_GRPACK      0x0400
@@ -171,7 +141,7 @@
 #define FIFOCTL_NEEDACK     0x0002
 #define FIFOCTL_LHEAD       0x0001
 
-//WMAC definition Frag Control
+/* WMAC definition Frag Control */
 #define FRAGCTL_AES         0x0300
 #define FRAGCTL_TKIP        0x0200
 #define FRAGCTL_LEGACY      0x0100
@@ -181,8 +151,6 @@
 #define FRAGCTL_STAFRAG     0x0001
 #define FRAGCTL_NONFRAG     0x0000
 
-#endif
-
 #define TYPE_TXDMA0     0
 #define TYPE_AC0DMA     1
 #define TYPE_ATIMDMA    2
-- 
1.9.1

