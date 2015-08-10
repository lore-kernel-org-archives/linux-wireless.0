Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbHJJkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 05:40:17 -0400
Date: Mon, 10 Aug 2015 12:39:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc100: Remove pointer and integer comparision
Message-ID: <20150810093943.GI5180@mwanda> (sfid-20150810_114034_695003_717EDED3)
References: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2015 at 08:50:02PM +0530, Chandra S Gorentla wrote:
> Removed pointer check with integer; this fixes 'sparse' error -
> error: incompatible types for operation (>)
>    left side has type unsigned char [usertype] *[usertype] pu8Tail
>    right side has type int
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
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
>  		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
>  	pu8CurrByte += pstrSetBeaconParam->u32TailLen;

Warnings are a precious thing, because they show you where people are
lost.  It's better to take a broader look at the code instead of *just*
silencing the warning.

For example, the comment is nonsense.  memcpy(anything, anything, 0);
is a no-op so it already would skip copying in that case.  I wonder what
bug 4599 actually means...

Also the next line is quite suspect.  Even though we don't copy then we
are still incrementing the pu8CurrByte count?  That seems wrong.

So now let's consider if the memcpy() is correct.  pu8CurrByte is
allocated at the start of the function.  It should have space for
->u32TailLen bytes, except for they seem to have forgotten about integer
overflow.  I think ->u32TailLen is not trusted data so this could be a
security bug.  Maybe you could exploit it by setting ->u32HeadLen to the
amount of memory you want to corrupt.  Set ->u32TailLen to a high
number so it triggers an integer overflow.  Set >pu8Tail to NULL so it
is doesn't just corrupt everything (DoS attack instead of privilege
escalation).

I have just looked at the code so I don't know if this is true, but this
is how I read that warning.

regards,
dan carpenter
