Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45589 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752245AbaCaLp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:45:28 -0400
Message-ID: <1396266320.6794.6.camel@dubbel> (sfid-20140331_134531_719164_BBA596C5)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 31 Mar 2014 14:45:20 +0300
In-Reply-To: <1396259841-6359-5-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-5-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v3 4/4] mac80211: disconnect iface if CSA unexpectedly
 fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
> It doesn't make much sense to leave a cripled
> interface running.
> 
> As a side effect this will unblock tx queues with
> CSA reason immediately after failure instead of
> until after userspace requests interface to stop.
> 
> This also gives userspace an opportunity to
> indirectly see CSA failure.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

[...]

> @@ -3100,7 +3100,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>  	sdata->radar_required = sdata->csa_radar_required;
>  	err = ieee80211_vif_change_channel(sdata, &changed);
>  	if (WARN_ON(err < 0))
> -		return;
> +		return err;

Didn't we agree to remove the WARN_ON() from here?

--
Luca.

