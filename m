Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:49919 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbZCZSAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 14:00:06 -0400
Received: by qw-out-2122.google.com with SMTP id 8so771990qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 11:00:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238065059.4331.28.camel@johannes.local>
References: <1237712542.5100.766.camel@johannes.local> <1238065059.4331.28.camel@johannes.local>
Date: Thu, 26 Mar 2009 10:59:48 -0700
Message-ID: <43e72e890903261059m386b3614u40db8a1a1913c25c@mail.gmail.com> (sfid-20090326_190010_430251_809877E1)
Subject: Re: [RFC] regulatory information interpretation rules
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Richard Farina <sidhayn@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	Ivan Seskar <Seskar@winlab.rutgers.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 3:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-03-22 at 10:02 +0100, Johannes Berg wrote:
>> Ok, so I'm thinking about the interpretation rules for the regulator=
y
>> information. I even dreamt about this tonight, unfortunately...
>
> [...]
>
>> Now how should you interpret this? I'll propose the following
>> interpretation rules (and show how you arrive at the required
>> interpretation from above):
>>
>> =C2=A01) MIN values are really something like MIN+, i.e. approaching=
 the MIN
>> =C2=A0 =C2=A0 from above, that means that the value "2452 MHz" falls=
 into the
>> =C2=A0 =C2=A0 first of the ranges, not the second [3]
>>
>> =C2=A02) The entire band a channel occupies needs to be covered by (=
any
>> =C2=A0 =C2=A0 number of) contiguous rules.
>>
>> =C2=A03) The MAXBW value specifies what maximum bandwidth a channel =
can use
>> =C2=A0 =C2=A0 which has its center frequency (!) falling into the gi=
ven range.
>>
>> =C2=A04) The FLAGS specify restrictions that any channel _overlappin=
g_ the
>> =C2=A0 =C2=A0 given range has to operate under.
>>
>> That is all. Now let me show how to interpret this.
>
> Let me rewrite those rules, more formally.
>
> Let's take an example regdomain with "n" rules:
>
> country EX:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(MIN_1 - MAX_1 @ BW_1), (MAXAG_1, TXPWR_1)=
, FLAGS_1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(MIN_n - MAX_n @ BW_n), (MAXAG_n, TXPWR_n)=
, FLAGS_n
>
> And let's say we need to determine whether a channel, which
> (disregarding modulation for a moment) is determined by its center
> frequency and bandwidth:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CHANNEL =3D (CENTER, BW)
>
> Then the rules are as follows, now using the notation outlined here:
> http://en.wikipedia.org/wiki/Interval_(mathematics)#Notations_for_int=
ervals (I'd use latex notation if I knew everybody was familiar with it=
, you have to do with some words instead)
>
> =C2=A00) (stated outside rules before) for all 1 <=3D k < n : MAX_k <=
=3D MIN_{k+1}
> =C2=A0 =C2=A0[1]
>
> =C2=A01) each rule in the regdomain covers the frequency range (MIN_1=
, MAX_1]
> =C2=A0 =C2=A0[2]
>
> =C2=A02) given C =3D union (over all k =3D 1 .. n) of (MIN_k, MAX_k] =
it must be
> =C2=A0 =C2=A0true that (CENTER - BW/2, CENTER + BW/2) is a subset of =
C
>
> =C2=A03) it must be true for all 1 <=3D k <=3D n:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if CENTER in (MIN_k, MAX_k] : BW <=3D BW_k=
 =C2=A0 [3]
>
> =C2=A04) This is easier to formulate algorithmically:
> =C2=A0 =C2=A0USE_FLAGS =3D 0
> =C2=A0 =C2=A0for k =3D 1 .. n
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if CENTER in (MIN_k, MAX_k]:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0USE_FLAGS |=3D FLAGS_k
>
> johannes
>
> [1] this says "no overlap" but also "must be sorted" which can be
> =C2=A0 =C2=A0beneficial
> [2] this is a useless rule given the way I formulated rules 3 and 4, =
but
> =C2=A0 =C2=A0it helps think about how it works
> [3] given rule 0) the if only matches (at most) once

This helps a lot :), looks good to me! If anyone has a case where
overlapping regulatory rules _should_ exist now would be a great time
to give an example. Otherwise they go away.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
