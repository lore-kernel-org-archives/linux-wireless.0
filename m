Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761550AbXHIAMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 20:12:15 -0400
Date: Wed, 8 Aug 2007 17:10:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-Id: <20070808171046.e6a3f506.akpm@linux-foundation.org>
In-Reply-To: <200708090202.20267.mb@bu3sch.de>
References: <200708071744.40287.mb@bu3sch.de>
	<46BA4E24.3060400@aurel32.net>
	<20070808164327.45803a64.akpm@linux-foundation.org>
	<200708090202.20267.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2007 02:02:19 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> > right stuff, all the latest stuff and I don't understand why some is going
> > into git-wireless and some is not.
> 
> Everything is going into git-wireless.
> git-wireless contains latest ssb. _but_ John complained
> about that. And he is right. SSB is not strictly wireless core.
> So I thought it was best to get ssb into mainline as soon as
> possible. So -mm is really the way to go into mainline.
> My plan was to merge mainline with the next merge window.
> 
> > I'd prefer to be dumbly pulling a tree which Michael controls rather than
> > trying to master it all in -mm, if possible.  A git tree or a quilt tree in
> > some open dir somewhere would suit?
> 
> It's a bit difficult, as bcm43xx depends on it. Which again depends
> on the wireless tree. :)
> So basically we are stuck with maintaining it in wireless-dev.
> 
> I don't know what your policy is with pulling from wireless-dev.
> So wireless-dev currently contains latest SSB. So if you pull from
> wireless-dev, you'll also get latest SSB. Though, if we want to
> merge SSB soon, we need it broken-out. That is what I was trying
> to do.

Still confused.

I pull
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git#mm-master
into -mm.  Could be that John puts other things into other trees which do
not appear in #mm-master, I don't know.

Given that you are the developer and maintainer of ssb it is appropriate
(especially at this stage) that you run a tree.  Just a plain old quilt
tree like
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/
would be fine.

If that tree is relative to some tree which John is running then that's OK,
as long as someone tells me where to get that tree from.

Or just merge all of SSB via John's tree.  I don't think it matters that
it's not strictly a wireless thing.  
