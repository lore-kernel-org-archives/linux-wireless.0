Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63002 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEWRBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:10 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so1399322wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/20] staging: vt6656: camel case cleanup MACvRegBitsOff
Date: Fri, 23 May 2014 18:00:05 +0100
Message-Id: <1400864419-8327-6-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190117_423203_75711F5F)
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
index c6bddf5..2edbaf9 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -181,20 +181,15 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 
 }
 
-void MACvRegBitsOff(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
+void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = byBits;
+	data[0] = 0;
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
 
 void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
-- 
1.9.1

