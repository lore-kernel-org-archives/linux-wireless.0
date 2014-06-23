Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45266 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaFWJiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 05:38:04 -0400
Message-ID: <1403516273.4418.11.camel@jlt4.sipsolutions.net> (sfid-20140623_113808_413784_B0E52BA3)
Subject: Re: [RFC 3/3] brcmfmac: update band and regulatory info before
 wiphy_register()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 23 Jun 2014 11:37:53 +0200
In-Reply-To: <1402996581-10764-4-git-send-email-arend@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
	 <1402996581-10764-4-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not really sure why this code requires the previous patch?

> @@ -5615,35 +5593,51 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>  	err = wl_init_priv(cfg);
>  	if (err) {
>  		brcmf_err("Failed to init iwm_priv (%d)\n", err);
> -		goto cfg80211_attach_out;
> +		brcmf_free_vif(vif);
> +		goto wiphy_out;
>  	}
>  	ifp->vif = vif;
>  
> +	if (wiphy_is_40mhz_24ghz_disabled(wiphy) == false) {
> +		err = brcmf_enable_bw40_2g(ifp);
> +		if (!err)
> +			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
> +						      BRCMF_OBSS_COEX_AUTO);
> +	}

This seems to have an effect only on the device, so why not do it after
wiphy_register()?

> +	/* determine d11 io type before updating bands */
> +	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
> +	if (err) {
> +		brcmf_err("Failed to get D11 version (%d)\n", err);
> +		goto priv_out;
> +	}
> +	cfg->d11inf.io_type = (u8)io_type;
> +	brcmu_d11_attach(&cfg->d11inf);
> +
> +	err = brcmf_update_wiphybands(cfg);
> +	if (err)
> +		goto priv_out;
> +
> +	brcmf_dbg(INFO, "Registering custom regulatory\n");
> +	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
> +	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);

The regdomain is also static const so not affected by it.

johannes

