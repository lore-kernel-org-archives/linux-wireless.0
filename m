Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2KTLmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:42:44 -0500
Message-ID: <1353411725.10872.159.camel@cumari.coelho.fi> (sfid-20121120_124247_861111_A326902A)
Subject: Re: [PATCH v2 01/11] wlcore: start sta role on CHANGED_BSSID
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 13:42:05 +0200
In-Reply-To: <1353410411-18833-2-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
	 <1353410411-18833-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 13:20 +0200, Eliad Peller wrote:
> Make the connection flow simpler by starting
> sta role on bssid change.
> 
> Currently, we start dev role when going idle-off,
> and start the sta role only after association
> indication. This complicates the connection
> flow with some possible intermediate states.
> 
> Make it simpler by starting sta role on bssid change,
> which now happens *before* auth req get sent.
> 
> Update the handling of mac80211's notifications
> and change wl1271_join/unjoin accordingly -
> * Split wl1271_join() into wlcore_join (tuning on
>   a channel/bssid) and wlcore_set_assoc (configure
>   sta after association).
> * Rename wl1271_unjoin() to wlcore_unset_assoc(), as
>   it is no longer the inversion of wl1271_join()
>   (now it's only used to disconnect associated sta /
>   joined ibss, without stopping the role).
> * Set ssid before starting station role (needed for
>   start_role(sta)
> 
> While on it, split wl1271_bss_info_changed_sta() into
> some sub-functions.
> 
> since we no longer use dev role in the connection flow,
> we now always use the hlid of the sta role.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: take some more code out of wl1271_bss_info_changed_sta (thanks Luca!)
>     squash patches [2/15, 3/15] into this one (thanks Julian!)
> 

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 41ed1d5..2690fe9 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c

[...]

> @@ -2510,29 +2587,58 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>  	 */
>  	ret = wl1271_acx_keep_alive_mode(wl, wlvif, true);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	ret = wl1271_acx_aid(wl, wlvif, wlvif->aid);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	ret = wl12xx_cmd_build_klv_null_data(wl, wlvif);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	ret = wl1271_acx_keep_alive_config(wl, wlvif,
>  					   wlvif->sta.klv_template_id,
>  					   ACX_KEEP_ALIVE_TPL_VALID);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
> -out:
>  	return ret;
>  }

This is, of course, functionally okay, but seems like an unrelated
change.  Also, this is different than the general style we use in the
driver (ie. use goto out in most error cases).

Same thing for the other functions you added.  It would be nice to be
consistent with the existing style, at least in error paths.

--
Luca.

