Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56142 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaEWRBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:03 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so1215708wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/20] staging: vt6656: remove camel case MACbShutdown
Date: Fri, 23 May 2014 18:00:01 +0100
Message-Id: <1400864419-8327-2-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190109_792198_5AD21B09)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv

signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 22dd653..cc80c8e 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -72,15 +72,9 @@ void MACvWriteMultiAddr(struct vnt_private *priv, u64 mc_filter)
  *
  *
  */
-void MACbShutdown(struct vnt_private *pDevice)
+void MACbShutdown(struct vnt_private *priv)
 {
-	CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_MACSHUTDOWN,
-                        0,
-                        0,
-                        0,
-                        NULL
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
 }
 
 void MACvSetBBType(struct vnt_private *pDevice, u8 byType)
-- 
1.9.1

