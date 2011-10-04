Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1JDGhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 02:37:13 -0400
Subject: Re: [PATCH] cfg80211: allow channel change on monitor i/f if no
 active i/f present
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Gilboa Davara <gilboad@gmail.com>
In-Reply-To: <1317673413-1467-1-git-send-email-linville@tuxdriver.com>
References: <1317673413-1467-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 08:37:10 +0200
Message-ID: <1317710230.3986.4.camel@jlt3.sipsolutions.net> (sfid-20111004_083717_157192_0A4EF685)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-03 at 16:23 -0400, John W. Linville wrote:
> This is the latest attempt to address the long-standing complaint from
> the aircrack-ng folks about being unable to change the channel on
> monitor interfaces.  This version checks for the existance of other
> "active" interfaces and refuses the channel change if they are present.
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=654344

Thanks for working on this.

> @@ -81,10 +81,32 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>  		      enum nl80211_channel_type channel_type)
>  {
>  	struct ieee80211_channel *chan;
> -	int result;
> +	int result, active_intf_present = 0;
> +	struct wireless_dev *mon_wdev = NULL;
> +
> +	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
> +		mon_wdev = wdev;
> +
> +		ASSERT_RDEV_LOCK(rdev);
> +
> +		/* rdev->devlist_mtx locked by callers */
> +		list_for_each_entry(wdev, &rdev->netdev_list, list) {
> +			if (wdev && wdev != mon_wdev &&
> +			    (wdev->iftype == NL80211_IFTYPE_ADHOC ||
> +			     wdev->iftype == NL80211_IFTYPE_AP ||
> +			     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
> +			     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
> +			     wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
> +				active_intf_present = 1;
> +				break;
> +			}
> +		}
> +
> +		if (active_intf_present)
> +			return -EINVAL;
>  
> -	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
>  		wdev = NULL;
> +	}

This really isn't the problem though, mac80211 will correctly treat
monitor interfaces already, and drivers are pretty much expected to do
the same thing.

> @@ -131,5 +153,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>  	if (wdev)
>  		wdev->channel = chan;
>  
> +	if (mon_wdev)
> +		mon_wdev->channel = chan;

This is the issue, it doesn't work. I'm finally getting to a point where
I'm not sure I care any more though, if the people who user monitor mode
are happy with this patch and don't care about getting the wrong results
then who am I to complain?

Maybe you should respin this patch with just the last bit. The checking
above is pretty much useless. Also please add *huge* warnings to it that
this *will* give the wrong results.

Alternatively, it could be fixed up properly, but I think to do that we
need a cfg80211 get_channel op to ask mac80211 what channel it really is
using. Not that this will help much once we go multi-channel :-)

johannes

