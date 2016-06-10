Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37371 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbcFJJUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:20:17 -0400
Received: by mail-wm0-f49.google.com with SMTP id k204so93565243wmk.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 02:20:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877fdxl8cu.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
 <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
 <87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk> <CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com>
 <87inxhl90y.fsf@toke.dk> <CA+BoTQ=9X8621AbG+S3MqYFpeySsYSr3iiwCTHf3VpQAkXAHiQ@mail.gmail.com>
 <877fdxl8cu.fsf@toke.dk>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 10 Jun 2016 11:20:14 +0200
Message-ID: <CA+BoTQmX0ULwRzHNjm83-_GbAQDMXgSsQgvBvm=4Bq3ozLOwjA@mail.gmail.com> (sfid-20160610_112024_672377_18A3C300)
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Adrian Chadd <adrian@freebsd.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2016 at 11:08, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> For A-MPDU all MPDU rx status (except last one) should share the same
>> timestamp. Last one has a different one so all you need is to
>> distinguish first and last MPDU. Non A-MPDU obviously are special case
>> (status bits are pricky).
>
> Right. So comparing the rs_stamp between first and last MPDU should give
> the duration of the entire thing?

Depends on how you define your "thing" :) I no, I don't know what
you'll actually measure. It should be reasonable either way.


> This would require keeping state
> between subsequent calls to the RX handler. Also, what happens if the
> last MPDU is lost?

No idea. If that's possible, then track last MPDU within PPDU, so you
can at least fallback to _something_ when you detect a new first
(A-)MPDU?

Or maybe it's impossible (i.e. not worth worrying) and HW always
reports last MPDU as far as status bits are concerned (regardless of
it being _actual_ last MPDU, i.e. it just says "ok, I'm done with this
PPDU").


>>> Is the entire A-MPDU received before the RX handler is called for the
>>> first frame?
>>
>> No idea. Maybe it is as there's distinction between "more" and
>> "moreaggr".
>
> Hmm. If it is, comparing the stamp of the first MPDU to the current time
> (when handling it) should give the needed duration? Will try doing that
> and see what the result is.

I'd say it's a little racy/inaccurate (and perhaps unreliable) to
compare any kind of global timer and compare it against your rx-status
descriptors.


Michał
