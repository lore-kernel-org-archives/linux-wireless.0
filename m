Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41112 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKFUCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:41 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so2599207wid.16
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:40 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: Fix issue of byPacketType is not set at all.
Date: Thu,  6 Nov 2014 20:02:05 +0000
Message-Id: <1415304125-5165-6-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210252_945484_82286F76)
In-Reply-To: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
References: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set by calling CARDbyGetPktType.

change CARDbIsOFDMinBasicRate to check basic_rates.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 1869557..aaa7289 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -342,6 +342,8 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
 	}
 
+	pDevice->byPacketType = CARDbyGetPktType(pDevice);
+
 	CARDvSetRSPINF(pDevice, ePHYType);
 
 	return true;
@@ -876,7 +878,7 @@ bool CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
 	int ii;
 
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-		if ((pDevice->wBasicRate) & ((unsigned short)(1 << ii)))
+		if ((pDevice->basic_rates) & ((u32)(1 << ii)))
 			return true;
 	}
 	return false;
-- 
2.1.0

