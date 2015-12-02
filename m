Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51668 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbLBN3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 08:29:38 -0500
Date: Wed, 2 Dec 2015 16:29:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Mario J. Rugiero" <mrugiero@gmail.com>
Cc: devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 1/1] staging: cleanup: Fix incompatible type comparison
 in wilc1000/host_interface.c
Message-ID: <20151202132923.GV18797@mwanda> (sfid-20151202_142941_470198_50658956)
References: <1448928544-3534-1-git-send-email-mrugiero@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448928544-3534-1-git-send-email-mrugiero@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put v2 in the subject.  Also the subsystem prefix is:

[PATCH v3] staging: wilc1000: ...

On Mon, Nov 30, 2015 at 09:09:04PM -0300, Mario J. Rugiero wrote:
> This patch replaces an "if (ptr > 0)" comparison that seems to be a
> confusing way to check for null by a simpler "if (ptr)" check.
> 
> Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
> ---
v2: Remove the != NULL because checkpatch complains.

>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index d5b7725..0c87f6c 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2270,7 +2270,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
>  	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
>  	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
>  
> -	if (pstrSetBeaconParam->tail > 0)
> +	if (pstrSetBeaconParam->tail)

Probably the intention was to check if "pstrSetBeaconParam->tail_len > 0"
but I'm not sure.  The wilc1000 maintainers are very responsive though
so maybe they will know for sure.

regards,
dan carpenter


