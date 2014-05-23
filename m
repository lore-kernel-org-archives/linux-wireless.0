Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47197 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaEWRBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:20 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1216542wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/20] staging: vt6656: camel case clean up MACvDisableProtectMD
Date: Fri, 23 May 2014 18:00:11 +0100
Message-Id: <1400864419-8327-12-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190127_681140_EB2CAC93)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 7783a37..0805341 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -231,20 +231,15 @@ void MACvEnableProtectMD(struct vnt_private *priv)
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableProtectMD(struct vnt_private *pDevice)
+void MACvDisableProtectMD(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = EnCFG_ProtectMd;
+	data[0] = 0;
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
 
 void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
-- 
1.9.1

