Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41542 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaEQIxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:03 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2005737wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/22] staging: vt6656: srom.h : Remove dead code.
Date: Sat, 17 May 2014 09:50:27 +0100
Message-Id: <1400316639-4430-10-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112147_476230_59F9845E)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove macros and unused strutures.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/srom.h | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/vt6656/srom.h b/drivers/staging/vt6656/srom.h
index 488192d..ce61ab4 100644
--- a/drivers/staging/vt6656/srom.h
+++ b/drivers/staging/vt6656/srom.h
@@ -32,10 +32,6 @@
 
 #define EEP_MAX_CONTEXT_SIZE    256
 
-#define CB_EEPROM_READBYTE_WAIT 900     //us
-
-#define W_MAX_I2CRETRY          0x0fff
-
 //
 // Contents in the EEPROM
 //
@@ -75,38 +71,4 @@
 //
 #define EEP_RADIOCTL_ENABLE 0x80
 
-// AT24C02 eeprom contents
-//      2048 bits = 256 bytes = 128 words
-//
-typedef struct tagSSromReg {
-    u8    abyPAR[6];                  // 0x00 (u16)
-
-    u16    wSUB_VID;                   // 0x03 (u16)
-    u16    wSUB_SID;
-
-    u8    byBCFG0;                    // 0x05 (u16)
-    u8    byBCFG1;
-
-    u8    byFCR0;                     // 0x06 (u16)
-    u8    byFCR1;
-    u8    byPMC0;                     // 0x07 (u16)
-    u8    byPMC1;
-    u8    byMAXLAT;                   // 0x08 (u16)
-    u8    byMINGNT;
-    u8    byCFG0;                     // 0x09 (u16)
-    u8    byCFG1;
-    u16    wCISPTR;                    // 0x0A (u16)
-    u16    wRsv0;                      // 0x0B (u16)
-    u16    wRsv1;                      // 0x0C (u16)
-    u8    byBBPAIR;                   // 0x0D (u16)
-    u8    byRFTYPE;
-    u8    byMinChannel;               // 0x0E (u16)
-    u8    byMaxChannel;
-    u8    bySignature;                // 0x0F (u16)
-    u8    byCheckSum;
-
-    u8    abyReserved0[96];           // 0x10 (u16)
-    u8    abyCIS[128];                // 0x80 (u16)
-} SSromReg, *PSSromReg;
-
 #endif /* __EEPROM_H__ */
-- 
1.9.1

