Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5313 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032592AbeBPSQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 13:16:06 -0500
Subject: Re: [PATCH 6/6] staging: wilc1000: fix line over 80 chars in
 wilc_spi_clear_int_ext()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
 <1518606615-14404-7-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <63adcc58-bdd1-9fe7-6774-3ea1d626858b@microchip.com> (sfid-20180216_191611_098755_0A8C7A5A)
Date: Fri, 16 Feb 2018 20:16:02 +0200
MIME-Version: 1.0
In-Reply-To: <1518606615-14404-7-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.02.2018 13:10, Ajay Singh wrote:
> Refactor wilc_spi_clear_int_ext() to fix the "line over 80 char" issue
> reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 113 +++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
> index 7c58beb8..6b392c9 100644
> --- a/drivers/staging/wilc1000/wilc_spi.c
> +++ b/drivers/staging/wilc1000/wilc_spi.c
> @@ -988,74 +988,69 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
>  {
>  	struct spi_device *spi = to_spi_device(wilc->dev);
>  	int ret;
> +	u32 flags;
> +	u32 tbl_ctl;
>  
>  	if (g_spi.has_thrpt_enh) {
>  		ret = spi_internal_write(wilc, 0xe844 - WILC_SPI_REG_BASE,
>  					 val);
> -	} else {
> -		u32 flags;
> -
> -		flags = val & (BIT(MAX_NUM_INT) - 1);> -		if (flags) {
> -			int i;
> -
> -			ret = 1;
> -			for (i = 0; i < g_spi.nint; i++) {
> -				/*
> -				 * No matter what you write 1 or 0,
> -				 * it will clear interrupt.
> -				 */
> -				if (flags & 1)
> -					ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
> -				if (!ret)
> -					break;
> -				flags >>= 1;
> -			}
> -			if (!ret) {
> +		return ret;
> +	}
> +
> +	flags = val & (BIT(MAX_NUM_INT) - 1);

Or you could use:
	unsigned long expected_irqs, unexpected_irqs;

	expected_irqs = val & GENMASK(g_spi.int - 1, 0);
	unexpected_irq = val & GENMASK(MAX_NUM_INT - 1, g_spi.int);

	for (i = 0; i < g_spi.nint && expected_irqs; i++) {
		if (expected_irqs & BIT(i)) {
			ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
			if (ret) {
				dev_err(...);
				goto _fail_;
			}
		}
	}

	for (i = g_spi.nint; i < MAX_NUM_INT && unexpected_irq; i++) {
		if (unexpected_irqs & BIT(i))
			dev_err(...);

Instead of this:
> +	if (flags) {
> +		int i;
> +
> +		ret = 1;
> +		for (i = 0; i < g_spi.nint; i++) {
> +			/*
> +			 * No matter what you write 1 or 0,
> +			 * it will clear interrupt.
> +			 */> +			if (flags & 1)
> +				ret = wilc_spi_write_reg(wilc,
> +							 0x10c8 + i * 4, 1);
> +			if (!ret)
> +				break;
> +			flags >>= 1;
> +		}
> +		if (!ret) {
> +			dev_err(&spi->dev,
> +				"Failed wilc_spi_write_reg, set reg %x ...\n",
> +				0x10c8 + i * 4);
> +			goto _fail_;
> +		}
> +		for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
> +			if (flags & 1)
>  				dev_err(&spi->dev,
> -					"Failed wilc_spi_write_reg, set reg %x ...\n",
> -					0x10c8 + i * 4);
> -				goto _fail_;
> -			}
> -			for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
> -				if (flags & 1)
> -					dev_err(&spi->dev,
> -						"Unexpected interrupt cleared %d...\n",
> -						i);
> -				flags >>= 1;
> -			}
> +					"Unexpected interrupt cleared %d...\n",
> +					i);
> +			flags >>= 1;
>  		}
> +	}
>  
until here.

> -		{
> -			u32 tbl_ctl;
> -
> -			tbl_ctl = 0;
> -			/* select VMM table 0 */
> -			if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
> -				tbl_ctl |= BIT(0);
> -			/* select VMM table 1 */
> -			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
> -				tbl_ctl |= BIT(1);
> +	tbl_ctl = 0;
> +	/* select VMM table 0 */
> +	if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
> +		tbl_ctl |= BIT(0);
> +	/* select VMM table 1 */
> +	if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
> +		tbl_ctl |= BIT(1);
>  
> -			ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL,
> -						 tbl_ctl);
> -			if (!ret) {
> -				dev_err(&spi->dev,
> -					"fail write reg vmm_tbl_ctl...\n");
> -				goto _fail_;
> -			}
> +	ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL, tbl_ctl);
> +	if (!ret) {
> +		dev_err(&spi->dev, "fail write reg vmm_tbl_ctl...\n");
> +		goto _fail_;
> +	}
>  
> -			if ((val & EN_VMM) == EN_VMM) {
> -				/*
> -				 * enable vmm transfer.
> -				 */
> -				ret = wilc_spi_write_reg(wilc,
> -							 WILC_VMM_CORE_CTL, 1);
> -				if (!ret) {
> -					dev_err(&spi->dev, "fail write reg vmm_core_ctl...\n");
> -					goto _fail_;
> -				}
> -			}
> +	if ((val & EN_VMM) == EN_VMM) {
> +		/*
> +		 * enable vmm transfer.
> +		 */> +		ret = wilc_spi_write_reg(wilc, WILC_VMM_CORE_CTL, 1);
> +		if (!ret) {
> +			dev_err(&spi->dev, "fail write reg vmm_core_ctl...\n");
> +			goto _fail_;
>  		}
>  	}
>  _fail_:
> 
