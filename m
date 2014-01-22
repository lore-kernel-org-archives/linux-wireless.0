Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43863 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaAVLkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 06:40:32 -0500
Message-ID: <1390390829.4189.10.camel@porter.coelho.fi> (sfid-20140122_124035_878892_31F61B09)
Subject: Re: [PATCH 3/7] mac80211: move csa_active setting in STA CSA
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 22 Jan 2014 13:40:29 +0200
In-Reply-To: <1390227670-19030-4-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> The sdata->vif.csa_active could be left set after,
> e.g. channel context constraints check fail in STA
> mode leaving the interface in a strange state for
> a brief period of time until it is disconnected.
> This was harmless but ugly.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/mlme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index fc1d824..bfb81cb 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1001,7 +1001,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
> -	sdata->vif.csa_active = true;
>  
>  	mutex_lock(&local->chanctx_mtx);
>  	if (local->use_chanctx) {
> @@ -1039,6 +1038,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>  	mutex_unlock(&local->chanctx_mtx);
>  
>  	sdata->csa_chandef = csa_ie.chandef;
> +	sdata->vif.csa_active = true;
>  
>  	if (csa_ie.mode)
>  		ieee80211_stop_queues_by_reason(&local->hw,

Looks better indeed.

--
Luca.

