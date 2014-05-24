Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35469 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXNiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:07 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so2120243wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/14] staging: vt6656: CARDqGetTSFOffset remove camel case
Date: Sat, 24 May 2014 14:37:00 +0100
Message-Id: <1400938630-2850-4-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153819_208587_0488A785)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
byRxRate -> rx_rate
qwTSF1 -> tsf1
qwTSF2 -> tsf2
qwTSFOffset -> tsf_offset
wRxBcnTSFOffst -> rx_bcn_offset

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index e39bdd5..8d12ae9 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -551,27 +551,27 @@ u8 CARDbyGetPktType(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be sync.
- *      qwTSF1          - Rx BCN's TSF
- *      qwTSF2          - Local TSF
+ *      rx_rate	- rx rate.
+ *      tsf1	- Rx BCN's TSF
+ *      tsf2	- Local TSF
  *  Out:
  *      none
  *
  * Return Value: TSF Offset value
  *
  */
-u64 CARDqGetTSFOffset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2)
+u64 CARDqGetTSFOffset(u8 rx_rate, u64 tsf1, u64 tsf2)
 {
-	u64 qwTSFOffset = 0;
-	u16 wRxBcnTSFOffst = 0;
+	u64 tsf_offset = 0;
+	u16 rx_bcn_offset = 0;
 
-	wRxBcnTSFOffst = cwRXBCNTSFOff[byRxRate % MAX_RATE];
+	rx_bcn_offset = cwRXBCNTSFOff[rx_rate % MAX_RATE];
 
-	qwTSF2 += (u64)wRxBcnTSFOffst;
+	tsf2 += (u64)rx_bcn_offset;
 
-	qwTSFOffset = qwTSF1 - qwTSF2;
+	tsf_offset = tsf1 - tsf2;
 
-	return qwTSFOffset;
+	return tsf_offset;
 }
 
 /*
-- 
1.9.1

