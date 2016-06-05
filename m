Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:32854 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcFERXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 13:23:09 -0400
Received: by mail-io0-f180.google.com with SMTP id t40so121914781ioi.0
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2016 10:23:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8737orucq4.fsf@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com> <8737orucq4.fsf@toke.dk>
From: Adrian Chadd <adrian@freebsd.org>
Date: Sun, 5 Jun 2016 10:23:07 -0700
Message-ID: <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com> (sfid-20160605_192312_800623_64D7BB11)
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2016 at 03:55, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Adrian Chadd <adrian@freebsd.org> writes:
>
>> I've been working on something similar in freebsd, so cool to see this
>> happening here!
>
> Cool. Do you have code available somewhere?

not yet. It was mostly what you just did in ath9k anyway :)

The sample rate control module and net80211 already had the duration
calculation bits, and I was just trying to figure out how to track it
per-node in a useful way without blowing CPU time.

>
>> The only thing missing atm is STBC and LDPC. My RX airtime code looks
>> basically like this one too; but I have TODO items for ensuring
>> LDPC/STBC calculations are sane.
>
> So basically this means taking into account whether there was MIMO in
> use (which may lower the transmit time)? My understanding is that (at
> least in Linux) this is encoded in the rate tables (i.e. a MIMO rate is
> a separate entry). Am I wrong in thinking so? Or is this something else
> entirely?

The existing routines take GI, MCS rate, channel width; figure out
MIMO, and do the math. The assumption is the symbol count is the same.
For STBC I think there's an additional symbol at the end (because it's
mixed current symbol plus previous symbol.) I forget the details for
LDPC.

I'll er, go read the standard again. :)


-adrian
