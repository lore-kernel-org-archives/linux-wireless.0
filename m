Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49554 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZAHQTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:19:04 -0500
Received: from [172.20.18.193]([172.20.18.193]) (2711 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LKxao-0002SrC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Thu, 8 Jan 2009 08:18:46 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Thu, 8 Jan 2009 16:18:56 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <1231426017.922.2.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.64.0901081603410.8411@blonde.anvils> (sfid-20090108_171913_772522_442B328D)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
 <1231426017.922.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Jan 2009, Maxim Levitsky wrote:
> On Thu, 2009-01-08 at 13:49 +0000, Hugh Dickins wrote:
> > 
> > When running swapping load tests, wireless alive but not in active use,
> > I've now twice hit the BUG_ON(bf->skb == NULL) in ath5k_tasklet_rx().
> > 
> > So, that BUG_ON(bf->skb == NULL) appears to be unsafe under
> > memory pressure; but the fix wasn't obvious to me, so over
> > to you!
> > 
> > I'd be glad to try patches, of course, but it's not happening
> > often enough for me to report back success quickly - unless I
> > stumble on a quicker way to reproduce it, it'll need a week or
> > two to grow confident of a fix.
> 
> I use aspire one, and I don't see that, did this happen several times?

A couple of times, when running memory swapping loads: I doubt it
would be any problem when there's easily freeable memory around.

> 
> Could you try compat-wireless:
> 
> http://wireless.kernel.org/en/users/Download

Thanks, I've downloaded the tarball, but the difference between the
drivers/net/wireless/ath5k/base.c in there and in Linus's git is
very little: I'd be be very surprised if it fixes this bug.

As I said, it'll take a week or two to be confident that the issue
has been fixed, so I'd rather embark on that once a likely fix has
gone in.

(Of course, just removing the BUG_ON, and making sure there's
no oops on the NULL pointer, would fix my immediate issue:
but I doubt the right fix will be as simple as that.)

> 
> It has many fixes that made my wireless on that notebook more or less
> usable.

I find 2.6.28's wireless very usable on that machine: I bet you're
a wireless specialist who stresses the wireless side of things in
ways I wouldn't begin to imagine: whereas I just browse and download
and scp a little, but as a memory specialist try swapping loads
which perhaps that driver had not been subjected to before.

Hugh
