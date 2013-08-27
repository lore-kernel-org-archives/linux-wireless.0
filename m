Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61242 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3H0LcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:32:07 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1610078bkb.10
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 04:32:05 -0700 (PDT)
Message-ID: <1377603121.3320.84.camel@canaries32-MCP7A> (sfid-20130827_133211_422602_A05BD57A)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c s_vFillTxKey use switch for
 pTransmitKey->byCipherSuite
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 12:32:01 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b5a9c3a..411189d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -198,7 +198,8 @@ static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 	*pdwIV = pDevice->dwIVCounter;
 	pDevice->byKeyIndex = pTransmitKey->dwKeyIndex & 0xf;
 
-	if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
+	switch (pTransmitKey->byCipherSuite) {
+	case KEY_CTL_WEP:
 		if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN) {
 			memcpy(pDevice->abyPRNG, (u8 *)&dwRevIVCounter, 3);
 			memcpy(pDevice->abyPRNG + 3, pTransmitKey->abyKey,
@@ -223,7 +224,9 @@ static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 		pDevice->dwIVCounter++;
 		if (pDevice->dwIVCounter > WEP_IV_MASK)
 			pDevice->dwIVCounter = 0;
-	} else if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
+
+		break;
+	case KEY_CTL_TKIP:
 		pTransmitKey->wTSC15_0++;
 		if (pTransmitKey->wTSC15_0 == 0)
 			pTransmitKey->dwTSC47_16++;
@@ -244,7 +247,8 @@ static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"vFillTxKey()---- pdwExtIV: %x\n", *pdwExtIV);
 
-	} else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
+		break;
+	case KEY_CTL_CCMP:
 		pTransmitKey->wTSC15_0++;
 		if (pTransmitKey->wTSC15_0 == 0)
 			pTransmitKey->dwTSC47_16++;
-- 
1.8.1.2

