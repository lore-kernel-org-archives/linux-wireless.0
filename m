Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:16359 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032592AbeBPSP7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 13:15:59 -0500
Subject: Re: [PATCH 5/6] staging: wilc1000: fix line over 80 characters in
 wilc_spi_read_int()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
 <1518606615-14404-6-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <6e94cbbe-d29a-bb3a-0fb4-2a9d0ca0fefd@microchip.com> (sfid-20180216_191602_490807_440522E3)
Date: Fri, 16 Feb 2018 20:15:53 +0200
MIME-Version: 1.0
In-Reply-To: <1518606615-14404-6-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.02.2018 13:10, Ajay Singh wrote:
> Refactor wilc_spi_read_int() to fix the line over 80 char issues reported
> by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 57 +++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index fddc0db..7c58beb8 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -939,45 +939,46 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>  	int happened, j;
>  	u32 unknown_mask;
>  	u32 irq_flags;
> +	int k = IRG_FLAGS_OFFSET + 5;
>  
>  	if (g_spi.has_thrpt_enh) {
>  		ret = spi_internal_read(wilc, 0xe840 - WILC_SPI_REG_BASE,
>  					int_status);
> -	} else {
> -		ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE,
> -					&byte_cnt);
> -		if (!ret) {
> -			dev_err(&spi->dev,
> -				"Failed read WILC_VMM_TO_HOST_SIZE ...\n");
> -			goto _fail_;
> -		}
> -		tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
> +		return ret;
> +	}
> +	ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE, &byte_cnt);
> +	if (!ret) {
> +		dev_err(&spi->dev,
> +			"Failed read WILC_VMM_TO_HOST_SIZE ...\n");
> +		goto _fail_;
> +	}
> +	tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
>  
> -		j = 0;
> -		do {
> -			happened = 0;
> +	j = 0;
> +	do {
> +		happened = 0;
You could remove this happen
>  
> -			wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
> -			tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
> +		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
> +		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
>  
> -			if (g_spi.nint > 5) {
> -				wilc_spi_read_reg(wilc, 0x1a94,
> -						  &irq_flags);
> -				tmp |= (((irq_flags >> 0) & 0x7) << (IRG_FLAGS_OFFSET + 5));
> -			}
> +		if (g_spi.nint > 5) {
> +			wilc_spi_read_reg(wilc, 0x1a94, &irq_flags);
> +			tmp |= (((irq_flags >> 0) & 0x7) << k);
> +		}
>  
> -			unknown_mask = ~((1ul << g_spi.nint) - 1);
> +		unknown_mask = ~((1ul << g_spi.nint) - 1);
You could use GENMASK(g_spi.nint - 1, 0) instead of ~((1ul << g_spi.nint) - 1)
>  
> -			if ((tmp >> IRG_FLAGS_OFFSET) & unknown_mask) {
> -				dev_err(&spi->dev, "Unexpected interrupt (2): j=%d, tmp=%x, mask=%x\n", j, tmp, unknown_mask);
> -					happened = 1;
> -			}
> +		if ((tmp >> IRG_FLAGS_OFFSET) & unknown_mask) {
> +			dev_err(&spi->dev,
> +				"Unexpected interrupt(2):j=%d,tmp=%x,mask=%x\n",
> +				j, tmp, unknown_mask);
> +				happened = 1;
And here just break;
> +		}
>  
> -			j++;
> -		} while (happened);
And here use while (true);
> +		j++;
> +	} while (happened);
>  
> -		*int_status = tmp;
> -	}
> +	*int_status = tmp;
>  
>  _fail_:
>  	return ret;
> 
