Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41077 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBSO2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:28:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
	<87y517xo7j.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm3werwtNrWVLBFxN5QOvLxucu0crDXdAJJj4X0gSnXrw@mail.gmail.com>
Date: Wed, 19 Feb 2014 16:18:38 +0200
In-Reply-To: <CA+BoTQm3werwtNrWVLBFxN5QOvLxucu0crDXdAJJj4X0gSnXrw@mail.gmail.com>
	(Michal Kazior's message of "Wed, 19 Feb 2014 14:25:59 +0100")
Message-ID: <87txbvxk1t.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_152804_616698_FD510D10)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 February 2014 13:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> +struct ath10k_hif_sg_item {
>>> +     u16 transfer_id;
>>> +     void *transfer_context;
>>> +     void *vaddr; /* for debugging mostly */
>>> +     u32 paddr;
>>> +     u16 len;
>>> +};
>>
>> This is the part I don't like. Instead of adding our own structs we
>> instead should have everything in skb->cb and pass the skbs around. The
>> sad part was that last fall I was working on cleaning up that but never
>> found the time to finish it :(
>
> There's simply not enough room to keep it all in ath10k_skb_cb
> directly.

After my cleanups transfer_context was not used and when using sk_buffs
properly vaddr and len would be useless. So we would have only transfer
id and paddr left. And when I was working on this they did fit to cb.

> It doesn't really make any sense to keep it there anyway because
> sg_item is used as means to pass a complex function argument to
> sg_tx(). 

If we used skbs we would just give a list/queue of them and no need to
have any extra structs.

> The sg_item list is never used again.

Ok, that's better. At least then it's later easier to convert to proper
skbs.

-- 
Kalle Valo
