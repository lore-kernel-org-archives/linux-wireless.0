Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35074 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbcG1ShW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 14:37:22 -0400
Received: by mail-wm0-f48.google.com with SMTP id f65so262880003wmi.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2016 11:37:21 -0700 (PDT)
Subject: Re: brcm4330 fails to load on newer kernels
To: Fabio Estevam <festevam@gmail.com>
References: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com>
 <57991EE9.30005@broadcom.com>
 <CAOMZO5CvuumYQZ92YFCjd7Vrmp4i1T1pdYAmGUvRgjNzVpMWyQ@mail.gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <814ae6d0-2375-e8bd-f3e3-98ec5f69b376@broadcom.com> (sfid-20160728_203726_441494_244D9475)
Date: Thu, 28 Jul 2016 20:37:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CvuumYQZ92YFCjd7Vrmp4i1T1pdYAmGUvRgjNzVpMWyQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-07-16 22:57, Fabio Estevam wrote:
> Hi Arend,
> 
> On Wed, Jul 27, 2016 at 5:51 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 27-07-16 00:35, Fabio Estevam wrote:
>>> Hi,
>>>
>>> On a imx6sl-warp board with a brcm4330 I get the following results
>>> depending on the kernel version:
>>>
>>> - Kernel 4.4.15: place brcmfmac4330-sdio.bin and brcmfmac4330-sdio.txt
>>> in the rootfs and the kernel is able to read them correctly. wlan0 is
>>> present. All is fine.
>>>
>>> - Kernel 4.5.7: place brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt in
>>> the rootfs and the kernel fails to load them:
>>>
>>> brcmfmac mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac4330-sdio.bin failed with error -2
>>>
>>> Then I build brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt into the
>>> kernel and then firmware is detected and wlan0 appears.
>>>
>>> - Kernel 4.7: I can place the firmware and nvram file into the rootfs
>>> or built-i and the following error is seen:
>>>
>>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>> brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>>
>>> So wlan0 never appears here.
>>>
>>> Does anyone have any suggestions about these different behaviours?
>>
>> So for all kernel you have brcmfmac built-in the kernel or as a module?
> 
> In all these tests I have brcmfmac built-in the kernel.

Hi Fabio,

So this is another fine example of firmware API not able to deliver. I
think in all these kernels you have the same issue. The problem is that
the order of events upon kernel boot is not predictable. In this case
you have rootfs being mounted and brcmfmac getting probed as the two
competing events. When rootfs is mounted before brcmfmac is being probed
it works, but if brcmfmac is probed before rootfs is mounted the
firmware request will fail. So the only reliable option for built-in
drivers requiring firmware is to built-in the firmware into the kernel
as well.

Regards,
Arend
