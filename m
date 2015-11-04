Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbbKDUow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:44:52 -0500
Date: Wed, 4 Nov 2015 12:44:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 02/17] staging: wilc1000: send_config_pkt: add
 argument struct net_device
Message-ID: <20151104204451.GA23896@kroah.com> (sfid-20151104_214455_265454_3FC53189)
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
 <1446198443-6623-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446198443-6623-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 06:47:08PM +0900, Glen Lee wrote:
> This patch adds new argument struct net_device and pass dev to the function
> as well.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c |   3 +-
>  drivers/staging/wilc1000/coreconfigurator.h |   3 +-
>  drivers/staging/wilc1000/host_interface.c   | 196 +++++++++++++++++++++-------
>  drivers/staging/wilc1000/wilc_wlan_if.h     |   1 +
>  4 files changed, 156 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index e10c6ff..3b4a950 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -586,7 +586,8 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
>   *  @date		1 Mar 2012
>   *  @version	1.0
>   */
> -s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
> +s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
> +		    u32 count, u32 drv)
>  {
>  	s32 counter = 0, ret = 0;
>  

But you don't do anything with this new argument?

And why struct net_device, why not your "local" structure instead?

thanks,

greg k-h
