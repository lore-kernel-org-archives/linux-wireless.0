Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38250 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbeFHVkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 17:40:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id 69-v6so6070549wmf.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2018 14:40:38 -0700 (PDT)
Subject: Re: [PATCH v2] net-fq: Add WARN_ON check for null flow.
To: Ben Greear <greearb@candelatech.com>,
        =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
References: <1528415316-6379-1-git-send-email-greearb@candelatech.com>
 <CAM_iQpULrWMNtgDcrZkc-uLtB0XOVFeZxQ6cFgpXwv7DtA9jzA@mail.gmail.com>
 <1f11144f-7580-03f4-72bd-76b0907d7ed1@candelatech.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B1AF7D4.9080700@broadcom.com> (sfid-20180608_234042_424710_4AEB8467)
Date: Fri, 8 Jun 2018 23:40:36 +0200
MIME-Version: 1.0
In-Reply-To: <1f11144f-7580-03f4-72bd-76b0907d7ed1@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/8/2018 5:17 PM, Ben Greear wrote:

I recalled an email from Michał leaving tieto so adding his alternate 
email he provided back then.

Gr. AvS

> On 06/07/2018 04:59 PM, Cong Wang wrote:
>> On Thu, Jun 7, 2018 at 4:48 PM,  <greearb@candelatech.com> wrote:
>>> diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
>>> index be7c0fa..cb911f0 100644
>>> --- a/include/net/fq_impl.h
>>> +++ b/include/net/fq_impl.h
>>> @@ -78,7 +78,10 @@ static struct sk_buff *fq_tin_dequeue(struct fq *fq,
>>>                         return NULL;
>>>         }
>>>
>>> -       flow = list_first_entry(head, struct fq_flow, flowchain);
>>> +       flow = list_first_entry_or_null(head, struct fq_flow,
>>> flowchain);
>>> +
>>> +       if (WARN_ON_ONCE(!flow))
>>> +               return NULL;
>>
>> This does not make sense either. list_first_entry_or_null()
>> returns NULL only when the list is empty, but we already check
>> list_empty() right before this code, and it is protected by fq->lock.
>>
>
> Hello Michal,
>
> git blame shows you as the author of the fq_impl.h code.
>
> I saw a crash when debugging funky ath10k firmware in a 4.16 + hacks
> kernel.  There was an apparent
> mostly-null deref in the fq_tin_dequeue method.  According to gdb, it
> was within
> 1 line of the dereference of 'flow'.
>
> My hack above is probably not that useful.  Cong thinks maybe the
> locking is bad.
>
> If you get a chance, please review this thread and see if you have any
> ideas for
> a better fix (or better debugging code).
>
> As always, if you would like me to generate you a buggy firmware that
> will crash
> in the tx path and cause all sorts of mayhem in the ath10k driver and
> wifi stack,
> I will be happy to do so.
>
> https://www.mail-archive.com/netdev@vger.kernel.org/msg239738.html
>
> Thanks,
> Ben
>
