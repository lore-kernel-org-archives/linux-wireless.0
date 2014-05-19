Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50632 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaESTeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:23 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so8432464wgg.30
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/20] staging: vt6656: BBuGetFrameTime remove camel case.
Date: Mon, 19 May 2014 20:33:00 +0100
Message-Id: <1400527992-3061-8-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213426_988587_805B32D3)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes.
byPreambleType, byPktType, cbFrameLength, uFrameTime, uPreamble, uTmp, uRate
->
preamble_type, pkt_type, frame_length, frame_time, preamble, tmp, rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 52 +++++++++++++++++++--------------------
 drivers/staging/vt6656/baseband.h |  4 +--
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index baa3858..36977f0 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -654,54 +654,54 @@ s_vClearSQ3Value(PSDevice pDevice);
  *
  * Parameters:
  *  In:
- *      byPreambleType  - Preamble Type
- *      byPktType        - PK_TYPE_11A, PK_TYPE_11B, PK_TYPE_11GB, PK_TYPE_11GA
- *      cbFrameLength   - Baseband Type
+ *	preamble_type	- Preamble Type
+ *	pkt_type	- PK_TYPE_11A, PK_TYPE_11B, PK_TYPE_11GB, PK_TYPE_11GA
+ *	frame_length	- Baseband Type
  *	tx_rate		- Tx Rate
  *  Out:
  *
  * Return Value: FrameTime
  *
  */
-unsigned int BBuGetFrameTime(u8 byPreambleType, u8 byPktType,
-	unsigned int cbFrameLength, u16 tx_rate)
+unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
+	unsigned int frame_length, u16 tx_rate)
 {
-	unsigned int uFrameTime;
-	unsigned int uPreamble;
-	unsigned int uTmp;
-	unsigned int uRate = 0;
+	unsigned int frame_time;
+	unsigned int preamble;
+	unsigned int tmp;
+	unsigned int rate = 0;
 
 	if (tx_rate > RATE_54M)
 		return 0;
 
-	uRate = (unsigned int)awcFrameTime[tx_rate];
+	rate = (unsigned int)awcFrameTime[tx_rate];
 
 	if (tx_rate <= 3) {
-		if (byPreambleType == 1)
-			uPreamble = 96;
+		if (preamble_type == 1)
+			preamble = 96;
 		else
-			uPreamble = 192;
+			preamble = 192;
 
-		uFrameTime = (cbFrameLength * 80) / uRate;
-		uTmp = (uFrameTime * uRate) / 80;
+		frame_time = (frame_length * 80) / rate;
+		tmp = (frame_time * rate) / 80;
 
-		if (cbFrameLength != uTmp)
-			uFrameTime++;
+		if (frame_length != tmp)
+			frame_time++;
 
-		return uPreamble + uFrameTime;
+		return preamble + frame_time;
 	} else {
-		uFrameTime = (cbFrameLength * 8 + 22) / uRate;
-		uTmp = ((uFrameTime * uRate) - 22) / 8;
+		frame_time = (frame_length * 8 + 22) / rate;
+		tmp = ((frame_time * rate) - 22) / 8;
 
-		if (cbFrameLength != uTmp)
-			uFrameTime++;
+		if (frame_length != tmp)
+			frame_time++;
 
-		uFrameTime = uFrameTime * 4;
+		frame_time = frame_time * 4;
 
-		if (byPktType != PK_TYPE_11A)
-			uFrameTime += 6;
+		if (pkt_type != PK_TYPE_11A)
+			frame_time += 6;
 
-		return 20 + uFrameTime;
+		return 20 + frame_time;
 	}
 }
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 08c24a3..da5520c 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -88,8 +88,8 @@ struct vnt_phy_field {
 	__le16 len;
 } __packed;
 
-unsigned int BBuGetFrameTime(u8 byPreambleType, u8 byPktType,
-	unsigned int cbFrameLength, u16 tx_rate);
+unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
+	unsigned int frame_length, u16 tx_rate);
 
 void BBvCalculateParameter(struct vnt_private *, u32 cbFrameLength,
 	u16 wRate, u8 byPacketType, struct vnt_phy_field *);
-- 
1.9.1

