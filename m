Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbJDImB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 04:42:01 -0400
Date: Sun, 4 Oct 2015 09:41:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 06/10] staging: wilc1000: rename hWFIDrv of
 host_int_set_mac_chnl_num
Message-ID: <20151004084158.GB21313@kroah.com> (sfid-20151004_104210_914277_F7EF2376)
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
 <1443789896-7082-6-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443789896-7082-6-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 09:44:52PM +0900, Chaehyun Lim wrote:
> This patch replaces hWFIDrv with wfi_drv that is first argument of
> host_int_set_mac_chnl_num to avoid camelcase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  drivers/staging/wilc1000/host_interface.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 133bb2d..d23d2dd 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -5315,10 +5315,10 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
>   *  @date		8 March 2012
>   *  @version		1.0
>   */
> -int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 channel)
> +int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
>  {
>  	int result = 0;
> -	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
> +	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)wfi_drv;

Not the issue here, but in the future, why is this cast needed?  Heck,
why is this local variable even needed, why not just use wifi_drv
everywhere in this function?

thanks,

greg k-h
