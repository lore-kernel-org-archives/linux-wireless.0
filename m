Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41346 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbeDKNhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 09:37:13 -0400
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
Message-ID: <b5837dcc-57e1-9169-fad4-6f553d7c2fa0@zonque.org> (sfid-20180411_153718_435063_A7B1EF51)
Date: Wed, 11 Apr 2018 15:37:10 +0200
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

Well, without documentation or the firmware sources, that's just
guesswork at this point. My assumption is only based on the weird
comments and workarounds in the downstream driver.

I added the second barrier to ensure that no descriptor is ever marked
valid unless all other bits are definitely in sync.


Thanks,
Daniel
