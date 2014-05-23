Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62654 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaEWRBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:15 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so5003217wgg.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/20] staging: vt6656: MACvWriteBSSIDAddress remove pbyData
Date: Fri, 23 May 2014 18:00:08 +0100
Message-Id: <1400864419-8327-9-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190122_543577_4D10AAA2)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove pbyData and point directly to pbyEtherAddr

The size is always ETH_ALEN (6)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index a195703..31f54fb 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -216,21 +216,12 @@ void MACvWriteWord(struct vnt_private *priv, u8 reg_ofs, u16 word)
 
 void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
 {
-	u8 pbyData[6];
-
-    pbyData[0] = *((u8 *)pbyEtherAddr);
-    pbyData[1] = *((u8 *)pbyEtherAddr+1);
-    pbyData[2] = *((u8 *)pbyEtherAddr+2);
-    pbyData[3] = *((u8 *)pbyEtherAddr+3);
-    pbyData[4] = *((u8 *)pbyEtherAddr+4);
-    pbyData[5] = *((u8 *)pbyEtherAddr+5);
-
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_WRITE,
                         MAC_REG_BSSID0,
                         MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
+			ETH_ALEN,
+			pbyEtherAddr
                         );
 }
 
-- 
1.9.1

