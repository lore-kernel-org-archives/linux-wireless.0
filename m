Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:37548 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbeDXOdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 10:33:22 -0400
Subject: Re: [PATCH 1/1 RFC] wcn36xx: fix buffer commit logic on TX path
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20180410174245.1116-1-daniel@zonque.org>
 <20180410174245.1116-2-daniel@zonque.org>
 <CAMZdPi8C84SC6RPS6yHfAgP7Xukdvw0m=Vqm4cV6HaOh7DX=Gg@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <f268b78d-b2f7-5500-1fd1-02ef04e28723@zonque.org> (sfid-20180424_163327_245616_DE38B20C)
Date: Tue, 24 Apr 2018 16:33:19 +0200
MIME-Version: 1.0
In-Reply-To: <CAMZdPi8C84SC6RPS6yHfAgP7Xukdvw0m=Vqm4cV6HaOh7DX=Gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Loic,

On Wednesday, April 11, 2018 03:30 PM, Loic Poulain wrote:
>>         /* Move the head of the ring to the next empty descriptor */
>> -        ch->head_blk_ctl = ctl->next;
>> +        ch->head_blk_ctl = ctl_skb->next;
>> +
>> +       /* Commit all previous writes and set descriptors to VALID */
>> +       wmb();
> 
> Is this first memory barrier really needed? from what I understand, we
> only need to ensure that the control descriptor is marked valid at the
> end of the procedure and we don't really care about the paylod one.
> 
>> +       desc_skb->ctrl = ch->ctrl_skb;
>> +       wmb();
>> +       desc_bd->ctrl = ch->ctrl_bd;
>>
>>         /*
>>          * When connected and trying to send data frame chip can be in sleep
> 
> Otherwise, patch makes sense.

This patch has somehow vanished from patchwork. I am running it since I
posted it and I can't see it causing any regressions, so I'd like to
repost. Given that you seem to be in favor of it, can I have your
Reviewed-by?


Thanks,
Daniel
