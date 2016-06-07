Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:55841 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751AbcFGLM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 07:12:58 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
References: <20160603165144.17356-1-toke@toke.dk>
	<20160603165144.17356-6-toke@toke.dk>
	<CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
	<8737orucq4.fsf@toke.dk>
	<CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
	<CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
	<87k2i1ml43.fsf@toke.dk>
Date: Tue, 07 Jun 2016 13:12:53 +0200
In-Reply-To: <87k2i1ml43.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
	=?utf-8?Q?=C3=B8rgensen=22's?= message of
	"Tue, 07 Jun 2016 10:58:04 +0200")
Message-ID: <87wpm1b6bu.fsf@toke.dk> (sfid-20160607_131302_740312_D0C9FEFE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen <toke@toke.dk> writes:

>> [snip]
>>
>> I also found one of my notes in my version of this - how can we
>> estimate the duration of an A-MPDU, when we only get hardware
>> de-encapsulated frames?
>
> Well in my case I'm sidestepping this by getting the TX duration from
> a register in the hardware. There seems to be registers containing the
> duration spent on each step in the retry chain; I simply sum these.

Ah, but you're still talking RX? Hmm, I'm using ath_pkt_duration() to
compute the RX time, which does take into account MIMO (I think) but
expects the size to include padding. Which is probably not included in
the rs_datalen field of struct ath_rx_status that I'm using.

So yeah, how to account for that?

I initially thought that using the timestamp put into the frame by the
hardware could be a way to get timing. But there's only a timestamp of
the first symbol in rs_tstamp, and getting a time to compare it with is
difficult; by the time the frame is handled in the rx tasklet, way too
much time has been spent on interrupt handling etc for the current time
to be worth comparing with.

-Toke
