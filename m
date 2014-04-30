Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:57106 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbaD3UdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 16:33:03 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so2207278wes.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 13:33:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6656: desh.h Remove unused macros and structures.
Date: Wed, 30 Apr 2014 21:31:13 +0100
Message-Id: <1398889875-3312-2-git-send-email-tvboxspy@gmail.com> (sfid-20140430_223309_312555_BC3EDBB8)
In-Reply-To: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com>
References: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All are dead and of no use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 55 -------------------------------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 7c6dd5f..171315a 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -91,15 +91,6 @@
 #define TSR_ACKDATA         0x02
 #define TSR_VALID           0x01
 
-#define CB_PROTOCOL_RESERVED_SECTION    16
-
-/*
- * if retries exceed 15 times, TX will abort, and
- * if TX fifo underflow, TX will fail
- * we should try to resend it
- */
-#define CB_MAX_TX_ABORT_RETRY   3
-
 #define FIFOCTL_AUTO_FB_1   0x1000
 #define FIFOCTL_AUTO_FB_0   0x0800
 #define FIFOCTL_GRPACK      0x0400
@@ -126,50 +117,4 @@
 #define FRAGCTL_STAFRAG     0x0001
 #define FRAGCTL_NONFRAG     0x0000
 
-#define TYPE_TXDMA0     0
-#define TYPE_AC0DMA     1
-#define TYPE_ATIMDMA    2
-#define TYPE_SYNCDMA    3
-#define TYPE_MAXTD      2
-
-#define TYPE_BEACONDMA  4
-
-#define TYPE_RXDMA0     0
-#define TYPE_RXDMA1     1
-#define TYPE_MAXRD      2
-
-/* TD_INFO flags control bit */
-#define TD_FLAGS_NETIF_SKB 0x01 /* check if need release skb */
-#define TD_FLAGS_PRIV_SKB  0x02 /* check if called from private skb(hostap) */
-#define TD_FLAGS_PS_RETRY  0x04 /* check if PS STA frame re-transmit */
-
-/*
- * TX FIFO header
- */
-typedef struct tagSBEACONCtl {
-	u32 BufReady:1;
-	u32 TSF:15;
-	u32 BufLen:11;
-	u32 Reserved:5;
-} __attribute__ ((__packed__))
-SBEACONCtl;
-
-typedef struct tagSSecretKey {
-	u32 dwLowDword;
-    u8    byHighByte;
-} __attribute__ ((__packed__))
-SSecretKey;
-
-typedef struct tagSKeyEntry {
-    u8  abyAddrHi[2];
-    u16  wKCTL;
-    u8  abyAddrLo[4];
-	u32 dwKey0[4];
-	u32 dwKey1[4];
-	u32 dwKey2[4];
-	u32 dwKey3[4];
-	u32 dwKey4[4];
-} __attribute__ ((__packed__))
-SKeyEntry;
-
 #endif /* __DESC_H__ */
-- 
1.9.1

