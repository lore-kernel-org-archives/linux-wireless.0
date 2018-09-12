Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9966 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbeILMrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 08:47:06 -0400
Subject: Re: [PATCH] staging: wilc1000: fix null checks on wilc
To: Colin King <colin.king@canonical.com>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
CC: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20180911173851.17567-1-colin.king@canonical.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <d6520e83-68d4-1c32-5291-74163b74e249@microchip.com> (sfid-20180912_094359_574386_A428C74C)
Date: Wed, 12 Sep 2018 10:43:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180911173851.17567-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11.09.2018 20:38, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the pointer wilc is being null checked several times
> and yet not checked for the final workqueue flush and destroy
> (which can lead to a null pointer dereference if wilc is null);
> these missing null checks were overlooked in an earlier core
> refactoring commit.
> 
> Clean up the code by checking wilc at the start and bailing out
> early if it is null allowing the subsequent null checks to be
> removed, this also fixes the potential null pointer deferences
> on the workqueue flush and destroy calls.
> 
> Detected by CoverityScan, CID#1473305 ("Dereference after null check")
> 
> Fixes: b3ee105c332e ("staging: wilc1000: refactor code to move initilization in wilc_netdev_init()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

> ---
>  drivers/staging/wilc1000/linux_wlan.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index a498321c908b..49afda669393 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1015,15 +1015,18 @@ void wilc_netdev_cleanup(struct wilc *wilc)
>  {
>  	int i;
>  
> -	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev))
> +	if (!wilc)
> +		return;
> +
> +	if (wilc->vif[0]->ndev || wilc->vif[1]->ndev)
>  		unregister_inetaddr_notifier(&g_dev_notifier);
>  
> -	if (wilc && wilc->firmware) {
> +	if (wilc->firmware) {
>  		release_firmware(wilc->firmware);
>  		wilc->firmware = NULL;
>  	}
>  
> -	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
> +	if (wilc->vif[0]->ndev || wilc->vif[1]->ndev) {
>  		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
>  			if (wilc->vif[i]->ndev)
>  				if (wilc->vif[i]->mac_opened)
> 
