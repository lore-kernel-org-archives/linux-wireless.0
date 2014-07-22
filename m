Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:61385 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaGVVue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:34 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so267235wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/7] staging: vt6656: struct vnt_beacon_buffer replace byType with type
Date: Tue, 22 Jul 2014 22:49:47 +0100
Message-Id: <1406065789-3374-5-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235037_646337_78A69538)
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
index 5a7114d..2dc7a17 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1046,7 +1046,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 
 	beacon_buffer->tx_byte_count = cpu_to_le16(count);
 	beacon_buffer->pkt_no = context->pkt_no;
-	beacon_buffer->byType = 0x01;
+	beacon_buffer->type = 0x01;
 
 	context->type = CONTEXT_BEACON_PACKET;
 	context->buf_len = count + 4; /* USB header */
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 808058f..d5769c1 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -245,7 +245,7 @@ struct vnt_tx_short_buf_head {
 } __packed;
 
 struct vnt_beacon_buffer {
-	u8 byType;
+	u8 type;
 	u8 pkt_no;
 	__le16 tx_byte_count;
 	struct vnt_tx_short_buf_head short_head;
-- 
2.0.1

