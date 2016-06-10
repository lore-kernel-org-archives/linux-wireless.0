Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:41063 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbcFJIxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 04:53:40 -0400
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
Date: Fri, 10 Jun 2016 10:53:33 +0200
In-Reply-To: <CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com>
	(Michal Kazior's message of "Fri, 10 Jun 2016 10:40:49 +0200")
Message-ID: <87inxhl90y.fsf@toke.dk> (sfid-20160610_105343_937086_4336A140)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> I initially thought that using the timestamp put into the frame by the
>> hardware could be a way to get timing. But there's only a timestamp of
>> the first symbol in rs_tstamp, and getting a time to compare it with is
>> difficult; by the time the frame is handled in the rx tasklet, way too
>> much time has been spent on interrupt handling etc for the current time
>> to be worth comparing with.

As an aside, I'm no longer sure this explanation for why I got wrong
timings for this way of measuring RX time is correct. It may simply be
that I was counting the same time interval more than once because I
didn't realise that the handler would be called for each frame. See
below.

> I think rs_tstamp in rx-status is different for first MPDU and last
> MPDU in an A-MPDU meaning you should be able to compute the entire
> duration (if you track it, and this should be fairly straightforward
> as you can't really rx interleaved MPDUs from different
> A-MPDUs/stations). I'm not sure if the last MPDU defines the tstamp of
> first symbol or last one.

I actually went down this path again last night, but haven't had a
chance to test it yet.

So what I have now is this:

       /* Only count airtime for last frame in an aggregate. FIXME: Should
        * this be only the first frame? */
       if (!rs->rs_isaggr || !rs->rs_moreaggr)
               airtime = (tsf & 0xffffffff) - rs->rs_tstamp;

Which was under the assumption that rs_tstamp will be the time of the
first symbol *of the whole ampdu* for all the frames in that aggregate.
However, if rs_tstamp differs between frames, tracking it at the first
frame might be the right things to do?

Is the entire A-MPDU received before the RX handler is called for the
first frame?

-Toke
