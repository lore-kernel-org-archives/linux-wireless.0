Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35550 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754660AbdDMS0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:26:04 -0400
Received: by mail-qt0-f182.google.com with SMTP id n46so52211439qta.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:26:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87efx5ply6.fsf@alrua-kau>
References: <20170405161810.30671-1-toke@toke.dk> <20170406093826.16626-1-toke@toke.dk>
 <1491475915.10124.75.camel@edumazet-glaptop3.roam.corp.google.com> <87efx5ply6.fsf@alrua-kau>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 13 Apr 2017 11:26:02 -0700
Message-ID: <CAA93jw7eYQ9dJ=tYuw5RDC7exf+mkc95U0jHP8FarAx0VuSwWA@mail.gmail.com> (sfid-20170413_202659_556505_DA3E8E55)
Subject: Re: [Make-wifi-fast] [PATCH v3] mac80211: Dynamically set CoDel
 parameters per station
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 6, 2017 at 8:58 AM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
> Eric Dumazet <eric.dumazet@gmail.com> writes:
>
>> On Thu, 2017-04-06 at 11:38 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>>
>>> +
>>> +    if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
>>> +            sta->cparams.target =3D MS2TIME(50);
>>> +            sta->cparams.interval =3D MS2TIME(300);
>>> +            sta->cparams.ecn =3D false;
>>> +    } else {
>>> +            sta->cparams.target =3D MS2TIME(20);
>>> +            sta->cparams.interval =3D MS2TIME(100);
>>> +            sta->cparams.ecn =3D true;
>>> +    }
>>> +}
>>
>> Why ECN is flipped on/off like that ?
>
> The reasoning is that at really low bandwidths we're better off dropping
> the packet and getting potentially latency-sensitive data queued behind
> it through (see Dave's various rants with the topic "Packets have
> mass").

My general take on wifi is that if you are running at - particularly,
stuck at - a low rate (sub 6mbits in the case of this code) - you have
so many other problems like retransmits, interference, etc, in the
first place, that the presence or absence of codel here is just a
small contributor to that noise.

We could leave ecn at whatever it is set to here and not flip it on or
off. It does seem sane to twiddle the parameters enough to make sure
codel doesn't trigger at less than a MTU vs the achieved rate.

>> ECN really should be an admin choice.
>
> Well, the trouble is that the mac80211 queues don't really have an admin
> interface currently. So it'll always use ECN (before this change).

Should we add a sysfs api to this?

>> Also, this change in parameters looks suspect to me, adding a bimodal
>> behavior. I would consult Kathleen and Van on this possibility.

It's sort of trimodal, actually. I think a more effective approach
would be codel's default were the normal 5% of 100ms, bumping it up
(as per the above) when we're having bad connectivity.... and we tried
to tackle excessive retransmits harder, and addressed  the side
impacts of multicast, instead, as much bigger parts of the problem.

> Yeah, I agree that it's somewhat of a hack from a theoretical point of
> view. I've also been experimenting with Kathy's recommended way of
> dealing with bursty MACs (turning off CoDel when there's less than an
> MTU's worth of data left), but have not had a lot of success with it.

I'm not in a position to resume trying myself.

> Guess I can go back and try some variants on that, unless someone else
> has better ideas?

Just as stuck as you are!

>
> -Toke
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
