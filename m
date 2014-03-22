Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50947 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCVJCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:18 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so1139638wib.8
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/10] staging: vt6656: rxtx.c: s_vFillTxKey Replace dwRevIVCounter
Date: Sat, 22 Mar 2014 09:01:23 +0000
Message-Id: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100222_909237_0CBBF86F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le32 and remove camel case.

Camel case change
dwRevIVCounter -> rev_iv_counter

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3840323..9f80a7a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -184,28 +184,28 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 	u32 *pdwIV = (u32 *)pbyIVHead;
 	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
-	u32 dwRevIVCounter;
+	__le32 rev_iv_counter;
 
 	/* Fill TXKEY */
 	if (pTransmitKey == NULL)
 		return;
 
-	dwRevIVCounter = cpu_to_le32(pDevice->dwIVCounter);
+	rev_iv_counter = cpu_to_le32(pDevice->dwIVCounter);
 	*pdwIV = pDevice->dwIVCounter;
 	pDevice->byKeyIndex = pTransmitKey->dwKeyIndex & 0xf;
 
 	switch (pTransmitKey->byCipherSuite) {
 	case KEY_CTL_WEP:
 		if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN) {
-			memcpy(pDevice->abyPRNG, (u8 *)&dwRevIVCounter, 3);
+			memcpy(pDevice->abyPRNG, (u8 *)&rev_iv_counter, 3);
 			memcpy(pDevice->abyPRNG + 3, pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 		} else {
-			memcpy(pbyBuf, (u8 *)&dwRevIVCounter, 3);
+			memcpy(pbyBuf, (u8 *)&rev_iv_counter, 3);
 			memcpy(pbyBuf + 3, pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 			if (pTransmitKey->uKeyLength == WLAN_WEP40_KEYLEN) {
-				memcpy(pbyBuf+8, (u8 *)&dwRevIVCounter, 3);
+				memcpy(pbyBuf+8, (u8 *)&rev_iv_counter, 3);
 			memcpy(pbyBuf+11, pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 			}
-- 
1.9.0

