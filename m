Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50893 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1ILNYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 09:24:18 -0400
Received: by pzk37 with SMTP id 37so6796750pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 06:24:18 -0700 (PDT)
Date: Mon, 12 Sep 2011 16:21:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/20] staging: brcm80211: removed softmac ratespec
 override functionality
Message-ID: <20110912132154.GJ14370@shale.localdomain> (sfid-20110912_152421_907093_7E1EC7E0)
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
 <1315822504-24210-14-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315822504-24210-14-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:14:57PM +0200, Roland Vossen wrote:
> @@ -5988,12 +5982,8 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
>  		for (i = 0; i < wlc->pub->_nbands; i++) {
>  			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
>  			       MCSSET_LEN);
> -			if (IS_MCS(wlc->band->rspec_override)) {
> -				wlc->bandstate[i]->rspec_override = 0;
> +			if (IS_MCS(0))
>  				brcms_c_reprate_init(wlc);
> -			}

IS_MCS(0) is always false.

> -			if (IS_MCS(wlc->band->mrspec_override))
> -				wlc->bandstate[i]->mrspec_override = 0;
>  		}

[snip]

> diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
> index 0a101a4..71c5d23 100644
> --- a/drivers/staging/brcm80211/brcmsmac/stf.c
> +++ b/drivers/staging/brcm80211/brcmsmac/stf.c
> @@ -293,26 +293,22 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
>  
>  	if (txstreams == 1) {
>  		for (i = 0; i < wlc->pub->_nbands; i++)
> -			if ((RSPEC_STF(wlc->bandstate[i]->rspec_override) !=
> +			if ((RSPEC_STF(0) !=
>  			     PHY_TXC1_MODE_SISO)

RSPEC_STF(0) is false as well.  Same below.

regards,
dan carpenter

> -			    || (RSPEC_STF(wlc->bandstate[i]->mrspec_override) !=
> +			    || (RSPEC_STF(0) !=
>  				PHY_TXC1_MODE_SISO)) {
>  				if (!force)
>  					return -EBADE;
>  
>  				/* over-write the override rspec */
> -				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
> +				if (RSPEC_STF(0)
>  				    != PHY_TXC1_MODE_SISO) {
> -					wlc->bandstate[i]->rspec_override = 0;
>  					wiphy_err(wlc->wiphy, "%s(): temp "
>  						  "sense override non-SISO "
>  						  "rspec_override\n",
>  						  __func__);
>  				}
> -				if (RSPEC_STF
> -				    (wlc->bandstate[i]->mrspec_override) !=
> -				    PHY_TXC1_MODE_SISO) {
> -					wlc->bandstate[i]->mrspec_override = 0;
> +				if (RSPEC_STF(0) != PHY_TXC1_MODE_SISO) {
>  					wiphy_err(wlc->wiphy, "%s(): temp "
>  						  "sense override non-SISO "
>  						  "mrspec_override\n",

