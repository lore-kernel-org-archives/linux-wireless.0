Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43000 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaEUUKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:10:46 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so2455467wgh.8
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:10:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6656: s_vSWencryption replace CRCdwGetCrc32Ex
Date: Wed, 21 May 2014 21:09:42 +0100
Message-Id: <1400702984-3221-4-git-send-email-tvboxspy@gmail.com> (sfid-20140521_221050_294716_842AA3D5)
In-Reply-To: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
References: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with ether_crc_le which gives the same result.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2b0ae06..0509672 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -304,7 +304,7 @@ static void s_vSWencryption(struct vnt_private *pDevice,
     if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
         //=======================================================================
         // Append ICV after payload
-        dwICV = CRCdwGetCrc32Ex(pbyPayloadHead, wPayloadSize, dwICV);//ICV(Payload)
+	dwICV = ether_crc_le(wPayloadSize, pbyPayloadHead);
         pdwICV = (u32 *)(pbyPayloadHead + wPayloadSize);
         // finally, we must invert dwCRC to get the correct answer
         *pdwICV = cpu_to_le32(~dwICV);
@@ -315,7 +315,7 @@ static void s_vSWencryption(struct vnt_private *pDevice,
     } else if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
         //=======================================================================
         //Append ICV after payload
-        dwICV = CRCdwGetCrc32Ex(pbyPayloadHead, wPayloadSize, dwICV);//ICV(Payload)
+	dwICV = ether_crc_le(wPayloadSize, pbyPayloadHead);
         pdwICV = (u32 *)(pbyPayloadHead + wPayloadSize);
         // finally, we must invert dwCRC to get the correct answer
         *pdwICV = cpu_to_le32(~dwICV);
-- 
1.9.1

