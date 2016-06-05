Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42662 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbcFEKwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 06:52:04 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Luca Muscariello <luca.muscariello@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"make-wifi-fast\@lists.bufferbloat.net"
	<make-wifi-fast@lists.bufferbloat.net>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [Make-wifi-fast] [RFC/RFT 0/5] Adding an airtime fairness
	scheduler to ath9k
References: <20160603165144.17356-1-toke@toke.dk>
	<CAHx=1M4K5jx1__PtD1hXZcpTrqvULfEr2fd7KJ=0neYoBQQt3g@mail.gmail.com>
Date: Sun, 05 Jun 2016 12:51:58 +0200
In-Reply-To: <CAHx=1M4K5jx1__PtD1hXZcpTrqvULfEr2fd7KJ=0neYoBQQt3g@mail.gmail.com>
	(Luca Muscariello's message of "Sat, 4 Jun 2016 17:24:42 +0200")
Message-ID: <877fe3ucvl.fsf@toke.dk> (sfid-20160605_125221_878750_380462D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Muscariello <luca.muscariello@gmail.com> writes:

> I don't fully understand your plots but it would be useful to report
> the  physical rate of the stations.

Yes, well, there's not really one rate to report for each station, since
Minstrel jumps about a bit and tries different ones.

> As a benchmark, if you know the physical rates assuming they are also
> optimally chosen (by minstrel for instance ) and stations don't move,
> the long term throughout can be computed ( e.g. for TCP ) assuming air
> time fairness. Than you can understand if your gain is what you should
> expect or if the implementation is not yet done.

So far I've just been looking at the figures for airtime (the first
graph in the blog post). These are the same numbers that the scheduler
uses to make scheduling decisions. It seems like the scheduler does help
somewhat, but is not perfect yet. Am definitely lacking a good ground
truth to compare against, though. Computing the expected throughput
might be possible, since minstrel does report statistics for how many
packets were transmitted at each rate. Will look into it; thanks for the
suggestion :)

-Toke
