Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:40546 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3FQVUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:20:01 -0400
Received: by mail-we0-f170.google.com with SMTP id w57so2832053wes.29
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 14:20:00 -0700 (PDT)
Message-ID: <1371503994.3546.2.camel@canaries64> (sfid-20130617_232007_038959_815DCD77)
Subject: [PATCH] staging: vt6656: mac.c pbyData Remove magic number array
 size
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Jun 2013 22:19:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Array size always equals ARRAY_SIZE of pbyData

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 343db19..87c7c8b 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -101,7 +101,7 @@ void MACvSetBBType(struct vnt_private *pDevice, u8 byType)
                         MESSAGE_TYPE_WRITE_MASK,
                         MAC_REG_ENCFG0,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -232,7 +232,7 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
                         MESSAGE_TYPE_SETKEY,
                         wOffset,
                         (u16)uKeyIdx,
-                        24,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 
@@ -249,7 +249,7 @@ void MACvRegBitsOff(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
                         MESSAGE_TYPE_WRITE_MASK,
                         byRegOfs,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -265,7 +265,7 @@ void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
                         MESSAGE_TYPE_WRITE_MASK,
                         byRegOfs,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -281,7 +281,7 @@ void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
                         MESSAGE_TYPE_WRITE,
                         byRegOfs,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 
@@ -302,7 +302,7 @@ void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
                         MESSAGE_TYPE_WRITE,
                         MAC_REG_BSSID0,
                         MESSAGE_REQUEST_MACREG,
-                        6,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -318,7 +318,7 @@ void MACvEnableProtectMD(struct vnt_private *pDevice)
                         MESSAGE_TYPE_WRITE_MASK,
                         MAC_REG_ENCFG0,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -334,7 +334,7 @@ void MACvDisableProtectMD(struct vnt_private *pDevice)
                         MESSAGE_TYPE_WRITE_MASK,
                         MAC_REG_ENCFG0,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -350,7 +350,7 @@ void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
                         MESSAGE_TYPE_WRITE_MASK,
                         MAC_REG_ENCFG2,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -366,7 +366,7 @@ void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
                         MESSAGE_TYPE_WRITE_MASK,
                         MAC_REG_ENCFG2,
                         MESSAGE_REQUEST_MACREG,
-                        2,
+			ARRAY_SIZE(pbyData),
                         pbyData
                         );
 }
@@ -382,7 +382,7 @@ void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
 			MESSAGE_TYPE_WRITE,
 			MAC_REG_BI,
 			MESSAGE_REQUEST_MACREG,
-			2,
+			ARRAY_SIZE(pbyData),
 			pbyData
 			);
 }
-- 
1.8.1.2


