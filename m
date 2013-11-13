Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3KMV2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:28:23 -0500
Message-ID: <1384378096.28806.20.camel@jlt4.sipsolutions.net> (sfid-20131113_222826_421707_A2550DCD)
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 22:28:16 +0100
In-Reply-To: <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191313_686085_B462C7D9)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_191313_686085_B462C7D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:

> +/**
> + * wiphy_enable_dfs_region - enable a DFS region
> + *
> + * @wiphy: the wiphy to set the supported DFS regions for
> + * @dfs_region: an DFS region specified by an &enum nl80211_dfs_regions
> + * 	representing the DFS region to enable support on the wiphy for.
> + *
> + * This can be used to indicate to cfg80211 that the wiphy has DFS driver
> + * support for the specified DFS region for modes of operation that require
> + * DFS on the driver.
> + */
> +void wiphy_enable_dfs_region(struct wiphy *wiphy,
> +			     enum nl80211_dfs_regions dfs_region);

What's the point of this function rather than the driver setting the
region bits before registration?

> +/**
> + * wiphy_dfs_region_supported - checks if a DFS region is supported
> + *
> + * @wiphy: the wiphy to check the DFS region for
> + * @dfs_region: the DFS region we want to check support for
> + *
> + * This can be used to query if the wiphy's a specific DFS region.
> + * This should be checked before for initiating radiation on
> + * DFS channels for modes of operation that require DFS on the driver.
> + *
> + * Return: true if the dfs_region is supported by the device, returns
> + * false otherwise.
> + */
> +bool wiphy_dfs_region_supported(struct wiphy *wiphy,
> +				enum nl80211_dfs_regions dfs_region);

Where would this function be used outside of cfg80211?

> +/**
> + * wiphy_core_dfs_region_usable - checks if the current DFS region can be used
> + *
> + * @wiphy: the wiphy to check the DFS region against
> + *
> + * This can be used to query if the wiphy can use the currently set
> + * DFS region on the regulatory core.
> + *
> + * Return: true if the core's dfs_region is supported and usable by the device,
> + * returns false otherwise.
> + */
> +bool wiphy_core_dfs_region_usable(struct wiphy *wiphy);

Ditto.

> + *	IBSS network. Userspace is also required to verify that the currently
> + *	programmed DFS region is supported by userspace and monitor it in case
> + *	of changes.

That seems like wishful thinking since userspace already exists for
this.

> + * @NL80211_ATTR_DFS_REGIONS: bitmask of all supported, tested, and
> + * 	certified &enum nl80211_dfs_regions that a wiphy has been declared to
> + *	support and that agrees with what is programmed currently on cfg80211.
> + *	This is used for modes of operation that require DFS support on the
> + *	driver. If %NL80211_ATTR_HANDLE_DFS is set userspace need not check
> + *	for this for IBSS as it will support DFS in userspace for IBSS.

???
You're confusing me. What's the point of these patches then if userspace
handles it?

The way I read the patch description was that here you were advertising
which pattern detectors a driver has - but that has nothing to do with
how userspace handles DFS in IBSS.

> +#define NL80211_ATTR_DFS_REGIONS NL80211_ATTR_DFS_REGIONS

Not needed.
 
> +void wiphy_enable_dfs_region(struct wiphy *wiphy,
> +			     enum nl80211_dfs_regions dfs_region)
> +{
> +	if (!config_enabled(CONFIG_CFG80211_CERTIFICATION_ONUS))
> +		return;
> +	if (!reg_supported_dfs_region(dfs_region))
> +		return;

Both of this is pointless, you can do it at build time.

> +	wiphy->dfs_regions |= BIT(dfs_region);

Just have the driver set this directly before registration and make
*using* and *advertising* it conditional.

johannes

