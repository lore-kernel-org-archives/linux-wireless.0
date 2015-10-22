Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23081 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbJVLRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 07:17:20 -0400
Date: Thu, 22 Oct 2015 14:17:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 03/12] staging: wilc1000: rename strInterfaceInfo in
 the sturct wilc
Message-ID: <20151022111704.GN7340@mwanda> (sfid-20151022_131724_085761_7D94E276)
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
 <1445318816-21686-4-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445318816-21686-4-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2015 at 02:26:47PM +0900, Tony Cho wrote:
> This patch renames strInterfaceInfo in the struct wilc to the vif. In
> addition, unnecessary print statements around it are removed in this patch.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c             | 91 +++++++++++------------
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 72 +++++++++---------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
>  3 files changed, 80 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 2bea103..971b99a 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -366,24 +366,21 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
>  	Bssid  = pMacHeader + 10;
>  	Bssid1 = pMacHeader + 4;
>  
> -	for (i = 0; i < g_linux_wlan->vif_num; i++) {
> -		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
> -		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
> -			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
> -		}
> -	}
> +	for (i = 0; i < g_linux_wlan->vif_num; i++)
> +		if (!memcmp(Bssid1, g_linux_wlan->vif[i].aBSSID, ETH_ALEN) ||
> +		    !memcmp(Bssid, g_linux_wlan->vif[i].aBSSID, ETH_ALEN))
> +			return g_linux_wlan->vif[i].wilc_netdev;
> +

Removing the curly braces was wrong.  Multi-line indents get curly
braces for readability even though the compiler does not insist on them.

regards,
dan carpenter

