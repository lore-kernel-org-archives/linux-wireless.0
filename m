Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:43714 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932634AbeEHQrR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 12:47:17 -0400
Message-ID: <66e8c88e49abb14a5a3b67ff074e7d5e54a0b461.camel@perches.com> (sfid-20180508_184720_641419_1E84E5DF)
Subject: Re: [PATCH 4.17] bcma: fix buffer size caused crash in
 bcma_core_mips_print_irq()
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Tue, 08 May 2018 09:47:13 -0700
In-Reply-To: <20180508093104.27018-1-zajec5@gmail.com>
References: <20180508093104.27018-1-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-08 at 11:31 +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Used buffer wasn't big enough to hold whole strings. Example output of
> this function is:
> [    0.180892] bcma: bus0: core 0x0800, irq: 2(S)* 3  4  5  6  D  I
> [    0.180948] bcma: bus0: core 0x0812, irq: 2(S)  3* 4  5  6  D  I
> [    0.180998] bcma: bus0: core 0x082d, irq: 2(S)  3  4* 5  6  D  I
> [    0.181046] bcma: bus0: core 0x082c, irq: 2(S)  3  4  5  6  D  I*
> which means we need to store up to 24 chars.
> 
> Fixes: 758f7e06063a8 ("bcma: Use bcma_debug and not pr_cont in MIPS driver")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Cc: stable@vger.kernel.org # v4.15+

Oops.  Apologies for not counting properly.

> ---
>  drivers/bcma/driver_mips.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> index f040aba48d50..27e9686b6d3a 100644
> --- a/drivers/bcma/driver_mips.c
> +++ b/drivers/bcma/driver_mips.c
> @@ -184,7 +184,7 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
>  {
>  	int i;
>  	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
> -	char interrupts[20];
> +	char interrupts[25];
>  	char *ints = interrupts;
>  
>  	for (i = 0; i < ARRAY_SIZE(irq_name); i++)
