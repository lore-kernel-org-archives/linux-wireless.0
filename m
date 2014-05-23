Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:49639 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEWRBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:14 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so5217721wev.31
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/20] staging: vt6656: camel case cleanup MACvWriteWord
Date: Fri, 23 May 2014 18:00:07 +0100
Message-Id: <1400864419-8327-8-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190120_070488_65093103)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byRegOfs -> reg_ofs
wData -> word
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index bb0c909..a195703 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -203,21 +203,15 @@ void MACvRegBitsOn(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
+void MACvWriteWord(struct vnt_private *priv, u8 reg_ofs, u16 word)
 {
-	u8 pbyData[2];
-
-    pbyData[0] = (u8)(wData & 0xff);
-    pbyData[1] = (u8)(wData >> 8);
+	u8 data[2];
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        byRegOfs,
-                        MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	data[0] = (u8)(word & 0xff);
+	data[1] = (u8)(word >> 8);
 
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
-- 
1.9.1

