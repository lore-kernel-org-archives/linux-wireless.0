Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34348 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428509AbdDYNSx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 09:18:53 -0400
Received: by mail-io0-f177.google.com with SMTP id a103so213893157ioj.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 06:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424133603.3697-1-colin.king@canonical.com>
References: <20170424133603.3697-1-colin.king@canonical.com>
From: Geoff Lansberry <geoff@kuvee.com>
Date: Tue, 25 Apr 2017 09:18:12 -0400
Message-ID: <CAO7Z3WL=iE++iJ5uGyrk3erG1U1OucH7csvWxdtw3eUqq3ca1A@mail.gmail.com> (sfid-20170425_151939_500727_3A4C1A64)
Subject: Re: [PATCH] NFC: trf7970a: fix check of clock frequencies, use &&
 instead of ||
To: Colin King <colin.king@canonical.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 24, 2017 at 9:36 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
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
>         }
>
>         of_property_read_u32(np, "clock-frequency", &clk_freq);
> -       if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
> -               (clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
> +       if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) &&
> +               (clk_freq != TRF7970A_13MHZ_CLOCK_FREQUENCY)) {
>                 dev_err(trf->dev,
>                         "clock-frequency (%u Hz) unsupported\n",
>                         clk_freq);
> --
> 2.11.0
>
Nice catch.

Acked-by: Geoff Lansberry <geoff@kuvee.com>
