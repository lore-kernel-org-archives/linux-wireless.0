Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56359 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZLNTnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:43:46 -0500
Received: by ewy19 with SMTP id 19so3764991ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 11:43:43 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 20:42:13 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200912141924.47370.bzolnier@gmail.com> <200912142016.00169.bzolnier@gmail.com> <20091214.112304.26981627.davem@davemloft.net>
In-Reply-To: <20091214.112304.26981627.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912142042.13251.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 08:23:04 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 20:16:00 +0100
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 20:16:00 +0100
> 
> > On Monday 14 December 2009 07:41:24 pm David Miller wrote:
> >> That's not true.  I use "gitk -- net/mac80211" all the time and it's
> >> helped me find bugs.  Or try "gitk -- include/tcp* net/ipv4/tcp*" to
> >> hunt down TCP regressions, etc.
> > 
> > It helps but with more complex ones you're back to guesswork and applying
> > by hand fixes for already fixed ages ago in-the-middle regressions.
> 
> Examples?
> 
> > commit d7fc02c7bae7b1cf69269992cf880a43a350cdaa
> > Merge: ee1262d 28b4d5c
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Tue Dec 8 07:55:01 2009 -0800
> > 
> >     Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
> > 
> >     * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6: (1815 commits)
> > 
> > with completely insane amount of changes:
> > 
> >  1396 files changed, 113877 insertions(+), 71108 deletions(-)
> > 
> > You may say that I should be following the development as it happens but such
> > strict requirement is not present in any other kernel subsystem tree.
> 
> About 1400 is drivers/net and about 500 is net
> 
> It's going to be a lot of changes no matter how I or John split it
> up.

The problem is not the total number of changes but their amount in one go.

> And guess what's just-as if not even more important?  A unified tree
> makes things easier for me.  So unless you plan on applying 100

[ 100 patches a day?  The math doesn't add up...? ]

> patches a day for me and doing all the cross merges, that's how I plan
> to keep doing things :-)

Oh, feel free to do what works best for you. :)

However looking at "Top non-author signoffs in 2.6.31" [1]:

David S. Miller     964 10.1%
Ingo Molnar         948 9.9%
Greg Kroah-Hartman  582 6.1%
...

it seems that there are people able to do large upstream merges in much
more transparent and reviewer-friendly way so it is not like there exists
some real physical barrier for not even trying to do things better..

[1] http://lwn.net/Articles/348445/
--
Bartlomiej Zolnierkiewicz
