Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46955 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaESTeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:37 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so8215741wgg.18
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/20] staging: vt6656: BBvExitDeepSleep remove camel case.
Date: Mon, 19 May 2014 20:33:08 +0100
Message-Id: <1400527992-3061-16-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213447_863295_31A96674)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 9956f5a..0cde6b5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1134,10 +1134,10 @@ void BBvSetDeepSleep(struct vnt_private *priv)
 	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
 }
 
-void BBvExitDeepSleep(struct vnt_private *pDevice)
+void BBvExitDeepSleep(struct vnt_private *priv)
 {
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0C, 0x00);//CR12
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0D, 0x01);//CR13
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x00);/* CR12 */
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
 }
 
 static unsigned long s_ulGetLowSQ3(struct vnt_private *pDevice)
-- 
1.9.1

