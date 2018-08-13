Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42247 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbeHMOt0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:49:26 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: use-after free bug in hacked 4.16 kernel, related to fq_flow_dequeue
In-Reply-To: <5B70A1A6.3010906@candelatech.com>
References: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com> <87in4sy2ks.fsf@toke.dk> <cbfd3c11-6896-ff43-2434-7c29b04f8a79@candelatech.com> <877el8y0yo.fsf@toke.dk> <5B70A1A6.3010906@candelatech.com>
Date: Mon, 13 Aug 2018 14:07:32 +0200
Message-ID: <87zhxqcvwb.fsf@toke.dk> (sfid-20180813_140732_753889_E5E3EF80)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 08/02/2018 01:20 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> On 08/02/2018 12:45 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Ben Greear <greearb@candelatech.com> writes:
>>>>
>>>>> This is from my hacked kernel, could be my fault. I thought the fq
>>>>> guys might want to know however...
>>>>
>>>> Hmm, nothing obvious comes to mind; fq_flow_dequeue() just dequeues a
>>>> packet from the queue; it only has two memory derefs, to fq->lock and
>>>> flow->queue. Don't see why either of those should be freed at this
>>>> point.
>>>>
>>>> Unless fq_adjust_removal() is being inlined, perhaps? Then I suppose t=
he
>>>> flow->tin reference could be the problem, if the txq_info struct was
>>>> already freed; did you change anything around the handling of TXQs?
>>>
>>> I have worked on some stuff to fix other leaks and corruptions in ath10=
k related
>>> to txqs, maybe that is part of this problem.  My full tree is here:
>>>
>>> https://github.com/greearb/linux-ct-4.16
>>>
>>> This bug in question is fairly repeatable on my current setup, which
>>> is high speed tx + rx on a 9984 NIC, with buggy firmware that crashes
>>> often in the tx path. I think the crash only happens when I rmmod the
>>> driver under load, but possibly some of the fw crash cleanup logic
>>> that ran previously is also involved.
>>
>> Yeah, if it happens under load that is consistent with packets being
>> queued.
>>
>> It seems that mac80211 frees the netdevs of an interface before flushing
>> the TXQs, which may be the cause of the bug you are seeing. Could you
>> try the patch below and see if that fixes the issue?
>
> I've run with this for a few days, and it seems to at least not cause
> any extra problems.  I mostly fixed the firmware crashing I was seeing
> before, so not certain it fixes the root cause of the crashes I
> saw before.  I'm going to roll this into my 4.16 ct kernel for wider
> testing.

Right, thanks for testing. I'll send a proper patch :)

-Toke
