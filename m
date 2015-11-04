Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbKDUpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:45:44 -0500
Date: Wed, 4 Nov 2015 12:45:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 03/17] staging: wilc1000: wilc_wlan_cfg_get: add
 argument struct net_device
Message-ID: <20151104204544.GB23896@kroah.com> (sfid-20151104_214548_117113_DB1717ED)
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
 <1446198443-6623-3-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446198443-6623-3-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 06:47:09PM +0900, Glen Lee wrote:
> Adds argument struct net_device and use netdev private data member wilc
> instead of g_linux_wlan, pass dev to the functions as well.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 3 ++-
>  drivers/staging/wilc1000/linux_wlan.c       | 2 +-
>  drivers/staging/wilc1000/wilc_wlan.c        | 8 ++++++--
>  drivers/staging/wilc1000/wilc_wlan.h        | 3 ++-
>  4 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 3b4a950..530d64a 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -595,7 +595,8 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
>  		for (counter = 0; counter < count; counter++) {
>  			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
>  				   (counter == count - 1));
> -			if (!wilc_wlan_cfg_get(!counter,
> +			if (!wilc_wlan_cfg_get(dev,
> +					       !counter,
>  					       wids[counter].id,
>  					       (counter == count - 1),
>  					       drv)) {
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index d0161cd..4ed324c 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1153,7 +1153,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
>  
>  		wilc_bus_set_max_speed();
>  
> -		if (wilc_wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
> +		if (wilc_wlan_cfg_get(dev, 1, WID_FIRMWARE_VERSION, 1, 0)) {
>  			int size;
>  			char Firmware_ver[20];
>  
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 16224ce..768fd30 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1809,12 +1809,16 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
>  
>  	return ret_size;
>  }
> -int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
> +int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
> +		      u32 drvHandler)
>  {
>  	wilc_wlan_dev_t *p = &g_wlan;
>  	u32 offset;
>  	int ret_size;
> +	perInterface_wlan_t *nic = netdev_priv(dev);
> +	struct wilc *wilc;
>  
> +	wilc = nic->wilc;

As you really want 'wilc', why not just pass that instead of a struct
net_device *?  You don't have to make it this complex :)

thanks,

greg k-h
