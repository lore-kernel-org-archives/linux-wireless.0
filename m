Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42008 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaESTeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:22 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so4725257wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/20] staging: vt6656: BBuGetFrameTime remove uRateIdx
Date: Mon, 19 May 2014 20:32:59 +0100
Message-Id: <1400527992-3061-7-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213428_536327_E57BABCD)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove uRateIdx and rename wRate tx_rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 13 ++++++-------
 drivers/staging/vt6656/baseband.h |  9 ++-------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index dbe06f9..baa3858 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -657,27 +657,26 @@ s_vClearSQ3Value(PSDevice pDevice);
  *      byPreambleType  - Preamble Type
  *      byPktType        - PK_TYPE_11A, PK_TYPE_11B, PK_TYPE_11GB, PK_TYPE_11GA
  *      cbFrameLength   - Baseband Type
- *      wRate           - Tx Rate
+ *	tx_rate		- Tx Rate
  *  Out:
  *
  * Return Value: FrameTime
  *
  */
-unsigned int BBuGetFrameTime(u8 byPreambleType,  u8 byPktType,
-	unsigned int cbFrameLength, u16 wRate)
+unsigned int BBuGetFrameTime(u8 byPreambleType, u8 byPktType,
+	unsigned int cbFrameLength, u16 tx_rate)
 {
 	unsigned int uFrameTime;
 	unsigned int uPreamble;
 	unsigned int uTmp;
-	unsigned int uRateIdx = (unsigned int)wRate;
 	unsigned int uRate = 0;
 
-	if (uRateIdx > RATE_54M)
+	if (tx_rate > RATE_54M)
 		return 0;
 
-	uRate = (unsigned int)awcFrameTime[uRateIdx];
+	uRate = (unsigned int)awcFrameTime[tx_rate];
 
-	if (uRateIdx <= 3) {
+	if (tx_rate <= 3) {
 		if (byPreambleType == 1)
 			uPreamble = 96;
 		else
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 79faedf4..08c24a3 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -88,13 +88,8 @@ struct vnt_phy_field {
 	__le16 len;
 } __packed;
 
-unsigned int
-BBuGetFrameTime(
-     u8 byPreambleType,
-     u8 byFreqType,
-     unsigned int cbFrameLength,
-     u16 wRate
-    );
+unsigned int BBuGetFrameTime(u8 byPreambleType, u8 byPktType,
+	unsigned int cbFrameLength, u16 tx_rate);
 
 void BBvCalculateParameter(struct vnt_private *, u32 cbFrameLength,
 	u16 wRate, u8 byPacketType, struct vnt_phy_field *);
-- 
1.9.1

