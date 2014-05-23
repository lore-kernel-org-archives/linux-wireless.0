Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:32848 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaEWRBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:22 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so5182352wes.16
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/20] staging: vt6656: camel case clean up MACvEnableBarkerPreambleMd
Date: Fri, 23 May 2014 18:00:12 +0100
Message-Id: <1400864419-8327-13-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190129_891645_6739662E)
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
index 0805341..86bf3fb 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -242,20 +242,15 @@ void MACvDisableProtectMD(struct vnt_private *priv)
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
+void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = EnCFG_BarkerPream;
-    pbyData[1] = EnCFG_BarkerPream;
+	data[0] = EnCFG_BarkerPream;
+	data[1] = EnCFG_BarkerPream;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        MAC_REG_ENCFG2,
-                        MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
-- 
1.9.1

