Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758423AbYJJQyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:54:12 -0400
Date: Fri, 10 Oct 2008 09:50:45 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable <stable@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH v2.6.27] mac80211: fix two issues in debugfs
Message-ID: <20081010165045.GA1309@kroah.com> (sfid-20081010_185426_251126_FD66C64D)
References: <1223653970.3748.23.camel@johannes.berg> <20081010160157.GA26323@kroah.com> <1223656232.3748.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223656232.3748.28.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 06:30:32PM +0200, Johannes Berg wrote:
> On Fri, 2008-10-10 at 09:01 -0700, Greg KH wrote:
> > On Fri, Oct 10, 2008 at 05:52:49PM +0200, Johannes Berg wrote:
> > > This fixes RHBZ 466264, whenever the master interface is
> > > renamed this code would BUG_ON. Also fixes a separately
> > > reported bug with the debugfs dir being NULL.
> > > 
> > > This patch is not applicable to the next kernel version
> > > because both these issues have been fixed, the first one
> > > by not having the master interface have a ieee80211_ptr
> > > at all, and the second one by also leaving the function
> > > early.
> > 
> > So this will not be going into .28, right? 
> 
> No, it won't, the code has changed in ways that won't make this happen
> any more. The fix with the (!dir) part is on it's way, I could split
> that out separately if you'd like, but then we'd have to fix up the
> rejects because that patch looks different too even though the result
> will be very similar.

That's ok, just want to have things clear if people are looking and
notice it's not in Linus's tree when it goes into -stable.


> >  What -stable trees should it
> > go to, .27?  .26?  .25?
> 
> Good question. The latter fix with (!dir) applies to .26 as well, but
> the issue is hit so infrequently (only when adding the debugfs dir has
> failed before) that I'm not sure it's worth it. And the master interface
> issue isn't present before .27.

Ok, so only for .27 is fine with me, I'll queue it up.

thanks,

greg k-h
