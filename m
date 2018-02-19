Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:11610 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752741AbeBSNdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:33:13 -0500
Subject: Re: [PATCH 02/12] staging: wilc1000: fix too many leading tabs
 warning in sdio_clear_int_ext()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
 <1518793909-15573-3-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <7576dfcf-caab-3b2d-c4bb-e1ea29db2fce@microchip.com> (sfid-20180219_143317_341337_C43A8C42)
Date: Mon, 19 Feb 2018 15:33:09 +0200
MIME-Version: 1.0
In-Reply-To: <1518793909-15573-3-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ajay,

On 16.02.2018 17:11, Ajay Singh wrote:
> Refactor sdio_clear_int_ext() function to remove "Too many leading tabs"
> warning reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 134 +++++++++++++++++------------------
>  1 file changed, 65 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index 6ce9c94..27ec90e 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -871,6 +871,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
>  {
>  	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
>  	int ret;
> +	int vmm_ctl;
>  
>  	if (g_sdio.has_thrpt_enh3) {
>  		u32 reg;
> @@ -909,84 +910,79 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
>  				goto _fail_;
>  			}
>  		}
> -	} else {
> -		if (g_sdio.irq_gpio) {
> -			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
> -			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
> -			u32 flags;
> -
> -			flags = val & (BIT(MAX_NUM_INT) - 1);
> -			if (flags) {
> -				int i;
> -
> -				ret = 1;
> -				for (i = 0; i < g_sdio.nint; i++) {
> -					if (flags & 1) {
> -						struct sdio_cmd52 cmd;
> -
> -						cmd.read_write = 1;
> -						cmd.function = 0;
> -						cmd.raw = 0;
> -						cmd.address = 0xf8;
> -						cmd.data = BIT(i);
> -
> -						ret = wilc_sdio_cmd52(wilc, &cmd);
> -						if (ret) {
> -							dev_err(&func->dev,
> -								"Failed cmd52, set 0xf8 data (%d) ...\n",
> -								__LINE__);
> -							goto _fail_;
> -						}
> +		return 1;
> +	}> +	if (g_sdio.irq_gpio) {

Since you re-factor this, as I suggested in patch:
"[PATCH 6/6] staging: wilc1000: fix line over 80 chars in
wilc_spi_clear_int_ext()" form your previous series:
"fix line over 80 char & coding style in wilc_spi.c",
for code starting here:

> +		/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
> +		/* Cannot clear multiple interrupts. Must clear each interrupt individually */
> +		u32 flags;
> +
> +		flags = val & (BIT(MAX_NUM_INT) - 1);
> +		if (flags) {
> +			int i;
> +
> +			ret = 1;
> +			for (i = 0; i < g_sdio.nint; i++) {
> +				if (flags & 1) {
> +					struct sdio_cmd52 cmd;
> +
> +					cmd.read_write = 1;
> +					cmd.function = 0;
> +					cmd.raw = 0;
> +					cmd.address = 0xf8;
> +					cmd.data = BIT(i);
> +
> +					ret = wilc_sdio_cmd52(wilc, &cmd);
> +					if (ret) {
> +						dev_err(&func->dev,
> +							"Failed cmd52, set 0xf8 data (%d) ...\n",
> +							__LINE__);
> +						goto _fail_;
>  					}
> -					if (!ret)
> -						break;
> -					flags >>= 1;
>  				}
>  				if (!ret)
> -					goto _fail_;
> -				for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
> -					if (flags & 1)
> -						dev_err(&func->dev,
> -							"Unexpected interrupt cleared %d...\n",
> -							i);
> -					flags >>= 1;
> -				}
> +					break;
> +				flags >>= 1;
>  			}
and ending here, further improvements could be done. Since the current series
was accepted, maybe add these to a todo list and review them later?

> -		}
> -
> -		{
> -			u32 vmm_ctl;
> -
> -			vmm_ctl = 0;
> -			/* select VMM table 0 */
> -			if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
> -				vmm_ctl |= BIT(0);
> -			/* select VMM table 1 */
> -			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
> -				vmm_ctl |= BIT(1);
> -			/* enable VMM */
> -			if ((val & EN_VMM) == EN_VMM)
> -				vmm_ctl |= BIT(2);
> -
> -			if (vmm_ctl) {
> -				struct sdio_cmd52 cmd;
> -
> -				cmd.read_write = 1;
> -				cmd.function = 0;
> -				cmd.raw = 0;
> -				cmd.address = 0xf6;
> -				cmd.data = vmm_ctl;
> -				ret = wilc_sdio_cmd52(wilc, &cmd);
> -				if (ret) {
> +			if (!ret)
> +				goto _fail_;
> +			for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
> +				if (flags & 1)
>  					dev_err(&func->dev,
> -						"Failed cmd52, set 0xf6 data (%d) ...\n",
> -						__LINE__);
> -					goto _fail_;
> -				}
> +						"Unexpected interrupt cleared %d...\n",
> +						i);
> +				flags >>= 1;
>  			}
>  		}
>  	}
>  
> +	vmm_ctl = 0;
> +	/* select VMM table 0 */
> +	if ((val & SEL_VMM_TBL0) == SEL_VMM_TBL0)
> +		vmm_ctl |= BIT(0);
> +	/* select VMM table 1 */
> +	if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
> +		vmm_ctl |= BIT(1);
> +	/* enable VMM */
> +	if ((val & EN_VMM) == EN_VMM)
> +		vmm_ctl |= BIT(2);
> +
> +	if (vmm_ctl) {
> +		struct sdio_cmd52 cmd;
> +
> +		cmd.read_write = 1;
> +		cmd.function = 0;
> +		cmd.raw = 0;
> +		cmd.address = 0xf6;
> +		cmd.data = vmm_ctl;
> +		ret = wilc_sdio_cmd52(wilc, &cmd);
> +		if (ret) {
> +			dev_err(&func->dev,
> +				"Failed cmd52, set 0xf6 data (%d) ...\n",
> +				__LINE__);
> +			goto _fail_;
> +		}
> +	}
>  	return 1;
>  _fail_:
>  	return 0;
> 
