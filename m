Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35783 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaBTGnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 01:43:03 -0500
Received: by mail-bk0-f48.google.com with SMTP id 6so486712bkj.7
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 22:43:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87txbvxk1t.fsf@kamboji.qca.qualcomm.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
	<87y517xo7j.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm3werwtNrWVLBFxN5QOvLxucu0crDXdAJJj4X0gSnXrw@mail.gmail.com>
	<87txbvxk1t.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 20 Feb 2014 07:43:00 +0100
Message-ID: <CA+BoTQn+8RUbmASLrrFwZqSRgWkLpy1Z3icy3Mp9VMPGHtQrEg@mail.gmail.com> (sfid-20140220_074317_853235_AEC57459)
Subject: Re: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 15:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 19 February 2014 13:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>
>>>> +struct ath10k_hif_sg_item {
>>>> +     u16 transfer_id;
>>>> +     void *transfer_context;
>>>> +     void *vaddr; /* for debugging mostly */
>>>> +     u32 paddr;
>>>> +     u16 len;
>>>> +};
>>>
>>> This is the part I don't like. Instead of adding our own structs we
>>> instead should have everything in skb->cb and pass the skbs around. The
>>> sad part was that last fall I was working on cleaning up that but never
>>> found the time to finish it :(
>>
>> There's simply not enough room to keep it all in ath10k_skb_cb
>> directly.
>
> After my cleanups transfer_context was not used and when using sk_buffs
> properly vaddr and len would be useless. So we would have only transfer
> id and paddr left. And when I was working on this they did fit to cb.

You'd need `len` so you can use part of the original MSDU as a frame
prefetch for htt tx descriptor.


>> It doesn't really make any sense to keep it there anyway because
>> sg_item is used as means to pass a complex function argument to
>> sg_tx().
>
> If we used skbs we would just give a list/queue of them and no need to
> have any extra structs.

Managing skbs would incur extra overhead. Skbs are also less flexible
and probably unnecessary (at least at this point).

Think about the qos workaround removal - you have to submit htt tx
descriptor frame prefetch in 2 parts instead of 1 (to make it appear
to FW as there's no QoS field). With skbs you have to allocate another
skb, copy part of MSDU into it... aaand you've just traded a single
memmove() for dev_alloc_skb(), skb_put() and a memcpy().


Micha³
