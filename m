Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57961 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaBPTIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 14:08:54 -0500
Received: by mail-wg0-f48.google.com with SMTP id a1so1639960wgh.15
        for <linux-wireless@vger.kernel.org>; Sun, 16 Feb 2014 11:08:53 -0800 (PST)
Message-ID: <1392577701.3430.8.camel@canaries64-MCP7A> (sfid-20140216_200858_467696_73922A4A)
Subject: [PATCH  1/3] staging: vt6656: int.h correct endian type
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 16 Feb 2014 19:08:21 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endian type u64 qwTSF Change to new base type __le64 tsf

In INTnsProcessData use le64_to_cpu for qwCurrTSF.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 2 +-
 drivers/staging/vt6656/int.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index d12036a..22d1ef5 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -167,7 +167,7 @@ void INTnsProcessData(struct vnt_private *pDevice)
 							NULL);
 			}
 		}
-		pDevice->qwCurrTSF = cpu_to_le64(pINTData->qwTSF);
+		pDevice->qwCurrTSF = le64_to_cpu(pINTData->tsf);
 		/*DBG_PRN_GRP01(("ISR0 = %02x ,
 		  LoTsf =  %08x,
 		  HiTsf =  %08x\n",
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 8e6e217..7ce6efc 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -45,7 +45,7 @@ typedef struct tagSINTData {
 	u8 byTSR3;
 	u8 byPkt3;
 	u16 wTime3;
-	u64 qwTSF;
+	__le64 tsf;
 	u8 byISR0;
 	u8 byISR1;
 	u8 byRTSSuccess;
-- 
1.9.rc1

