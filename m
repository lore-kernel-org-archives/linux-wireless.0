Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HIJNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:37 -0400
Received: by wyg24 with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/40] wl12xx: use 1 spare block in all cases
Date: Tue,  9 Aug 2011 12:13:16 +0300
Message-Id: <1312881233-9366-4-git-send-email-eliad@wizery.com> (sfid-20110809_111341_004042_36601371)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Remove support for firmwares that require 2 spare blocks for packet TX.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 0696aed..c67340f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -166,18 +166,15 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
-	u32 spare_blocks;
 
-	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
-		spare_blocks = 2;
-	else
-		spare_blocks = 1;
+	/* we use 1 spare block */
+	u32 spare_blocks = 1;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
 
 	/* allocate free identifier for the packet */
 	id = wl1271_alloc_tx_id(wl, skb);
-- 
1.7.6.401.g6a319

