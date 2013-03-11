Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35240 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKIQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 04:16:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Braun <jjo.braun@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
References: <CADwvPCsGtzDyY4=yjMuX0qha-cdZHdZ-BTAhuwD7jb8pVXYPdw@mail.gmail.com>
	<87txoms6hs.fsf@kamboji.qca.qualcomm.com>
	<CADwvPCvuTWbJ3sHgrzc-dJ+Sc5gdZ26XyAnzT6y92DAyCw161g@mail.gmail.com>
Date: Mon, 11 Mar 2013 10:16:36 +0200
In-Reply-To: <CADwvPCvuTWbJ3sHgrzc-dJ+Sc5gdZ26XyAnzT6y92DAyCw161g@mail.gmail.com>
	(Johannes Braun's message of "Mon, 11 Mar 2013 08:36:56 +0100")
Message-ID: <87fw02e4gr.fsf@kamboji.qca.qualcomm.com> (sfid-20130311_091647_001710_32AD775E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Braun <jjo.braun@gmail.com> writes:

> Hello,
>
>> Is your platform big endian or little endian? I haven't tested ath6kl on
>> a big endian platform so there might be issues.
>
> The arm works in little endian mode. CPU_BIG_ENDIAN is not set in the
> kernel config.

Good, so that's not it.

>> The last two messages make me suspect a hardware problem, but it's
>> difficult to know really.
>>
>> Can you please enable debug messages and send them? Especially these
>> levels are important:
>>
>>         ATH6KL_DBG_SDIO         = BIT(16),
>>         ATH6KL_DBG_SDIO_DUMP    = BIT(17),
>>         ATH6KL_DBG_BOOT         = BIT(18),    /* driver init and fw boot */
>>
>> Or you could just enable everything with debug_mask=0xffffffff.
>
> I am a litte bit confused. The module ath6kl_core and ath6kl_sdio.
> ath6kl_sdio depends on ath6kl_core. When I check the parameters of
> ath6kl_sdio I can`t see the parameter debug_mask. But the core module
> has this parameter. First I loaded ath6kl_core via "modprobe
> ath6kl_core debug_mask=0xffffffff " and afterwards the ath6kl_sdio via
> "modprobe ath6kl_sdio".

This looks correct to me. Can you check from sysfs that the module
parameter is really set:

$ cat /sys/module/ath6kl_core/parameters/debug_mask 
4294967295

> But it seems to have no effect. I can`t see more debug messages as
> before.

That's odd, you should see something like this when you load
ath6kl_sdio:

[  186.426262] ath6kl: sdio new func 1 vendor 0x271 device 0x301 block 0x800/0x200
[  186.426371] ath6kl: ath6kl_sdio_free_bus_req: bus request 0xf35f002c
[  186.426548] ath6kl: ath6kl_sdio_free_bus_req: bus request 0xf35f0050

> I have also enabled all debug parameters in the "Atheros Wireless
> Cards" menu in the kernel config, CONFIG_ATH_DEBUG and
> CONFIG_ATH6KL_DEBUG. Am i doing something wrong?

I can't see anything wrong, but it's Monday morning so I might be
missing something :)

One thing is to double check that CONFIG_ATH6KL_DEBUG is really set and
you are using the correct version of _both_ kernel modules. IIRC ath6kl
has a bug that it doesn't warn if debug_mask is set and
CONFIG_ATH6KL_DEBUG is not set. We should fix that.

>> Also try various quirks in the SDIO controller, if it supports those.
>
> I googled for quirks in combination with my sdio controller. The
> controller is a freescale controller and the driver is implemented in
> /drivers/mmc/host/sdhci-esdhc-imx.c. Currently there are some quirks
> enabled.
>
> 389 static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
> 390         .quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_NO_HISPD_BIT
> 391                         | SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC
> 392                         | SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC
> 393                         | SDHCI_QUIRK_BROKEN_CARD_DETECTION,
> 394         .ops = &sdhci_esdhc_ops,
> 395 };
>
> I will have a looks at the available quirks in
> include/linux/mmc/sdhci.h and try to test various combinations. I have
> to say that I`m not a SDIO expert, and I hope that I have properly
> understood your hint.

This is exactly what I was suggesting.

Can you use any other SDIO device to test if the problem is in ath6kl or
in the SDIO bus?

-- 
Kalle Valo
