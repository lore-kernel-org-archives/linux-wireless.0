Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbaEFOmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:42:39 -0400
Message-ID: <1399387345.4218.44.camel@jlt4.sipsolutions.net> (sfid-20140506_164245_485780_3891C1DE)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 06 May 2014 16:42:25 +0200
In-Reply-To: <1397051137-26201-3-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155154_888951_7A1A150A)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_155154_888951_7A1A150A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls csa_finish(), the other
> is when reservation is actually finalized (which
> be defered for in-place reservation).

"which be defered"? should that be "can be"?

> +	if (sdata->reserved_chanctx) {
> +		/*
> +		 * with multi-vif csa driver may call ieee80211_csa_finish()
> +		 * many times while waiting for other interfaces to use their
> +		 * reservations
> +		 */
> +		if (sdata->reserved_ready)
> +			return 0;
> +
> +		err = ieee80211_vif_use_reserved_context(sdata);
> +		if (err)
> +			return err;
> +
> +		return 0;
>  	}
>  
> +	if (!cfg80211_chandef_identical(&sdata->vif.bss_conf.chandef,
> +					&sdata->csa_chandef))
> +		return -EINVAL;
> +
>  	sdata->vif.csa_active = false;

Should csa_active really stay true in the reserved_chanctx case?
Wouldn't that leave it beaconing, with potentially suddenly negative
(due to underflow) CSA counter, or something?

johannes

