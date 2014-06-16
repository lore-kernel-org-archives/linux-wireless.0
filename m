Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:33332 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaFPOfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:35:32 -0400
Message-ID: <1402929323.13599.13.camel@dubbel> (sfid-20140616_163544_044904_5F3EE3C3)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 16 Jun 2014 17:35:23 +0300
In-Reply-To: <1402577680-17888-2-git-send-email-michal.kazior@tieto.com>
References: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
	 <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	 <1402577680-17888-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v9 1/5] mac80211: implement multi-vif in-place
 reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-12 at 14:54 +0200, Michal Kazior wrote:
> Multi-vif in-place reservations happen when
> it is impossible to allocate more channel contexts
> as indicated by interface combinations.
> 
> Such reservations are not finalized until all
> assigned interfaces are ready.
> 
> This still doesn't handle all possible cases
> (i.e. degradation of number of channels) properly.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> 

[...]

> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 3702d64..159f4c3 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -63,6 +63,19 @@ static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
>  	return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
>  }
>  
> +static struct ieee80211_chanctx *
> +ieee80211_vif_get_chanctx(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_chanctx_conf *conf;
> +
> +	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
> +					 lockdep_is_held(&local->chanctx_mtx));

This doesn't compile.  local is undefined here. :(

It's a simple fix though.  s/local/sdata->local/

--
Luca.

