Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:4652 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3001314AbdDZOeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 10:34:50 -0400
Message-ID: <5900AFFE.8060702@bfs.de> (sfid-20170426_163509_644565_26E6611A)
Date: Wed, 26 Apr 2017 16:34:38 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Geoff Lansberry <geoff@kuvee.com>
CC: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com
Subject: Re: [PATCH] NFC: trf7970a: Correct register settings for 27MHz clock
References: <1493214513-12245-1-git-send-email-geoff@kuvee.com>
In-Reply-To: <1493214513-12245-1-git-send-email-geoff@kuvee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 26.04.2017 15:48, schrieb Geoff Lansberry:
> In prior commits the selected clock frequency does not propagate
> correctly to what is written the the TRF7970A_MODULATOR_SYS_CLK_CTRL
> register.
> Also fixes a bug that causes the device tree property check to always
> pass.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  drivers/nfc/trf7970a.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 2d1c8ca..c278b0e 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2071,7 +2071,7 @@ static int trf7970a_probe(struct spi_device *spi)
>  	}
>  
>  	of_property_read_u32(np, "clock-frequency", &clk_freq);
> -	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
> +	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) &&
>  		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
>  		dev_err(trf->dev,
>  			"clock-frequency (%u Hz) unsupported\n",
> @@ -2079,6 +2079,13 @@ static int trf7970a_probe(struct spi_device *spi)
>  		return -EINVAL;
>  	}
>  
> +	if (clk_freq == TRF7970A_27MHZ_CLOCK_FREQUENCY) {
> +		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
> +		dev_dbg(trf->dev, "trf7970a configured for 27MHz crystal\n");
> +	} else {
> +		trf->modulator_sys_clk_ctrl = 0;
> +	}
> +


I am a fan of defensive programming and would move do:
trf->modulator_sys_clk_ctrl = 0;
if (clk_freq == TRF7970A_27MHZ_CLOCK_FREQUENCY) {
		trf->modulator_sys_clk_ctrl = TRF7970A_MODULATOR_27MHZ;
		dev_dbg(trf->dev, "trf7970a configured for 27MHz crystal\n");
	}

perhaps using a switch/case here is appropriate IMHO a border case for 2 case
but would make the init code more clear.

just my 2 cents,

re,
 wh

>  	if (of_property_read_bool(np, "en2-rf-quirk"))
>  		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
>  
