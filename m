Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044Ab2COSmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:42:45 -0400
Subject: Re: [PATCH v2] mac80211: Add iface name when calling WARN-ON
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331836838-30360-1-git-send-email-greearb@candelatech.com> (sfid-20120315_194052_312524_BA55ABF8)
References: <1331836838-30360-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120315_194052_312524_BA55ABF8)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:42:44 +0100
Message-ID: <1331836964.3432.32.camel@jlt3.sipsolutions.net> (sfid-20120315_194250_463612_11A4DE3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 11:40 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This lets the user know which interface has failed
> the check_sdata_in_driver check.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 af4691f... 43e95f0... M	net/mac80211/driver-ops.h
>  net/mac80211/driver-ops.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index af4691f..43e95f0 100644
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
> +		WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
> +	}

Please use WARN() instead of WARN_ON() to make the message part of the
warning.

johannes

