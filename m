Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:41487 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbcFJJIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:08:06 -0400
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
Date: Fri, 10 Jun 2016 11:08:01 +0200
In-Reply-To: <CA+BoTQ=9X8621AbG+S3MqYFpeySsYSr3iiwCTHf3VpQAkXAHiQ@mail.gmail.com>
	(Michal Kazior's message of "Fri, 10 Jun 2016 11:02:35 +0200")
Message-ID: <877fdxl8cu.fsf@toke.dk> (sfid-20160610_110812_083799_3522BA45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> For A-MPDU all MPDU rx status (except last one) should share the same
> timestamp. Last one has a different one so all you need is to
> distinguish first and last MPDU. Non A-MPDU obviously are special case
> (status bits are pricky).

Right. So comparing the rs_stamp between first and last MPDU should give
the duration of the entire thing? This would require keeping state
between subsequent calls to the RX handler. Also, what happens if the
last MPDU is lost?

>> Is the entire A-MPDU received before the RX handler is called for the
>> first frame?
>
> No idea. Maybe it is as there's distinction between "more" and
> "moreaggr".

Hmm. If it is, comparing the stamp of the first MPDU to the current time
(when handling it) should give the needed duration? Will try doing that
and see what the result is.

-Toke
