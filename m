Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2CJIC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 03:02:28 -0500
Subject: Re: [PATCH] mac80211:  Add iface name when calling WARN-ON.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331318216-27235-1-git-send-email-greearb@candelatech.com> (sfid-20120310_015306_799372_9A7E4047)
References: <1331318216-27235-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120310_015306_799372_9A7E4047)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Mar 2012 09:02:23 +0100
Message-ID: <1331366543.3348.1.camel@jlt3.sipsolutions.net> (sfid-20120310_090255_505475_C8F8CE81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 10:36 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This lets the user know which interface has failed
> the check_sdata_in_driver check.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 e8960ae... e62e7c3... M	net/mac80211/driver-ops.h
>  net/mac80211/driver-ops.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index e8960ae..e62e7c3 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -7,7 +7,11 @@
>  
>  static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
>  {
> -	WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
> +	if (unlikely(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))) {
> +		printk(KERN_ERR "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
> +		       sdata->dev->name, sdata->flags);
> +		WARN_ON(1);
> +	}

How about WARN(!(...), ...) instead -- that way the message will be part
of the warning too.

johannes

