Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52896 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbZJZTiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 15:38:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Date: Mon, 26 Oct 2009 20:37:33 +0100
Cc: linux-wireless@vger.kernel.org,
	Christian Casteyde <casteyde.christian@free.fr>,
	Johannes Berg <johannes@sipsolutions.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <20091026185901.GH2792@tuxdriver.com> <200910262011.22950.mb@bu3sch.de>
In-Reply-To: <200910262011.22950.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910262037.35469.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 October 2009 20:11:20 Michael Buesch wrote:
> On Monday 26 October 2009 19:59:02 John W. Linville wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
> > > Subject		: Caught 8-bit read from freed memory in b43 driver at association
> > > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > > Date		: 2009-09-30 18:06 (27 days old)
> 
> Does this still trigger with a recent kernel (and thus recent memory debugging).
> I'm still not convinced that this is a wireless bug.
> 

Ok, it just turns out this actually is a driver bug.
Thanks to Johannes Berg for tracking it down.

I think it's caused by the DMA bouncebuffer stuff that does not copy the skb->cb
and does not adjust the "tx-info" pointer.
I wonder why this didn't blow up easlier, because this bug is there since mac80211
switched to using the CB.

Here's a completely untested patch.

---
 drivers/net/wireless/b43/dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/b43/dma.c
+++ wireless-testing/drivers/net/wireless/b43/dma.c
@@ -1224,6 +1224,8 @@ static int dma_tx_fragment(struct b43_dm
 		}
 
 		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
+		memcpy(bounce_skb->cb, skb->cb, sizeof(skb->cb));
+		info = IEEE80211_SKB_CB(bounce_skb);
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
 		meta->skb = skb;


-- 
Greetings, Michael.
