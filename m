Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51538 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaESTef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:35 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so4736772wiw.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/20] staging: vt6656: BBvSetDeepSleep remove camel case
Date: Mon, 19 May 2014 20:33:07 +0100
Message-Id: <1400527992-3061-15-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213441_304370_737A1AC3)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 466abd9..9956f5a 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1121,17 +1121,17 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
+ *	priv	- Device Structure
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void BBvSetDeepSleep(struct vnt_private *pDevice)
+void BBvSetDeepSleep(struct vnt_private *priv)
 {
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);//CR12
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0D, 0xB9);//CR13
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);/* CR12 */
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
 }
 
 void BBvExitDeepSleep(struct vnt_private *pDevice)
-- 
1.9.1

