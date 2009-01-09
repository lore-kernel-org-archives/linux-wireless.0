Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45263 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZAIOLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 09:11:08 -0500
Received: from [172.20.26.116]([172.20.26.116]) (2475 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LLI4P-0002T7C@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Fri, 9 Jan 2009 06:10:41 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Fri, 9 Jan 2009 14:10:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Bob Copeland <bcopeland@gmail.com>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901091400290.925@blonde.anvils> (sfid-20090109_151113_476253_EB3ECDD9)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
 <1231426017.922.2.camel@maxim-laptop>  <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
  <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
 <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
 <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com>
 <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Jan 2009, Bob Copeland wrote:
> On Thu, Jan 8, 2009 at 1:41 PM, Bob Copeland <bcopeland@gmail.com> wrote:
> > On Thu, Jan 8, 2009 at 12:55 PM, Hugh Dickins <hugh@veritas.com> wrote:
> >> Let me see if I can reproduce the ath5k BUG with a straightforward
> >> memhog, repeatedly dirtying more anon memory than RAM can provide.
> >> Is there something suitable I could run to exercise that wireless
> >> path concurrently?  It was just idling when I hit the BUGs before.
> >
> > Receiving any packets will do it, in your case it was probably
> > beacons from nearby APs if you weren't using the wifi.  So iperf
> > or similar will work.
> 
> Actually it's probably enough to just intentionally fail one
> of the allocations in the driver.  I'll do that and let you know
> if I can easily break it.

Good, that should be a lot quicker.

My overnight try with simple memhog, and iperf -s receiving from
another machine doing iperf -c at intervals, didn't hit it (but my
more involved test wouldn't necessarily have hit it in that time either).

Currently trying just a 2.6.28 defconfig kernel build in tmpfs
(other filesystems should get their dirty pages pdflushed sooner)
along with the iperf, but haven't got the sizes suitably tuned yet.

Hugh
