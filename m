Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:56819 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbaGVVuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:32 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so270688wes.22
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/7] staging: vt6656: vnt_tx_buffer replace byType with type
Date: Tue, 22 Jul 2014 22:49:46 +0100
Message-Id: <1406065789-3374-4-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235036_240034_F8405B20)
In-Reply-To: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
References: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 8e33e40..5a7114d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -950,7 +950,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	tx_buffer->tx_byte_count = cpu_to_le16(tx_bytes);
 	tx_buffer->pkt_no = tx_context->pkt_no;
-	tx_buffer->byType = 0x00;
+	tx_buffer->type = 0x00;
 
 	tx_bytes += 4;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 5439ed0..808058f 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -229,7 +229,7 @@ struct vnt_tx_fifo_head {
 } __packed;
 
 struct vnt_tx_buffer {
-	u8 byType;
+	u8 type;
 	u8 pkt_no;
 	__le16 tx_byte_count;
 	struct vnt_tx_fifo_head fifo_head;
-- 
2.0.1

