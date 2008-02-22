Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3482 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYBVQCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:02:09 -0500
Date: Fri, 22 Feb 2008 10:57:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: sta info locking
Message-ID: <20080222155704.GD3067@tuxdriver.com> (sfid-20080222_160250_815586_99F9B086)
References: <1203677069.26341.52.camel@johannes.berg> <20080222143745.GB3067@tuxdriver.com> <1203693409.7082.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203693409.7082.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2008 at 04:16:49PM +0100, Johannes Berg wrote:
> 
> > > Hence, I think we can actually get away without more locking if we
> > > protect the flags better. Should we use a spinlock or the atomic
> > > set_bit()/clear_bit()/etc. operations?
> > 
> > Using the atomic operations seems appropriate to me.
> 
> Right, but I figured if we could get rid of the AMPDU spinlocks and just
> use a single one in total (for flags as well) then that'd be of benefit
> too; even with the dynamic allocation strategy (see other mail) we'd not
> need to allocate two more spinlocks for ampdu.

Yes, I thought that was behind your question.  I'll let Ron comment
on the AMPDU spinlock usage.

John
-- 
John W. Linville
linville@tuxdriver.com
