Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5043 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYBUS1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 13:27:38 -0500
Subject: Re: [PATCH] mac80211: fix IBSS code
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080221173224.GJ3094@tuxdriver.com>
References: <1203588513.17534.138.camel@johannes.berg>
	 <1203614162.2141.2.camel@dv>  <20080221173224.GJ3094@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 13:27:36 -0500
Message-Id: <1203618456.2141.9.camel@dv> (sfid-20080221_182742_192775_3F60FBA7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-21 at 12:32 -0500, John W. Linville wrote:
> On Thu, Feb 21, 2008 at 12:16:02PM -0500, Pavel Roskin wrote:
> > On Thu, 2008-02-21 at 11:08 +0100, Johannes Berg wrote:
> > > -			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> > > +#ifndef CONFIG_MAC80211_IBSS_DEBUG
> > > +			if (net_ratelimit())
> > > +#endif
> > 
> > It looks like you did a better job at guessing the intention of the code
> > than me.
> > 
> > Please apply this patch, not mine.
> 
> Hmmm...maybe you are right.  Unfortunately I already apply your
> patch instead.

I don't really care.  It's just a KERN_DEBUG message after all.  I see
no problems with using net_ratelimit() in all cases.  And I don't see
any strong need to suppress this message.  I don't expect it will happen
often.  But I'm not the one who will be looking at the logs :)

-- 
Regards,
Pavel Roskin
