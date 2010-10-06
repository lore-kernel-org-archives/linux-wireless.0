Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759582Ab0JFSVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:21:32 -0400
Subject: Re: [PATCH v2 03/03] wl1271: 11n Support, functionality and
 configuration ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1286388491-28752-5-git-send-email-shahar_levi@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
	 <1286388491-28752-5-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:21:27 +0200
Message-ID: <1286389287.3655.398.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 20:08 +0200, Shahar Levi wrote:

>  	/* peek into the rates configured in the STA entry */
>  	spin_lock_irqsave(&wl->wl_lock, flags);
> -	if (sta && sta->supp_rates[conf->channel->band] != wl->sta_rate_set) {
> +	if (sta &&
> +	    (sta->supp_rates[conf->channel->band] !=
> +	    (wl->sta_rate_set & HW_BG_RATES_MASK))) {
>  		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
>  		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
>  	}

???

How can non-BG rates ever show up there? Is this really an 11a change?

johannes

