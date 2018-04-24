Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeDXPRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 11:17:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: Loic Poulain <loic.poulain@linaro.org>,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 1/1 RFC] wcn36xx: fix buffer commit logic on TX path
References: <20180410174245.1116-1-daniel@zonque.org>
        <20180410174245.1116-2-daniel@zonque.org>
        <CAMZdPi8C84SC6RPS6yHfAgP7Xukdvw0m=Vqm4cV6HaOh7DX=Gg@mail.gmail.com>
        <f268b78d-b2f7-5500-1fd1-02ef04e28723@zonque.org>
Date: Tue, 24 Apr 2018 18:17:26 +0300
In-Reply-To: <f268b78d-b2f7-5500-1fd1-02ef04e28723@zonque.org> (Daniel Mack's
        message of "Tue, 24 Apr 2018 16:33:19 +0200")
Message-ID: <87604gbpmh.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_171736_504202_15052E21)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> Hi Loic,
>
> On Wednesday, April 11, 2018 03:30 PM, Loic Poulain wrote:
>>>         /* Move the head of the ring to the next empty descriptor */
>>> -        ch->head_blk_ctl = ctl->next;
>>> +        ch->head_blk_ctl = ctl_skb->next;
>>> +
>>> +       /* Commit all previous writes and set descriptors to VALID */
>>> +       wmb();
>> 
>> Is this first memory barrier really needed? from what I understand, we
>> only need to ensure that the control descriptor is marked valid at the
>> end of the procedure and we don't really care about the paylod one.
>> 
>>> +       desc_skb->ctrl = ch->ctrl_skb;
>>> +       wmb();
>>> +       desc_bd->ctrl = ch->ctrl_bd;
>>>
>>>         /*
>>>          * When connected and trying to send data frame chip can be in sleep
>> 
>> Otherwise, patch makes sense.
>
> This patch has somehow vanished from patchwork.

It's still in patchwork, just in state RFC:

https://patchwork.kernel.org/patch/10333553/

-- 
Kalle Valo
