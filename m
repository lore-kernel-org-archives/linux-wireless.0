Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53149 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756513Ab0AFWw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:52:58 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.33 6/8] rt2x00: Only remove L2 padding in received frames if there is payload.
Date: Wed,  6 Jan 2010 23:52:47 +0100
Message-Id: <1262818369-16820-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262818369-16820-6-git-send-email-gwingerde@gmail.com>
References: <1262818369-16820-1-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-2-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-3-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-4-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-5-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

L2 padding will only be present when there is actual payload present.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
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
1.6.6

