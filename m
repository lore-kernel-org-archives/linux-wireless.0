Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47804 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaIDRpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 13:45:12 -0400
Date: Thu, 4 Sep 2014 13:38:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 2/2] bcma: use separated function to initialize bus on SoC
Message-ID: <20140904173833.GG3467@tuxdriver.com> (sfid-20140904_194535_344342_1BC45862)
References: <1409605867-30051-1-git-send-email-zajec5@gmail.com>
 <1409605867-30051-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1409605867-30051-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2014 at 11:11:07PM +0200, Rafał Miłecki wrote:
> This is required to split SoC bus init into two phases. The later one
> (which includes scanning) should be called when kalloc is available.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: please note this patch touches arch/mips/bcm47xx/setup.c
> 
> This patches is a first step of simplifying MIPS booting process on
> Broadcom SoCs. My research described in:
> > Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
> e-mail thread explained how we could get rid of all these early scanning
> tricks. The main idea is to postpone bus initialization a bit and use
> all standard calls then. So far we were doing it so early we had to
> avoid kalloc.
> ---
>  arch/mips/bcm47xx/setup.c     |  4 ++++
>  drivers/bcma/host_soc.c       | 11 +++++++++--
>  include/linux/bcma/bcma_soc.h |  1 +
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
> index 2b63e7e..fff6ed4 100644
> --- a/arch/mips/bcm47xx/setup.c
> +++ b/arch/mips/bcm47xx/setup.c
> @@ -202,6 +202,10 @@ static void __init bcm47xx_register_bcma(void)
>  
>  	err = bcma_host_soc_register(&bcm47xx_bus.bcma);
>  	if (err)
> +		panic("Failed to register BCMA bus (err %d)", err);
> +
> +	err = bcma_host_soc_init(&bcm47xx_bus.bcma);
> +	if (err)
>  		panic("Failed to initialize BCMA bus (err %d)", err);
>  
>  	bcm47xx_fill_bcma_boardinfo(&bcm47xx_bus.bcma.bus.boardinfo, NULL);

This hunk looks wrong.  Is it missing indentation?  Or should a line
be removed at the top?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
