Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35814 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaBRBKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:44 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so7325434eei.26
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:43 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 6/7] rtl818x: Make sure the TX descriptor "valid" flag is written by last
Date: Tue, 18 Feb 2014 02:10:45 +0100
Message-Id: <1392685846-10116-7-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021051_183717_6B4ABF0B)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

The TX descriptors are consumed by the HW using DMA.
Even if in the driver code the memory write that sets the "valid"
flag appears after all other writes, the CPU may reorder writes,
causing the HW to consider as valid a not-fully-written yet
descriptor.

This may cause HW incorrect behaviour.

This can happen because (AFAIK) the HW may attempt DMA
asynchronously without waiting to be kicked by the following
register write.

This patch adds a write memory barrier to enforce writes ordering.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index be9a8a1..7027cb7 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -335,7 +335,11 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	entry->flags2 = info->control.rates[1].idx >= 0 ?
 		ieee80211_get_alt_retry_rate(dev, info, 0)->bitrate << 4 : 0;
 	entry->retry_limit = info->control.rates[0].count;
+
+	/* We must be sure that tx_flags is written last because the HW
+	 * looks at it to check if the rest of data is valid or not
+	 */
+	wmb();
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
-- 
1.8.3.2

