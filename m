Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33994 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744AbZAHRzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 12:55:51 -0500
Received: from [172.20.18.193]([172.20.18.193]) (2314 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LKz60-0002SkC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Thu, 8 Jan 2009 09:55:04 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Thu, 8 Jan 2009 17:55:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Bob Copeland <bcopeland@gmail.com>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> (sfid-20090108_185603_488332_FECECB98)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
 <1231426017.922.2.camel@maxim-laptop>  <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
 <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Jan 2009, Bob Copeland wrote:
> On Thu, Jan 8, 2009 at 11:18 AM, Hugh Dickins <hugh@veritas.com> wrote:
> >> > So, that BUG_ON(bf->skb == NULL) appears to be unsafe under
> >> > memory pressure; but the fix wasn't obvious to me, so over
> >> > to you!
> 
> Thanks for the report... I guess the error paths haven't been tested
> much when rx buf setup fails.
> 
> > (Of course, just removing the BUG_ON, and making sure there's
> > no oops on the NULL pointer, would fix my immediate issue:
> > but I doubt the right fix will be as simple as that.)
> 
> Are your memory load testing scripts available somewhere?

No.  They're little more than repeatedly running a "make -j20"
kernel build in a tmpfs, and another in an ext2 on /dev/loop0
backed by large tmpfs file.  But most of that will be irrelevant
to the ath5k issue, and it can be tricky when setting up to get
memory and swap and tmpfs sizes right to do plenty of swapping,
without the test just collapsing in out-of-memory kills.

Let me see if I can reproduce the ath5k BUG with a straightforward
memhog, repeatedly dirtying more anon memory than RAM can provide.
Is there something suitable I could run to exercise that wireless
path concurrently?  It was just idling when I hit the BUGs before.

Hugh
