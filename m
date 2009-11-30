Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:62456 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbZK3VJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 16:09:08 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Benoit Papillault <benoit.papillault@free.fr>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v3 4/4] rt2x00: Only remove L2 padding in received frames if there is payload.
Date: Mon, 30 Nov 2009 22:08:18 +0100
Message-Id: <1259615298-2305-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-4-git-send-email-gwingerde@gmail.com>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
 <1259615298-2305-2-git-send-email-gwingerde@gmail.com>
 <1259615298-2305-3-git-send-email-gwingerde@gmail.com>
 <1259615298-2305-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

L2 padding will only be present when there is actual payload present.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ca2bcc0..b93731b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -401,7 +401,9 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	    (rxdesc.flags & RX_FLAG_IV_STRIPPED))
 		rt2x00crypto_rx_insert_iv(entry->skb, header_length,
 					  &rxdesc);
-	else if (rxdesc.dev_flags & RXDONE_L2PAD)
+	else if (header_length &&
+		 (rxdesc.size > header_length) &&
+		 (rxdesc.dev_flags & RXDONE_L2PAD))
 		rt2x00queue_remove_l2pad(entry->skb, header_length);
 	else
 		rt2x00queue_align_payload(entry->skb, header_length);
-- 
1.6.5.3

