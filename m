Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2EIJPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:15:48 -0400
Message-ID: <1336554945.4323.12.camel@jlt3.sipsolutions.net> (sfid-20120509_111551_996894_68BE4F96)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Wed, 09 May 2012 11:15:45 +0200
In-Reply-To: <1335479316-2933-1-git-send-email-thomas@cozybit.com> (sfid-20120427_002914_313709_1CC9F96D)
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120427_002914_313709_1CC9F96D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-26 at 15:28 -0700, Thomas Pedersen wrote:
> It seems as long as we have a netdev, a wdev is available as well.
> Remove the restriction that netdev must be up before a wdev can be
> obtained in nl80211, or changing channels in cfg80211.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> 
> ---
> Hi list,
> 
> This was encountered while implementing an interface for setting
> BSSBasicRateSet in mesh. The wdev->channel is needed in nl80211.c for
> rate verification, but prior to this patch not available.  This doesn't
> seem right since the following sequence of commands would fail:
> 
> iw wlan0 set type mp
> iw wlan0 set channel n
> ip link set wlan0 up
> iw wlan0 mesh join meshid basic-rate 1,2
> 
> Also, 'iw set channel' is met with an -EBUSY if doing this after the
> link is up for fixed channel modes (mesh) anyway.
> 
> Comments? Any idea why this was required initially?


I don't think this patch is correct -- mac80211 will get updated even if
the device isn't even started which will likely cause trouble. Even if
not though, this all doesn't match any kind of multi-channel concept. We
treat the channel as part of the temporary setup, e.g. part of the
association. AP and mesh are the only ones that are different today I
think.

Overall, I don't think setting the channel & doing mesh setup separately
is really a good API.

>From mac80211's (and other drivers if they existed) POV the channel
should be given with the mesh_join command, like for IBSS.

Now, obviously, requiring userspace to do that would be an API change.
We probably don't want that, so I would suggest to change cfg80211 to
track the channel and then pass it to join_mesh as one of the mesh
parameters. This could be made work even when somebody attempts to set
the channel before the interface is up, but we'd have to be careful
about interface type changes.

We should do the same for AP mode as well, since the channel really
becomes relevant only upon start_ap(), before that there's no real
concept of a channel since you don't use it yet anyway.

johannes


