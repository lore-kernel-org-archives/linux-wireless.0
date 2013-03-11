Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:40982 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3CKHg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 03:36:57 -0400
Received: by mail-ia0-f173.google.com with SMTP id h37so3365147iak.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 00:36:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87txoms6hs.fsf@kamboji.qca.qualcomm.com>
References: <CADwvPCsGtzDyY4=yjMuX0qha-cdZHdZ-BTAhuwD7jb8pVXYPdw@mail.gmail.com>
	<87txoms6hs.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 11 Mar 2013 08:36:56 +0100
Message-ID: <CADwvPCvuTWbJ3sHgrzc-dJ+Sc5gdZ26XyAnzT6y92DAyCw161g@mail.gmail.com> (sfid-20130311_083659_958909_02057B8D)
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
From: Johannes Braun <jjo.braun@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> Is your platform big endian or little endian? I haven't tested ath6kl on
> a big endian platform so there might be issues.

The arm works in little endian mode. CPU_BIG_ENDIAN is not set in the
kernel config.


> The last two messages make me suspect a hardware problem, but it's
> difficult to know really.
>
> Can you please enable debug messages and send them? Especially these
> levels are important:
>
>         ATH6KL_DBG_SDIO         = BIT(16),
>         ATH6KL_DBG_SDIO_DUMP    = BIT(17),
>         ATH6KL_DBG_BOOT         = BIT(18),    /* driver init and fw boot */
>
> Or you could just enable everything with debug_mask=0xffffffff.

I am a litte bit confused. The module ath6kl_core and ath6kl_sdio.
ath6kl_sdio depends on ath6kl_core. When I check the parameters of
ath6kl_sdio I can`t see the parameter debug_mask. But the core module
has this parameter. First I loaded ath6kl_core via "modprobe
ath6kl_core debug_mask=0xffffffff " and afterwards the ath6kl_sdio via
"modprobe ath6kl_sdio". But it seems to have no effect. I can`t see
more debug messages as before. I have also enabled all debug
parameters in the "Atheros Wireless Cards" menu in the kernel config,
CONFIG_ATH_DEBUG and CONFIG_ATH6KL_DEBUG. Am i doing something wrong?


> Also try various quirks in the SDIO controller, if it supports those.

I googled for quirks in combination with my sdio controller. The
controller is a freescale controller and the driver is implemented in
/drivers/mmc/host/sdhci-esdhc-imx.c. Currently there are some quirks
enabled.

389 static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
390         .quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_NO_HISPD_BIT
391                         | SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC
392                         | SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC
393                         | SDHCI_QUIRK_BROKEN_CARD_DETECTION,
394         .ops = &sdhci_esdhc_ops,
395 };

I will have a looks at the available quirks in
include/linux/mmc/sdhci.h and try to test various combinations. I have
to say that I`m not a SDIO expert, and I hope that I have properly
understood your hint.


> For example in some platforms using sdhci people have had to disable DMA
> etc to get SDIO bus reliable.

DMA is completly disabled in the kernel.

Best regards
Johannes

2013/3/8 Kalle Valo <kvalo@qca.qualcomm.com>:
> Hi,
>
> Johannes Braun <jjo.braun@gmail.com> writes:
>
>> in my company we are using a Freescale imx35 based platform with a
>> 3.7.6 Kernel. Currently I am trying to get the Silex SX-SDCAN (AR6003)
>> module up and running on this platform. But I have some trouble. The
>> module is connected via sdio.
>
> Is your platform big endian or little endian? I haven't tested ath6kl on
> a big endian platform so there might be issues.
>
>> My first try was with the ath6kl_sdio driver module of our kernel
>> (vanilla 3.7.6) which ends in the following error:
>> root@generic-armv6:~# modprobe ath6kl_sdio
>> cfg80211: Calling CRDA to update world regulatory domain
>> cfg80211: World regulatory domain updated:
>> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211: Calling CRDA for country: DE
>> cfg80211: Regulatory domain changed to country: DE
>> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> cfg80211:   (2400000 KHz - 2483000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2700 mBm)
>> ath6kl: temporary war to avoid sdio crc error
>> ath6kl: host only supports scatter of :1 entries, need: 16
>> ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
>> ath6kl: abi version mismatch: host(0x1), target(0x0)
>> mmc0: Timeout waiting for hardware interrupt.
>
> The last two messages make me suspect a hardware problem, but it's
> difficult to know really.
>
> Can you please enable debug messages and send them? Especially these
> levels are important:
>
>         ATH6KL_DBG_SDIO         = BIT(16),
>         ATH6KL_DBG_SDIO_DUMP    = BIT(17),
>         ATH6KL_DBG_BOOT         = BIT(18),    /* driver init and fw boot */
>
> Or you could just enable everything with debug_mask=0xffffffff. More
> info here:
>
> http://wireless.kernel.org/en/users/Drivers/ath6kl/Debug
>
> Also try various quirks in the SDIO controller, if it supports those.
> For example in some platforms using sdhci people have had to disable DMA
> etc to get SDIO bus reliable.
>
> --
> Kalle Valo
