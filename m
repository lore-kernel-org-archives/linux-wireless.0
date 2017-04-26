Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59017 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751276AbdDZREq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 13:04:46 -0400
Date: Wed, 26 Apr 2017 10:04:43 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>, g@animalcreek.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com
Subject: Re: [PATCH] NFC: trf7970a: Correct register settings for 27MHz clock
Message-ID: <20170426170443.GB11522@animalcreek.com> (sfid-20170426_190604_687954_D4497D21)
References: <1493214513-12245-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493214513-12245-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 26, 2017 at 09:48:33AM -0400, Geoff Lansberry wrote:
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

There is already a patch submitted to fix this issue so no need to fix
it again.  For the record, it should have been in a separate patch
since it fixes a different issue than what is fixed below.

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
>  	if (of_property_read_bool(np, "en2-rf-quirk"))
>  		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;

This part looks okay to me but I like Walter's suggestion too.

Mark
--
