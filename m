Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11908 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0G0EoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 00:44:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 21:44:24 -0700
Message-ID: <4C4E6516.1070308@atheros.com>
Date: Tue, 27 Jul 2010 10:18:22 +0530
From: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Reply-To: ranga.ravuri@atheros.com
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: improve aggregation throughput by
 using only first rate
References: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>	<4C4DC98E.6090002@openwrt.org>	<AANLkTinZ=KDo4aJU6Z93p1DXghF_MzE9CeBN6OuC_LnD@mail.gmail.com> <4C4DE4F5.3010907@openwrt.org>
In-Reply-To: <4C4DE4F5.3010907@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/27/2010 01:11 AM, Felix Fietkau wrote:
> On 2010-07-26 9:23 PM, Björn Smedman wrote:
>> 2010/7/26 Felix Fietkau<nbd@openwrt.org>:
>>> On 2010-07-26 7:10 PM, Björn Smedman wrote:
>>>> I think there are some (in theory) simple improvements that can be
>>>> done to the tx aggregation / rate control logic. A proof of concept of
>>>> one such improvement is provided below. Basically, it's a hack that
>>> I think it makes sense to rely less on on-chip MRR for fallback, but I
>>> think to make this workable, we really should use the MRR table for
>>> something, otherwise the rate control algorithm will take much longer to
>>> adapt.
>>> It's probably better to fix this properly after I'm done with my A-MPDU
>>> rewrite, because then I can more easily push parts of the software
>>> retransmission behaviour into minstrel_ht directly.
>> Sounds very reasonable. I'm sure you've thought of it but now that
>> it's fresh in my head it would be great if the new aggregation design
>> allowed us to experiment with stuff like this:
>>
>> * The rate control logic treats the average aggregate length as a
>> measured independent variable, when in fact it depends heavily on the
>> rates selected (via the 4 ms txop limit).
> Yes, with the new design maybe we could use the initial rate lookup only
> for setting the sampling flag, and then doing a separate per-AMPDU
> lookup, which properly takes the AMPDU length into account.
>
>> * When tx is aggregated most rate control probe frames end up inside
>> aggregates and are never used for probing (effective probe frequency
>> is divided by average aggregate length).
> Nope, a probing frame never ends up inside an aggregate. It's always
> sent out as a single frame, which is why I had to make the decision
> about sending a probing frame more complex in minstrel_ht, compared to
> minstrel - the previous 10% stuff was limiting aggregation size.
>
>> * When setting up a hardware MRR for an aggregate the focus should be
>> on throughput (as explained earlier in this thread). But there are
>> situations when reliability is important: e.g. when a subframe in the
>> aggregate is about to expire (because of time or block ack window). It
>> may even be advantageous to tx the subframes that are about to expire
>> in their own aggregate with lower / more reliable bitrate?
> Yes, that's what I was thinking as well. We should probably make this
> decision based on the number of sw-retransmitted frames, and maybe
> consider the offset of seqno vs baw_tail as well.
>
>> * In many busy radio environments the packet success rate depends very
>> much on the protection method being used (none, cts-to-self or
>> rts-cts), often more so than on the bitrate itself. It would be
>> interesting to experiment with including the protection method in the
>> rate selection, i.e. to probe for the optimal protection method and
>> bitrate combination.
> Sounds good.
>
>> * In order to have the best possible rate control in very dynamic rf
>> environments it's important to keep the hardware queue short and
>> select rates as late as possible (to not introduce unnecessary delay
>> when selecting new rates). I have no idea how to do this but it would
>> be great if the tx queue could be kept long enough to never stall tx,
>> but no longer.
> This would work with what I suggested above - per-AMPDU rate lookup.
> With software scheduling that's easy to do, since we already restrict
> the queue to max. 2 AMPDUs
>
>> * If I understand correctly the Atheros hardware does not adjust the
>> rts / cts-to-self duration field when going through the MRR
>> (correct?). In that case it may be even more advantageous to use
>> software retry as much as possible when some form of protection is
>> enabled.
> Not sure, but I think it does adjust the duration field according to the
> rate, while transmitting.
[ranga] Yes it does. If you enable RTS on all rates, you would see 
different RTSs coming with different duration.
>> Looking forward to the new aggregation code!
> That will still take some time, I recently came up with some better
> design ideas, which require some larger changes to the code that I
> already wrote.
>
> - Felix
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
