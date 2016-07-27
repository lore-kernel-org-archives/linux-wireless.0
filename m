Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36023 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbcG0Uv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 16:51:57 -0400
Received: by mail-wm0-f54.google.com with SMTP id q128so227214531wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2016 13:51:56 -0700 (PDT)
Subject: Re: brcm4330 fails to load on newer kernels
To: Fabio Estevam <festevam@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
References: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57991EE9.30005@broadcom.com> (sfid-20160727_225201_463120_4D6B4687)
Date: Wed, 27 Jul 2016 22:51:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-07-16 00:35, Fabio Estevam wrote:
> Hi,
> 
> On a imx6sl-warp board with a brcm4330 I get the following results
> depending on the kernel version:
> 
> - Kernel 4.4.15: place brcmfmac4330-sdio.bin and brcmfmac4330-sdio.txt
> in the rootfs and the kernel is able to read them correctly. wlan0 is
> present. All is fine.
> 
> - Kernel 4.5.7: place brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt in
> the rootfs and the kernel fails to load them:
> 
> brcmfmac mmc1:0001:1: Direct firmware load for
> brcm/brcmfmac4330-sdio.bin failed with error -2
> 
> Then I build brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt into the
> kernel and then firmware is detected and wlan0 appears.
> 
> - Kernel 4.7: I can place the firmware and nvram file into the rootfs
> or built-i and the following error is seen:
> 
> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
> 
> So wlan0 never appears here.
> 
> Does anyone have any suggestions about these different behaviours?

So for all kernel you have brcmfmac built-in the kernel or as a module?

Regards,
Arend

> Thanks,
> 
> Fabio Estevam
> 
