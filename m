Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1HHNHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:07:31 -0400
Subject: Re: [RFC 1/2] nl80211/cfg80211: adding 'scan_cancel' command.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311513038-5669-1-git-send-email-VictorG@ti.com> (sfid-20110724_151057_640848_FA9FADC0)
References: <1311513038-5669-1-git-send-email-VictorG@ti.com>
	 (sfid-20110724_151057_640848_FA9FADC0)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:07:29 +0200
Message-ID: <1312808849.4372.20.camel@jlt3.sipsolutions.net> (sfid-20110808_150734_450875_E2CE5207)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-24 at 16:10 +0300, Victor Goldenshtein wrote:
> Mostly from an energy consumption and cpu load perspective,
> it can be useful to stop a triggered scan earlier, when one
> finds the desired scan results.
> Adding the ability to stop a scan from user space by exposing
> new NL80211_CMD_SCAN_CANCEL API.

As I said to you privately, I don't think having this API before a
partial results notification is useful. Therefore, I don't think this
should be merged before a partial results notification patch.

A few comments on the code:

> +++ b/include/linux/nl80211.h
> @@ -491,6 +491,11 @@
>   *	this command may also be sent by the driver as an MLME event to
>   *	inform userspace of the new replay counter.
>   *
> + * @NL80211_CMD_SCAN_CANCEL: Stop currently running scan (both sw and hw).
> + *      This will eventually call ieee80211_scan_cancel() in mac80211 which
> + *      will clean up scan_req resources. If we try to stop a not running
> + *      scan it will return -ENOENT.

You must not mention mac80211 here. You're writing a comment about the
implementation, while a comment about the API/semantics is required.

> @@ -615,6 +620,7 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_SET_REKEY_OFFLOAD,
>  
> +	NL80211_CMD_SCAN_CANCEL,
>  	/* add new commands above here */

Please keep the blank line.
 
>  	/* used to define NL80211_CMD_MAX below */
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 4bf101b..0d619b9 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1334,6 +1334,7 @@ struct cfg80211_gtk_rekey_data {
>   * @set_ringparam: Set tx and rx ring sizes.
>   *
>   * @get_ringparam: Get tx and rx ring current and maximum sizes.
> + * @scan_cancel: Stop triggered scan, return 0 if successful.
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -1516,6 +1517,7 @@ struct cfg80211_ops {
>  
>  	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
>  				  struct cfg80211_gtk_rekey_data *data);
> +	void    (*scan_cancel)(struct wiphy *wiphy, struct net_device *dev);

Since this struct isn't ABI it'd be more useful to put the scan_cancel
with the scan call.

> +		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
> +				NL80211_FLAG_NEED_RTNL,

whitespace?

> +	if (!rdev->ops->scan_cancel)
> +		return -EOPNOTSUPP;
> +	if (!rdev->scan_req)
> +		return -ENOENT;
> +
> +	dev = rdev->scan_req->dev;
> +	rdev->ops->scan_cancel(&rdev->wiphy, dev);
> +	return 0;
> +}

So ... does this mean the driver is still expected to send a "scan
aborted" event? That would be useful to document ... not the mac80211
internals.

johannes

