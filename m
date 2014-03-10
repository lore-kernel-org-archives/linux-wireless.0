Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaCJQ1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 12:27:41 -0400
Message-ID: <1394468854.24115.3.camel@jlt4.sipsolutions.net> (sfid-20140310_172744_621158_A28B3F97)
Subject: Re: [PATCH 1/4] mac80211: fix CSA tx queue locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Mar 2014 18:27:34 +0200
In-Reply-To: <1394029623-21894-2-git-send-email-michal.kazior@tieto.com> (sfid-20140305_153225_368737_9AD7B7CA)
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1394029623-21894-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140305_153225_368737_9AD7B7CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 15:27 +0100, Michal Kazior wrote:

> +void ieee80211_recalc_csa_block_tx(struct ieee80211_local *local)
> +{
> +	lockdep_assert_held(&local->mtx);
> +
> +	if (ieee80211_csa_needs_block_tx(local))
> +		ieee80211_stop_queues_by_reason(&local->hw,
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);
> +	else
> +		ieee80211_wake_queues_by_reason(&local->hw,
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);
> +}

I don't like this function, even if technically stop is idempotent, it
still seems strange to call this "recalc".

> @@ -1092,7 +1131,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
>  	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
>  
>  	/* abort any running channel switch */
> +	mutex_lock(&local->mtx);
>  	sdata->vif.csa_active = false;
> +	ieee80211_recalc_csa_block_tx(local);
> +	mutex_unlock(&local->mtx);

In fact, here you don't care about the stop queues part at all, afaict.


>  	sdata->csa_chandef = params->chandef;
> +	sdata->csa_block_tx = params->block_tx;

doesn't that more belong to the previous patch?

johannes

