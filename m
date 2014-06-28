Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48747 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaF1W40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:26 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4359706wib.7
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6656: vnt_tx_packet remove first assignment of time_stamp.
Date: Sat, 28 Jun 2014 23:55:41 +0100
Message-Id: <1403996146-4082-3-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005637_782726_32EE89FE)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is assigned later in function and should have been removed in
an out-of-tree merge.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5513121..e896dfe5d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -929,9 +929,6 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	frame_size = tx_body_size + 4;
 
-	/* Set time stamp */
-	tx_buffer_head->time_stamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
-
 	/*Set fifo controls */
 	if (pkt_type == PK_TYPE_11A)
 		tx_buffer_head->wFIFOCtl = 0;
-- 
1.9.1

