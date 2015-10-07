Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28377 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbJGGYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 02:24:20 -0400
Date: Wed, 7 Oct 2015 09:23:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: devel@driverdev.osuosl.org, Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH next] staging: wilc1000: avoid NULL pointer dereference
 on error
Message-ID: <20151007062358.GN7340@mwanda> (sfid-20151007_082513_060456_C8B6A56A)
References: <1444194505-31080-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1444194505-31080-1-git-send-email-vincent.stehle@laposte.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 07, 2015 at 07:08:25AM +0200, Vincent Stehlé wrote:
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 2cf82b2..2fe3023 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -6017,7 +6017,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
>  	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
>  	if (!pstrWFIDrv) {
>  		result = -ENOMEM;
> -		goto _fail_timer_2;
> +		goto _fail_;

Fair enough.  I would have prefered a direct return, but his also works.

The error handling in this function is still very bad and nonsensical.
You have fixed the first goto but all the others are buggy as well.

if add_handler_in_list() fails we should "goto free_pstrWFIDrv" (except
the label name should have Hungarian notation or CamelCase).  Instead of
freeing the current code unlocks a lock which is not initialiazed and
frees some timers which are also not initialized.

TODO: wilc1000: fix error handling in host_int_init()

regards,
dan carpenter


