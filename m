Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36228 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761439Ab3EAPRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/7] rt2x00: rt2x00dev: use rt2x00dev->tx->limit
Date: Wed,  1 May 2013 17:17:29 +0200
Message-Id: <1367421455-18463-2-git-send-email-juhosg@openwrt.org> (sfid-20130501_171827_234401_D44CCBD9)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX data queue is initialized already when
the rt2x00lib_probe_hw() function is called.

Fetch the number of the queue entries from that
instead of using the entry_num field of the data
queue descriptor.

The two values are the same, and the use of the
rt2x00dev->tx->limit value allows us to get rid
of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 90dc143..b287467 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1077,7 +1077,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		 */
 		int kfifo_size =
 			roundup_pow_of_two(rt2x00dev->ops->tx_queues *
-					   rt2x00dev->ops->tx->entry_num *
+					   rt2x00dev->tx->limit *
 					   sizeof(u32));
 
 		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, kfifo_size,
-- 
1.7.10

