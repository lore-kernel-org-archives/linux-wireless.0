Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:58038 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaEWRBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:18 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so4978445wes.8
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/20] staging: vt6656: camel case clean up MACvEnableProtectMD
Date: Fri, 23 May 2014 18:00:10 +0100
Message-Id: <1400864419-8327-11-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190124_984786_968EC13A)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index a19602f3..7783a37 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -220,20 +220,15 @@ void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
 		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
-void MACvEnableProtectMD(struct vnt_private *pDevice)
+void MACvEnableProtectMD(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = EnCFG_ProtectMd;
-    pbyData[1] = EnCFG_ProtectMd;
+	data[0] = EnCFG_ProtectMd;
+	data[1] = EnCFG_ProtectMd;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        MAC_REG_ENCFG0,
-                        MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvDisableProtectMD(struct vnt_private *pDevice)
-- 
1.9.1

