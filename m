Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56702 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbaGVVu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:29 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so264815wgh.32
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/7] staging: vt6656: struct vnt_tx_buffer replace byPKTNO with pkt_no
Date: Tue, 22 Jul 2014 22:49:44 +0100
Message-Id: <1406065789-3374-2-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235031_927197_4DAEE8A7)
In-Reply-To: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
References: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7a7b6cbf..7834128 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -949,7 +949,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 						IEEE80211_SCTL_SEQ) >> 4;
 
 	tx_buffer->tx_byte_count = cpu_to_le16(tx_bytes);
-	tx_buffer->byPKTNO = tx_context->pkt_no;
+	tx_buffer->pkt_no = tx_context->pkt_no;
 	tx_buffer->byType = 0x00;
 
 	tx_bytes += 4;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 62a9ed3..dee2bdf 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -230,7 +230,7 @@ struct vnt_tx_fifo_head {
 
 struct vnt_tx_buffer {
 	u8 byType;
-	u8 byPKTNO;
+	u8 pkt_no;
 	__le16 tx_byte_count;
 	struct vnt_tx_fifo_head fifo_head;
 	union vnt_tx_head tx_head;
-- 
2.0.1

