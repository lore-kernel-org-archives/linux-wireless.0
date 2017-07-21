Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754652AbdGUQv6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 12:51:58 -0400
Message-ID: <1500655872.10725.1.camel@redhat.com> (sfid-20170721_185201_940626_24493B2B)
Subject: Re: brcfmac: add possibility to turn off powersave on wiphy
From: Dan Williams <dcbw@redhat.com>
To: Rafal <fatwildcat@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 21 Jul 2017 11:51:12 -0500
In-Reply-To: <alpine.DEB.2.20.1707211652430.10663@wilk>
References: <alpine.DEB.2.20.1707211652430.10663@wilk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-07-21 at 16:56 +0200, Rafal wrote:
> I have a board with ap6212 chip and I have encountered two problems
> with the brcmfmac driver operating with this device. First problem I
> describe below, second one in separate mail.
> 
> 
> Namely, I have noticed quite poor connection with the device despite
> good signal strength. Ping to the device was very uneven, about 50 -
> 100 ms in average, 10 - 20% of packets loss. After some
> investigations I have found that problem is caused by powersave
> feature on wiphy (BRCMF_C_SET_PM command). When the value is set to
> PM_OFF, the problem does not appear - ping is quite stable, ~2ms.
> When set to PM_FAST, the ping is bad.
> 
> The brcmfmac driver currently does not have possibility to turn off
> the powersave feature. I have added the possibility on 4.11.6 kernel 

I don't think that's true?  The driver implements the nl80211
set_power_mgmt hook, which lets you turn off powersave with 'iw'.  That
seems like a much better option than a module parameter.  I know other
drivers have the module parameter, but I personally consider that
legacy/holdover, given that we have runtime toggles for this kind of
thing.

brcmf_cfg80211_set_power_mgmt() should do what you need, right?

Dan

> in my sandbox, but maybe the change is worth to add in general. I'm
> providing my patch for reference. This change allows to turn off
> powersave in two ways. First one, by specify "brcm,powersave-default-
> off" option in OF devicetree. Second one - as a module parameter. The
> parameter is named powersave_default and is tri-state:
> 
> value >0 enables powersave
> value =0 disables powersave
> value <0 (the default) does not override powersave value, i.e. value
> from devicetree or driver default is in effect.
> 
> Rafal
> 
> 
> diff --git
> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 944b83c..86cd1f7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5702,7 +5702,7 @@ static s32 wl_init_priv(struct
> brcmf_cfg80211_info *cfg)
>   	s32 err = 0;
> 
>   	cfg->scan_request = NULL;
> -	cfg->pwr_save = true;
> +	cfg->pwr_save = !cfg->pub->settings->powersave_default_off;
>   	cfg->active_scan = true;	/* we do active scan per
> default */
>   	cfg->dongle_up = false;		/* dongle is not up
> yet */
>   	err = brcmf_init_priv_mem(cfg);
> @@ -6450,8 +6450,9 @@ static int brcmf_setup_wiphy(struct wiphy
> *wiphy, struct brcmf_if *ifp)
>   				    BIT(NL80211_BSS_SELECT_ATTR_BAN
> D_PREF) |
>   				    BIT(NL80211_BSS_SELECT_ATTR_RSS
> I_ADJUST);
> 
> -	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
> -			WIPHY_FLAG_OFFCHAN_TX |
> +	if( ! ifp->drvr->settings->powersave_default_off )
> +		wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +	wiphy->flags |= WIPHY_FLAG_OFFCHAN_TX |
>   			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
>   	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
>   		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
> diff --git
> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 33b133f..191424e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -80,6 +80,10 @@ module_param_named(ignore_probe_fail,
> brcmf_ignore_probe_fail, int, 0);
>   MODULE_PARM_DESC(ignore_probe_fail, "always succeed probe for
> debugging");
>   #endif
> 
> +static int brcmf_powersave_default = -1;
> +module_param_named(powersave_default, brcmf_powersave_default, int,
> 0);
> +MODULE_PARM_DESC(powersave_default, "Set powersave default on/off on
> wiphy");
> +
>   static struct brcmfmac_platform_data *brcmfmac_pdata;
>   struct brcmf_mp_global_t brcmf_mp_global;
> 
> @@ -319,6 +323,8 @@ struct brcmf_mp_device
> *brcmf_get_module_param(struct device *dev,
>   		/* No platform data for this device, try OF (Open
> Firwmare) */
>   		brcmf_of_probe(dev, bus_type, settings);
>   	}
> +	if( brcmf_powersave_default >= 0 )
> +		settings->powersave_default_off =
> !brcmf_powersave_default;
>   	return settings;
>   }
> 
> diff --git
> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index a62f8e7..ab67fcf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -59,6 +59,7 @@ struct brcmf_mp_device {
>   	int		fcmode;
>   	bool		roamoff;
>   	bool		ignore_probe_fail;
> +	bool		powersave_default_off;
>   	struct brcmfmac_pd_cc *country_codes;
>   	union {
>   		struct brcmfmac_sdio_pd sdio;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index aee6e59..904ba11 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -39,6 +39,9 @@ void brcmf_of_probe(struct device *dev, enum
> brcmf_bus_type bus_type,
>   	if (of_property_read_u32(np, "brcm,drive-strength", &val)
> == 0)
>   		sdio->drive_strength = val;
> 
> +	settings->powersave_default_off = of_property_read_bool(np,
> +			"brcm,powersave-default-off");
> +
>   	/* make sure there are interrupts defined in the node */
>   	if (!of_find_property(np, "interrupts", NULL))
>   		return;
