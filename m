Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55654 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3KZVGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 16:06:14 -0500
Received: by mail-wi0-f173.google.com with SMTP id hm4so5834992wib.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 13:06:14 -0800 (PST)
Message-ID: <1385499966.10545.10.camel@canaries32-MCP7A> (sfid-20131126_220618_960918_3A4364D2)
Subject: [PATCH] staging: vt6656: mac.c MACvWriteBSSIDAddress Remove
 secondary buffer
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 21:06:06 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Point to the callers buffer, the bssid.

Size is always ETH_ALEN (6).

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 5392f7c..c5b04e9 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -255,24 +255,11 @@ void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
 
 }
 
-void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
+void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *bssid)
 {
-	u8 pbyData[6];
 
-    pbyData[0] = *((u8 *)pbyEtherAddr);
-    pbyData[1] = *((u8 *)pbyEtherAddr+1);
-    pbyData[2] = *((u8 *)pbyEtherAddr+2);
-    pbyData[3] = *((u8 *)pbyEtherAddr+3);
-    pbyData[4] = *((u8 *)pbyEtherAddr+4);
-    pbyData[5] = *((u8 *)pbyEtherAddr+5);
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_BSSID0,
-                        MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE,
+		MAC_REG_BSSID0, MESSAGE_REQUEST_MACREG, ETH_ALEN, bssid);
 }
 
 void MACvEnableProtectMD(struct vnt_private *pDevice)
-- 
1.8.4.4

