Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43714 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932842AbeFKNSv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 09:18:51 -0400
Subject: Re: [PATCH v2] net-fq: Add WARN_ON check for null flow.
To: =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
References: <1528415316-6379-1-git-send-email-greearb@candelatech.com>
 <CAM_iQpULrWMNtgDcrZkc-uLtB0XOVFeZxQ6cFgpXwv7DtA9jzA@mail.gmail.com>
 <1f11144f-7580-03f4-72bd-76b0907d7ed1@candelatech.com>
 <5B1AF7D4.9080700@broadcom.com>
 <CABvG-CUUAQaWQuh1HqNmyM+wudBdAjZhSvHdsXEpwRyOwTg-fg@mail.gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2f1e8d2c-8134-69ff-48b3-c115605e219d@candelatech.com> (sfid-20180611_151906_338243_884E6019)
Date: Mon, 11 Jun 2018 06:18:41 -0700
MIME-Version: 1.0
In-Reply-To: <CABvG-CUUAQaWQuh1HqNmyM+wudBdAjZhSvHdsXEpwRyOwTg-fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2018 10:10 AM, Michał Kazior wrote:
> Ben,
>
> The patch is symptomatic. fq_tin_dequeue() already checks if the list
> is empty before it tries to access first entry. I see no point in
> using the _or_null() + WARN_ON.
>
> The 0x3c deref is likely an offset off of NULL base pointer. Did you
> check gdb/addr2line of the ieee80211_tx_dequeue+0xfb? Where did it
> point to?

gdb pointed to one line above the flow dereference, which is why I was
going to put some debugging in there.

>
> I suspect there's not enough synchronization between quescing the
> device/ath10k after fw crashes and performing mac80211's reconfig
> procedure.

I am already running this patch which helps with some of that.  That
patch never made it upstream, but it fixed problems for me earlier.

https://patchwork.kernel.org/patch/9457639/

Could easily be there are some more issues in that logic.

Someone else posted a patch to disable mac-80211 tx when FW crashes,
I think...I have not tried to backport that.

https://patchwork.kernel.org/patch/10411967/

Thanks,
Ben


>
>
> Michał
>
> On 8 June 2018 at 23:40, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>> On 6/8/2018 5:17 PM, Ben Greear wrote:
>>
>> I recalled an email from Michał leaving tieto so adding his alternate email
>> he provided back then.
>>
>> Gr. AvS
>>
>>
>>> On 06/07/2018 04:59 PM, Cong Wang wrote:
>>>>
>>>> On Thu, Jun 7, 2018 at 4:48 PM,  <greearb@candelatech.com> wrote:
>>>>>
>>>>> diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
>>>>> index be7c0fa..cb911f0 100644
>>>>> --- a/include/net/fq_impl.h
>>>>> +++ b/include/net/fq_impl.h
>>>>> @@ -78,7 +78,10 @@ static struct sk_buff *fq_tin_dequeue(struct fq *fq,
>>>>>                         return NULL;
>>>>>         }
>>>>>
>>>>> -       flow = list_first_entry(head, struct fq_flow, flowchain);
>>>>> +       flow = list_first_entry_or_null(head, struct fq_flow,
>>>>> flowchain);
>>>>> +
>>>>> +       if (WARN_ON_ONCE(!flow))
>>>>> +               return NULL;
>>>>
>>>>
>>>> This does not make sense either. list_first_entry_or_null()
>>>> returns NULL only when the list is empty, but we already check
>>>> list_empty() right before this code, and it is protected by fq->lock.
>>>>
>>>
>>> Hello Michal,
>>>
>>> git blame shows you as the author of the fq_impl.h code.
>>>
>>> I saw a crash when debugging funky ath10k firmware in a 4.16 + hacks
>>> kernel.  There was an apparent
>>> mostly-null deref in the fq_tin_dequeue method.  According to gdb, it
>>> was within
>>> 1 line of the dereference of 'flow'.
>>>
>>> My hack above is probably not that useful.  Cong thinks maybe the
>>> locking is bad.
>>>
>>> If you get a chance, please review this thread and see if you have any
>>> ideas for
>>> a better fix (or better debugging code).
>>>
>>> As always, if you would like me to generate you a buggy firmware that
>>> will crash
>>> in the tx path and cause all sorts of mayhem in the ath10k driver and
>>> wifi stack,
>>> I will be happy to do so.
>>>
>>> https://www.mail-archive.com/netdev@vger.kernel.org/msg239738.html
>>>
>>> Thanks,
>>> Ben
>>>
>>
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
