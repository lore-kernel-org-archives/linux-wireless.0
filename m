Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42499 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbcFJJtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:49:31 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime
	deficit
References: <20160603165144.17356-1-toke@toke.dk>
	<20160603165144.17356-6-toke@toke.dk>
	<CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
	<8737orucq4.fsf@toke.dk>
	<CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
	<CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
	<87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk>
	<CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com>
	<87inxhl90y.fsf@toke.dk>
	<CA+BoTQ=9X8621AbG+S3MqYFpeySsYSr3iiwCTHf3VpQAkXAHiQ@mail.gmail.com>
	<877fdxl8cu.fsf@toke.dk>
	<CA+BoTQmX0ULwRzHNjm83-_GbAQDMXgSsQgvBvm=4Bq3ozLOwjA@mail.gmail.com>
Date: Fri, 10 Jun 2016 11:49:25 +0200
In-Reply-To: <CA+BoTQmX0ULwRzHNjm83-_GbAQDMXgSsQgvBvm=4Bq3ozLOwjA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 10 Jun 2016 11:20:14 +0200")
Message-ID: <8737oll6fu.fsf@toke.dk> (sfid-20160610_114935_746138_E6E3D28E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 June 2016 at 11:08, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> For A-MPDU all MPDU rx status (except last one) should share the same
>>> timestamp. Last one has a different one so all you need is to
>>> distinguish first and last MPDU. Non A-MPDU obviously are special case
>>> (status bits are pricky).
>>
>> Right. So comparing the rs_stamp between first and last MPDU should give
>> the duration of the entire thing?
>
> Depends on how you define your "thing" :) I no, I don't know what
> you'll actually measure. It should be reasonable either way.

"Time spent receiving from this station" is the overall metric I want.
In this case that then becomes "Time spend receiving this aggregate"
which I can then account to that stations' total RX airtime.

>> This would require keeping state between subsequent calls to the RX
>> handler. Also, what happens if the last MPDU is lost?
>
> No idea. If that's possible, then track last MPDU within PPDU, so you
> can at least fallback to _something_ when you detect a new first
> (A-)MPDU?
>
> Or maybe it's impossible (i.e. not worth worrying) and HW always
> reports last MPDU as far as status bits are concerned (regardless of
> it being _actual_ last MPDU, i.e. it just says "ok, I'm done with this
> PPDU").

I'll try a couple of different permutations of this and see what works.
Thanks for the ideas!

>>> No idea. Maybe it is as there's distinction between "more" and
>>> "moreaggr".
>>
>> Hmm. If it is, comparing the stamp of the first MPDU to the current time
>> (when handling it) should give the needed duration? Will try doing that
>> and see what the result is.
>
> I'd say it's a little racy/inaccurate (and perhaps unreliable) to
> compare any kind of global timer and compare it against your rx-status
> descriptors.

Well, the timer would be the one coming from the card (tsf in the code
snippet I posted comes from ath9k_hw_gettsf64()). But yeah, it is going
to account some things that are not *strictly* air time (interrupt
latency for one). However, the question is how much this really
contributes (at least in cases where we are not running behind because
of lack of CPU). And if there's a constant overhead it shouldn't matter
so much as long as it is the same for all stations. Certainly just
timestamping packets with the current time works well enough in the
qdisc layer...

-Toke
