Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47951 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaEWRB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:26 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so1172284wiv.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/20] staging: vt6656: camel case clean up MACvWriteBeaconInterval
Date: Fri, 23 May 2014 18:00:14 +0100
Message-Id: <1400864419-8327-15-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192149_129224_ACDE72D2)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wInterval -> interval
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index b370b0a..f486834 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -264,18 +264,13 @@ void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
+void MACvWriteBeaconInterval(struct vnt_private *priv, u16 interval)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-	pbyData[0] = (u8)(wInterval & 0xff);
-	pbyData[1] = (u8)(wInterval >> 8);
+	data[0] = (u8)(interval & 0xff);
+	data[1] = (u8)(interval >> 8);
 
-    CONTROLnsRequestOut(pDevice,
-			MESSAGE_TYPE_WRITE,
-			MAC_REG_BI,
-			MESSAGE_REQUEST_MACREG,
-			ARRAY_SIZE(pbyData),
-			pbyData
-			);
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		MAC_REG_BI, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
-- 
1.9.1

