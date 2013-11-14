Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3KNOsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:48:45 -0500
Message-ID: <1384440519.13941.31.camel@jlt4.sipsolutions.net> (sfid-20131114_154848_383812_96255B19)
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Nov 2013 15:48:39 +0100
In-Reply-To: <20131114143126.GC19070@garbanzo.do-not-panic.com> (sfid-20131114_152052_516271_FF484F9B)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
	 <1384378096.28806.20.camel@jlt4.sipsolutions.net>
	 <20131114143126.GC19070@garbanzo.do-not-panic.com>
	 (sfid-20131114_152052_516271_FF484F9B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 06:31 -0800, Luis R. Rodriguez wrote:

> > What's the point of this function rather than the driver setting the
> > region bits before registration?
> 
> I don't trust driver developers, this provides a simple interface
> which pushes driver developers to use CONFIG_CFG80211_CERTIFICATION_ONUS
> for driver DFS features, it also validates the input and also does
> the conversion to bitmasks for the driver developers. Without this
> we'd assume driver developers would enable DFS under proper regulatory
> configs but also require BIT() | BIT() settings.

It has nothing to do with trust. If the driver author sets

	dfs_capability = BIT(FCC) | BIT(ETSI)

you still don't have to use the values if CERTIFICATION_ONUS isn't set.
Therefore, I'm not buying it.

> > > + *	IBSS network. Userspace is also required to verify that the currently
> > > + *	programmed DFS region is supported by userspace and monitor it in case
> > > + *	of changes.
> > 
> > That seems like wishful thinking since userspace already exists for
> > this.
> 
> It is, but its also a heads up as to perhaps what we should do to help
> userspace, I think I mentioned elsewhere we could require userspace DFS
> support to supply the supported DFS regions and then we'd deal with the
> conflicts.

I really don't get why userspace should have to deal with DFS regions.
You know what region you're in, you know which the hardware supports -
that's all userspace should care about. We can even make up the "is DFS
supported" flag on-the-fly based on all this information.

Pushing any of this to userspace just seems really stupid.

> The way I'd envision support for that is to add a user_dfs_regions and
> a respective cmd which userspace can set, if the kernel supports
> it userspace can ifdef it (with the define trick on nl80211.h) and
> then send this over for the supported DFS regions for new IBSS userspace.
> We'd then get an enhancement moving forward, otherwise older kernels
> would require userspace to handle DFS region mismatches / updates /
> quiescing itself.

See above. I see no reason for userspace to ever be really concerned
about the DFS region.

> > > + * @NL80211_ATTR_DFS_REGIONS: bitmask of all supported, tested, and
> > > + * 	certified &enum nl80211_dfs_regions that a wiphy has been declared to
> > > + *	support and that agrees with what is programmed currently on cfg80211.
> > > + *	This is used for modes of operation that require DFS support on the
> > > + *	driver. If %NL80211_ATTR_HANDLE_DFS is set userspace need not check
> > > + *	for this for IBSS as it will support DFS in userspace for IBSS.

> NL80211_ATTR_HANDLE_DFS seems to be only for IBSS userspace, I'm trying
> to provide clarification that this is not required for
> NL80211_ATTR_HANDLE_DFS.

Still doesn't make sense - HANDLE_DFS means "I'll react to radar
detection events and will do the CSA". It has absolutely nothing to do
with DFS regions. Please keep those things separate.

> > > +#define NL80211_ATTR_DFS_REGIONS NL80211_ATTR_DFS_REGIONS
> > 
> > Not needed.
> 
> Why is that?

Because nobody will do an #ifdef on it anyway

johannes

