Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51152 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160995AbcFHNGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 09:06:33 -0400
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
	<87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk>
	<CAJ-VmonOKjeY5uLeKFOVGmdBmm1V37TH72avf4XNe=-884Szwg@mail.gmail.com>
Date: Wed, 08 Jun 2016 15:06:26 +0200
In-Reply-To: <CAJ-VmonOKjeY5uLeKFOVGmdBmm1V37TH72avf4XNe=-884Szwg@mail.gmail.com>
	(Adrian Chadd's message of "Tue, 7 Jun 2016 18:41:19 -0700")
Message-ID: <87eg87q17x.fsf@toke.dk> (sfid-20160608_150656_645425_374030CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> Right. In the case of RX'ing an A-MPDU, we only get told about the
> A-MPDU boundaries (isaggr/lastaggr or something in the RX descriptor)
> but nothing telling us how long the original RX'ed PPDU is.
>
> So if we get say 16 frames and we are missing the middle one, we can
> reconstruct things okay. But if we miss the first 8 frames, we don't
> know when it started - we only get the RX aggr boundary flags set on
> the 9th and the 16th and we don't even know about the missed frames.

Yes, discovering retransmissions is difficult at the RX side by nature.
Another approach to catching (some of) these is trying to parse the MAC
address even for corrupted frames, and if it fits to a station, account
the airtime. Of course this will only catch cases where the frame header
does make it through, and it won't work if the hardware discards the
frame as corrupt before we get to see it.

> I think that's going to be a shortcoming right now. I couldn't think
> of a clever way to figure it out except to detect holes in the BAW and
> determine the client is missing frames and take actions there.

Yes, I'm fine with having the RX side airtime accounting just ignore the
retransmission issue, at least for now.

-Toke
