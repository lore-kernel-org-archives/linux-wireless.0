Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43365 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753571AbeFJRKe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 13:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <5B1AF7D4.9080700@broadcom.com>
References: <1528415316-6379-1-git-send-email-greearb@candelatech.com>
 <CAM_iQpULrWMNtgDcrZkc-uLtB0XOVFeZxQ6cFgpXwv7DtA9jzA@mail.gmail.com>
 <1f11144f-7580-03f4-72bd-76b0907d7ed1@candelatech.com> <5B1AF7D4.9080700@broadcom.com>
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date: Sun, 10 Jun 2018 19:10:32 +0200
Message-ID: <CABvG-CUUAQaWQuh1HqNmyM+wudBdAjZhSvHdsXEpwRyOwTg-fg@mail.gmail.com> (sfid-20180610_191041_818257_859DAFEB)
Subject: Re: [PATCH v2] net-fq: Add WARN_ON check for null flow.
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben,

The patch is symptomatic. fq_tin_dequeue() already checks if the list
is empty before it tries to access first entry. I see no point in
using the _or_null() + WARN_ON.

The 0x3c deref is likely an offset off of NULL base pointer. Did you
check gdb/addr2line of the ieee80211_tx_dequeue+0xfb? Where did it
point to?

I suspect there's not enough synchronization between quescing the
device/ath10k after fw crashes and performing mac80211's reconfig
procedure.


Micha=C5=82

On 8 June 2018 at 23:40, Arend van Spriel <arend.vanspriel@broadcom.com> wr=
ote:
> On 6/8/2018 5:17 PM, Ben Greear wrote:
>
> I recalled an email from Micha=C5=82 leaving tieto so adding his alternat=
e email
> he provided back then.
>
> Gr. AvS
>
>
>> On 06/07/2018 04:59 PM, Cong Wang wrote:
>>>
>>> On Thu, Jun 7, 2018 at 4:48 PM,  <greearb@candelatech.com> wrote:
>>>>
>>>> diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
>>>> index be7c0fa..cb911f0 100644
>>>> --- a/include/net/fq_impl.h
>>>> +++ b/include/net/fq_impl.h
>>>> @@ -78,7 +78,10 @@ static struct sk_buff *fq_tin_dequeue(struct fq *fq=
,
>>>>                         return NULL;
>>>>         }
>>>>
>>>> -       flow =3D list_first_entry(head, struct fq_flow, flowchain);
>>>> +       flow =3D list_first_entry_or_null(head, struct fq_flow,
>>>> flowchain);
>>>> +
>>>> +       if (WARN_ON_ONCE(!flow))
>>>> +               return NULL;
>>>
>>>
>>> This does not make sense either. list_first_entry_or_null()
>>> returns NULL only when the list is empty, but we already check
>>> list_empty() right before this code, and it is protected by fq->lock.
>>>
>>
>> Hello Michal,
>>
>> git blame shows you as the author of the fq_impl.h code.
>>
>> I saw a crash when debugging funky ath10k firmware in a 4.16 + hacks
>> kernel.  There was an apparent
>> mostly-null deref in the fq_tin_dequeue method.  According to gdb, it
>> was within
>> 1 line of the dereference of 'flow'.
>>
>> My hack above is probably not that useful.  Cong thinks maybe the
>> locking is bad.
>>
>> If you get a chance, please review this thread and see if you have any
>> ideas for
>> a better fix (or better debugging code).
>>
>> As always, if you would like me to generate you a buggy firmware that
>> will crash
>> in the tx path and cause all sorts of mayhem in the ath10k driver and
>> wifi stack,
>> I will be happy to do so.
>>
>> https://www.mail-archive.com/netdev@vger.kernel.org/msg239738.html
>>
>> Thanks,
>> Ben
>>
>
