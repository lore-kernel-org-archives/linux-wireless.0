Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56368 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGJS5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:05 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3613wgh.11
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/16] staging: vt6656: s_vGenerateTxParameter remove else from if statements
Date: Thu, 10 Jul 2014 19:56:13 +0100
Message-Id: <1405018577-6832-12-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205739_950857_408F7CDB)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function returns out at if statements so drop else.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 6113807..0d0a956 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -717,25 +717,20 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
 					byPktType, cbFrameSize, bNeedACK,
 						wCurrentRate, need_mic);
-		} else {
-			if (need_mic)
-				*mic_hdr = &tx_buffer->
-						tx_head.tx_cts.tx.mic.hdr;
-
-			return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
-					byPktType, cbFrameSize, bNeedACK,
-						wCurrentRate, need_mic);
 		}
-	} else {
+
 		if (need_mic)
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
-		return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head,
-					byPktType, cbFrameSize, bNeedACK,
-					wCurrentRate, need_rts, need_mic);
+		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, byPktType,
+				cbFrameSize, bNeedACK, wCurrentRate, need_mic);
 	}
 
-	return 0;
+	if (need_mic)
+		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+
+	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
+		cbFrameSize, bNeedACK, wCurrentRate, need_rts, need_mic);
 }
 
 static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
-- 
1.9.1

