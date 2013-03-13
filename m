Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60253 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3CMNzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 09:55:47 -0400
Received: by mail-ie0-f171.google.com with SMTP id 10so1446937ied.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 06:55:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e96eef3b43e416010faf699295f0e2dc.squirrel@www.infidigm.net>
References: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net>
	<CADwvPCsk2is8doPmbMuSTNC0CB6Zi_t0Z-D9FUFchiC9e0BZpg@mail.gmail.com>
	<e96eef3b43e416010faf699295f0e2dc.squirrel@www.infidigm.net>
Date: Wed, 13 Mar 2013 14:55:46 +0100
Message-ID: <CADwvPCtse3oQFXA6pun6udK2r62sAwCGncWfSMCiF9MF0YYTzg@mail.gmail.com> (sfid-20130313_145555_623962_91C89537)
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
From: Johannes Braun <jjo.braun@gmail.com>
To: drwho@infidigm.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/12  <drwho@infidigm.net>:
>>> struct sdhci_of_data sdhci_esdhc = {
>>>         .quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
>>>                   SDHCI_QUIRK_BROKEN_CARD_DETECTION |
>>>                   SDHCI_QUIRK_NO_BUSY_IRQ |
>>>                   SDHCI_QUIRK_NONSTANDARD_CLOCK |
>>>                   SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
>>>                   SDHCI_QUIRK_PIO_NEEDS_DELAY |
>>>                   SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
>>>                   SDHCI_QUIRK_NO_CARD_NO_RESET,
>>>         .ops = {
>>>
>>> Jon
>>
>> I made a test with these quirks enabled. But the result was the same.
>> Loading the module also ends in the known error "mmc0: Timeout waiting
>> for hardware interrupt".
>> I am a little bit confuced. Seems your freescale kernel uses another
>> mmc driver for your imx51? My kernel config, the one for imx35
>> processors, includes "/drivers/mmc/host/sdhci-esdhc-imx.c" =>
>> CONFIG_MMC_SDHCI_ESDHC_IMX and not "drivers/mmc/host/sdhci-of-esdhc.c"
>
> My bad.  Still my driver is different.  The kernel config defines
> CONFIG_MMC_IMX_ESDHCI=y which adds
> /drivers/mmc/host/mx_sdhci.c
> and has a bunch of quirks that are only defined locally.
>
> Are you using a freescale kernel or mainline kernel?  freescale kernels
> change from one ltib to the next.  My ltib that supports imx51 may have
> had the sdhci driver rewritten since the ltib that first supported imx35.
>

I am using a mainline kernel. I don`t want to use freescale`s ltip,
because the kernel version is very old.

--
Johannes
