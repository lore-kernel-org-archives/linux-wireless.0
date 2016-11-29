Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934002AbcK2Pfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:35:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: add Dell Inspiron 3148
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161128075712.10785-1-jslaby@suse.cz>
References: <20161128075712.10785-1-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Message-Id: <20161129153530.6AF7F6134E@smtp.codeaurora.org> (sfid-20161129_163652_902767_A2928DEB)
Date: Tue, 29 Nov 2016 15:35:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby <jslaby@suse.cz> wrote:
> This is what is in the laptop:
> 01:00.0 Network controller [0280]: Broadcom Limited BCM43142 802.11b/g/n [14e4:4365] (rev 01)
>         Subsystem: Dell Device [1028:0018]
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at b0400000 (64-bit, non-prefetchable) [size=32K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-00-9a-ff-ff-f3-40-b8
>         Capabilities: [16c] Power Budgeting <?>
> 
> With the patch, I can see:
> bcma: bus0: Found chip with id 43142, rev 0x01 and package 0x08
> bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
> bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
> bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x16, class 0x0)
> bcma: bus0: Core 3 found: UNKNOWN (manuf 0x43B, id 0x368, rev 0x00, class 0x0)
> bcma: bus0: Bus registered
> 
> The wifi is not currently supported by brcmsmac yet:
> brcmsmac bcma1:1: mfg 4bf core 812 rev 33 class 0 irq 18
> brcmsmac: unknown device id 4365
> 
> So don't expect a working wifi from this patch :).
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: <linux-wireless@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

59391a96dc73 bcma: add Dell Inspiron 3148

-- 
https://patchwork.kernel.org/patch/9449165/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
