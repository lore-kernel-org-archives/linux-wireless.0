Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f169.google.com ([209.85.210.169]:58000 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLQra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:47:30 -0400
Received: by mail-ia0-f169.google.com with SMTP id j5so42738iaf.14
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 09:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net>
References: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net>
Date: Tue, 12 Mar 2013 17:47:30 +0100
Message-ID: <CADwvPCsk2is8doPmbMuSTNC0CB6Zi_t0Z-D9FUFchiC9e0BZpg@mail.gmail.com> (sfid-20130312_174735_062232_4EE19E2E)
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
From: Johannes Braun <jjo.braun@gmail.com>
To: drwho@infidigm.net, Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm using an AR6103 (AR6003) on the imx51 platform connected via sdio on
> mmc1.  Seems to work good.  I'm using Freescale's patched 2.6.35 kernel
> which comes from their ltib L2.6.35_11.05.01 and compat v3.8.  Here are
> the QUIRKs from drivers/mmc/host/sdhci-of-esdhc.c
>
> struct sdhci_of_data sdhci_esdhc = {
>         .quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
>                   SDHCI_QUIRK_BROKEN_CARD_DETECTION |
>                   SDHCI_QUIRK_NO_BUSY_IRQ |
>                   SDHCI_QUIRK_NONSTANDARD_CLOCK |
>                   SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
>                   SDHCI_QUIRK_PIO_NEEDS_DELAY |
>                   SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
>                   SDHCI_QUIRK_NO_CARD_NO_RESET,
>         .ops = {
>
> Jon

I made a test with these quirks enabled. But the result was the same.
Loading the module also ends in the known error "mmc0: Timeout waiting
for hardware interrupt".
I am a little bit confuced. Seems your freescale kernel uses another
mmc driver for your imx51? My kernel config, the one for imx35
processors, includes "/drivers/mmc/host/sdhci-esdhc-imx.c" =>
CONFIG_MMC_SDHCI_ESDHC_IMX and not "drivers/mmc/host/sdhci-of-esdhc.c"
=> CONFIG_MMC_SDHCI_OF_ESDHC. CONFIG_MMC_SDHCI_OF_ESDHC cant`t be
enabled because CONFIG_PPC_OF is not defined. And I think
CONFIG_PPC_OF is power pc stuff.

"/drivers/mmc/host/Kconfig" file:
[...]
132 config MMC_SDHCI_ESDHC_IMX
133     tristate "SDHCI support for the Freescale eSDHC/uSDHC i.MX controller"
134     depends on ARCH_MXC
135     depends on MMC_SDHCI_PLTFM
136     select MMC_SDHCI_IO_ACCESSORS
137     help
138         This selects the Freescale eSDHC/uSDHC controller support
139          found on i.MX25, i.MX35 i.MX5x and i.MX6x.
140
141         If you have a controller with this interface, say Y or M here.
142
143         If unsure, say N.
[...]
95 config MMC_SDHCI_OF_ESDHC
96     tristate "SDHCI OF support for the Freescale eSDHC controller"
97     depends on MMC_SDHCI_PLTFM
98     depends on PPC_OF
99     select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
100    help
101         This selects the Freescale eSDHC controller support.
102
103         If you have a controller with this interface, say Y or M here.
104
105         If unsure, say N.
[...]

"/drivers/mmc/host/Makefile":
[...]
  obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)       += sdhci-esdhc-imx.o
  obj-$(CONFIG_MMC_SDHCI_DOVE)            += sdhci-dove.o
  obj-$(CONFIG_MMC_SDHCI_TEGRA)           += sdhci-tegra.o
  obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)        += sdhci-of-esdhc.o
[...]

---
Johannes
