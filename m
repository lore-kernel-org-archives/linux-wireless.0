Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35442 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEWRBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so1164354wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/20] staging: vt6656: camel case clean up MACvWriteBSSIDAddress
Date: Fri, 23 May 2014 18:00:09 +0100
Message-Id: <1400864419-8327-10-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_874557_DE8855AE)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
pbyEtherAddr -> addr

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 31f54fb..a19602f3 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -214,15 +214,10 @@ void MACvWriteWord(struct vnt_private *priv, u8 reg_ofs, u16 word)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
+void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
 {
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_BSSID0,
-                        MESSAGE_REQUEST_MACREG,
-			ETH_ALEN,
-			pbyEtherAddr
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_BSSID0,
+		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
 void MACvEnableProtectMD(struct vnt_private *pDevice)
-- 
1.9.1

