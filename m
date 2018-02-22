Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeBVHVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 02:21:13 -0500
Date: Thu, 22 Feb 2018 10:20:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove use of 'happened' variable
 in wilc_spi_read_int()
Message-ID: <20180222072058.g6wyrsmg5lr6vnef@mwanda> (sfid-20180222_082116_969037_A1DB8A39)
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
 <1519229532-11265-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519229532-11265-2-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 21, 2018 at 09:42:09PM +0530, Ajay Singh wrote:
> Modified wilc_spi_read_int() by removing unnecessary use of "happened"
> variable.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 6b392c9..131d2b7 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -936,7 +936,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>  	int ret;
>  	u32 tmp;
>  	u32 byte_cnt;
> -	int happened, j;
> +	int j;
>  	u32 unknown_mask;
>  	u32 irq_flags;
>  	int k = IRG_FLAGS_OFFSET + 5;
> @@ -956,8 +956,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>  
>  	j = 0;
>  	do {
> -		happened = 0;
> -
>  		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
>  		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
>  
> @@ -972,11 +970,11 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>  			dev_err(&spi->dev,
>  				"Unexpected interrupt(2):j=%d,tmp=%x,mask=%x\n",
>  				j, tmp, unknown_mask);
> -				happened = 1;
> +				break;

This is flipped around.  happened means don't break, but you've changed
it to be the opposite.

regards,
dan carpenter

>  		}
>  
>  		j++;
> -	} while (happened);
> +	} while (1);
>  
