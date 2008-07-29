Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:8248 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYG2Pzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 11:55:33 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1545489ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 08:55:32 -0700 (PDT)
Message-ID: <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com> (sfid-20080729_175537_352647_BCDB3EFB)
Date: Tue, 29 Jul 2008 18:55:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217341293.10489.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 5:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 17:06 +0300, Tomas Winkler wrote:
>
>> Please put some reasoning behind this 'wrong'?  Different doesn't mean
>> wrong and 'only one' certainly doesn't mean wrong.
>> And it also doesn't mean that this hw should not operates correctly
>> under Linux. I also cannot publish any performance comparison but it
>> doesn't look wrong at all.
>
> Well I read that that you said one needs hardware queues for
> correctness, which clearly cannot be the case since neither Atheros nor
> Broadcom have hardware queues used for this.
>
>> If Intel is the only vendor implements this that way that we may push
>> the extra queuing into driver
>> but so far I've seen only athk9 with 11n.
>
> I think we need a terminology update and a bit of a big picture thing
> here.
>
> First of all, let me ask a question: Why should stations that enable
> aggregation be treated preferentially by giving them an extra qdisc?
>

> As far as I'm concerned, they should _not_ be, and thus their packets
> should flow through the qdisc for the same AC that packets from non-agg
> stations go through. If this AC queue gets full because it's background
> and video is hogging the air, then for fairness reasons we really should
> stop the whole AC and not let aggregation frames continue to flow.
>

So why do you need 4 HW queues for QoS, every vendor now implements it
that way today. There is only one medium, you don't put 4 packets on
the air at the same time.  Now imaging that withing single queue you
have another priority level why it is wrong to add another queue for
it?

In aggregation a bunch of packets need to be transmitted as a single
entity.  Aggregation on the air is not interleaved by other packets
There is a strict timing between packets. While there no such
distinction in application level and packets arriving interleaved to
the driver. So aggregation is definitely stream of its own rate and
from obvious reasons we need buffering for it.
Even if you don't have HW queue you still you need something that
selects bunch of packets for <sta,tid> pair put them on the air. It's
much easier if they are already queued in a single queue, maybe other
vendors have or other way to do it. This is very legitimate way.

I would say that not add HW queue might be the question of silicon
real estate for low cost products I also would handle it in SW.
You must count number of packets you are able to put in one
aggregation according TXOP etc. I guess just that HW do it faster and
more accurate and therefore can utilize medium better then sw which
has unknown delay in computation.

ipw2100 has QoS implemented in sw and it works in general but it's
headache and it's not accurate.

> I think we're talking about two different queue stopping issues here
> maybe?

Maybe
Tomas
