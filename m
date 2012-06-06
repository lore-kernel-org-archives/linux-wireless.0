Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2FFJSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:18:25 -0400
Message-ID: <1338974304.4513.49.camel@jlt3.sipsolutions.net> (sfid-20120606_111828_932811_E3CE5D44)
Subject: Re: [RFC 13/14] cfg80211: extend combination checking to consider
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:18:24 +0200
In-Reply-To: <1338203942-5667-14-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-14-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:19 +0200, Michal Kazior wrote:
> cfg80211_can_change_interface will soon be used
> before .start_ap, .join_mesh, .join_ibss and .auth to
> verify whether a given interface combination is
> allowed.
> 
> .connect cannot be handled since the driver scans
> and connects on its own. It is up to the driver
> then to refuse a connection (with -EBUSY for
> example).

 
>  int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
>  				  struct wireless_dev *wdev,
> -				  enum nl80211_iftype iftype);
> +				  enum nl80211_iftype iftype,
> +				  struct ieee80211_channel *chan);
>  
>  static inline int
>  cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
> -			   enum nl80211_iftype iftype)
> +			   enum nl80211_iftype iftype,
> +			   struct ieee80211_channel *chan)
>  {
> -	return cfg80211_can_change_interface(rdev, NULL, iftype);
> +	return cfg80211_can_change_interface(rdev, NULL, iftype, chan);
>  }

I have a feeling we should preserve can_change_interface() as an inline
with the existing prototype, add something like can_use_channel that
doesn't get the iftype, and implement it with a common function like
can_use_iftype_channel():

can_use_iftype_channel(rdev, wdev, iftype, chan)

can_change_interface(rdev, wdev, new_iftype):
	return can_use_iftype_channel(rdev, wdev, new_iftype, NULL)

can_use_channel(rdev, wdev, chan):
	return can_use_iftype_channel(rdev, wdev, wdev->iftype, chan)


I think that would make the code simpler to read since the reader
doesn't have to know about the chan=NULL semantics etc. just like now
with can_add_interface they don't have to know about the wdev=NULL
semantics -- all of that we could explain in can_use_iftype_channel()

johannes

