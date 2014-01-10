Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53476 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaAJOpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 09:45:09 -0500
Date: Fri, 10 Jan 2014 09:34:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Alex Gal <a.gal@motsai.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] wl12xx: fix tx power setting
Message-ID: <20140110143403.GD2131@tuxdriver.com> (sfid-20140110_154513_398764_282980BD)
References: <CAN44aq1AQYHDUsU6wVf01NcWS9EWnJe0BwF+Ygv1kqZ7M8AwgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN44aq1AQYHDUsU6wVf01NcWS9EWnJe0BwF+Ygv1kqZ7M8AwgA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 09, 2014 at 02:02:00PM -0500, Alex Gal wrote:
> Sorry for the previous format.
> 
> Fixes wl12xx tx power.
> 
> Signed-off-by: Alex Gal <a.gal@motsai.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index e9da47c..cbbfc50 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4457,6 +4457,16 @@ static void wl1271_op_bss_info_changed(struct
> ieee80211_hw *hw,
>         if (ret < 0)
>                 goto out;
> 
> +       if ((changed & BSS_CHANGED_TXPOWER) &&
> +               bss_conf->txpower != wlvif->power_level) {

The prevailing style would be to align the bss_conf clause to start
under the second parenthesis in the line above.

> +
> +               ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
> +               if (ret < 0)
> +                       goto out;
> +
> +               wlvif->power_level = bss_conf->txpower;
> +       }
> +
>         if (is_ap)
>                 wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
>         else
> -- 
> 1.8.5.2
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
