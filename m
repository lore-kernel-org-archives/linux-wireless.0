Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbbILEfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 00:35:14 -0400
Date: Fri, 11 Sep 2015 19:36:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH V2 01/31] staging: wilc1000: rename WILC_WFI_CfgSetChannel
Message-ID: <20150912023647.GA5330@kroah.com> (sfid-20150912_063707_632580_7E405A54)
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2015 at 04:14:00AM +0900, Chaehyun Lim wrote:
> This patch replaces WILC_WFI_CfgSetChannel with
> wilc_set_channel to avoid CamelCase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: to make function name simple
> 
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index cf76a33..3149fd8 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -677,7 +677,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
>  
>  
>  /**
> - *  @brief      WILC_WFI_CfgSetChannel
> + *  @brief      wilc_set_channel
>   *  @details    Set channel for a given wireless interface. Some devices
>   *                      may support multi-channel operation (by channel hopping) so cfg80211
>   *                      doesn't verify much. Note, however, that the passed netdev may be
> @@ -689,8 +689,8 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
>   *  @date	01 MAR 2012
>   *  @version	1.0
>   */
> -static int WILC_WFI_CfgSetChannel(struct wiphy *wiphy,
> -				  struct cfg80211_chan_def *chandef)
> +static int wilc_set_channel(struct wiphy *wiphy,
> +			    struct cfg80211_chan_def *chandef)

static functions do not need a "wilc_" prefix.  Just name it
"set_channel()"

Can you redo this series based on that, rebase on my staging-testing git
branch as things are changing fast in this driver, and then resend?

thanks,

greg k-h
