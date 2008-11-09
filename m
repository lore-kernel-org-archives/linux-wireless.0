Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s16.bay0.hotmail.com ([65.54.246.216]:3168 "EHLO
	bay0-omc3-s16.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890AbYKIOVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 09:21:00 -0500
Message-ID: <BAY104-DAV13111B5239758324EF2350991B0@phx.gbl> (sfid-20081109_152106_673161_702761DF)
Message-ID: <4916F1C0.1040703@hotmail.com>
Date: Mon, 10 Nov 2008 01:20:48 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>	 <200810251325.07916.mb@bu3sch.de>	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>	 <1226149894.3610.8.camel@johannes.berg>  <491653A6.20705@hotmail.com> <1226220992.3614.16.camel@johannes.berg>
In-Reply-To: <1226220992.3614.16.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09/11/08 19:56, Johannes Berg wrote:
> Yes, I think you're right, it appears that the 802.11 header isn't
> aligned on a 2-byte boundary, which is extremely strange. Can you, with
> your patch applied, do something like
> 
> 	printk(KERN_DEBUG "%p\n", skb->data);
> 
> before this code in zd_mac.c:
> 
>         memcpy(skb_put(skb, length), buffer, length);
> 
>         ieee80211_rx_irqsafe(hw, skb, &stats);

I have done this... but I think that there is too much output to place 
here. What I can tell you with confidence is that every value is 4-byte 
aligned.

However, I modify filter_ack() in zd_mac.c so that the code looks like this:

         for (skb = q->next; skb != (struct sk_buff *)q; skb = skb->next) {
                 struct ieee80211_hdr *tx_hdr;

                 tx_hdr = (struct ieee80211_hdr *)skb->data;
         printk(KERN_DEBUG "%s:%u: skb %p skb->data %p tx_hdr->addr2 %p 
rx_hdr->addr1 %p\n", __FILE__, __LINE__, skb, skb->data, tx_hdr->addr2, 
rx_hdr->addr1);
                 //if (likely(!memcmp(tx_hdr->addr2, rx_hdr->addr1, 
ETH_ALEN)))
                 if (likely(!compare_ether_addr(tx_hdr->addr2, 
rx_hdr->addr1)))
                 {

(note, I re-instated the compare_ether_addr() so that I could be sure 
that the unaligned access corresponded with whatever values I was seeing 
in the print).

Here is the output of the first print from this location that I see in 
syslog:

Nov 10 00:47:17 trad kernel: [ 8239.534950] 
drivers/net/wireless/zd1211rw/zd_mac.c:639: skb fffff8003d0d8fc0 
skb->data fffff8003d874cdb tx_hdr->addr2 fffff8003d874ce5 rx_hdr->addr1 
fffff8003f3e0009
Nov 10 00:47:17 trad kernel: [ 8239.534986] Kernel unaligned access at 
TPC[100f5bd0] zd_mac_rx+0x1b0/0x398 [zd1211rw]
Nov 10 00:47:17 trad kernel: [ 8239.637697] Kernel unaligned access at 
TPC[100f5bd4] zd_mac_rx+0x1b4/0x398 [zd1211rw]
Nov 10 00:47:17 trad kernel: [ 8239.740208] Kernel unaligned access at 
TPC[100f5bd8] zd_mac_rx+0x1b8/0x398 [zd1211rw]
Nov 10 00:47:17 trad kernel: [ 8239.842417] Kernel unaligned access at 
TPC[100f5bdc] zd_mac_rx+0x1bc/0x398 [zd1211rw]
Nov 10 00:47:17 trad kernel: [ 8239.944583] Kernel unaligned access at 
TPC[100f5be0] zd_mac_rx+0x1c0/0x398 [zd1211rw]

So you can see that skb->data is not even 2-byte aligned. And my debug 
leads me to believe that the problem is this line in zd_mac_tx_to_dev():

                  skb_pull(skb, sizeof(struct zd_ctrlset));

A before and after of this line gives me this output:

Nov 10 00:47:17 trad kernel: [ 8239.534065] 
drivers/net/wireless/zd1211rw/zd_mac.c:376: skb fffff8003d0d8fc0 
skb->data fffff8003d874cd0
Nov 10 00:47:17 trad kernel: [ 8239.534092] 
drivers/net/wireless/zd1211rw/zd_mac.c:390: skb fffff8003d0d8fc0 
skb->data fffff8003d874cdb

Perhaps there needs to be some padding there?

Also, I've just had a look at the git version of zd_mac.c, and I notice 
it is all change there again. I would feel uncomfortable having studied 
the 2.6.26 code to have to start again. Is it expected that I use the 
latest available via git?

Thanks in advance,
Shaddy

