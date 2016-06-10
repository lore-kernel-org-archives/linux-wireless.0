Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36868 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbcFJIk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 04:40:56 -0400
Received: by mail-wm0-f48.google.com with SMTP id k204so92170881wmk.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 01:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wpm1b6bu.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
 <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
 <87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 10 Jun 2016 10:40:49 +0200
Message-ID: <CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com> (sfid-20160610_104102_577969_AA7B7C02)
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Adrian Chadd <adrian@freebsd.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 June 2016 at 13:12, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>
>>> [snip]
>>>
>>> I also found one of my notes in my version of this - how can we
>>> estimate the duration of an A-MPDU, when we only get hardware
>>> de-encapsulated frames?
>>
>> Well in my case I'm sidestepping this by getting the TX duration from
>> a register in the hardware. There seems to be registers containing the
>> duration spent on each step in the retry chain; I simply sum these.
>
> Ah, but you're still talking RX? Hmm, I'm using ath_pkt_duration() to
> compute the RX time, which does take into account MIMO (I think) but
> expects the size to include padding. Which is probably not included in
> the rs_datalen field of struct ath_rx_status that I'm using.
>
> So yeah, how to account for that?
>
> I initially thought that using the timestamp put into the frame by the
> hardware could be a way to get timing. But there's only a timestamp of
> the first symbol in rs_tstamp, and getting a time to compare it with is
> difficult; by the time the frame is handled in the rx tasklet, way too
> much time has been spent on interrupt handling etc for the current time
> to be worth comparing with.

I think rs_tstamp in rx-status is different for first MPDU and last
MPDU in an A-MPDU meaning you should be able to compute the entire
duration (if you track it, and this should be fairly straightforward
as you can't really rx interleaved MPDUs from different
A-MPDUs/stations). I'm not sure if the last MPDU defines the tstamp of
first symbol or last one.


Michał
