Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:49436 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbcFGI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 04:58:09 -0400
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
Date: Tue, 07 Jun 2016 10:58:04 +0200
In-Reply-To: <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
	(Adrian Chadd's message of "Mon, 6 Jun 2016 17:01:08 -0700")
Message-ID: <87k2i1ml43.fsf@toke.dk> (sfid-20160607_105816_126570_C4BD3CC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> [snip]
>
> I also found one of my notes in my version of this - how can we
> estimate the duration of an A-MPDU, when we only get hardware
> de-encapsulated frames?

Well in my case I'm sidestepping this by getting the TX duration from a
register in the hardware. There seems to be registers containing the
duration spent on each step in the retry chain; I simply sum these.

-Toke
