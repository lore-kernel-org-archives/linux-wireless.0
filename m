Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63439 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KNOUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:20:50 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so2134022pab.26
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 06:20:49 -0800 (PST)
Date: Thu, 14 Nov 2013 06:31:29 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
Message-ID: <20131114143126.GC19070@garbanzo.do-not-panic.com> (sfid-20131114_152053_765837_46ECD8C4)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
 <1384378096.28806.20.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384378096.28806.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 10:28:16PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> 
> > +/**
> > + * wiphy_enable_dfs_region - enable a DFS region
> > + *
> > + * @wiphy: the wiphy to set the supported DFS regions for
> > + * @dfs_region: an DFS region specified by an &enum nl80211_dfs_regions
> > + * 	representing the DFS region to enable support on the wiphy for.
> > + *
> > + * This can be used to indicate to cfg80211 that the wiphy has DFS driver
> > + * support for the specified DFS region for modes of operation that require
> > + * DFS on the driver.
> > + */
> > +void wiphy_enable_dfs_region(struct wiphy *wiphy,
> > +			     enum nl80211_dfs_regions dfs_region);
> 
> What's the point of this function rather than the driver setting the
> region bits before registration?

I don't trust driver developers, this provides a simple interface
which pushes driver developers to use CONFIG_CFG80211_CERTIFICATION_ONUS
for driver DFS features, it also validates the input and also does
the conversion to bitmasks for the driver developers. Without this
we'd assume driver developers would enable DFS under proper regulatory
configs but also require BIT() | BIT() settings.

> > +/**
> > + * wiphy_dfs_region_supported - checks if a DFS region is supported
> > + *
> > + * @wiphy: the wiphy to check the DFS region for
> > + * @dfs_region: the DFS region we want to check support for
> > + *
> > + * This can be used to query if the wiphy's a specific DFS region.
> > + * This should be checked before for initiating radiation on
> > + * DFS channels for modes of operation that require DFS on the driver.
> > + *
> > + * Return: true if the dfs_region is supported by the device, returns
> > + * false otherwise.
> > + */
> > +bool wiphy_dfs_region_supported(struct wiphy *wiphy,
> > +				enum nl80211_dfs_regions dfs_region);
> 
> Where would this function be used outside of cfg80211?

It would not, I can stuff that alone into core.c and make it static.

> > +/**
> > + * wiphy_core_dfs_region_usable - checks if the current DFS region can be used
> > + *
> > + * @wiphy: the wiphy to check the DFS region against
> > + *
> > + * This can be used to query if the wiphy can use the currently set
> > + * DFS region on the regulatory core.
> > + *
> > + * Return: true if the core's dfs_region is supported and usable by the device,
> > + * returns false otherwise.
> > + */
> > +bool wiphy_core_dfs_region_usable(struct wiphy *wiphy);
> 
> Ditto.

This was a question I had, but based on Januz' feedback it sounds like
we can keep this private.

> > + *	IBSS network. Userspace is also required to verify that the currently
> > + *	programmed DFS region is supported by userspace and monitor it in case
> > + *	of changes.
> 
> That seems like wishful thinking since userspace already exists for
> this.

It is, but its also a heads up as to perhaps what we should do to help
userspace, I think I mentioned elsewhere we could require userspace DFS
support to supply the supported DFS regions and then we'd deal with the
conflicts.

The way I'd envision support for that is to add a user_dfs_regions and
a respective cmd which userspace can set, if the kernel supports
it userspace can ifdef it (with the define trick on nl80211.h) and
then send this over for the supported DFS regions for new IBSS userspace.
We'd then get an enhancement moving forward, otherwise older kernels
would require userspace to handle DFS region mismatches / updates /
quiescing itself.

> > + * @NL80211_ATTR_DFS_REGIONS: bitmask of all supported, tested, and
> > + * 	certified &enum nl80211_dfs_regions that a wiphy has been declared to
> > + *	support and that agrees with what is programmed currently on cfg80211.
> > + *	This is used for modes of operation that require DFS support on the
> > + *	driver. If %NL80211_ATTR_HANDLE_DFS is set userspace need not check
> > + *	for this for IBSS as it will support DFS in userspace for IBSS.
> 
> ???
> You're confusing me. What's the point of these patches then if userspace
> handles it?

NL80211_ATTR_HANDLE_DFS seems to be only for IBSS userspace, I'm trying
to provide clarification that this is not required for
NL80211_ATTR_HANDLE_DFS.

> 
> The way I read the patch description was that here you were advertising
> which pattern detectors a driver has - but that has nothing to do with
> how userspace handles DFS in IBSS.

Agreed, I'm just providing clarification to the special
IBSS case when NL80211_ATTR_HANDLE_DFS is used, so that
useres of IBSS with DFS in userspace and NL80211_ATTR_HANDLE_DFS
don't set the DFS regions on their driver. As I mentioned
above though, a user_dfs_regions however is welcomed.

> > +#define NL80211_ATTR_DFS_REGIONS NL80211_ATTR_DFS_REGIONS
> 
> Not needed.

Why is that?

> > +void wiphy_enable_dfs_region(struct wiphy *wiphy,
> > +			     enum nl80211_dfs_regions dfs_region)
> > +{
> > +	if (!config_enabled(CONFIG_CFG80211_CERTIFICATION_ONUS))
> > +		return;
> > +	if (!reg_supported_dfs_region(dfs_region))
> > +		return;
> 
> Both of this is pointless, you can do it at build time.

Hrm.

> > +	wiphy->dfs_regions |= BIT(dfs_region);
> 
> Just have the driver set this directly before registration and make
> *using* and *advertising* it conditional.

OK yeah that works too, thanks for the feedback.

  Luis
