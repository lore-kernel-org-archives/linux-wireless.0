Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:18660 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0DKNLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 09:11:37 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1720397qwh.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 06:11:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19393.24337.10019.88274@gargle.gargle.HOWL>
References: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
	 <19393.24337.10019.88274@gargle.gargle.HOWL>
Date: Sun, 11 Apr 2010 21:11:36 +0800
Message-ID: <n2ld82e647a1004110611hc424f464gf8443967fa97c21a@mail.gmail.com>
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

2010/4/11 Sujith <Sujith.Manoharan@atheros.com>:
> tom.leiming@gmail.com wrote:
>> In ath9k_hif_usb_alloc_rx_urbs, ath9k-htc will pass skb->data into
>> usb hcd and usb hcd will do dma mapping and unmapping to the buffer
>> pointed by skb->data, so we should pass a cache-line aligned address.
>>
>> This patch replace __dev_alloc_skb with alloc_skb to make skb->data
>> pointed to a cacheline aligned address simply since ath9k-htc does not
>> skb_push on the skb.
>>
>
> AFAIK, the only architecture that has a requirement to override NET_SKB_PAD
> is powerpc, and it does it anyway - by setting it to a cacheline size.
>
> So why do we need to do this ?

Documentation/DMA-API.txt says:
| Warnings:  Memory coherency operates at a granularity called the cache
| line width.  In order for memory mapped by this API to operate
| correctly, the mapped region must begin exactly on a cache line
| boundary and end exactly on one (to prevent two separately mapped
| regions from sharing a single cache line).  Since the cache line size
| may not be known at compile time, the API will not enforce this
| requirement.  Therefore, it is recommended that driver writers who
| don't take special care to determine the cache line size at run time
| only map virtual regions that begin and end on page boundaries (which
| are guaranteed also to be cache line boundaries)

The skb->data is passed into usb hcd and usb hcd will do dma mapping
for the buffer of skb->data, so it is better to keep it cache-line aligned.

Size of cache line is very cpu dependent, we can't suppose it is
32byte(NET_SKB_PAD) aligned, 64byte or more is very possible.

Thanks,

-- 
Lei Ming
