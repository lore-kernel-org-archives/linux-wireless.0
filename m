Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51123 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab1F3I1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 04:27:20 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so1995448wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 01:27:19 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC v3 12/13] bcm47xx: add support for bcma bus
Date: Thu, 30 Jun 2011 10:31:30 +0200
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de,
	julian.calaby@gmail.com, sshtylyov@mvista.com
References: <1309385518-12097-1-git-send-email-hauke@hauke-m.de> <1309385518-12097-13-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1309385518-12097-13-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106301031.30524.florian@openwrt.org> (sfid-20110630_102725_610756_C4758B0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 June 2011 00:11:57 Hauke Mehrtens wrote:
> This patch add support for the bcma bus. Broadcom uses only Mips 74K
> CPUs on the new SoC and on the old ons using ssb bus there are no Mips
> 74K CPUs.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  arch/mips/bcm47xx/Kconfig                    |   13 ++++++
>  arch/mips/bcm47xx/gpio.c                     |   22 +++++++++++
>  arch/mips/bcm47xx/nvram.c                    |   10 +++++
>  arch/mips/bcm47xx/serial.c                   |   29 ++++++++++++++
>  arch/mips/bcm47xx/setup.c                    |   53
> +++++++++++++++++++++++++- arch/mips/bcm47xx/time.c                     | 
>   5 ++
>  arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    8 ++++
>  arch/mips/include/asm/mach-bcm47xx/gpio.h    |   41 ++++++++++++++++++++
>  drivers/watchdog/bcm47xx_wdt.c               |   11 +++++
>  9 files changed, 190 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
> index 443d918..85ca1f5 100644
> --- a/arch/mips/bcm47xx/Kconfig
> +++ b/arch/mips/bcm47xx/Kconfig
> @@ -15,4 +15,17 @@ config BCM47XX_SSB
> 
>  	 This will generate an image with support for SSB and MIPS32 R2
> instruction set.
> 
> +config BCM47XX_BCMA
> +	bool "SSB Support for Broadcom BCM47XX"

and "BCMA support for Broadcom BCM47XX" here?
