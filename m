Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:36014 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdAPJn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 04:43:27 -0500
Received: by mail-pg0-f46.google.com with SMTP id t6so9181402pgt.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 01:43:26 -0800 (PST)
Subject: Re: support for Ampak AP6255 (bcm43455c0 with SDIO device ID 0xa9bf)
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        brcm80211-dev-list.pdl@broadcom.com
References: <CAFBinCDyQqDQ3mS4H0qZCzHs7xYKwxRqvfboU4ibdN0WNmpkQA@mail.gmail.com>
Cc: hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5fa67b79-fd8b-aadb-0215-6f2b37856f9c@broadcom.com> (sfid-20170116_104331_104639_1526DAA3)
Date: Mon, 16 Jan 2017 10:43:22 +0100
MIME-Version: 1.0
In-Reply-To: <CAFBinCDyQqDQ3mS4H0qZCzHs7xYKwxRqvfboU4ibdN0WNmpkQA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-1-2017 0:18, Martin Blumenstingl wrote:
> Hello,
> 
> I recently got a "Khadas VIM Pro" (see [0] for more information)
> The "Pro" version comes with an AP6255 wifi chipset.
> Looking at the vendor firmware this seems to be a bcm43455 device: [1]
> 
> To my surprise brcmfmac from a mainline 4.10-rc3 kernel did not pick
> this device up.
> So I started investigating:
> $ grep "" /sys/class/mmc_host/mmc2/mmc2\:0001/mmc2\:0001\:*/{class,device,vendor}
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/class:0x00
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/class:0x00
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/class:0x02
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/device:0xa9bf
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/device:0xa9bf
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/device:0xa9bf
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/vendor:0x02d0
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/vendor:0x02d0
> /sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/vendor:0x02d0
> 
> I then went ahead and added the device ID to
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c (sample
> patch attached)
> as a result of that the device is now being detected.
> it boots fine with the firmware found in linux-firmware: [2] (plus the
> nvram.txt from the vendor repo [1] renamed to brcmfmac43455-sdio.txt)
> 
> $ cat /sys/kernel/debug/brcmfmac/mmc2\:0001\:1/revinfo
> vendorid: 0x14e4
> deviceid: 0x43ab
> radiorev: 0.88.3.11
> chipnum: 17221 (4345)
> chiprev: 6
> chippkg: 2
> corerev: 54
> boardid: 0x06e4
> boardvendor: 0x14e4
> boardrev: P304
> driverrev: 7.45.18
> ucoderev: 0
> bus: 0
> phytype: 11
> phyrev: 20
> anarev: 0
> nvramrev: 00079ac5
> 
> downloading a random 100MB file from the internet using curl confirms this.
> There are no hangs, connection drops, other devices are also working fine.
> 
> the problem I'm facing is very simply (but unfortunately a very common
> development problem): naming things (the SDIO_DEVICE_ID_BROADCOM_TODO
> constant)!
> there's already a definition for SDIO_DEVICE_ID_BROADCOM_4345 with
> value 0x4345, does that mean 0xa9bf should be
> SDIO_DEVICE_ID_BROADCOM_43455?

Yup. That seems a good name to me.

Regards,
Arend

> Regards,
> Martin
> 
> 
> [0] http://khadas.com/vim/
> [1] https://github.com/khadas/android_hardware_amlogic_wifi/tree/b6709758755568e4a0ff6e80993be0fc64c77fb9/bcm_ampak/config/6255
> [2] https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/brcm/brcmfmac43455-sdio.bin?id=b9a38d041d38ac6cf47274e9933f8083e12fc601
> 
