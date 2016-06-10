Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35523 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbcFJPww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 11:52:52 -0400
Received: by mail-it0-f45.google.com with SMTP id z189so185083057itg.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 08:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wplxawjx.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
 <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
 <87k2i1ml43.fsf@toke.dk> <87wpm1b6bu.fsf@toke.dk> <CA+BoTQ=2GNSW7uSw9acPxO6C22itbWtahmuNj2cT5_09QkNr-A@mail.gmail.com>
 <87inxhl90y.fsf@toke.dk> <CA+BoTQ=9X8621AbG+S3MqYFpeySsYSr3iiwCTHf3VpQAkXAHiQ@mail.gmail.com>
 <877fdxl8cu.fsf@toke.dk> <CA+BoTQmX0ULwRzHNjm83-_GbAQDMXgSsQgvBvm=4Bq3ozLOwjA@mail.gmail.com>
 <8737oll6fu.fsf@toke.dk> <87wplxawjx.fsf@toke.dk>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 10 Jun 2016 08:52:50 -0700
Message-ID: <CAJ-VmonRKvQi-c=NfT1RTc6whWQ0qBTEL3iKsYho=R7Jcy535Q@mail.gmail.com> (sfid-20160610_175256_117420_6A06C3DE)
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 [picking a random email to reply to]

I /think/ the TSF is only valid for the last frame of an aggregate.

'more' means "this RX frame is split across multiple RX descriptors"
"moreaggr" means "there's more subframes in this RX'ed A-MPDU"

If you get a TSF in the first frame, it's whatever was left over at
that point in the RX FIFO when it was last updated; it isn't an actual
timestamp timestamp. The logic for populating the descriptor contents
just takes stuff out of certain offsets in the RX FIFO, and sometimes
that contains stale/wrong data.

I'll go and double/triple check this (as well as where the TSF is
actually stamped - I think it's actually stamped at the leading edge
of a packet, but stamped at the /end/ of it.)


-adrian
