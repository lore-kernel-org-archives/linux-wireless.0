Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:52050 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbcFJPdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 11:33:12 -0400
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
	<8737oll6fu.fsf@toke.dk>
Date: Fri, 10 Jun 2016 17:33:06 +0200
In-Reply-To: <8737oll6fu.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
	=?utf-8?Q?=C3=B8rgensen=22's?= message of
	"Fri, 10 Jun 2016 11:49:25 +0200")
Message-ID: <87wplxawjx.fsf@toke.dk> (sfid-20160610_173330_711055_D9E1D19C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen <toke@toke.dk> writes:

>> No idea. If that's possible, then track last MPDU within PPDU, so you
>> can at least fallback to _something_ when you detect a new first
>> (A-)MPDU?
>>
>> Or maybe it's impossible (i.e. not worth worrying) and HW always
>> reports last MPDU as far as status bits are concerned (regardless of
>> it being _actual_ last MPDU, i.e. it just says "ok, I'm done with this
>> PPDU").
>
> I'll try a couple of different permutations of this and see what works.
> Thanks for the ideas!

OK, so having tried all the different approaches, this seems to be the
best one. Basically, this:

	if (rs->rs_isaggr && rs->rs_firstaggr) {
		an->airtime_rx_start = rs->rs_tstamp;
	} else if (rs->rs_isaggr && !rs->rs_moreaggr && an->airtime_rx_start) {
		airtime = rs->rs_tstamp - an->airtime_rx_start;
	} else if (!rs->rs_isaggr) {
		an->airtime_rx_start = 0;
                /* keeping the previous length-based calculation here */
        }


This seems to give me RX airtime figures that correspond fairly well to
the TX airtime for running the same test in the opposite direction (I'm
running a ten-second UDP flood test and looking at the total airtime
accounted after the end of the run).

-Toke
