Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbeB1Ohr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:37:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: add HP Stream Notebook
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180208162542.20100-1-GNUtoo@no-log.org>
References: <20180208162542.20100-1-GNUtoo@no-log.org>
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Message-Id: <20180228143746.EF77E60272@smtp.codeaurora.org> (sfid-20180228_153815_188301_43DCE7EF)
Date: Wed, 28 Feb 2018 14:37:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Denis 'GNUtoo' Carikli <GNUtoo@no-log.org> wrote:

> In this laptop we have the following PCI device:
> 02:00.0 Network controller [0280]: Broadcom Limited BCM43142 802.11b/g/n [14e4:4365] (rev 01)
> 	Subsystem: Hewlett-Packard Company BCM43142 802.11b/g/n [103c:804a]
> 	[...]
> 	Region 0: Memory at 91000000 (64-bit, non-prefetchable) [size=32K]
> 	[...]
> 
> With this patch, we can now see its WiFi chip:
>   bcma: bus0: Found chip with id 43142, rev 0x01 and package 0x08
>   bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
>   bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
>   bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x16, class 0x0)
>   bcma: bus0: Core 3 found: UNKNOWN (manuf 0x43B, id 0x368, rev 0x00, class 0x0)
>   bcma: bus0: Found rev 15 PMU (capabilities 0x518C5E0F)
>   bcma: bus0: SPROM offset 0x840
>   bcma: bus0: Found SPROM revision 10
>   bcma: bus0: Workarounds unknown or not needed for device 0xA886
>   bcma: bus0: Bus registered
> 
> But it not yet supported by brcmsmac so it won't work for now:
>   brcmsmac bcma0:1: brcms_b_attach wl0: vendor 0x14e4 device 0x4365
>   brcmsmac: unknown device id 4365
> 
> Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>

Patch applied to wireless-drivers-next.git, thanks.

985324a16efb bcma: add HP Stream Notebook

-- 
https://patchwork.kernel.org/patch/10207423/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
