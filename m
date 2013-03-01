Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45835 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3CAK3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 05:29:24 -0500
Message-ID: <513082F8.8080002@openwrt.org> (sfid-20130301_112927_683577_F8E77BE0)
Date: Fri, 01 Mar 2013 11:29:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20130228114724.GB16369@localhost> <512F5709.60907@openwrt.org> <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com> <512FAB01.2050104@openwrt.org> <CAJ-Vmokr4_k5QKrvVGU-1pG0Y07iW9evyRkj_U4-zQ5TH1ZHBQ@mail.gmail.com> <51307F80.4010202@openwrt.org> <CAJ-Vmok9-dmC5-vhHA1DE_KW6mp7P3tijrSz-3D45jjQthbcCA@mail.gmail.com>
In-Reply-To: <CAJ-Vmok9-dmC5-vhHA1DE_KW6mp7P3tijrSz-3D45jjQthbcCA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-01 11:22 AM, Adrian Chadd wrote:
> On 1 March 2013 02:14, Felix Fietkau <nbd@openwrt.org> wrote:
> 
>>> Having access to schedule which peer and how much to send to each peer
>>> would be nice. Stuff like "peer X only can have up to x ms in this WME
>>> class this round", so you don't have a busy, close peer monopolising
>>> the air. It also means you can start doing smart things with far away
>>> peers who retransmit a lot - they're likely tying up a lot of airtime.
>>>
>>> None of this is new. It's just, you know, new to open source. :-)
> 
>> In my opinion this doesn't really belong into a rate control module.
>> There should be a tx scheduling API to take care of this. Before I
>> implement something like this, I plan on exposing all per-station driver
>> queues to mac80211. This is necessary for a few other things anyway,
>> e.g. unifying software aggregation logic and fixing its buffer management.
> 
> Sure, but then some more clever tricks end up being difficult to
> implement. For example, knowing if a client is tying up too much
> airtime at the given rate and whether to back them off for a bit. Or
> to use smaller aggregation limits for certain clients because your'e
> trying to be "fairer" when trying to keep latency low. That kind of
> thing.
> 
> I think "rate control" should likely be expanded to "tx scheduling" as
> a whole, rather than sitting as a separate thing that just selects the
> rate for a node who has already been chosen to transmit.
Even with client airtime use, I still don't see how tx scheduling and
rate control belong together. In my opinion, the rate selection should
not be based on client airtime usage or the current load, as it can
optimize for throughput/airtime ratio without it.

- Felix
