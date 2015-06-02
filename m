Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35317 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbFBI3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 04:29:22 -0400
Date: Tue, 2 Jun 2015 10:29:17 +0200
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: fix warning while printing
Message-ID: <20150602082917.GB5903@patagonia> (sfid-20150602_102941_853259_2C6DCFFA)
References: <1433231814-4204-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433231814-4204-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02, Sudip Mukherjee wrote:
> size_t should print using %zu, but here it was using %d and hence we
> were getting warning while printing.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> I think it will be easy to remove the other warnings if all the typedefs
> are removed first.
> 
>  drivers/staging/wilc1000/wilc_spi.c               | 2 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index d0e7610..6d854fd 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -404,7 +404,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
>  #undef NUM_DUMMY_BYTES
>  
>  	if (len2 > (sizeof(wb) / sizeof(wb[0]))) {
> -		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%d)\n",
> +		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%lu)\n",

Hi, it seems that the above line should use %zu too. Am I correct or I'm
missing something?

 - konrad

>  			 len2, (sizeof(wb) / sizeof(wb[0])));
>  		result = N_FAIL;
>  		return result;
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index e9ab2cb..6fdb0d6 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -638,7 +638,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
>  		}
>  
>  
> -		PRINT_D(CFG80211_DBG, "Association request info elements length = %d\n", pstrConnectInfo->ReqIEsLen);
> +		PRINT_D(CFG80211_DBG, "Association request info elements length = %zu\n", pstrConnectInfo->ReqIEsLen);
>  
>  		PRINT_D(CFG80211_DBG, "Association response info elements length = %d\n", pstrConnectInfo->u16RespIEsLen);
>  
> @@ -778,7 +778,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
>  		}
>  
>  		PRINT_D(CFG80211_DBG, "Requested num of scan channel %d\n", request->n_channels);
> -		PRINT_D(CFG80211_DBG, "Scan Request IE len =  %d\n", request->ie_len);
> +		PRINT_D(CFG80211_DBG, "Scan Request IE len =  %zu\n", request->ie_len);
>  
>  		PRINT_D(CFG80211_DBG, "Number of SSIDs %d\n", request->n_ssids);
>  
> @@ -3316,7 +3316,7 @@ static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
>  	priv = wiphy_priv(wiphy);
>  	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
>  
> -	PRINT_D(HOSTAPD_DBG, "Interval = %d \n DTIM period = %d\n Head length = %d Tail length = %d\n",
> +	PRINT_D(HOSTAPD_DBG, "Interval = %d \n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
>  		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
>  
>  	s32Error = WILC_WFI_CfgSetChannel(wiphy, &settings->chandef);
> -- 
> 1.8.1.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
