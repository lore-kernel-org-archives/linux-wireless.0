Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56559 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754289AbdA3Tnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 14:43:52 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Klaus Kinski <jpo234@outlook.de>
Cc: Dave Taht <dave.taht@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Packet throughput (and those iperf data rate) with mac80211/ath9k is 20% worse than net80211/madwifi
References: <HE1PR0701MB1803E46BC8EC38D682361523FC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
        <87lgtsjz6o.fsf@toke.dk>
        <CAA93jw5w6MaegbE+n9=-+F59vXTjEFGOH94Q=XYxiAqFKHeVfw@mail.gmail.com>
        <HE1PR0701MB1803A03DD96F300119936D0EFC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
Date: Mon, 30 Jan 2017 20:43:47 +0100
In-Reply-To: <HE1PR0701MB1803A03DD96F300119936D0EFC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
        (Klaus Kinski's message of "Mon, 30 Jan 2017 17:00:46 +0000")
Message-ID: <87o9yo2v0s.fsf@toke.dk> (sfid-20170130_204410_304061_21F26BB1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Klaus Kinski <jpo234@outlook.de> writes:

> The captures I used to create the statistics are here:
> https://drive.google.com/open?id=0ByFGz3ZH6JcYMGp0a05lYzBPNzA
>
> An obvious difference is, that Madwifi sends 5 packets in a row
> without waiting for an ACK whereas ath9k/mac80211 always seems to wait
> for an ACK. This seems to point to the "net80211 aggressive mode
> theory" https://wiki.freebsd.org/WifiAggressiveMode, IMHO.

I'm not too familiar with that part of the stack, but that seems
reasonable, yeah. AFAIK the "aggresive mode" is a pre-802.11n feature,
though, which is why you won't see that in ath9k. In 802.11n this kind
of bursting was replaced by aggregation, which you're not getting any of
since you're running in 802.11a mode, obviously.

The lack of bursting will translate to slightly lower throughput, which
will be why you see fewer packets transmitted by ath9k. Of course, if
your receiver supported aggregation, the numbers would look dramatically
better in ath9k's favour... ;)

-Toke
