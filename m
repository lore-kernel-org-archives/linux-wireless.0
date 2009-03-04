Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33852 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZCDKzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 05:55:50 -0500
Received: by fxm24 with SMTP id 24so2830289fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 02:55:46 -0800 (PST)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Always send a null data frame if TIM bit is set.
References: <20090302145030.GA4660@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 04 Mar 2009 12:55:41 +0200
In-Reply-To: <20090302145030.GA4660@myhost.users.atheros.com> (Vivek Natarajan's message of "Mon\, 2 Mar 2009 20\:20\:30 +0530")
Message-ID: <874oy9h80i.fsf@litku.valot.fi> (sfid-20090304_115553_953370_22693976)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> If the AP thinks we are in power save state eventhough we are not truly
> in that state, it sets the TIM bit and does not send a data frame unless
> we send a null data frame to correct the state in the AP.
> This might happen if the null data frame for wake up is lost in the air
> after we disable power save.

Not a bad idea. Of course the proper fix would be that the stack is
notified when the null frames transmission fails, but we don't have
that yet.

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1457,8 +1457,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  	ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
>  				 elems.wmm_param_len);
>  
> -	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK &&
> -	    local->hw.conf.flags & IEEE80211_CONF_PS) {
> +	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
>  		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);

Please add a comment why IEEE80211_CONF_PS is not checked.

-- 
Kalle Valo
