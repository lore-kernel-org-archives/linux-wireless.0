Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbINEwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 00:52:14 -0400
Date: Sun, 13 Sep 2015 21:52:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH V3 29/31] staging: wilc1000: rename
 WILC_WFI_frame_register
Message-ID: <20150914045214.GA24383@kroah.com> (sfid-20150914_065234_682636_47216996)
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
 <1442201071-16155-29-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442201071-16155-29-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2015 at 12:24:29PM +0900, Chaehyun Lim wrote:
> This patch replaces WILC_WFI_frame_register with mgmt_frame_register to
> avoid CamelCase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V3: remove "wilc_" prefix
> 
>  drivers/staging/wilc1000/linux_wlan.c             | 12 ++++++------
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 63f44f8..5576e1c 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1618,8 +1618,8 @@ int mac_init_fn(struct net_device *ndev)
>  	return 0;
>  }
>  
> -void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
> -				u16 frame_type, bool reg);
> +void mgmt_frame_register(struct wiphy *wiphy, struct net_device *dev,
> +			 u16 frame_type, bool reg);

This should be in a .h file, as it's a global variable.

And because it's global, it needs to keep a wilc_ prefix, right?

thanks,

greg k-h
