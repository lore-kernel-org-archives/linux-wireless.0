Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35911 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3KNPXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:23:01 -0500
Received: by mail-pb0-f47.google.com with SMTP id rr4so701903pbb.20
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:23:01 -0800 (PST)
Date: Thu, 14 Nov 2013 07:33:41 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
Message-ID: <20131114153339.GB30653@garbanzo.do-not-panic.com> (sfid-20131114_162306_792808_EC50C1E2)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
 <1384378096.28806.20.camel@jlt4.sipsolutions.net>
 <20131114143126.GC19070@garbanzo.do-not-panic.com>
 <1384440519.13941.31.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384440519.13941.31.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 03:48:39PM +0100, Johannes Berg wrote:
> On Thu, 2013-11-14 at 06:31 -0800, Luis R. Rodriguez wrote:
> 
> > > What's the point of this function rather than the driver setting the
> > > region bits before registration?
> > 
> > I don't trust driver developers, this provides a simple interface
> > which pushes driver developers to use CONFIG_CFG80211_CERTIFICATION_ONUS
> > for driver DFS features, it also validates the input and also does
> > the conversion to bitmasks for the driver developers. Without this
> > we'd assume driver developers would enable DFS under proper regulatory
> > configs but also require BIT() | BIT() settings.
> 
> It has nothing to do with trust. If the driver author sets
> 
> 	dfs_capability = BIT(FCC) | BIT(ETSI)
> 
> you still don't have to use the values if CERTIFICATION_ONUS isn't set.
> Therefore, I'm not buying it.

True.

> > > > + *	IBSS network. Userspace is also required to verify that the currently
> > > > + *	programmed DFS region is supported by userspace and monitor it in case
> > > > + *	of changes.
> > > 
> > > That seems like wishful thinking since userspace already exists for
> > > this.
> > 
> > It is, but its also a heads up as to perhaps what we should do to help
> > userspace, I think I mentioned elsewhere we could require userspace DFS
> > support to supply the supported DFS regions and then we'd deal with the
> > conflicts.
> 
> I really don't get why userspace should have to deal with DFS regions.
> You know what region you're in, you know which the hardware supports -
> that's all userspace should care about. We can even make up the "is DFS
> supported" flag on-the-fly based on all this information.
> 
> Pushing any of this to userspace just seems really stupid.

You're missing my point that we are not sure if IBSS DFS userspace
supports DFS region changes as a cornercase, and I'm arguing userspace
should not have to deal with that and that I wish for us to deal with
that for userspace. Thinking about it though, if we quiesce for IBSS
upon regulatory change we'd cover this corner case.

> > The way I'd envision support for that is to add a user_dfs_regions and
> > a respective cmd which userspace can set, if the kernel supports
> > it userspace can ifdef it (with the define trick on nl80211.h) and
> > then send this over for the supported DFS regions for new IBSS userspace.
> > We'd then get an enhancement moving forward, otherwise older kernels
> > would require userspace to handle DFS region mismatches / updates /
> > quiescing itself.
> 
> See above. I see no reason for userspace to ever be really concerned
> about the DFS region.

Agreed, I was trying to deal with the corner case of quiescing upon
regulatory change for a DFS region change.

> > > > + * @NL80211_ATTR_DFS_REGIONS: bitmask of all supported, tested, and
> > > > + * 	certified &enum nl80211_dfs_regions that a wiphy has been declared to
> > > > + *	support and that agrees with what is programmed currently on cfg80211.
> > > > + *	This is used for modes of operation that require DFS support on the
> > > > + *	driver. If %NL80211_ATTR_HANDLE_DFS is set userspace need not check
> > > > + *	for this for IBSS as it will support DFS in userspace for IBSS.
> 
> > NL80211_ATTR_HANDLE_DFS seems to be only for IBSS userspace, I'm trying
> > to provide clarification that this is not required for
> > NL80211_ATTR_HANDLE_DFS.
> 
> Still doesn't make sense - HANDLE_DFS means "I'll react to radar
> detection events and will do the CSA". It has absolutely nothing to do
> with DFS regions. Please keep those things separate.

How you deal with radar detection is completely dependent on the DFS
region, no?

> > > > +#define NL80211_ATTR_DFS_REGIONS NL80211_ATTR_DFS_REGIONS
> > > 
> > > Not needed.
> > 
> > Why is that?
> 
> Because nobody will do an #ifdef on it anyway

OK

  Luis
