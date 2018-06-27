Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41316 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753030AbeF0Ib1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 04:31:27 -0400
Subject: Re: [PATCH] libertas: fix return codes in if_sdio_suspend()
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180626204834.14278-1-daniel@zonque.org>
 <950add1e-ec3a-a179-ff49-b49b3a748bcb@zonque.org>
 <CAPDyKFp-KkHbqR4+vOL2XZnAcXPPCJ7snW=2wFoz82UckPFW1w@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <3f91c902-4aef-77cb-6fa1-d90cb1bc4aab@zonque.org> (sfid-20180627_103132_535272_58559279)
Date: Wed, 27 Jun 2018 10:31:24 +0200
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp-KkHbqR4+vOL2XZnAcXPPCJ7snW=2wFoz82UckPFW1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 27, 2018 09:54 AM, Ulf Hansson wrote:
> On 26 June 2018 at 22:50, Daniel Mack <daniel@zonque.org> wrote:
>> On Tuesday, June 26, 2018 10:48 PM, Daniel Mack wrote:

>>> @@ -1321,7 +1334,7 @@ static int if_sdio_suspend(struct device *dev)
>>>          if (ret)
>>>                  return ret;
>>>    -     ret = lbs_suspend(card->priv);
>>> +       ret = lbs_suspend(priv);
>>>          if (ret)
>>>                  return ret;
>>>    @@ -1336,6 +1349,9 @@ static int if_sdio_resume(struct device *dev)
>>>          dev_info(dev, "%s: resume: we're back\n", sdio_func_id(func));
>>>    +     if (card->priv->power_up_on_resume)
>>> +               if_sdio_power_on(card);
>>> +
> 
> To guarantee firmware is loaded, don't you need the below as well?
> 
> wait_event(card->pwron_waitq, priv->fw_ready);

Hmm, yes. I should probably just be calling into if_sdio_power_restore().

I'll test that and resend the patch.


Thanks,
Daniel
