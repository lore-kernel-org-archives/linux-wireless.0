Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4559 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbYBUSEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 13:04:08 -0500
Date: Thu, 21 Feb 2008 12:32:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix IBSS code
Message-ID: <20080221173224.GJ3094@tuxdriver.com> (sfid-20080221_180414_649361_03BEE485)
References: <1203588513.17534.138.camel@johannes.berg> <1203614162.2141.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203614162.2141.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 12:16:02PM -0500, Pavel Roskin wrote:
> On Thu, 2008-02-21 at 11:08 +0100, Johannes Berg wrote:
> > -			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> > +#ifndef CONFIG_MAC80211_IBSS_DEBUG
> > +			if (net_ratelimit())
> > +#endif
> 
> It looks like you did a better job at guessing the intention of the code
> than me.
> 
> Please apply this patch, not mine.

Hmmm...maybe you are right.  Unfortunately I already apply your
patch instead.

Johannes, I'll refactor this patch on top of proski's to get your
original intended result.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
