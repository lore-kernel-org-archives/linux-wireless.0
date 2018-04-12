Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:41823 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbeDLMqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 08:46:24 -0400
Received: by mail-ot0-f179.google.com with SMTP id m22-v6so5798304otf.8
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 05:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b5837dcc-57e1-9169-fad4-6f553d7c2fa0@zonque.org>
References: <20180410174245.1116-1-daniel@zonque.org> <20180410174245.1116-2-daniel@zonque.org>
 <CAMZdPi8C84SC6RPS6yHfAgP7Xukdvw0m=Vqm4cV6HaOh7DX=Gg@mail.gmail.com> <b5837dcc-57e1-9169-fad4-6f553d7c2fa0@zonque.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Thu, 12 Apr 2018 14:45:43 +0200
Message-ID: <CAMZdPi_CYf1oS_+pX+prgT9aDULkkLbT6tkHiHmVo7zZkvZ7Zw@mail.gmail.com> (sfid-20180412_144628_164656_7E14E291)
Subject: Re: [PATCH 1/1 RFC] wcn36xx: fix buffer commit logic on TX path
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2018 at 15:37, Daniel Mack <daniel@zonque.org> wrote:
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
>
> Well, without documentation or the firmware sources, that's just
> guesswork at this point. My assumption is only based on the weird
> comments and workarounds in the downstream driver.
>
> I added the second barrier to ensure that no descriptor is ever marked
> valid unless all other bits are definitely in sync.

Fair enough!
