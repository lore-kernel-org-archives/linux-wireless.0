Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42551 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaEWRBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:12 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so1396767wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/20] staging: vt6656: camel case clean up MACvRegBitsOn
Date: Fri, 23 May 2014 18:00:06 +0100
Message-Id: <1400864419-8327-7-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_658174_9CC06490)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byRegOfs -> reg_ofs
byBits -> bits
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 2edbaf9..bb0c909 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -192,20 +192,15 @@ void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
+void MACvRegBitsOn(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = byBits;
-    pbyData[1] = byBits;
+	data[0] = bits;
+	data[1] = bits;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        byRegOfs,
-                        MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
-- 
1.9.1

