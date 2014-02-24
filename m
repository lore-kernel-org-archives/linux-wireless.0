Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8416 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBXLrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 06:47:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
	<87y517xo7j.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm3werwtNrWVLBFxN5QOvLxucu0crDXdAJJj4X0gSnXrw@mail.gmail.com>
	<87txbvxk1t.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn+8RUbmASLrrFwZqSRgWkLpy1Z3icy3Mp9VMPGHtQrEg@mail.gmail.com>
Date: Mon, 24 Feb 2014 13:46:20 +0200
In-Reply-To: <CA+BoTQn+8RUbmASLrrFwZqSRgWkLpy1Z3icy3Mp9VMPGHtQrEg@mail.gmail.com>
	(Michal Kazior's message of "Thu, 20 Feb 2014 07:43:00 +0100")
Message-ID: <87wqgku41f.fsf@kamboji.qca.qualcomm.com> (sfid-20140224_124726_431369_587FDED9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 February 2014 15:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> It doesn't really make any sense to keep it there anyway because
>>> sg_item is used as means to pass a complex function argument to
>>> sg_tx().
>>
>> If we used skbs we would just give a list/queue of them and no need to
>> have any extra structs.
>
> Managing skbs would incur extra overhead. Skbs are also less flexible
> and probably unnecessary (at least at this point).

As a rule of thumb we should avoid reinventing things on our own and use
Linux infrastructure as much possible. There are a lot of benefits from
using sk_buffs.

> Think about the qos workaround removal - you have to submit htt tx
> descriptor frame prefetch in 2 parts instead of 1 (to make it appear
> to FW as there's no QoS field). With skbs you have to allocate another
> skb, copy part of MSDU into it... aaand you've just traded a single
> memmove() for dev_alloc_skb(), skb_put() and a memcpy().

I'm missing a lot of details here (and I can't check from code right
now), but are you saying that skb allocation is too slow? In that case
we should fix the skb allocation instead of working it around in ath10k.

But this is all hand waving for the future, not really something I see a
problem with this patchset.

-- 
Kalle Valo
