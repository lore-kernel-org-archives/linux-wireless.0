Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDUOAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 10:00:51 -0400
Date: Tue, 21 Apr 2009 09:49:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: warning in current tree
Message-ID: <20090421134922.GF17805@tuxdriver.com> (sfid-20090421_160056_086012_7E906F57)
References: <20090421.014340.235726123.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090421.014340.235726123.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 01:43:40AM -0700, David Miller wrote:
> 
> This appears in net-2.6 as well as net-next-2.6, could someone
> please fix it up?  Thanks!
> 
> drivers/net/wireless/mwl8k.c:897: warning: large integer implicitly truncated to unsigned type

That line looks like this:

			cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST);

And MWL8K_RX_CTRL_OWNED_BY_HOST is defined like this:

#define MWL8K_RX_CTRL_OWNED_BY_HOST	0x02

I'm going to take a wild guess that Dave is building on 64-bit Sparc, and based on that I'm going to bet that the bare "0x02" is getting typed as a 64-bit integer.  My
first thought is to suggest changing "0x02" to "0x02L", but I think that would just change it to a "long" type.  IIRC, "long" would still be 64-bit on sparc64...?

What about a patch like this?

>From 6b398445ed3c56ac0fac2080da1ef02944b2b834 Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Tue, 21 Apr 2009 09:47:22 -0400
Subject: [PATCH] mwl8k: remove warning for cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST)

drivers/net/wireless/mwl8k.c:897: warning: large integer implicitly truncated to unsigned type

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwl8k.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b5dbf6d..f23f2dc 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -826,9 +826,9 @@ static inline struct sk_buff *mwl8k_add_dma_header(struct sk_buff *skb)
 /*
  * Packet reception.
  */
-#define MWL8K_RX_CTRL_KEY_INDEX_MASK	0x30
-#define MWL8K_RX_CTRL_OWNED_BY_HOST	0x02
-#define MWL8K_RX_CTRL_AMPDU		0x01
+#define MWL8K_RX_CTRL_KEY_INDEX_MASK	(u32)0x30
+#define MWL8K_RX_CTRL_OWNED_BY_HOST	(u32)0x02
+#define MWL8K_RX_CTRL_AMPDU		(u32)0x01
 
 struct mwl8k_rx_desc {
 	__le16 pkt_len;
-- 
1.6.0.6

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
