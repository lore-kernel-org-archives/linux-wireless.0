Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:44804 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1424895AbdDVPAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 11:00:41 -0400
Message-ID: <1492873234.30293.38.camel@perches.com> (sfid-20170422_170342_096736_C7B88F3F)
Subject: Re: [PATCH] staging: wilc1000: Fixes Alignment should match open
 parenthesis
From: Joe Perches <joe@perches.com>
To: richard@netpro.work, gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Apr 2017 08:00:34 -0700
In-Reply-To: <20170422062830.30715-1-richard@netpro.work>
References: <20170422062830.30715-1-richard@netpro.work>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-22 at 07:28 +0100, richard@netpro.work wrote:
> This patch fixes the following checkpatch.pl
> check: CHECK: Alignment should match open parenthesis

Please strive for improved code for human readers and
not just shutting up checkpatch.

> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
[]
> @@ -870,12 +870,12 @@ static int wilc_mac_open(struct net_device *ndev)
>  				if (memcmp(wl->vif[i ^ 1]->bssid,
>  					   wl->vif[i ^ 1]->src_addr, 6))
>  					wilc_set_wfi_drv_handler(vif,
> -							 wilc_get_vif_idx(vif),
> -							 0);
> +					                         wilc_get_vif_idx(vif),
> +					                         0);
>  				else
>  					wilc_set_wfi_drv_handler(vif,
> -							 wilc_get_vif_idx(vif),
> -							 1);
> +					                         wilc_get_vif_idx(vif),
> +					                         1);

Depending on alignment, perhaps a good bit of this code
could use ether_addr_<foo> functions.

				wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
							 ether_addr_equals(wl->vif[i ^ 1]->bssid,
									   wl->vif[i ^ 1]->src_addr));

The code could also be restructured to reduce
indentation by using if / continue;

		if (ndev != wl->vif[i]->ndev)
			continue;

Using a temporary for the repeated use of
wilc_get_vif_idx(vif) would also help code length.

> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
[]
> @@ -1301,16 +1301,16 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
>  
>  	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
>  		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
> -				 ETH_ALEN)) {
> +		            ETH_ALEN)) {

		ether_addr_equals()

>  			flag = PMKID_FOUND;
>  			break;
>  		}
>  	}
>  	if (i < WILC_MAX_NUM_PMKIDS) {
>  		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
> -			    ETH_ALEN);
> +		       ETH_ALEN);

		ether_addr_copy()

etc.
