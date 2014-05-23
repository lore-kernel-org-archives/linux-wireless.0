Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37129 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaEWRBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:24 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so5046679wgh.11
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/20] staging: vt6656: camel case clean up MACvDisableBarkerPreambleMd
Date: Fri, 23 May 2014 18:00:13 +0100
Message-Id: <1400864419-8327-14-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192147_537688_1D9DEFE4)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
phyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 86bf3fb..b370b0a 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -253,20 +253,15 @@ void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
+void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = EnCFG_BarkerPream;
+	data[0] = 0;
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
 
 void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
-- 
1.9.1

