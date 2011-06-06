Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1FFJZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:25:18 -0400
Received: by wwa36 with SMTP id 36so3585239wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 02:25:17 -0700 (PDT)
Message-ID: <4DEC9CC5.9010700@mvista.com> (sfid-20110606_112524_889108_91FAF135)
Date: Mon, 06 Jun 2011 13:24:21 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com
Subject: Re: [RFC][PATCH 10/10] bcm47xx: fix irq assignment for new SoCs.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <1307311658-15853-11-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1307311658-15853-11-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 06-06-2011 2:07, Hauke Mehrtens wrote:

> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   arch/mips/bcm47xx/irq.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)

> diff --git a/arch/mips/bcm47xx/irq.c b/arch/mips/bcm47xx/irq.c
> index 325757a..3642cee 100644
> --- a/arch/mips/bcm47xx/irq.c
> +++ b/arch/mips/bcm47xx/irq.c
[...]
> @@ -51,5 +52,12 @@ void plat_irq_dispatch(void)
>
>   void __init arch_init_irq(void)
>   {
> +	if (bcm47xx_active_bus_type == BCM47XX_BUS_TYPE_BCMA) {
> +		bcma_write32(bcm47xx_bus.bcma.drv_mips.core,
> +			     BCMA_MIPS_MIPS74K_INTMASK(5), 1<<  31);
> +		/* the kernel reads the timer irq from some register and thinks
> +		 * it's #5, but we offset it by 2 and route to #7 */

    The preferred style for the multi-line comments is this:

/*
  * bla
  * bla
  */

WBR, Sergei
