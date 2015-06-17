Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbFQCVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 22:21:35 -0400
Date: Tue, 16 Jun 2015 19:21:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 2/2] staging: wilc1000: modify uninitialized warning
Message-ID: <20150617022135.GA18464@kroah.com> (sfid-20150617_042138_782871_5BF35B7B)
References: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
 <1434438685-24336-2-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434438685-24336-2-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 04:11:25PM +0900, Dean Lee wrote:
> initialize it.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 358283f..03e6bc5 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -7241,7 +7241,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
>  	s32 s32Error = WILC_SUCCESS;
>  	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
>  	tstrHostIFmsg strHostIFmsg;
> -	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
> +	tstrHostIFSetBeacon *pstrSetBeaconParam = NULL;

This isn't fixing an "unitialized pointer" warning, the code is just
fine.

Well, it's really odd, but it is correct, there's nothing really wrong
here that I can see.

thanks,

greg k-h
