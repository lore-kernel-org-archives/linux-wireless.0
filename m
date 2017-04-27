Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33139 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161903AbdD0RTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 13:19:39 -0400
Date: Thu, 27 Apr 2017 10:19:37 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com, colin.king@canonical.com,
        wharms@bfs.de
Subject: Re: [PATCH v3] NFC: trf7970a: Correct register settings for 27MHz
 clock
Message-ID: <20170427171937.GA21522@animalcreek.com> (sfid-20170427_192125_955469_7D9637CB)
References: <1493304119-16605-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493304119-16605-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 27, 2017 at 10:41:59AM -0400, Geoff Lansberry wrote:
> In prior commits the selected clock frequency does not propagate
> correctly to what is written the the TRF7970A_MODULATOR_SYS_CLK_CTRL
                               ^^^^^^^
s/the the/to the/

> register.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  drivers/nfc/trf7970a.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 6ed5d7e..f7fee7d 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2067,6 +2067,13 @@ static int trf7970a_probe(struct spi_device *spi)
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
>  	ret = devm_request_threaded_irq(trf->dev, spi->irq, NULL,
>  					trf7970a_irq,
>  					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> -- 
> 2.7.4

With the suggested fix above:

Acked-by: Mark Greer <mgreer@animalcreek.com>
