Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37287 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYBTUHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:07:52 -0500
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Pavel Roskin <proski@gnu.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <20080220195913.GE21139@uranus.ravnborg.org>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 15:07:50 -0500
Message-Id: <1203538070.17531.6.camel@dv> (sfid-20080220_200801_584365_75A20893)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-20 at 20:59 +0100, Sam Ravnborg wrote:
> On Wed, Feb 20, 2008 at 11:38:29AM +0100, Johannes Berg wrote:
> > Make sure sparse checks endianness when run on mac80211.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Sam, is this an OK use of makefiles or is there something else I should
> > be doing?
> 
> I would prefer it to be kernel wide enabled.
> Tried a defconfig build.

I cannot agree more.  It's not like endian warnings are some nuisance
that's OK to fix later.  There are more real bugs indicated by the
endianess warnings than by any other warnings.

Besides, the endian warnings can be disabled by adding "-Wno-bitwise" to
the sparse flags.  Not that I would recommend it to anyone.

> When I enabled __CHECK_ENDIAN I got:
> 8 files with > 100 warnings
> 14 files with 10 to 99 warnings.
> 
> So nothing that should scare a kernel hacker...
> 
> warnings without: 1686
> warnings with: 2788
> 
> OK - thats a lot, but then fixing 8 files will significantly
> reduce this.

Thanks for the statistics!

-- 
Regards,
Pavel Roskin
