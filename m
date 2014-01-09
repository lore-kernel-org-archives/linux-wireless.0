Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41374 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaAIRaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 12:30:18 -0500
Date: Thu, 9 Jan 2014 12:28:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Alex Gal <a.gal@motsai.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wl12xx: fix tx power setting
Message-ID: <20140109172847.GB2131@tuxdriver.com> (sfid-20140109_183022_186969_44C32666)
References: <CAN44aq1na7XbhArseUVwKybMS7bhn_0uCFXxVvEvgX=RfUbBGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN44aq1na7XbhArseUVwKybMS7bhn_0uCFXxVvEvgX=RfUbBGQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 09, 2014 at 12:06:36PM -0500, Alex Gal wrote:
> Fixes wl12xx tx power.
> 
> Signed-off-by: Alex Gal <a.gal@motsai.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index e9da47c..3f77a8d 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4457,6 +4457,15 @@ static void wl1271_op_bss_info_changed(struct
> ieee80211_hw *hw,
>         if (ret < 0)
>                 goto out;
> 
> +    if ((changed & BSS_CHANGED_TXPOWER) && bss_conf->txpower !=
> wlvif->power_level) {

This line needs to be broken after the '&&'.  FWIW, I think the
rest of the patch is whitespace-damaged as well...

> +
> +        ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
> +        if (ret < 0)
> +            goto out;
> +
> +        wlvif->power_level = bss_conf->txpower;
> +    }
> +
>         if (is_ap)
>                 wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
>         else
> -- 
> 1.8.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
