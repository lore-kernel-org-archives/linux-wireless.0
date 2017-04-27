Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33085 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966021AbdD0U3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 16:29:07 -0400
Date: Thu, 27 Apr 2017 13:29:05 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: colin.king@canonical.com
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux NFC <linux-nfc@lists.01.org>
Subject: Re: [PATCH] NFC: trf7970a: fix check of clock frequencies, use &&
 instead of ||
Message-ID: <20170427202905.GA8348@animalcreek.com> (sfid-20170427_222917_139889_01F56ABB)
Reply-To: 20170424133603.3697-1-colin.king@canonical.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Colin Ian King <colin.king@canonical.com>

Hi Colin.

[I completely missed this patch and don't have it to directly respond to
 anymore so I probably missed some addresses from the CC list.]

> The "or" condition (clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
> (clk_freq != TRF7970A_13MHZ_CLOCK_FREQUE) will always be true because
> clk_freq cannot be equal to two different values at the same time. Use
> the  && operator instead of || to fix this.
> 
> Detected by CoverityScan, CID#1430468 ("Constant expression result")
> 
> Fixes: 837eb4d21ecde7 ("NFC: trf7970a: add device tree option for 27MHz clock")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/trf7970a.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 2d1c8ca6e679..00eb6cd2b22f 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2071,8 +2071,8 @@ static int trf7970a_probe(struct spi_device *spi)
>  	}
>  
>  	of_property_read_u32(np, "clock-frequency", &clk_freq);
> -	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
> -		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
> +	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) &&
> +		(clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
>  		dev_err(trf->dev,
>  			"clock-frequency (%u Hz) unsupported\n",
>  			clk_freq);

Thanks for catching and fixing this.  Please rebase on the latest
nfc-next/master branch and line up the two conditional lines of the
'if' statement to match other similar instances in the latest version
of the driver.

Thanks,

Mark
--
