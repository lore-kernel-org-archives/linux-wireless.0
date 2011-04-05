Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DEH25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 03:28:57 -0400
Subject: Re: [PATCH v7 03/10] mac80211: Support userspace mesh
 authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301966140-26080-4-git-send-email-thomas@cozybit.com>
References: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
	 <1301966140-26080-4-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 09:28:55 +0200
Message-ID: <1301988535.3831.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 18:15 -0700, Thomas Pedersen wrote:
> Also, disallow joining a secure mesh if the wiphy does not support
> authentication.

> +	/* if the underlying driver supports mesh, mac80211 will (at least)
> +	 * provide routing of mesh authentication frames to userspace */
> +	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
> +		local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;

I'm getting bored and I'm sure you're also getting annoyed by resending
this all the time, and I guess it doesn't matter, but strictly speaking
after this patch mac80211 doesn't even support this feature yet since
the whole feature needs all the different bits from patches 4-10 too.
Therefore you should really prepare the feature with a bunch of patches
and then have a last patch that enables it, if it's split up, so that at
any point in time the kernel can not only compile but also has a
consistent feature advertising.

> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -72,6 +72,10 @@ int __cfg80211_join_mesh(struct
> cfg80211_registered_device *rdev,
>         if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
>                 return -EOPNOTSUPP;
>  
> +       if (!(rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
> +             setup->is_secure)
> +               return -EOPNOTSUPP;

However this really should be a part of patch 2 or so since it's not
related to mac80211 at all.

How about you split this patch, and make the mac80211 bits part of what
is patch 10, and the nl80211 bits part of what is patch 2, then you have
only 9 patches, the feature gets enabled cleanly and there's no
confusion about mac80211 vs. nl80211.

The trivial mac80211 bits in patch 2 should probably be in patch 4,
since they aren't required to compile the kernel with patch 2 by itself.

Also the description for patch 8 should incorporate that it also
includes nl80211 API changes, or possibly be split up into
nl80211/mac80211 bits. I don't really mind combined nl80211/mac80211
patches, but I think it should be clear when looking over them, like
e.g.

commit 026331c4d9b526561ea96f95fac4bfc52b69e316
Author: Jouni Malinen <jouni.malinen@atheros.com>
Date:   Mon Feb 15 12:53:10 2010 +0200

    cfg80211/mac80211: allow registering for and sending action frames


Anyway, I do think the code can be as it is, I just think the patch
splitting is a bit unfortunate. As such, I'd be OK with it going in now
anyway.

johannes

