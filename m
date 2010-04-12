Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50236 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0DLHXq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:23:46 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 00:23:46 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19394.51792.397561.53767@gargle.gargle.HOWL>
Date: Mon, 12 Apr 2010 12:52:56 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] ath9k-htc: replace __dev_alloc_skb with alloc_skb
 in 	ath9k_hif_usb_alloc_rx_urbs
In-Reply-To: <n2ld82e647a1004110611hc424f464gf8443967fa97c21a@mail.gmail.com>
References: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
	<19393.24337.10019.88274@gargle.gargle.HOWL>
	<n2ld82e647a1004110611hc424f464gf8443967fa97c21a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> The skb->data is passed into usb hcd and usb hcd will do dma mapping
> for the buffer of skb->data, so it is better to keep it cache-line aligned.
> 
> Size of cache line is very cpu dependent, we can't suppose it is
> 32byte(NET_SKB_PAD) aligned, 64byte or more is very possible.

Hm. Indeed, using alloc_skb() is right in this case,
since we reuse the same RX buffer and never pass it on to mac80211 directly.
Instead, new SKBs are formed from the stream and sent to mac80211.

So yes, it makes sense to use alloc_skb() instead of dev_alloc_skb().
A small nitpick: It would be a bit clearer if you can use kfree_skb()
instead of dev_kfree_skb_any() in the corresponding places.

Sujith
