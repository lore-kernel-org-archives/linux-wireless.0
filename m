Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:11537 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab3FCNFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 09:05:10 -0400
Date: Mon, 3 Jun 2013 15:05:03 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix sdata locking around
 __ieee80211_request_smps
Message-ID: <20130603150503.787d2840@north> (sfid-20130603_150558_925578_7A3DAC3C)
In-Reply-To: <1370260400-12149-1-git-send-email-johannes@sipsolutions.net>
References: <1370260400-12149-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon,  3 Jun 2013 13:53:20 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> My cfg80211/mac80211 locking unification broke the sdata
> locking in ieee80211_set_power_mgmt, it needs to acquire
> the lock for __ieee80211_request_smps(). Add the locking.
>
> Reported-by: Jakub Kicinski <kubakici@wp.pl>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 9034da1..3062210 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2378,7 +2378,9 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
>  	local->dynamic_ps_forced_timeout = timeout;
>  
>  	/* no change, but if automatic follow powersave */
> +	sdata_lock(sdata);
>  	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
> +	sdata_unlock(sdata);
>  
>  	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);

I can confirm that this patch fixes the reported warning.

I had to double check that sdata_lock takes the wdev mutex
though, because lockdep assert on cfg.c:2321 looks like this:

lockdep_assert_held(&sdata->wdev.mtx)

instead of:

sdata_assert_lock(&sdata)

just saying... :-)

 -- kuba
