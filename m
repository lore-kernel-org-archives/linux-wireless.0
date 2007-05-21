Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:27730 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbXEUOac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 10:30:32 -0400
Received: by wx-out-0506.google.com with SMTP id i26so300599wxd
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2007 07:30:31 -0700 (PDT)
Date: Mon, 21 May 2007 22:30:22 +0800
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	jeff@garzik.org, Florin Malita <fmalita@gmail.com>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix  use-after-free
Message-ID: <20070521143022.GA26452@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <464DD957.9040803@redhat.com> <20070518174623.GA3492@tuxdriver.com> <464E6B82.40607@redhat.com> <20070521133124.GB9621@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070521133124.GB9621@tuxdriver.com>
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<quote sender="John W. Linville">
> On Sat, May 19, 2007 at 11:14:10AM +0800, Eugene Teo wrote:
> > John W. Linville wrote:
> 
> > >>  done:
> > >>         LEAVE();
> > >>
> > >> -       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
> > >> -
> > > 
> > > Except for this part...is this intentional?
> > 
> > skb could have been freed by then. And, in libertas_upload_rx_packet(), skb->protocol
> > is initialized by eth_type_trans(skb, priv->wlan_dev.netdev).
> 
> OK, I see that.  Looks like Florin has reposted his patch, still
> without this hunk.  Would you like to submit a patch for this hunk?

skb could have been freed by then. Also, in libertas_upload_rx_packet(),
skb->protocol is initialized by eth_type_trans().

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---

diff -uprN -X 2.6.22-rc2/Documentation/dontdiff 2.6.22-rc2.default/drivers/net/wireless/libertas/rx.c 2.6.22-rc2/drivers/net/wireless/libertas/rx.c
--- 2.6.22-rc2.default/drivers/net/wireless/libertas/rx.c	2007-05-21 22:07:50.000000000 +0800
+++ 2.6.22-rc2/drivers/net/wireless/libertas/rx.c	2007-05-21 22:08:44.000000000 +0800
@@ -453,7 +453,5 @@ static int process_rxed_802_11_packet(wl
 done:
 	LEAVE();
 
-	skb->protocol = __constant_htons(0x0019);	/* ETH_P_80211_RAW */
-
 	return (ret);
 }

-- 
1024D/58DF8823 print 47B9 90F6 AE4A 9C51 37E0  D6E1 EA84 C6A2 58DF 8823
main(i) { putchar(182623909 >> (i-1) * 5&31|!!(i<7)<<6) && main(++i); }
