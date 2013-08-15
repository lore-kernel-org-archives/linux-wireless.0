Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HOMD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 08:03:59 -0400
Message-ID: <1376568235.14084.12.camel@jlt4.sipsolutions.net> (sfid-20130815_140402_517391_66316847)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 14:03:55 +0200
In-Reply-To: <1376395438-24788-1-git-send-email-arik@wizery.com> (sfid-20130813_140413_518220_6596D641)
References: <1376395438-24788-1-git-send-email-arik@wizery.com>
	 (sfid-20130813_140413_518220_6596D641)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-13 at 15:03 +0300, Arik Nemtsov wrote:

> This isn't very well tested yet, but seems to work with a TI wl18xx card.
> The single-role/single-channel support is enough to pass the 11h certification.

:-)

>  net/mac80211/cfg.c  |  5 +++++
>  net/mac80211/chan.c |  5 -----
>  net/mac80211/mlme.c | 55 +++++++++++++++++++++++++++++++++++++++--------------
>  3 files changed, 46 insertions(+), 19 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 7aa38ce..beb1c2a 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2872,6 +2872,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>  	if (WARN_ON(err < 0))
>  		return;
>  
> +	if (!local->use_chanctx) {
> +		local->_oper_chandef = local->csa_chandef;
> +		ieee80211_hw_config(local, 0);
> +	}

I don't really understand this part - I think you should add some
documentation or something?

> @@ -453,11 +453,6 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
>  	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
>  	drv_change_chanctx(local, ctx, chanctx_changed);
>  
> -	if (!local->use_chanctx) {
> -		local->_oper_chandef = *chandef;
> -		ieee80211_hw_config(local, 0);
> -	}

I really don't like it either - this was here so that no other code
really needed to be worried about non-chanctx drivers.

> @@ -1180,17 +1196,27 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
> +	sdata->vif.csa_active = true;

I don't think we can just do this - this isn't going to result in good
behaviour for multi-vif drivers and in particular I'm pretty sure with
the MVM driver this would result in bad behaviour.

If you really want to do this I think it needs to be optional.

Also the documentation for the chanctx channel change probably needs to
be updated, etc.

johannes

