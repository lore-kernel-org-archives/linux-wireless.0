Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:17628 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbYGTPs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 11:48:57 -0400
Received: by ik-out-1112.google.com with SMTP id c28so716903ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 08:48:53 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Fix memleak when RTS/CTS fails
Date: Sun, 20 Jul 2008 18:03:58 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807201803.38957.IvDoorn@gmail.com>
In-Reply-To: <200807201803.38957.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807201803.58311.IvDoorn@gmail.com> (sfid-20080720_174900_505419_52927D10)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending the RTS/CTS frame fails, we should
free the skb buffer which was created.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 16b72d9..64a4fc6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -83,6 +83,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				  (struct ieee80211_rts *)(skb->data));
 
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
+		dev_kfree_skb_any(skb);
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
 		return NETDEV_TX_BUSY;
 	}
-- 
1.5.6.1

