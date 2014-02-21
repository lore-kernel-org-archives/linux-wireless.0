Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaBUIeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:34:07 -0500
Message-ID: <1392971643.4346.23.camel@jlt4.sipsolutions.net> (sfid-20140221_093411_489786_85F01C04)
Subject: Re: [PATCH v3 2/7] cfg80211: remove radar requirements check from
 cfg80211_can_use_iftype_chan()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:34:03 +0100
In-Reply-To: <1392906986-12275-3-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-3-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> We don't have to double check whether the parameters passed to
> cfg80211_can_use_iftype_chan() are correct.  We should just make sure
> they *are* when we call this function.
> 
> Remove the radar_detect argument check in
> cfg80211_can_use_iftype_chan() to simplify the code.

Applied.


>  	check_chan = params->chandef.chan;
> -	if (params->userspace_handles_dfs) {
> -		/* use channel NULL to check for radar even if the current
> -		 * channel is not a radar channel - it might decide to change
> -		 * to DFS channel later.
> +	if (params->userspace_handles_dfs)
> +		/* Check for radar even if the current channel is not
> +		 * a radar channel - it might decide to change to DFS
> +		 * channel later.
>  		 */
>  		radar_detect_width = BIT(params->chandef.width);
> -		check_chan = NULL;
> -	}

but I kept those braces, since the long comment otherwise makes it easy
to get it wrong when changing code.

johannes

