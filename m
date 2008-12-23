Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:18682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYLWUdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:33:46 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1021711fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 12:33:44 -0800 (PST)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
References: <20081223044424.GC11534@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 23 Dec 2008 22:33:41 +0200
In-Reply-To: <20081223044424.GC11534@myhost.users.atheros.com> (Vivek Natarajan's message of "Mon\, 22 Dec 2008 20\:44\:24 -0800")
Message-ID: <873aged42i.fsf@litku.valot.fi> (sfid-20081223_213349_008920_31AAACCA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> This patch enables mac80211 to send a null frame and also to
> check for tim in the beacon if power save is enabled.

I would like to see a separate hw flag for disabling this feature. Not
all drivers need this, for example iwlwifi.

> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 673c5d7..6470614 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -871,12 +871,17 @@ set:
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
>  		else {
> -			if (local->powersave)
> +			if (local->powersave) {
> +				ieee80211_send_nullfunc(local, sdata, 1);
>  				conf->flags |= IEEE80211_CONF_PS;
> -			else
> +				ret = ieee80211_hw_config(local,
> +						IEEE80211_CONF_CHANGE_PS);
> +			} else {
>  				conf->flags &= ~IEEE80211_CONF_PS;
> -			ret = ieee80211_hw_config(local,
> -					IEEE80211_CONF_CHANGE_PS);
> +				ret = ieee80211_hw_config(local,
> +						IEEE80211_CONF_CHANGE_PS);
> +				ieee80211_send_nullfunc(local, sdata, 0);

Maybe add a helper function for checking the new flag I proposed and
sending the null frame?

-- 
Kalle Valo
