Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:41229 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750975AbdJRWyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 18:54:36 -0400
Message-ID: <1508367271.6806.25.camel@perches.com> (sfid-20171019_005455_948690_D9BC540B)
Subject: Re: [PATCH] staging: wilc1000: replace redundant computations with 0
From: Joe Perches <joe@perches.com>
To: Colin King <colin.king@canonical.com>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Oct 2017 15:54:31 -0700
In-Reply-To: <20171010140548.18016-1-colin.king@canonical.com>
References: <20171010140548.18016-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 15:05 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting and masking strHostIfSetMulti->enabled is redundant since
> enabled is a bool and so all the shifted and masked values will be
> zero. Replace them with zero to simplify the code.
> 
> Detected by CoverityScan, CID#1339458 ("Bad shift operation") and
> CID#1339506 ("Operands don't affect result").
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 7b620658ec38..94477dd08c85 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2417,9 +2417,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
>  
>  	pu8CurrByte = wid.val;
>  	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
> +	*pu8CurrByte++ = 0;
> +	*pu8CurrByte++ = 0;
> +	*pu8CurrByte++ = 0;

This might be more an indication of another defect

Perhaps this is just supposed to be

	*pu8CurrByte++ = strHostIfSetMulti->enabled;

without the three byte sets to zero after that.

>  	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
>  	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
