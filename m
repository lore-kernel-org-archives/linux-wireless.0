Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdDRLvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 07:51:05 -0400
Date: Tue, 18 Apr 2017 13:50:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, ganesh.krishna@microchip.com
Subject: Re: [PATCH v3] staging: wilc1000: New cfg packet format in
 handle_set_wfi_drv_handler
Message-ID: <20170418115055.GA17911@kroah.com> (sfid-20170418_135111_278912_A9751134)
References: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491928903-2866-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 11, 2017 at 10:11:43PM +0530, Aditya Shankar wrote:
> Change the config packet format used in handle_set_wfi_drv_handler()
> to align the host driver with the new format used in the wilc firmware.
> 
> The change updates the format in which the host driver provides the
> firmware with the drv_handler index and also uses two new
> fields viz. "mode" and 'name" in the config packet along with this index
> to directly provide details about the interface and its mode to the
> firmware instead of having multiple if-else statements in the host driver
> to decide which interface to configure.
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> ---
> Change in v2: Fix build warning
> Change in v3: Address review comments from v2
> ---
>  drivers/staging/wilc1000/host_interface.c         | 48 ++++++++++++++++++-----
>  drivers/staging/wilc1000/host_interface.h         |  9 ++++-
>  drivers/staging/wilc1000/linux_wlan.c             | 37 +++++------------
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
>  drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
>  6 files changed, 59 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c3a8af0..7352488 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -334,14 +334,39 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
>  {
>  	int ret = 0;
>  	struct wid wid;
> +	u8 *currbyte, *buffer;
> +	struct host_if_drv *hif_drv = NULL;
> +
> +	if (!vif->hif_drv)
> +		return;
> +
> +	if (!hif_drv_handler)
> +		return;
> +
> +	hif_drv	= vif->hif_drv;
> +	buffer = kzalloc(DRV_HANDLER_SIZE, GFP_ATOMIC);
> +
> +	if (!buffer)
> +		return;

Test on the line right after allocation.

And there is no way to return an error from this function?  That seems
bad.

And why do you need GFP_ATOMIC?

And finally, where do you free this buffer?

> @@ -3449,8 +3477,10 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
>  
>  	id = ((buffer[length - 4]) | (buffer[length - 3] << 8) | (buffer[length - 2] << 16) | (buffer[length - 1] << 24));
>  	vif = wilc_get_vif_from_idx(wilc, id);
> +
>  	if (!vif)
>  		return;
> +
>  	hif_drv = vif->hif_drv;
>  
>  	if (!hif_drv || hif_drv == terminated_handle)	{

Unneeded whitespace changes.  Don't do that in a patch that does other
things.

thanks,

greg k-h
