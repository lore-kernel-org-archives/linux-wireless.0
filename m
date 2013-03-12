Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:4738 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab3CLSkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 14:40:22 -0400
Message-ID: <e96eef3b43e416010faf699295f0e2dc.squirrel@www.infidigm.net> (sfid-20130312_194044_708906_65873EF7)
In-Reply-To: <CADwvPCsk2is8doPmbMuSTNC0CB6Zi_t0Z-D9FUFchiC9e0BZpg@mail.gmail.com>
References: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net>
    <CADwvPCsk2is8doPmbMuSTNC0CB6Zi_t0Z-D9FUFchiC9e0BZpg@mail.gmail.com>
Date: Tue, 12 Mar 2013 15:42:58 -0400
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35
 platform
From: drwho@infidigm.net
To: "Johannes Braun" <jjo.braun@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> struct sdhci_of_data sdhci_esdhc = {
>>         .quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
>>                   SDHCI_QUIRK_BROKEN_CARD_DETECTION |
>>                   SDHCI_QUIRK_NO_BUSY_IRQ |
>>                   SDHCI_QUIRK_NONSTANDARD_CLOCK |
>>                   SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
>>                   SDHCI_QUIRK_PIO_NEEDS_DELAY |
>>                   SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
>>                   SDHCI_QUIRK_NO_CARD_NO_RESET,
>>         .ops = {
>>
>> Jon
>
> I made a test with these quirks enabled. But the result was the same.
> Loading the module also ends in the known error "mmc0: Timeout waiting
> for hardware interrupt".
> I am a little bit confuced. Seems your freescale kernel uses another
> mmc driver for your imx51? My kernel config, the one for imx35
> processors, includes "/drivers/mmc/host/sdhci-esdhc-imx.c" =>
> CONFIG_MMC_SDHCI_ESDHC_IMX and not "drivers/mmc/host/sdhci-of-esdhc.c"

My bad.  Still my driver is different.  The kernel config defines
CONFIG_MMC_IMX_ESDHCI=y which adds
/drivers/mmc/host/mx_sdhci.c
and has a bunch of quirks that are only defined locally.

Are you using a freescale kernel or mainline kernel?  freescale kernels
change from one ltib to the next.  My ltib that supports imx51 may have
had the sdhci driver rewritten since the ltib that first supported imx35.

Jon

