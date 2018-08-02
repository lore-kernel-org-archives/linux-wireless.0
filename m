Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57466 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbeHBVrP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 17:47:15 -0400
Subject: Re: use-after free bug in hacked 4.16 kernel, related to
 fq_flow_dequeue
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com>
 <87in4sy2ks.fsf@toke.dk>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <cbfd3c11-6896-ff43-2434-7c29b04f8a79@candelatech.com> (sfid-20180802_215441_378443_96F8B720)
Date: Thu, 2 Aug 2018 12:54:36 -0700
MIME-Version: 1.0
In-Reply-To: <87in4sy2ks.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2018 12:45 PM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> This is from my hacked kernel, could be my fault. I thought the fq
>> guys might want to know however...
>
> Hmm, nothing obvious comes to mind; fq_flow_dequeue() just dequeues a
> packet from the queue; it only has two memory derefs, to fq->lock and
> flow->queue. Don't see why either of those should be freed at this
> point.
>
> Unless fq_adjust_removal() is being inlined, perhaps? Then I suppose the
> flow->tin reference could be the problem, if the txq_info struct was
> already freed; did you change anything around the handling of TXQs?

I have worked on some stuff to fix other leaks and corruptions in ath10k related
to txqs, maybe that is part of this problem.  My full tree is here:

https://github.com/greearb/linux-ct-4.16

This bug in question is fairly repeatable on my current setup, which is high speed
tx + rx on a 9984 NIC, with buggy firmware that crashes often in the tx
path.  I think the crash only happens when I rmmod the driver under
load, but possibly some of the fw crash cleanup logic that ran previously
is also involved.

I'll get the FW fixed sooner or later and quite reloading modules, and then this
problem will probably go away.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
