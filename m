Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36999 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933310AbdDFP63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 11:58:29 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [Make-wifi-fast] [PATCH v3] mac80211: Dynamically set CoDel parameters per station
References: <20170405161810.30671-1-toke@toke.dk>
        <20170406093826.16626-1-toke@toke.dk>
        <1491475915.10124.75.camel@edumazet-glaptop3.roam.corp.google.com>
Date: Thu, 06 Apr 2017 17:58:25 +0200
In-Reply-To: <1491475915.10124.75.camel@edumazet-glaptop3.roam.corp.google.com>
        (Eric Dumazet's message of "Thu, 06 Apr 2017 03:51:55 -0700")
Message-ID: <87efx5ply6.fsf@alrua-kau> (sfid-20170406_175909_746270_629C1F8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Thu, 2017-04-06 at 11:38 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> +
>> +	if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
>> +		sta->cparams.target =3D MS2TIME(50);
>> +		sta->cparams.interval =3D MS2TIME(300);
>> +		sta->cparams.ecn =3D false;
>> +	} else {
>> +		sta->cparams.target =3D MS2TIME(20);
>> +		sta->cparams.interval =3D MS2TIME(100);
>> +		sta->cparams.ecn =3D true;
>> +	}
>> +}
>
> Why ECN is flipped on/off like that ?

The reasoning is that at really low bandwidths we're better off dropping
the packet and getting potentially latency-sensitive data queued behind
it through (see Dave's various rants with the topic "Packets have
mass").

> ECN really should be an admin choice.

Well, the trouble is that the mac80211 queues don't really have an admin
interface currently. So it'll always use ECN (before this change).

> Also, this change in parameters looks suspect to me, adding a bimodal
> behavior. I would consult Kathleen and Van on this possibility.

Yeah, I agree that it's somewhat of a hack from a theoretical point of
view. I've also been experimenting with Kathy's recommended way of
dealing with bursty MACs (turning off CoDel when there's less than an
MTU's worth of data left), but have not had a lot of success with it.
Guess I can go back and try some variants on that, unless someone else
has better ideas?

-Toke
