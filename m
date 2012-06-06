Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FFI5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:57:50 -0400
Message-ID: <1338973069.4513.30.camel@jlt3.sipsolutions.net> (sfid-20120606_105753_581048_495D69AE)
Subject: Re: [RFC 06/14] cfg80211: introduce cfg80211_get_used_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:57:49 +0200
In-Reply-To: <1338203942-5667-7-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-7-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Helper function for finding out which channel is
> used by a given interface.
> 
> Will be used for matching interface combinations.
> 
> Change-Id: Ic9e5a68d66aaa26e73901648b04a6e9b465430d0
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/wireless/chan.c |   31 +++++++++++++++++++++++++++++++
>  net/wireless/core.h |    4 ++++
>  2 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index c1999e4..45b28ab 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -92,3 +92,34 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
>  
>  	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
>  }
> +
> +struct ieee80211_channel *
> +cfg80211_get_used_channel(struct cfg80211_registered_device *rdev,
> +			  struct wireless_dev *wdev)
> +{
> +	ASSERT_RDEV_LOCK(rdev);
> +	ASSERT_WDEV_LOCK(wdev);
> +
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_STATION:
> +	case NL80211_IFTYPE_P2P_CLIENT:
> +		if (wdev->current_bss)
> +			return wdev->current_bss->pub.channel;

I think the IBSS part isn't something we should really do. Maybe if we
track whether it's fixed-channel or not (to not break some use cases
like freifunk), but I don't think we should assume IBSS stays here.

In mac80211, IBSS causes it to assume "channel hopping" to handle this.
Maybe here we could return some "cookie" channel pointer to handle this.

johannes

