Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36834 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbcFJJCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:02:37 -0400
Received: by mail-wm0-f48.google.com with SMTP id n184so257696925wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 02:02:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87inxhl90y.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
 <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
 <87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk> <CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com>
 <87inxhl90y.fsf@toke.dk>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 10 Jun 2016 11:02:35 +0200
Message-ID: <CA+BoTQ=9X8621AbG+S3MqYFpeySsYSr3iiwCTHf3VpQAkXAHiQ@mail.gmail.com> (sfid-20160610_110244_396875_A7DD4D01)
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Adrian Chadd <adrian@freebsd.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2016 at 10:53, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>
>>> I initially thought that using the timestamp put into the frame by the
>>> hardware could be a way to get timing. But there's only a timestamp of
>>> the first symbol in rs_tstamp, and getting a time to compare it with is
>>> difficult; by the time the frame is handled in the rx tasklet, way too
>>> much time has been spent on interrupt handling etc for the current time
>>> to be worth comparing with.
>
> As an aside, I'm no longer sure this explanation for why I got wrong
> timings for this way of measuring RX time is correct. It may simply be
> that I was counting the same time interval more than once because I
> didn't realise that the handler would be called for each frame. See
> below.
>
>> I think rs_tstamp in rx-status is different for first MPDU and last
>> MPDU in an A-MPDU meaning you should be able to compute the entire
>> duration (if you track it, and this should be fairly straightforward
>> as you can't really rx interleaved MPDUs from different
>> A-MPDUs/stations). I'm not sure if the last MPDU defines the tstamp of
>> first symbol or last one.
>
> I actually went down this path again last night, but haven't had a
> chance to test it yet.
>
> So what I have now is this:
>
>        /* Only count airtime for last frame in an aggregate. FIXME: Should
>         * this be only the first frame? */
>        if (!rs->rs_isaggr || !rs->rs_moreaggr)
>                airtime = (tsf & 0xffffffff) - rs->rs_tstamp;
>
> Which was under the assumption that rs_tstamp will be the time of the
> first symbol *of the whole ampdu* for all the frames in that aggregate.
> However, if rs_tstamp differs between frames, tracking it at the first
> frame might be the right things to do?

For A-MPDU all MPDU rx status (except last one) should share the same
timestamp. Last one has a different one so all you need is to
distinguish first and last MPDU. Non A-MPDU obviously are special case
(status bits are pricky).


> Is the entire A-MPDU received before the RX handler is called for the
> first frame?

No idea. Maybe it is as there's distinction between "more" and "moreaggr".


Michał
