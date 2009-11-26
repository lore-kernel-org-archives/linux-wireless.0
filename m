Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58496 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbZKZIHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 03:07:35 -0500
Received: by bwz27 with SMTP id 27so337596bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 00:07:40 -0800 (PST)
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix dynamic power save for scanning.
References: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
	<1259063627-20033-2-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 26 Nov 2009 10:07:38 +0200
In-Reply-To: <1259063627-20033-2-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Tue\, 24 Nov 2009 17\:23\:46 +0530")
Message-ID: <87einlaeut.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> Not only ps_sdata but also IEEE80211_CONF_PS is to be considered
> before restoring PS in scan_ps_disable(). For instance, when ps_sdata
> is set but CONF_PS is not set just because the dynamic timer is still
> running, a sw scan leads to setting of CONF_PS in scan_ps_disable
> instead of starting the dynamic PS timer.

Good that you found this. Some comments about the fix, though.

> @@ -746,6 +746,7 @@ struct ieee80211_local {
>  	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
>  
>  	bool pspolling;
> +	bool scan_ps_enabled;

I don't like the idea of adding more state variables to
ieee80211_local. We should be removing them instead because the code
is getting quite complex. Is there any way to fix this but not add a
new variable?

> @@ -277,6 +279,10 @@ static void ieee80211_scan_ps_disable(struct ieee80211_sub_if_data *sdata)
>  		 */
>  		local->hw.conf.flags |= IEEE80211_CONF_PS;
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +	} else {
> +		ieee80211_send_nullfunc(local, sdata, 0);
> +		mod_timer(&local->dynamic_ps_timer, jiffies +
> +			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>  	}
>  }

You need to take into account that dynamic_ps_timeout can be zero.

-- 
Kalle Valo
