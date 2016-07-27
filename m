Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34111 "EHLO
	mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbcG0U5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 16:57:11 -0400
Received: by mail-ua0-f179.google.com with SMTP id 35so26085451uap.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2016 13:57:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57991EE9.30005@broadcom.com>
References: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com>
 <57991EE9.30005@broadcom.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 27 Jul 2016 17:57:09 -0300
Message-ID: <CAOMZO5CvuumYQZ92YFCjd7Vrmp4i1T1pdYAmGUvRgjNzVpMWyQ@mail.gmail.com> (sfid-20160727_225714_491802_32DE635C)
Subject: Re: brcm4330 fails to load on newer kernels
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Wed, Jul 27, 2016 at 5:51 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 27-07-16 00:35, Fabio Estevam wrote:
>> Hi,
>>
>> On a imx6sl-warp board with a brcm4330 I get the following results
>> depending on the kernel version:
>>
>> - Kernel 4.4.15: place brcmfmac4330-sdio.bin and brcmfmac4330-sdio.txt
>> in the rootfs and the kernel is able to read them correctly. wlan0 is
>> present. All is fine.
>>
>> - Kernel 4.5.7: place brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt in
>> the rootfs and the kernel fails to load them:
>>
>> brcmfmac mmc1:0001:1: Direct firmware load for
>> brcm/brcmfmac4330-sdio.bin failed with error -2
>>
>> Then I build brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt into the
>> kernel and then firmware is detected and wlan0 appears.
>>
>> - Kernel 4.7: I can place the firmware and nvram file into the rootfs
>> or built-i and the following error is seen:
>>
>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>
>> So wlan0 never appears here.
>>
>> Does anyone have any suggestions about these different behaviours?
>
> So for all kernel you have brcmfmac built-in the kernel or as a module?

In all these tests I have brcmfmac built-in the kernel.

Thanks,

Fabio Estevam
