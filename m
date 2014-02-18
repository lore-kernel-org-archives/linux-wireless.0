Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55544 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaBRBKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:46 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so7612567eak.14
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:45 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 7/7] rtl818x: make sure TX descriptor writes are done before kicking DMA
Date: Tue, 18 Feb 2014 02:10:46 +0100
Message-Id: <1392685846-10116-8-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021050_248405_F30B41BF)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

The TX descriptors are consumed by the HW using DMA.
Even if in the driver code the TX descriptor writes appears before
the HW "dma kick" register writes, the CPU may reorder them.

If this happens, the TX may not happen at all becase the "valid"
descriptor flag may have not been set yet.

This patch adds a write memory barrier to ensures the TX
descriptor is written before writing to the HW "dma kick" register.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 7027cb7..7ce58d2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -341,6 +341,12 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
      */
 	wmb();
 	entry->flags = cpu_to_le32(tx_flags);
+	/* We must be sure this has been written before followings HW
+	 * register write, because this write will made the HW attempts
+	 * to DMA the just-written data
+	 */
+	wmb();
+
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
 		ieee80211_stop_queue(dev, prio);
-- 
1.8.3.2

