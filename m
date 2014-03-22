Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:43159 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaCVJCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:23 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so2168144wes.37
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/10] staging: vt6656: rxtx s_vFillTxKey Fix pdwIV base type
Date: Sat, 22 Mar 2014 09:01:24 +0000
Message-Id: <1395478892-3419-2-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100227_221737_8EFBF5AA)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use base type __le32 and endian correct changed values.

Correct endian conversions to cpu_to_le32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9f80a7a..f2f96ee 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -181,7 +181,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 	struct vnt_mic_hdr *mic_hdr)
 {
 	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
-	u32 *pdwIV = (u32 *)pbyIVHead;
+	__le32 *pdwIV = (__le32 *)pbyIVHead;
 	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
 	__le32 rev_iv_counter;
@@ -191,7 +191,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 		return;
 
 	rev_iv_counter = cpu_to_le32(pDevice->dwIVCounter);
-	*pdwIV = pDevice->dwIVCounter;
+	*pdwIV = cpu_to_le32(pDevice->dwIVCounter);
 	pDevice->byKeyIndex = pTransmitKey->dwKeyIndex & 0xf;
 
 	switch (pTransmitKey->byCipherSuite) {
@@ -213,9 +213,8 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 			memcpy(pDevice->abyPRNG, pbyBuf, 16);
 		}
 		/* Append IV after Mac Header */
-		*pdwIV &= WEP_IV_MASK;
-		*pdwIV |= (u32)pDevice->byKeyIndex << 30;
-		*pdwIV = cpu_to_le32(*pdwIV);
+		*pdwIV &= cpu_to_le32(WEP_IV_MASK);
+		*pdwIV |= cpu_to_le32((u32)pDevice->byKeyIndex << 30);
 
 		pDevice->dwIVCounter++;
 		if (pDevice->dwIVCounter > WEP_IV_MASK)
@@ -256,7 +255,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 		*(pbyIVHead+3) = (u8)(((pDevice->byKeyIndex << 6) &
 							0xc0) | 0x20);
 
-		*pdwIV |= cpu_to_le16((u16)(pTransmitKey->wTSC15_0));
+		*pdwIV |= cpu_to_le32((u32)(pTransmitKey->wTSC15_0));
 
 		/* Append IV&ExtIV after Mac Header */
 		*pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
-- 
1.9.0

