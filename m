Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab1EUD2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 23:28:55 -0400
Date: Fri, 20 May 2011 20:11:35 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	Kalle Valo <kalle.valo@atheros.com>, linville@tuxdriver.com,
	devel@linuxdriverproject.org
Subject: Re: Plan for ath6kl cleanup
Message-ID: <20110521031135.GA19907@suse.de> (sfid-20110521_052900_086095_6C0D99AA)
References: <4DD668F4.6090308@atheros.com>
 <20110520133600.GA10521@suse.de>
 <20110520142934.GA20250@infradead.org>
 <1305910281.4209.36.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305910281.4209.36.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2011 at 09:51:21AM -0700, Joe Perches wrote:
> On Fri, 2011-05-20 at 10:29 -0400, Christoph Hellwig wrote:
> > On Fri, May 20, 2011 at 06:36:00AM -0700, Greg KH wrote:
> > > On Fri, May 20, 2011 at 04:13:24PM +0300, Kalle Valo wrote:
> > > > We have been thinking about how to get ath6kl out from staging and get
> > > > it to a first class citizen under drivers/net/wireless. There's quite a
> > > > lot of work to do get ath6kl cleaned up and the prospect of doing all
> > > > that through the staging-next tree wasn't that exciting. We would be
> > > > sending hundreds of patches and it would take a long time to cleanup the
> > > > driver. And the disconnection from the wireless core development also
> > > > sounded very daunting (cfg80211 API changes etc.).
> > > 
> > > This sounds like, "We don't like the kernel development model, it
> > > requires us to break everything up into small patches and show our work
> > > to everyone."
> > 
> > It's not the kernel development mode, it's something that you try to
> > impose on staging users.  Creating a more less new driver from a pig
> > pile of junk doesn't make sense minimized patches with micro-review.
> 
> I tried it once on ath6kl.
> Ended up with ~300 patches and a very clean tree.

Yes it can be done, and others do it for other drivers, it just takes a
bit of effort.

But as this is pretty much a total rewrite, that's fine to do
out-of-tree and then just submit it for inclusion in the main wireless
tree and then we can delete this driver.

We've done this for other wireless drivers, so it wouldn't be the first
time.  I just wanted to make sure that it wasn't something with how the
overall development process was working that caused this.

thanks,

greg k-h
