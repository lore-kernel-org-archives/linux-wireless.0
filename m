Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47313 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3HMSrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 14:47:15 -0400
Received: by mail-ee0-f47.google.com with SMTP id d49so4326402eek.6
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 11:47:13 -0700 (PDT)
Message-ID: <1376419628.6292.3.camel@canaries32-MCP7A> (sfid-20130813_204718_404441_8586F53F)
Subject: [PATCH 1/2 v2] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Aug 2013 19:47:08 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All structure members of BEACON_BUFFER/TX_BUFFER should be packed.

Only the first 4 members of these structures are live.

The forth member is referenced at run-time by packed structures.
typedef struct tagSTxBufHead
typedef struct tagSTxShortBufHead
in desc.h

If these structures are not packed the alignment of these members
will be wrong.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index dd7e85d..d854b38 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -609,7 +609,7 @@ typedef struct tagSTX_BUFFER
     // Actual message
     TX_BUFFER_CONTAINER             BufferHeader;
 
-} TX_BUFFER, *PTX_BUFFER;
+} __packed TX_BUFFER, *PTX_BUFFER;
 
 //
 // Remote NDIS message format
@@ -626,7 +626,7 @@ typedef struct tagSBEACON_BUFFER
     // Actual message
     TX_BUFFER_CONTAINER             BufferHeader;
 
-} BEACON_BUFFER, *PBEACON_BUFFER;
+} __packed BEACON_BUFFER, *PBEACON_BUFFER;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
 int nsDMA_tx_packet(struct vnt_private *, u32 uDMAIdx, struct sk_buff *skb);
-- 
1.8.1.2


