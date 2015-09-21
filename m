Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbbIUEiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 00:38:24 -0400
Date: Sun, 20 Sep 2015 19:03:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 10/18] staging: wilc1000: rename WILC_WFI_set_power_mgmt
Message-ID: <20150921020339.GA29503@kroah.com> (sfid-20150921_063831_792897_18FB8246)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-10-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-10-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:17PM +0900, Chaehyun Lim wrote:
> This patch replaces WILC_WFI_set_power_mgmt with set_power_mgmt to avoid
> CamelCase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index c8e286d..e6e437f 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -2653,7 +2653,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
>  
>  
>  /**
> - *  @brief      WILC_WFI_set_power_mgmt
> + *  @brief      set_power_mgmt
>   *  @details
>   *  @param[in]
>   *  @return     int : Return 0 on Success.
> @@ -2661,8 +2661,8 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
>   *  @date	01 JUL 2012
>   *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
>   */
> -int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
> -			    bool enabled, int timeout)
> +int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
> +		   bool enabled, int timeout)

This really should be a static function, especially as you just renamed
it to be a very generic name.

thanks,

greg k-h
