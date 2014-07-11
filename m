Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:59629 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaGKAJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:22 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so311857wes.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/13] staging: vt6656: s_uGetDataDuration remove camel case
Date: Fri, 11 Jul 2014 01:08:21 +0100
Message-Id: <1405037311-3666-3-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020926_944046_89087DD0)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byPktType -> pkt_type
bNeedAck -> need_ack
uAckTime -> ack_time

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c994c08..a89f7fd 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -210,19 +210,20 @@ static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
-					u8 byPktType, int bNeedAck)
+static __le16 s_uGetDataDuration(struct vnt_private *piv,
+					u8 pkt_type, int need_ack)
 {
-	u32 uAckTime = 0;
+	u32 ack_time = 0;
 
-	if (bNeedAck) {
-		if (byPktType == PK_TYPE_11B)
-			uAckTime = vnt_get_frame_time(pDevice->byPreambleType,
-				byPktType, 14, pDevice->byTopCCKBasicRate);
+	if (need_ack) {
+		if (pkt_type == PK_TYPE_11B)
+			ack_time = vnt_get_frame_time(piv->byPreambleType,
+				pkt_type, 14, piv->byTopCCKBasicRate);
 		else
-			uAckTime = vnt_get_frame_time(pDevice->byPreambleType,
-				byPktType, 14, pDevice->byTopOFDMBasicRate);
-		return cpu_to_le16((u16)(pDevice->uSIFS + uAckTime));
+			ack_time = vnt_get_frame_time(piv->byPreambleType,
+				pkt_type, 14, piv->byTopOFDMBasicRate);
+
+		return cpu_to_le16((u16)(piv->uSIFS + ack_time));
 	}
 
 	return 0;
-- 
1.9.1

