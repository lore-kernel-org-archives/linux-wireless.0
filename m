Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2FZNWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:22:09 -0400
Message-ID: <1340716926.14634.32.camel@jlt3.sipsolutions.net> (sfid-20120626_152213_691424_30A23620)
Subject: Re: [RFC v3 11/13] cfg80211/mac80211: remove .get_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 15:22:06 +0200
In-Reply-To: <1340713818-28549-12-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
	 <1340713818-28549-12-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:30 +0200, Michal Kazior wrote:

> +++ b/net/wireless/nl80211.c
> @@ -1588,17 +1588,11 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>  			(cfg80211_rdev_list_generation << 2)))
>  		goto nla_put_failure;
>  
> -	if (rdev->ops->get_channel) {
> -		struct ieee80211_channel *chan;
> -		enum nl80211_channel_type channel_type;
> -
> -		chan = rdev->ops->get_channel(&rdev->wiphy, &channel_type);
> -		if (chan &&
> -		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
> -				    chan->center_freq) ||
> -		     nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
> -				    channel_type)))
> -			goto nla_put_failure;
> +	if (rdev->monitor_channel) {
> +		nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
> +			    rdev->monitor_channel->center_freq);
> +		nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
> +			    rdev->monitor_channel_type);

Tiny comment here -- you're removing nla_put error handling.

johannes

