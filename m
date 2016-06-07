Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36555 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcFGBbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 21:31:10 -0400
Received: by mail-lf0-f45.google.com with SMTP id b73so105321895lfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 18:31:10 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [Make-wifi-fast] [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
From: Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
Date: Tue, 7 Jun 2016 04:31:06 +0300
Cc: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <17429B50-653E-4D4A-A49B-A40DB5CF6311@gmail.com> (sfid-20160607_033134_078521_36C3F5AF)
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk> <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com> <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com> <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 7 Jun, 2016, at 03:01, Adrian Chadd <adrian@freebsd.org> wrote:
> 
> I also found one of my notes in my version of this - how can we
> estimate the duration of an A-MPDU, when we only get hardware
> de-encapsulated frames?

If my understanding is correct:

The A-MPDU itself is sent at the “data” rate (selected by Minstrel), so its total size can be used to calculate this portion of its duration in the same way as any other packet.

It is also surrounded by the same framing/preamble material, sent at the fixed “control” rate, as any normal frame.

The sum of these two major components should be the total airtime, no?

Or is the difficulty in identifying which de-encapsulated frames belonged to a particular A-MPDU?

 - Jonathan Morton

