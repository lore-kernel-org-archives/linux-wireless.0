Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:51183 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3E0NF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:05:59 -0400
Received: by mail-bk0-f53.google.com with SMTP id mx1so3693960bkb.12
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 06:05:57 -0700 (PDT)
Message-ID: <1369659951.8283.22.camel@canaries64> (sfid-20130527_150601_981576_0B88019B)
Subject: [PATCH 3/5] staging: vt6656: rf.c: RFvRSSITodBm Remove camel case
 and clean up.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:05:51 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


White space clean up.

Camel case changes;
pDevice -> priv
byCurrRSSI -> rssi
pldBm -> dbm
byIdx -> idx
abyAIROHARF -> airoharf

No functional changes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index b7aad36..2f3963e 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -31,6 +31,7 @@
  * Revision History:
  *	RF_VT3226: RobertYu:20051111, VT3226C0 and before
  *	RF_VT3226D0: RobertYu:20051228
+ *	RF_VT3342A0: RobertYu:20060609
  *
  */
 
@@ -942,27 +943,27 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
  * Return Value: none
  *
 -*/
-void RFvRSSITodBm(struct vnt_private *pDevice, u8 byCurrRSSI, long *pldBm)
+void RFvRSSITodBm(struct vnt_private *priv, u8 rssi, long *dbm)
 {
-	u8 byIdx = (((byCurrRSSI & 0xC0) >> 6) & 0x03);
-	signed long b = (byCurrRSSI & 0x3F);
-	signed long a = 0;
-	u8 abyAIROHARF[4] = {0, 18, 0, 40};
+	u8 idx = (((rssi & 0xc0) >> 6) & 0x03);
+	long b = (rssi & 0x3f);
+	long a = 0;
+	u8 airoharf[4] = {0, 18, 0, 40};
 
-    switch (pDevice->byRFType) {
-        case RF_AL2230:
-        case RF_AL2230S:
-        case RF_AIROHA7230:
-        case RF_VT3226: //RobertYu:20051111
-        case RF_VT3226D0:
-        case RF_VT3342A0:   //RobertYu:20060609
-            a = abyAIROHARF[byIdx];
-            break;
-        default:
-            break;
-    }
+	switch (priv->byRFType) {
+	case RF_AL2230:
+	case RF_AL2230S:
+	case RF_AIROHA7230:
+	case RF_VT3226:
+	case RF_VT3226D0:
+	case RF_VT3342A0:
+		a = airoharf[idx];
+		break;
+	default:
+		break;
+	}
 
-    *pldBm = -1 * (a + b * 2);
+	*dbm = -1 * (a + b * 2);
 }
 
 void RFbRFTableDownload(struct vnt_private *pDevice)
-- 
1.8.1.2






