Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36764 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbHJEac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 00:30:32 -0400
Date: Mon, 10 Aug 2015 10:00:19 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: wilc1000: Remove pointer and integer
 comparision
Message-ID: <20150810043019.GA6528@sudip-pc> (sfid-20150810_063055_115205_A3FE69D0)
References: <1439134511-9931-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439134511-9931-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2015 at 09:05:11PM +0530, Chandra S Gorentla wrote:
> Removed pointer check with integer; this fixes 'sparse' error -
> error: incompatible types for operation (>)
>    left side has type unsigned char [usertype] *[usertype] pu8Tail
>    right side has type int
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
> Changes in v2: Subject line corrected wilc100 -> wilc1000
> 
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index cc549c2..4ba1ad7 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -3471,7 +3471,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
>  	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 24) & 0xFF);
>  
>  	/* Bug 4599 : if tail length = 0 skip copying */
> -	if (pstrSetBeaconParam->pu8Tail > 0)
> +	if (pstrSetBeaconParam->pu8Tail != NULL)
This NULL test can be better wriiten as if (pstrSetBeaconParam->pu8Tail)

regards
sudip
