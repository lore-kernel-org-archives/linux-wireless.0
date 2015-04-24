Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39785 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbDXKch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:32:37 -0400
Message-ID: <1429871554.1852.32.camel@sipsolutions.net> (sfid-20150424_123240_494474_FA06DD12)
Subject: Re: [PATCH] cfg80211: Allow GO concurrent relaxation after BSS
 disconnetion
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Date: Fri, 24 Apr 2015 12:32:34 +0200
In-Reply-To: <1427720905-30872-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427720905-30872-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 16:08 +0300, Emmanuel Grumbach wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> If P2P GO was allowed on a channel because of the GO concurrent
> relaxation and additional station interface associated to an AP on
> the same channel or the same UNII band, and the station interface
> disconnected from the AP, allow the P2P GO to stay on that channel
> unless the channel is marked as indoor only and the device is not
> operating in an indoor environment.

I'm not really sure what to do with this - this neither explains why
this is needed nor why it's actually allowed to do it.

> +               if (wdev->iftype == NL80211_IFTYPE_STATION &&
> +                   netif_running(wdev->netdev) && wdev->current_bss)

having a current_bss implies running

> +               if (wdev->iftype == NL80211_IFTYPE_P2P_GO &&
> wdev->netdev &&
> +                   netif_running(wdev->netdev) &&
> wdev->beacon_interval &&
> +                   !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
> +                       other_chan = wdev->chandef.chan;

that "wdev->netdev" check is also useless, iftype==P2P_GO must have a
netdev.
netif_running() is probably also useless since wdev->beacon_interval
implies it.

This patch also doesn't really do exactly what you said it does - it
doesn't just allow that GO to be running but it also allows more to be
started up there... Not sure if that's desired, but it should be
documented (again, with the reasons for it)

johannes

