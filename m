Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:24837 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaK1KI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 05:08:26 -0500
Message-ID: <5478498E.3070508@broadcom.com> (sfid-20141128_110847_146062_30176CBB)
Date: Fri, 28 Nov 2014 11:08:14 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Brett Rudley <brudley@broadcom.com>
CC: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Julia Lawall" <Julia.Lawall@lip6.fr>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>,
	<kernel-janitors@vger.kernel.org>
Subject: Re: [patch] brcmsmac: NULL dereferences in brcms_c_detach_mfree()
References: <20141128094340.GA10364@mwanda>
In-Reply-To: <20141128094340.GA10364@mwanda>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-11-14 10:43, Dan Carpenter wrote:
> The brcms_c_attach_malloc() function can call this with a NULL
> "wlc->corestate" or "wlc->hw".
> 
> Also I threw in a bonus cleanup by deleting an obvious comment and a
> no-op NULL assignment.  :)

Thanks for the patch+bonus

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 738cfac..a104d7a 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -445,18 +445,18 @@ static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
>  	kfree(wlc->protection);
>  	kfree(wlc->stf);
>  	kfree(wlc->bandstate[0]);
> -	kfree(wlc->corestate->macstat_snapshot);
> +	if (wlc->corestate)
> +		kfree(wlc->corestate->macstat_snapshot);
>  	kfree(wlc->corestate);
> -	kfree(wlc->hw->bandstate[0]);
> +	if (wlc->hw)
> +		kfree(wlc->hw->bandstate[0]);
>  	kfree(wlc->hw);
>  	if (wlc->beacon)
>  		dev_kfree_skb_any(wlc->beacon);
>  	if (wlc->probe_resp)
>  		dev_kfree_skb_any(wlc->probe_resp);
>  
> -	/* free the wlc */
>  	kfree(wlc);
> -	wlc = NULL;
>  }
>  
>  static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
> 

