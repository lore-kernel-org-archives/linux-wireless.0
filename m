Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42739 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbcG0Rbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 13:31:35 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
	<87oa5snzav.fsf@toke.dk> <87fur4nxhn.fsf@toke.dk>
	<CA+BoTQms1bKrNKgDVdBZYt3HTA3Hdv9tcN6vgnpNOYFHiwDmXw@mail.gmail.com>
Date: Wed, 27 Jul 2016 19:31:29 +0200
In-Reply-To: <CA+BoTQms1bKrNKgDVdBZYt3HTA3Hdv9tcN6vgnpNOYFHiwDmXw@mail.gmail.com>
	(Michal Kazior's message of "Mon, 25 Jul 2016 07:15:01 +0200")
Message-ID: <8760rrkmxa.fsf@toke.dk> (sfid-20160727_193139_333464_88A18855)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 20 July 2016 at 17:24, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>>
>>> Felix Fietkau <nbd@nbd.name> writes:
>>>
>>>> - if I put a hack in the fq code to force the hash to a constant value
>>>> (effectively disabling fq without disabling codel), the problem
>>>> disappears and even multiple streams get proper performance.
>>>
>>> There's definitely something iffy about the hashing. Here's the output
>>> relevant line from the aqm debug file after running a single TCP stream
>>> for 60 seconds to that station:
>>>
>>> ifname addr tid ac backlog-bytes backlog-packets flows drops marks overlimit collisions
>>> tx-bytes tx-packets
>>> wlp2s0 04:f0:21:1e:74:20 0 2 0 0 146 16 0 0 0 717758966 467925
>>>
>>> (there are two extra fields here; I added per-txq CoDel stats, will send
>>> a patch later).
>>>
>>> This shows that the txq has 146 flows associated from that one TCP flow.
>>> Looking at this over time, it seems that each time the queue runs empty
>>> (which happens way too often, which is what I was originally
>>> investigating), another flow is assigned.
>>>
>>> Michal, any idea why? :)
>>
>> And to answer this: because the flow is being freed to be reassigned
>> when it runs empty, but the counter is not decremented. Is this
>> deliberate? I.e. is the 'flows' var supposed to be a total 'new_flows'
>> counter and not a measure of the current number of assigned flows?
>
> Yes, it is deliberate. fq_codel qdisc does the same thing and I just
> mimicked it.

Right. Think it was the name that sent me down the wrong track ('flows'
instead of 'new_flows'). Especially since the way you structured things,
having a counter for how many flows are currently assigned each tid
might actually make sense...

-Toke
