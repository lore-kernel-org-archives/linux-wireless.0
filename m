Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43710 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1HRHoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 03:44:23 -0400
Received: by gwaa12 with SMTP id a12so730072gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2011 00:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110818T013212-230@post.gmane.org>
References: <1313345797-5441-2-git-send-email-zajec5@gmail.com>
	<loom.20110817T044544-76@post.gmane.org>
	<CACna6ryO9=rwwOMya7RdDohk0p-TOR6O0FU2p6UYnOCzBsHhWg@mail.gmail.com>
	<loom.20110818T013212-230@post.gmane.org>
Date: Thu, 18 Aug 2011 09:44:22 +0200
Message-ID: <CACna6ryOmdwnwsxqN4vhK58GAOnnY74oht3W2AvegL6Zekk4JQ@mail.gmail.com> (sfid-20110818_094426_370789_B0089D0D)
Subject: Re: [PATCH V3 3.2 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?V=C3=ADtor_Ferreira?= <vitor.dominor@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/18 Vítor Ferreira <vitor.dominor@gmail.com>:
>>> Just a side note... Curiously with Intel VT, the b43 driver would start and
> work
>>> for some short time before it crashed, while the wl proprietary driver (from
>>> Broadcom) would not even fully load.
>> I hope you mean DMA errors, not really crashing.
>
> Yes, I mean DMA errors. It just seems it crashed, because it never recovers
> until reboot.
>
>> What you describe here sounds like standard LP-PHY DMA issue resolved
>> in 3.0 kernel. We got some timeouts-related bug, which didn't hit
>> right after loading b43, usually some time (seconds-minutes) later.
>
> Well, lately there wasn't always a timeout after loading b43. Sometimes, the DMA
> error occured only after doing some more network intensive activity, like
> downloading a file or watching a video on the web.
>
>> The last patches are supposed to fix situation where DMA does not work
>> at all. Not even for a second, not for a single packet. I'm really
>> sure of that, unless you have some *really* bugged hardware accepting
>> multiple "translation bits" (something my patches fix).
>> Moreover LP-PHY DMA problems (timeouts issue) was known to be somehow
>> CPU/BIOS-related. Which makes it even more probably that that's
>> exactly what you were experiencing.
>
> Honestly, I wouldn't know. I don't have quite fully understood what is that dma
> translation bug causing the dma fatal errors.
> However, I suspect it might be one of those *really* bugged hardware. I'm just
> guessing, perhaps it has something to do with the DMA features enabled by the
> Intel Virtualization Technology for Directed I/O. It's too much of a coincidence
> that the DMA errors only happen when Intel VT is enabled.
> Just for your reference, this is the system log extract regarding DMA on my
> system.
>
> kernel  [    0.257149] DMAR: Forcing write-buffer flush capability
> kernel  [    0.257150] DMAR: Disabling IOMMU for graphics on this chipset
> kernel  [    0.601514] PCI-DMA: Intel(R) Virtualization Technology for Directed
> I/O
> kernel  [    0.745975] ata1: SATA max UDMA/133 abar m2048@0xdf305000 port
> 0xdf305100 irq 49
> kernel  [    0.745978] ata2: SATA max UDMA/133 abar m2048@0xdf305000 port
> 0xdf305180 irq 49
> kernel  [    0.745983] ata5: SATA max UDMA/133 abar m2048@0xdf305000 port
> 0xdf305300 irq 49
> kernel  [    0.745986] ata6: SATA max UDMA/133 abar m2048@0xdf305000 port
> 0xdf305380 irq 49
> kernel  [    1.206589] ata1.00: ATA-8: FUJITSU MHZ2320BH G2, 8909, max UDMA/100
> kernel  [    1.207251] ata1.00: configured for UDMA/100
> kernel  [    1.682191] ata2.00: ATAPI: TSSTcorp CDDVDW TS-L633L, 0400, max
> UDMA/100
> kernel  [    1.695900] ata2.00: configured for UDMA/100
> kernel  [    2.696557] mmc0: SDHCI controller on PCI [0000:06:00.1] using DMA
> kernel  [   28.902798] DMAR:[DMA Read] Request device [02:00.0] fault addr
> ffff4000
> kernel  [   28.902800] DMAR:[fault reason 06] PTE Read access is not set
> kernel  [   28.902841] b43-phy0 ERROR: Fatal DMA error: 0x00000800, 0x00000000,
> 0x00000000, 0x00000000, 0x00000000, 0x00000000
> kernel  [   28.902846] b43-phy0 ERROR: This device does not support DMA on your
> system. It will now be switched to PIO.
> kernel  [   28.902850] b43-phy0: Controller RESET (DMA error) ...
>
> From lspci, 02:00.0 refers to the Broadcom 4312 wireless card.
>
>> That's the tricky part. Kernel 3.0 should really work for you. Unless
>> Fedora got some problem (mistake?) in compiling/numbering...
>
>> I think the important part was updating to the recent compat-wireless,
>> not applying my patches. If you wish, you can still use that
>> compat-wireless, revert my 2 patches and test again. I suspect card
>> will be still working for you.
>
> I booted back to the kernel 3.0 from fedora, without your patches and any
> compat-wireless. I checked again and the DMA errors really continue in these
> circunstances.
> Then I booted again to my updated 3.0.3.rc1 kernel and I applied the same recent
> compat-wireless without your last patches. Again, the same DMA errors occurred
> after loading b43, as shown in the log above.
> Only after patching the compat-wireless with your last patches and rebooting did
> those DMA errors disappear. So I am afraid the recent (unpatched)
> compat-wireless isn't the solution.

Hm, OK, it really seems you're right, there is something more we
wasn't aware of.

Thanks for your testing :)

-- 
Rafał
