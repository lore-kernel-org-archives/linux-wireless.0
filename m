Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:48651 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaEWRBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:03 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so5093530wes.20
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/20] staging: vt6656: remove camel case  MACvWriteMultiAddr
Date: Fri, 23 May 2014 18:00:00 +0100
Message-Id: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190107_246447_571011D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes.
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 8298a9e..22dd653 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -53,11 +53,11 @@ static int          msglevel                =MSG_LEVEL_INFO;
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(struct vnt_private *pDevice, u64 mc_filter)
+void MACvWriteMultiAddr(struct vnt_private *priv, u64 mc_filter)
 {
 	__le64 le_mc = cpu_to_le64(mc_filter);
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, MAC_REG_MAR0,
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_MAR0,
 		MESSAGE_REQUEST_MACREG, sizeof(le_mc), (u8 *)&le_mc);
 }
 
-- 
1.9.1

