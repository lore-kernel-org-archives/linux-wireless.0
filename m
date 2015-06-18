Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbFREQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 00:16:24 -0400
Date: Wed, 17 Jun 2015 21:16:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sunghoon Cho <ywhsbliss@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com
Subject: Re: [PATCH 3/5] staging: wilc1000: remove the warnings on line over
 80 characters.
Message-ID: <20150618041622.GA3830@kroah.com> (sfid-20150618_061627_569098_389410C4)
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
 <96ea4637a566933afbba83499d2e4ab0ed75355c.1434519635.git.ywhsbliss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <96ea4637a566933afbba83499d2e4ab0ed75355c.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 02:42:34PM +0900, Sunghoon Cho wrote:
> This removes the warnings reported by checkpatch.pl for line over 80
> characters.
> 
> Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 7f58551..96e4d5c 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -77,8 +77,8 @@ struct WILC_WFI_stats {
>  #define num_reg_frame 2
>  /*
>   * If you use RX_BH_WORK_QUEUE on LPC3131: You may lose the first interrupt on
> - * LPC3131 which is important to get the MAC start status when you are blocked inside
> - * linux_wlan_firmware_download() which blocks mac_open().
> + * LPC3131 which is important to get the MAC start status when you are blocked
> + * inside linux_wlan_firmware_download() which blocks mac_open().
>   */
>  #if defined (NM73131_0_BOARD)
>   #define RX_BH_TYPE  RX_BH_KTHREAD
> @@ -150,7 +150,8 @@ struct WILC_WFI_priv {
>  	u8 WILC_WFI_wep_default;
>  	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
>  	u8 WILC_WFI_wep_key_len[4];
> -	struct net_device *real_ndev;   /* The real interface that the monitor is on */
> +	/* The real interface that the monitor is on  */
> +	struct net_device *real_ndev;

This change doesn't work well, I'd leave it as-is.

thanks,

greg k-h
