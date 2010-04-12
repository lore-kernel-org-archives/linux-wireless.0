Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:64009 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0DLOTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 10:19:01 -0400
Received: by qw-out-2122.google.com with SMTP id 8so2019589qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 07:19:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19394.51792.397561.53767@gargle.gargle.HOWL>
References: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
	 <19393.24337.10019.88274@gargle.gargle.HOWL>
	 <n2ld82e647a1004110611hc424f464gf8443967fa97c21a@mail.gmail.com>
	 <19394.51792.397561.53767@gargle.gargle.HOWL>
Date: Mon, 12 Apr 2010 22:19:00 +0800
Message-ID: <u2id82e647a1004120719w4892fa9ez184df916d988300a@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k-htc: replace __dev_alloc_skb with alloc_skb in
	ath9k_hif_usb_alloc_rx_urbs
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/12 Sujith <Sujith.Manoharan@atheros.com>:
> Ming Lei wrote:
>> The skb->data is passed into usb hcd and usb hcd will do dma mapping
>> for the buffer of skb->data, so it is better to keep it cache-line aligned.
>>
>> Size of cache line is very cpu dependent, we can't suppose it is
>> 32byte(NET_SKB_PAD) aligned, 64byte or more is very possible.
>
> Hm. Indeed, using alloc_skb() is right in this case,
> since we reuse the same RX buffer and never pass it on to mac80211 directly.
> Instead, new SKBs are formed from the stream and sent to mac80211.
>
> So yes, it makes sense to use alloc_skb() instead of dev_alloc_skb().
> A small nitpick: It would be a bit clearer if you can use kfree_skb()
> instead of dev_kfree_skb_any() in the corresponding places.

OK, I'll submit a new version to use kfree_skb.


-- 
Lei Ming
