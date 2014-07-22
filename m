Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64985 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaGVVua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:30 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so261511wgh.34
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/7] staging: vt6656: struct vnt_beacon_buffer replace byPKTNO with pkt_no
Date: Tue, 22 Jul 2014 22:49:45 +0100
Message-Id: <1406065789-3374-3-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235035_145428_997F28EE)
In-Reply-To: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
References: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7834128..8e33e40 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1045,7 +1045,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 	count = sizeof(struct vnt_tx_short_buf_head) + skb->len;
 
 	beacon_buffer->tx_byte_count = cpu_to_le16(count);
-	beacon_buffer->byPKTNO = context->pkt_no;
+	beacon_buffer->pkt_no = context->pkt_no;
 	beacon_buffer->byType = 0x01;
 
 	context->type = CONTEXT_BEACON_PACKET;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index dee2bdf..5439ed0 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -246,7 +246,7 @@ struct vnt_tx_short_buf_head {
 
 struct vnt_beacon_buffer {
 	u8 byType;
-	u8 byPKTNO;
+	u8 pkt_no;
 	__le16 tx_byte_count;
 	struct vnt_tx_short_buf_head short_head;
 	struct ieee80211_mgmt mgmt_hdr;
-- 
2.0.1

