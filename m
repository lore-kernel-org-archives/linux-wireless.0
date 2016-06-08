Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35102 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbcFHBlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 21:41:21 -0400
Received: by mail-io0-f194.google.com with SMTP id n127so4049660iof.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2016 18:41:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wpm1b6bu.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
 <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
 <87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 7 Jun 2016 18:41:19 -0700
Message-ID: <CAJ-VmonOKjeY5uLeKFOVGmdBmm1V37TH72avf4XNe=-884Szwg@mail.gmail.com> (sfid-20160608_034125_089556_6380246A)
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 June 2016 at 04:12, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
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

Right. In the case of RX'ing an A-MPDU, we only get told about the
A-MPDU boundaries (isaggr/lastaggr or something in the RX descriptor)
but nothing telling us how long the original RX'ed PPDU is.

So if we get say 16 frames and we are missing the middle one, we can
reconstruct things okay. But if we miss the first 8 frames, we don't
know when it started - we only get the RX aggr boundary flags set on
the 9th and the 16th and we don't even know about the missed frames.

I think that's going to be a shortcoming right now. I couldn't think
of a clever way to figure it out except to detect holes in the BAW and
determine the client is missing frames and take actions there.


-adrian
