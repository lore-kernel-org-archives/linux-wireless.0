Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:36213 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbcJXPJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 11:09:22 -0400
Received: by mail-qt0-f170.google.com with SMTP id m5so130404985qtb.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 08:09:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 24 Oct 2016 08:09:15 -0700
Message-ID: <CAA93jw6Ec-Nw4GORdBnS10PQFWS4BfooJpZg3J9tD3RKbXAENg@mail.gmail.com> (sfid-20161024_170931_876385_835C1F9F)
Subject: Re: Bayesian rate control
To: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn@openias.org>,
        make-wifi-fast@lists.bufferbloat.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 23, 2016 at 6:57 AM, Bj=C3=B6rn Smedman <bjorn@openias.org> wro=
te:
> Hi all,
>
> I've been thinking about rate control a bit lately. I've written up
> some of my thoughts in a blog post
> (http://www.openias.org/bayesian-wifi-rate-control), but very briefly

It is nice to see some newer thinking here.

> put I'd like to build a rate control algorithm based on Bayesian
> statistical inference, possibly by modeling the rate control problem
> as a "multi-armed bandit" problem and/or using Thompson sampling.

The paper on minstrel's design was never widely published. I linked to it h=
ere:

http://blog.cerowrt.org/post/minstrel/

Looking harder at rate control has long been on my todo list, but at
the top of my list to finish first has been the fair queuing
(fq_codel) and airtime fairness work.

https://blog.tohojo.dk/2016/06/fixing-the-wifi-performance-anomaly-on-ath9k=
.html#results

http://blog.cerowrt.org/post/real_results

Once you are statistically hitting more stations, more often, on a
more regular basis, with smaller txops, I felt that many things that
were perceived as rate control problems would go away, and other
things become easier.

A basic "fix" to minstrel is to opportunistically sample (which so far
as I know, minstrel-blues does), rather than at a fixed rate.

btw: I called my early (unpublished) attempt at a "minstrel-2", "bard". :)

The now-enormous search space is a big problem in present-day
minstrel, followed by excessive retries/latency when sampling, and
hidden stations are becoming more and more of a problem as densities
go up. (long list of minstrel issues on that first link I posted
above).

> A couple of questions for the list:
>
> 1. Is there anybody else out there thinking along similar lines?

Yes and no. At the moment I am thinking about the insights from the
TCP "BBR" work google just published: (paywalled but at:
http://queue.acm.org/app/ ) where they also point to max-plus algebra
as being helpful for solving the problems it had.

> I'd very much like to find collaborators interested in working on
> this. It coruld serve as a pretty nice masters thesis problem, for
> example.

Please join us over on the make-wifi-fast list. There are more than a
few good papers to be had out of it.

>
> 2. What would be the best hardware/software stack to base this work on?

Presently ath9k is the only game in town, and developing/debugging on
x86 is the easiest.

> I'm thinking the best driver for rate control experimentation would be
> ath9k, right? If so then a TP-Link TL-WA901ND router (apparently based
> on Qualcomm QCA956x SOC) with OpenWrt, and a TP-Link TL-WDN4800 PCIe
> card (apparently based on Atheros AR9380 with PCI ID 168c:0030) for my
> desktop sounds like a good combo, no? But would I have to run a custom
> kernel on my desktop then (or can I somehow get by with an Ubuntu
> standard kernel)?

These days I am using a pcengines apu2 as my primary x86 testbed, with
ath9k and ath10k cards in it (and one day mt72). The new turris omnia
looks like a good platform also. I've been trying to use stuff newer
than AR92xx there.

Another box I really like is the ubnt uap-lite.

Prior to all those, it was the wndr3800, archer c7v2, and nanostation
m5s for outdoor work.

>
> Any other thoughts or pointers are also more than welcome.
>
> Many thanks,
>
> Bj=C3=B6rn Smedman



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
