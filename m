Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19136 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdJWMTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 08:19:22 -0400
Date: Mon, 23 Oct 2017 15:19:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Colin King <colin.king@canonical.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: replace redundant computations with 0
Message-ID: <20171023121907.phgo4ch5ygms2uja@mwanda> (sfid-20171023_141941_223794_9574E5C4)
References: <20171010140548.18016-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010140548.18016-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, Oct 10, 2017 at 03:05:48PM +0100, Colin King wrote:
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

This is harder to understand now.  I would be better to solve this by
declaring a struct with the right format and using cpu_to_be32().

regards,
dan carpenter
