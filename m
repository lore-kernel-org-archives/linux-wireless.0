Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48117 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3FCVmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:42:42 -0400
Received: by mail-we0-f182.google.com with SMTP id w58so2247635wes.27
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:42:41 -0700 (PDT)
Message-ID: <1370295754.9091.26.camel@canaries64> (sfid-20130603_234247_630352_EF875F20)
Subject: [PATCH 1/8] staging: vt6656: rf.c: IFRFbWriteEmbedded cleanup and
 remove camel case
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:42:34 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up.

Camel case changes;
pDevice -> priv
dwData -> data
pbyData -> reg_data

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(reg_data)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index d27fa43..9fbef8c 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -707,17 +707,17 @@ const u8 RFaby11aChannelIndex[200] = {
  * Return Value: true if succeeded; false if failed.
  *
  */
-int IFRFbWriteEmbedded(struct vnt_private *pDevice, u32 dwData)
+int IFRFbWriteEmbedded(struct vnt_private *priv, u32 data)
 {
-	u8 pbyData[4];
+	u8 reg_data[4];
 
-	pbyData[0] = (u8)dwData;
-	pbyData[1] = (u8)(dwData >> 8);
-	pbyData[2] = (u8)(dwData >> 16);
-	pbyData[3] = (u8)(dwData >> 24);
+	reg_data[0] = (u8)data;
+	reg_data[1] = (u8)(data >> 8);
+	reg_data[2] = (u8)(data >> 16);
+	reg_data[3] = (u8)(data >> 24);
 
-	CONTROLnsRequestOut(pDevice,
-		MESSAGE_TYPE_WRITE_IFRF, 0, 0, 4, pbyData);
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_IFRF,
+				0, 0, ARRAY_SIZE(reg_data), reg_data);
 
 	return true;
 }
-- 
1.8.1.2

