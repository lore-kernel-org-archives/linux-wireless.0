Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37814 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0GZTXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 15:23:07 -0400
Received: by ewy23 with SMTP id 23so1001523ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 12:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4DC98E.6090002@openwrt.org>
References: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>
	<4C4DC98E.6090002@openwrt.org>
Date: Mon, 26 Jul 2010 21:23:01 +0200
Message-ID: <AANLkTinZ=KDo4aJU6Z93p1DXghF_MzE9CeBN6OuC_LnD@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: improve aggregation throughput by
	using only first rate
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/7/26 Felix Fietkau <nbd@openwrt.org>:
> On 2010-07-26 7:10 PM, Björn Smedman wrote:
>> I think there are some (in theory) simple improvements that can be
>> done to the tx aggregation / rate control logic. A proof of concept of
>> one such improvement is provided below. Basically, it's a hack that
> I think it makes sense to rely less on on-chip MRR for fallback, but I
> think to make this workable, we really should use the MRR table for
> something, otherwise the rate control algorithm will take much longer to
> adapt.
> It's probably better to fix this properly after I'm done with my A-MPDU
> rewrite, because then I can more easily push parts of the software
> retransmission behaviour into minstrel_ht directly.

Sounds very reasonable. I'm sure you've thought of it but now that
it's fresh in my head it would be great if the new aggregation design
allowed us to experiment with stuff like this:

* The rate control logic treats the average aggregate length as a
measured independent variable, when in fact it depends heavily on the
rates selected (via the 4 ms txop limit).

* When tx is aggregated most rate control probe frames end up inside
aggregates and are never used for probing (effective probe frequency
is divided by average aggregate length).

* When setting up a hardware MRR for an aggregate the focus should be
on throughput (as explained earlier in this thread). But there are
situations when reliability is important: e.g. when a subframe in the
aggregate is about to expire (because of time or block ack window). It
may even be advantageous to tx the subframes that are about to expire
in their own aggregate with lower / more reliable bitrate?

* In many busy radio environments the packet success rate depends very
much on the protection method being used (none, cts-to-self or
rts-cts), often more so than on the bitrate itself. It would be
interesting to experiment with including the protection method in the
rate selection, i.e. to probe for the optimal protection method and
bitrate combination.

* In order to have the best possible rate control in very dynamic rf
environments it's important to keep the hardware queue short and
select rates as late as possible (to not introduce unnecessary delay
when selecting new rates). I have no idea how to do this but it would
be great if the tx queue could be kept long enough to never stall tx,
but no longer.

* If I understand correctly the Atheros hardware does not adjust the
rts / cts-to-self duration field when going through the MRR
(correct?). In that case it may be even more advantageous to use
software retry as much as possible when some form of protection is
enabled.

Looking forward to the new aggregation code!

/Björn
