Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbcBAXkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 18:40:46 -0500
Date: Mon, 1 Feb 2016 23:40:39 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/8] rtlwifi: rtl8723be: Fix module parameter
 initialization
Message-ID: <20160201234039.GB5257@charon.olymp> (sfid-20160202_004049_997330_6EDC712A)
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 04:34:31PM -0600, Larry Finger wrote:
> This driver has a number of errors in the module initialization. These
> include the following:
> 
> Parameter msi_support is stored in two places - one is removed.
> Paramters sw_crypto and disable_watchdog were never stored in the final
> locations, nor were they initialized properly.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
> index d091f1d..a78eaed 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
> @@ -93,7 +93,6 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
>  	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
>  
>  	rtl8723be_bt_reg_init(hw);
> -	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
>  	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
>  
>  	rtlpriv->dm.dm_initialgain_enable = 1;
> @@ -151,6 +150,10 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
>  	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
>  	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
>  	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
> +	rtlpriv->cfg->mod_params->sw_crypto =
> +		 rtlpriv->cfg->mod_params->sw_crypto;
> +	rtlpriv->cfg->mod_params->disable_watchdog =
> +		 rtlpriv->cfg->mod_params->disable_watchdog;

Ok, I give up and just ask: are the above hw mapped registers that
actually need to be read/written?  Or am I missing something here, as
the 2 statements above don't seem to make sense.  The same for other
patches in this series.

Cheers,
--
Luís

>  	if (rtlpriv->cfg->mod_params->disable_watchdog)
>  		pr_info("watchdog disabled\n");
>  	rtlpriv->psc.reg_fwctrl_lps = 3;
> @@ -267,6 +270,9 @@ static struct rtl_mod_params rtl8723be_mod_params = {
>  	.inactiveps = true,
>  	.swctrl_lps = false,
>  	.fwctrl_lps = true,
> +	.msi_support = false,
> +	.disable_watchdog = false,
> +	.debug = DBG_EMERG,
>  };
>  
>  static struct rtl_hal_cfg rtl8723be_hal_cfg = {
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
