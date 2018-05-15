Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752587AbeEOJBg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:01:36 -0400
Date: Tue, 15 May 2018 12:01:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 24/30] staging: wilc1000: refactor del_station() to avoid
 parenthesis misalignment
Message-ID: <20180515090112.fba2zkzsqd7j7ckq@mwanda> (sfid-20180515_110140_711079_31E7BB43)
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-25-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525682614-3824-25-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I feel sort of bad complaining about this patchset when your co-workers
already nit picked it to death...  :P

On Mon, May 07, 2018 at 02:13:28PM +0530, Ajay Singh wrote:
> Refactor the code to fix open parenthesis alignment issue reported by
> checkpatch.pl script in del_station().

I no idea what an "open parenthesis alignment issue" is.  It's sort of
surprising because I deal with checkpatch patches a lot.

> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 4600f4a..7f49d60 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -1997,6 +1997,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
>  	s32 ret = 0;
>  	struct wilc_priv *priv;
>  	struct wilc_vif *vif;
> +	struct sta_info *info;
>  
>  	if (!wiphy)
>  		return -EFAULT;
> @@ -2004,16 +2005,17 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
>  	priv = wiphy_priv(wiphy);
>  	vif = netdev_priv(dev);
>  
> -	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
> -		if (!mac)
> -			ret = wilc_del_allstation(vif,
> -				     priv->assoc_stainfo.sta_associated_bss);
> +	if (!(vif->iftype == AP_MODE || vif->iftype == GO_MODE))

I feel like this is better as:
	if (vif->iftype != AP_MODE && vif->iftype != GO_MODE)

> +		return ret;

What is "ret" here?  I haven't looked at this patch in context, but
it's probably zero.  Just return the literal.

regards,
dan carpenter
