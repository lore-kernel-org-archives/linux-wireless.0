Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48469 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3HEUFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 16:05:07 -0400
Received: by mail-wi0-f178.google.com with SMTP id j17so1957696wiw.5
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 13:05:05 -0700 (PDT)
Message-ID: <1375733094.7004.23.camel@canaries64> (sfid-20130805_220513_588557_DF5BDCA4)
Subject: [PATCH 1/3] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 Aug 2013 21:04:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All structure members of BEACON_BUFFER/TX_BUFFER should be packed.

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



