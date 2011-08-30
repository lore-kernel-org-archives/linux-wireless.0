Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58222 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1H3BIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 21:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com>
	<CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
Date: Mon, 29 Aug 2011 18:08:51 -0700
Message-ID: <CAA93jw4Dg--nz6F6fA0BACebXVdS9iY2As+__9ww1cu1Vy265Q@mail.gmail.com> (sfid-20110830_030857_641274_57501EC3)
Subject: Re: BQL crap and wireless
From: Dave Taht <dave.taht@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Tom Herbert <therbert@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2. Constant small drops in throughput
> =============================

Huge drops in throughput, actually.

> How to explain this? I have no clue. Two current theories:
>
> a. Dynamic Power save
> b. Offchannel operations on bgscans
> c. Bufferbloat: large hw queue size and sw retries
>
> One can rule out (a) and (b) by disabling Dynamic Power Save (iw dev
> wlan0 power_save off) and also bg scans. If its (c) then we can work
> our way up to proving a solution with the same fixes for the first
> latency issue. But there are more subtle issues here.

(in part, your) recent analysis of the periodicity of bandwidth drops
does point
strongly to points a and b being mis-implemented by many vendors and OS-makers,
and shows a clear path toward further testing by several labs.

> Bufferbloat
> folks talk about "ants" and "elephants". They call "Elephants" as
> frames that are just data, but "ants" are small frames that build make
> the networks work --

This is an over-simplification of a complex issue, and wrong.

Elephants are very large *streams* of tcp data, the kind you get after
a few seconds of operation, and mice are short ones, the kind you
commonly get with non-pipelined http protocols and normal websites.

As noted elsewhere, with tons of reference material on google and citeseer,
"tcp mice and elephants" are a well researched and understood topic -
or at least were, back when network research still happened, which
was prior to the explosion and predominance of wireless.

The need for AQMs such as RED, Blue, etc, to manage elephants was
well demonstrated back in  the early 90s. Being able to shoot/slow down
the elephants on a sane basis is also required to have sane shared
network behavior.

There has been a huge shift in TCP flows with first the advent of the
web for all things, and more recently, back again, with the rise of video.

> so consider 802.11 management frames, and TCP
> ACKs, and so forth.

Um, actually, if TCP acks are 'ANT's, it's news to me, and I co-coined the term.

There is one special case, commonly implemented in cable modems, of
Syn and Syn/Ack optimization, that might pay off to some extent in wireless.

Upstream ACK prioritization does seem to help when it comes to
managing interactive
flows on asymmetric (e.g. home) networks as (for example) demonstrated by
wondershaper and other QoS mechanism.

But anything involving TCP fits into the well defined mice and
elephant categories
already, not ANTs.

I'm told that most management frames are in a separately managed queue already.

> They argue we should prioritize these more and
> ensure we use whatever techniques we can to ensure we reduce latency
> for them.

ARP, DHCP, ND, RA, and various forms of ipv6's ping based protocols,
most routing protocols
in many aspects, numerous other non-tcp protocols, all count as ANTs.

> At least on ath9k we only aggregate data frames, but that
> doesn't mean we are not aggregating other "ant" frames.

The approach that we are experimenting with now, is putting
ANT-like packets into the VO and VI queues as appropriate and out
of the BE or BK queues.

Too early to publish preliminary results, but I am encouraged by what
I've seen so far.

It's interesting to note that a lot of web traffic is actually marked
as bulk traffic (tos of bulk)
which ends up in the wireless BK queue, rather than BE.




-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
