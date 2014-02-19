Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56080 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBSN0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:26:00 -0500
Received: by mail-bk0-f53.google.com with SMTP id my13so196598bkb.26
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 05:25:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87y517xo7j.fsf@kamboji.qca.qualcomm.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
	<87y517xo7j.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 19 Feb 2014 14:25:59 +0100
Message-ID: <CA+BoTQm3werwtNrWVLBFxN5QOvLxucu0crDXdAJJj4X0gSnXrw@mail.gmail.com> (sfid-20140219_142605_355624_2C4322F6)
Subject: Re: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 13:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> PCI is capable of handling scatter-gather lists.
>> This can be used to avoid copying memory.
>>
>> Change the name of the callback while at to
>> reflect its purpose.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +struct ath10k_hif_sg_item {
>> +     u16 transfer_id;
>> +     void *transfer_context;
>> +     void *vaddr; /* for debugging mostly */
>> +     u32 paddr;
>> +     u16 len;
>> +};
>
> This is the part I don't like. Instead of adding our own structs we
> instead should have everything in skb->cb and pass the skbs around. The
> sad part was that last fall I was working on cleaning up that but never
> found the time to finish it :(

There's simply not enough room to keep it all in ath10k_skb_cb
directly. It doesn't really make any sense to keep it there anyway
because sg_item is used as means to pass a complex function argument
to sg_tx(). The sg_item list is never used again.


Michał
