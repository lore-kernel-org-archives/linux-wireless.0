Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46419 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaE0UGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:11 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so2371206wiv.15
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/10] staging: vt6656: IFRFbWriteEmbedded remove camel case
Date: Tue, 27 May 2014 21:05:19 +0100
Message-Id: <1401221126-4219-3-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220644_445697_34408512)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
dwData -> data
pbyData -> reg_data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 9126156..a8e50f7 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -706,17 +706,17 @@ const u8 RFaby11aChannelIndex[200] = {
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
 
-	vnt_control_out(pDevice,
-		MESSAGE_TYPE_WRITE_IFRF, 0, 0, ARRAY_SIZE(pbyData), pbyData);
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_IFRF,
+				0, 0, ARRAY_SIZE(reg_data), reg_data);
 
 	return true;
 }
-- 
1.9.1

