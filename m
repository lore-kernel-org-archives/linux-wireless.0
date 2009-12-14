Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:17859 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbZLNTRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:17:51 -0500
Received: by ey-out-2122.google.com with SMTP id d26so940907eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 11:17:49 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 20:16:00 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200912141720.11465.bzolnier@gmail.com> <200912141924.47370.bzolnier@gmail.com> <20091214.104124.98693961.davem@davemloft.net>
In-Reply-To: <20091214.104124.98693961.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912142016.00169.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 07:41:24 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 19:24:47 +0100
> 
> > On Monday 14 December 2009 07:03:45 pm David Miller wrote:
> >> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> Date: Mon, 14 Dec 2009 17:20:11 +0100
> >> 
> >> > Well, in theory all maintainers should be testing -next kernels
> >> > so nothing should change also in this regard.
> >> 
> >> You conveniently did not quote and respond to my comments showing that
> >> you can ask git tools to seperate out the changesets for you, regardless
> >> of what subsystem maintainers decide to do.
> >> 
> >> Power is in your hands, really. :-)
> > 
> > That is simply untrue from Linus' kernel point of view.
> > 
> > Each networking merge contains multiple sub-merges from wireless tree
> > (at random points in networking tree history) which in turn may contain
> > multiple sub-merges from Johannes (at random points in wireless tree
> > history) and wireless driver sub-projects so unless you are a hardcore
> > networking/wireless developer it is practically impossible to make
> > a sense out of it in a reasonable time.
> 
> That's not true.  I use "gitk -- net/mac80211" all the time and it's
> helped me find bugs.  Or try "gitk -- include/tcp* net/ipv4/tcp*" to
> hunt down TCP regressions, etc.

It helps but with more complex ones you're back to guesswork and applying
by hand fixes for already fixed ages ago in-the-middle regressions.

However that's not the main point here.

With almost all other major trees I'm able to stay more-or-less informed on
what is being merged to Linus tree and follow the development thanks to well
fine-grained pull requests (up to few hundred commit in one go, very often
accompanied by combined diff).

The networking is unfortunate exception with thousands of commits in one go,
i.e. for 2.6.33 "merge window" it was 1815 (!) commits:

commit d7fc02c7bae7b1cf69269992cf880a43a350cdaa
Merge: ee1262d 28b4d5c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Dec 8 07:55:01 2009 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6

    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6: (1815 commits)

with completely insane amount of changes:

 1396 files changed, 113877 insertions(+), 71108 deletions(-)

You may say that I should be following the development as it happens but such
strict requirement is not present in any other kernel subsystem tree.

--
Bartlomiej Zolnierkiewicz
