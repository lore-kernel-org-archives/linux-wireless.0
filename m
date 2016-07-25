Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34823 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbcGYFPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 01:15:05 -0400
Received: by mail-wm0-f41.google.com with SMTP id f65so120591849wmi.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jul 2016 22:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fur4nxhn.fsf@toke.dk>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <87oa5snzav.fsf@toke.dk> <87fur4nxhn.fsf@toke.dk>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 25 Jul 2016 07:15:01 +0200
Message-ID: <CA+BoTQms1bKrNKgDVdBZYt3HTA3Hdv9tcN6vgnpNOYFHiwDmXw@mail.gmail.com> (sfid-20160725_071509_138229_F2BBCE98)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2016 at 17:24, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>
>> Felix Fietkau <nbd@nbd.name> writes:
>>
>>> - if I put a hack in the fq code to force the hash to a constant value
>>> (effectively disabling fq without disabling codel), the problem
>>> disappears and even multiple streams get proper performance.
>>
>> There's definitely something iffy about the hashing. Here's the output
>> relevant line from the aqm debug file after running a single TCP stream
>> for 60 seconds to that station:
>>
>> ifname addr tid ac backlog-bytes backlog-packets flows drops marks overlimit collisions
>> tx-bytes tx-packets
>> wlp2s0 04:f0:21:1e:74:20 0 2 0 0 146 16 0 0 0 717758966 467925
>>
>> (there are two extra fields here; I added per-txq CoDel stats, will send
>> a patch later).
>>
>> This shows that the txq has 146 flows associated from that one TCP flow.
>> Looking at this over time, it seems that each time the queue runs empty
>> (which happens way too often, which is what I was originally
>> investigating), another flow is assigned.
>>
>> Michal, any idea why? :)
>
> And to answer this: because the flow is being freed to be reassigned
> when it runs empty, but the counter is not decremented. Is this
> deliberate? I.e. is the 'flows' var supposed to be a total 'new_flows'
> counter and not a measure of the current number of assigned flows?

Yes, it is deliberate. fq_codel qdisc does the same thing and I just
mimicked it.


Michał
