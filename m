Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33003 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbaCRT03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:29 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so6399620wgh.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/14] staging: vt6656: Correct return type s_uGetRTSCTSDuration.
Date: Tue, 18 Mar 2014 19:25:05 +0000
Message-Id: <1395170708-2990-11-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202636_816052_F3AFAE56)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_uGetRTSCTSDuration always returns in __le16 type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 63bffc2..850d1b9 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -132,7 +132,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 static u16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
-static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
+static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
 	int bNeedAck, u8 byFBOption);
 
@@ -430,7 +430,7 @@ static u16 s_uGetDataDuration(struct vnt_private *pDevice,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
+static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
 	u8 byFBOption)
 {
-- 
1.9.0

