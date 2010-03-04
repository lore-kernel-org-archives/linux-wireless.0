Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:63413 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0CDQq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 11:46:59 -0500
Received: by iwn5 with SMTP id 5so2082828iwn.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 08:46:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100304141256.GA1985@hash.localnet>
References: <4B8C3A21.2050105@openwrt.org>
	 <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	 <4B8D25DC.8070502@openwrt.org>
	 <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
	 <alpine.DEB.2.00.1003031006390.10063@kauri>
	 <20100304141256.GA1985@hash.localnet>
Date: Thu, 4 Mar 2010 17:40:46 +0100
Message-ID: <133e8d7e1003040840p6d1eddc2nfab2876c4e5af474@mail.gmail.com>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Bob Copeland <me@bobcopeland.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 3:12 PM, Bob Copeland <me@bobcopeland.com> wrote:
>
> Minstrel definitely performs better in real life.

Agree, minstrel works very well in real life.

> That said, I looked at the current minstrel code and have a few
> puzzlements:
>
> - As I understand it, minstrel is not supposed to delay packets more
>  than 24 ms to avoid TCP resends.  However, if I understand the code,
>  this is done by limiting each MRR segment to 6 ms, which doesn't seem
>  right to me.  The retries in the second MRR slot will have to wait
>  a backoff before being used, right?

I took a look at the minstrel code back in madwifi and the comments
there suggest this 24 ms thing is not very theoretically based. It
sounds like a very reasonable explanation though so I'm not saying it
is wrong. But I think there might be another very good reason to limit
the number of attempts at a given rate: after a certain number of
retries we have to conclude that our hypothesis about the packet
error/success rate is probably incorrect, and there is no point in
more retries at that rate.

An example: Lets say my hypothesis is that the packet error rate at 24
Mbit/s is 10%. The probability that 3 attempts in a row will fail is
then 0.1^3 = 0.1% (given that my hypothesis is correct). A
statistician would say that we have tested my hypothesis and that it
can be rejected on the 99.9%-level. Continuing with a fourth attempt
is approaching what Einstein defined as insanity: doing the same thing
over and over again and expecting different results. :)

> - Often, two slots in the MRR array use the same rate (e.g. slots 1 and 3).
>  Maybe we should pick a 'next lower' rate for the lower slot in such a case?
>  If we are really in a place where the originally attempted rate isn't
>  workable, this might slightly boost throughput.

Agree. With the same reasoning as above this can be generalized to: if
an MRR slot has failed and we have fallen through to the next one then
that slot should be set up to be optimal under a new hypothesis
(taking the failed MRR segment into account).

In any case Felix patch is a giant leap towards better rate control.
Looking forward to tweaking it and this time hopefully submitting
something.

/Björn
