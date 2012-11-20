Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50967 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2KTH4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:56:21 -0500
Message-ID: <1353398144.10872.144.camel@cumari.coelho.fi> (sfid-20121120_085625_178585_AF84978A)
Subject: Re: [PATCH 12/15] wlcore: specify correct supported_rates
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 09:55:44 +0200
In-Reply-To: <1353343170-26516-13-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-13-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
> The supported_rates field should contain all our supported
> rates, even if the remote peer doesn't support them.
> 
> (use CONF_TX_AP_ENABLED_RATES for bg rates, as the possible
> rates are the same for ap and sta)

Maybe the macro should be renamed then?


> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/cmd.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
> index 28a235f..4c2ed25 100644
> --- a/drivers/net/wireless/ti/wlcore/cmd.c
> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
> @@ -441,6 +441,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  {
>  	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
>  	struct wl12xx_cmd_role_start *cmd;
> +	u32 supported_rates;
>  	int ret;
>  
>  	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> @@ -461,7 +462,14 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  	cmd->sta.ssid_len = wlvif->ssid_len;
>  	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
>  	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
> -	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
> +
> +	supported_rates = CONF_TX_AP_ENABLED_RATES | CONF_TX_MCS_RATES |
> +			  wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
> +	if (wlvif->p2p)
> +		supported_rates &= ~CONF_TX_CCK_RATES;

Why not do this when creating the vif (init_vif_data)? I think this kind
of code doesn't belong in the cmd function.  Seem better to adjust
wlvif->rate_set.

--
Luca.

