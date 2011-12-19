Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48306 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab1LSK7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 05:59:17 -0500
Received: by lagv3 with SMTP id v3so339642lag.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 02:59:15 -0800 (PST)
Subject: Re: [PATCH v2 1/7] wl12xx: implement change_interface
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324288803-1666-1-git-send-email-eliad@wizery.com>
References: <1324288803-1666-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 12:59:10 +0200
Message-ID: <1324292350.2800.280.camel@cumari> (sfid-20111219_115921_221165_E058627F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 12:00 +0200, Eliad Peller wrote: 
> Implement the change_interface callback by simply removing the
> current vif and adding a new one after updating the vif type.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: update vif->p2p as well
> 
>  drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index c305841..82fc318 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2269,6 +2269,17 @@ out:
>  	cancel_work_sync(&wl->recovery_work);
>  }
>  
> +static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
> +				      struct ieee80211_vif *vif,
> +				      enum nl80211_iftype new_type, bool p2p)
> +{
> +	wl1271_op_remove_interface(hw, vif);
> +
> +	vif->type = ieee80211_iftype_p2p(new_type, p2p);
> +	vif->p2p = p2p;
> +	return wl1271_op_add_interface(hw, vif);
> +}
> +

As Arik already commented, this looks a bit weird.  Shouldn't the type
and p2p elements be changed in mac80211 itself? What about doing so if
the op_change_interface returns success? Currently, the opposite seems
to happen (ie. mac80211 changes type back to the original vif.type if
the op fails).

Also, it seems that the p2p value will be overwritten in the
ieee80211_setup_sdata() which is called just after this op returns, so
there's no use to do it here.

-- 
Cheers,
Luca.

