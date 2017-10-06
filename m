Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59296 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdJFRMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 13:12:39 -0400
Message-ID: <1507309955.19300.23.camel@sipsolutions.net> (sfid-20171006_191256_891942_B00CF4E0)
Subject: Re: [Make-wifi-fast] [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Morton <chromatix99@gmail.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Fri, 06 Oct 2017 19:12:35 +0200
In-Reply-To: <CAJq5cE0YewMkTcuWM_tRjJnP2vLa_cvoQEsgz8JhGLHxOOSRsw@mail.gmail.com> (sfid-20171006_161834_329224_D41F44FB)
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net>
         <CAJq5cE0YewMkTcuWM_tRjJnP2vLa_cvoQEsgz8JhGLHxOOSRsw@mail.gmail.com>
         (sfid-20171006_161834_329224_D41F44FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please don't use html format, the linux lists drop it]

> As I understand it, this code is mainly intended for stations that
> serve as an AP, rather than as a client.

Sure, it's pointless in all other cases since there's only one (L2)
station to talk to.

> Since the MAC layer is the one with easiest access to the real
> airtime statistics (much easier than, say, a qdisc), there is no
> better place to implement it.

I'm not arguing anything else, what are you trying to say?

> If RTS/CTS probes are in use, then the AP does in fact have control
> over receive bandwidth on a per station basis, at least in theory.

That's super theoretical, there's no chipset I know of that'd easily
let you use this to control it. You'd also use up airtime for a bunch
of RTS retransmits - they really aren't intended for that type of
usage.

> But I think this is simply an attempt to balance total airtime
> between stations by accounting for airtime used in both directions,
> even if one of those directions isn't controlled so strictly.

My concern is that you don't have _any_ control over the TX from the
station, so the client can effectively starve itself by sending "too
much". I'm concerned that this can lead to pathological corner cases
where the client tries to retransmit things because there was no proper
ACK etc.?

johannes
