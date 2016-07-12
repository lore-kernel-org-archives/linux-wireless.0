Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33037 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbcGLMoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 08:44:06 -0400
Received: by mail-oi0-f47.google.com with SMTP id j185so13910499oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2016 05:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87shvfujl4.fsf@toke.dk>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name> <87shvfujl4.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Tue, 12 Jul 2016 14:44:05 +0200
Message-ID: <CAA93jw6z53P+JCPsjYD-vaY+9vq9ZO-Ob_cXm0AE76uVcM=F9g@mail.gmail.com> (sfid-20160712_144417_168544_4CB123F4)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2016 at 2:28 PM, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Felix Fietkau <nbd@nbd.name> writes:
>
>> Hi,
>>
>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>> regression when running local iperf on an AP (running the txq stuff) to
>> a wireless client.
>>
>> Here's some things that I found:
>> - when I use only one TCP stream I get around 90-110 Mbit/s
>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
>> - fairness between TCP streams looks completely fine
>> - there's no big queue buildup, the code never actually drops any packets
>> - if I put a hack in the fq code to force the hash to a constant value
>> (effectively disabling fq without disabling codel), the problem
>> disappears and even multiple streams get proper performance.
>>
>> Please let me know if you have any ideas.
>
> Hmm, I see two TCP streams get about the same aggregate throughput as
> one, both when started from the AP and when started one hop away.
> However, do see TCP flows take a while to ramp up when started from the
> AP - a short test gets ~70Mbps when run from one hop away and ~50Mbps
> when run from the AP. how long are you running the tests for?
>
> (I seem to recall the ramp-up issue to be there pre-patch as well,
> though).

The original ath10k code had a "swag" at hooking in an estimator from
rate control.
With minstrel in play that can be done better in the ath9k.

> As for why this would happen... There could be a bug in the dequeue code
> somewhere, but since you get better performance from sticking everything
> into one queue, my best guess would be that the client is choking on the
> interleaved packets? I.e. expending more CPU when it can't stick
> subsequent packets into the same TCP flow?

I share this concern.

The quantum is? I am not opposed to a larger quantum (2 full size
packets = 3028 in this case?).

> -Toke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
