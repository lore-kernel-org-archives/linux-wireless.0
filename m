Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXH1M2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 08:28:52 -0400
Date: Tue, 28 Aug 2007 13:28:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Message-ID: <20070828122838.GA16906@infradead.org>
References: <1188192012.13078.177.camel@debian.sh.intel.com> <20070827131026.GA21137@infradead.org> <1188285945.13078.242.camel@debian.sh.intel.com> <1188291015.7837.67.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188291015.7837.67.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2007 at 10:50:15AM +0200, Johannes Berg wrote:
> On Tue, 2007-08-28 at 15:25 +0800, Zhu Yi wrote:
> 
> > I know the method is not common used in the Linux drivers, but this is
> > decided by the hardware layout. For 3945 and 4965, 90% of the
> > hardware/firmware layout are the same and only 10% are different. This
> > makes it possible to support two slightly differs hardwares in one
> > driver. If the hardwares differ a lot (i.e 2100 and 2200), I won't even
> > think about to do it in this way.
> 
> To be fair, that's not what you do, you're building two drivers from one
> source rather than have a single driver that supports both. I'm fairly
> certain Christoph wouldn't object to the latter.

Absolutely not.  The right way to do it is to have a least a common
driver core, and if the device-specific parts get too big they can but
don't have to be separate modules.

With s"light amount of duplicated code" I meant possibly duplicated bits if
the split between common and device-specific bits doesn't work out perfectly
because e.g. both device types do the same kind of operation on differently
layed out data structures, which AFAIK is the case for some operations in
this driver.

> 
> johannes


---end quoted text---
