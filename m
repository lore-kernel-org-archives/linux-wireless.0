Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40140 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1KRVPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 16:15:25 -0500
Date: Fri, 18 Nov 2011 16:09:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
Message-ID: <20111118210953.GC2663@tuxdriver.com> (sfid-20111118_221529_772534_1ED984DC)
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
 <1321650012.10266.78.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321650012.10266.78.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 10:00:12PM +0100, Johannes Berg wrote:
> On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
> > The way the compat-* header files are included causes the default
> > pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
> > Files that define pr_fmt then generate a lot of build SPAM about
> > pr_fmt being redefined.
> > 
> > Eliminate the build noise by preemptively undefining pr_fmt in those
> > files that define it.  This is accomplished by adding a patch to the
> > patches directory.
> 
> This patch is going to be relatively painful when files move etc -- is
> that really worth it? I for one will just drop it in our compat version
> if it goes in since I don't even have all the files it patches :-)

I don't know how much those definitions will move, since they are
rooted to the tops of those files anyway.  If the files move or
whatever there will be some flux.  But then you'll be no worse-off
than we are now for that file, and hopefully only a few hunks will
have problems at any given time.

Personally, I hate seeing all those warnings fly-by.  It is even worse
when you know you are building backported code, where my experience
suggests that warnings are more likely to be revealing real problems.
Having all that SPAM about pr_fmt being redefined is just encouraging
us to ignore what might otherwise be legitimate warnings.

These hunks are one-liners that I predict will change rarely and
which are obvious to move or to add to new files.  I'd rather have
this patch than not.

John

P.S.  I'll see your threat to drop the patch at Intel and I'll raise
it with my threat to add the patch to Fedora. :-)
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
