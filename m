Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:52722 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdIUH0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 03:26:52 -0400
Received: by mail-qt0-f182.google.com with SMTP id o52so5069762qtc.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 00:26:51 -0700 (PDT)
Subject: Re: AP6335 with mainline kernel
To: Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: embed3d@gmail.com, joerg.krause@embedded.rocks,
        Vanessa Maegima <vanessa.maegima@nxp.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e9fe560a-fba3-aaa8-8c0a-b3c6f5ce1a74@broadcom.com> (sfid-20170921_092656_670525_B585AD57)
Date: Thu, 21 Sep 2017 09:26:47 +0200
MIME-Version: 1.0
In-Reply-To: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-09-17 21:33, Vanessa Ayumi Maegima wrote:
> Hi,
> 
> I am trying to enable Wifi on imx7d-pico using mainline kernel. imx7d-pico
> has an AP6335 chip.
> 
> I am facing some issues related to the nvram file. I am using the firmware
> provided by Buildroot (brcmfmac4339-sdio.bin). I get the following error:
> 
> [    8.630380] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> 
> I have tried to use the firmware and nvram provided by TechNexion but I get
> the same error.
> 
> Is there anyone that could enable Wifi on AP6335 using kernel mainline?
> What nvram file was used?
> 
> I am able to use Wifi on the board if I use the firmware, nvram file and kernel
> provided by TechNexion. They use a 4.1 kernel from NXP with the bcmdhd
> driver.
> 
> So I know that the hardware is functional.
> 
> Any suggestions as how to get it working with a 4.13 and brcmfmac driver is
> appreciated.

So the nvram file is specific to the wifi chipset on your platform so 
best to stick with the provided one. The "HT Avail timeout" most often 
is an indication that the firmware crashed. So getting more debug output 
would help us understand how it ended up like that. Can you build the 
brcmfmac with CONFIG_BRCMDBG and load the driver using:

$ insmod brcmfmac.ko debug=0x1416

Regards,
Arend
> Thanks!
> 
> Regards,
> Vanessa
> 
