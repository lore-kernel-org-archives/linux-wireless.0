Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38067 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHM3a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 08:29:30 -0400
Received: by mail-wm0-f42.google.com with SMTP id m85so5818095wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 05:29:29 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 34/34] brcmfmac: Reduce the noise from repeatedly
 dereferencing common pointers
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-35-ian@mnementh.co.uk>
Message-ID: <3fcfb0c3-7cb3-78f0-bc50-c6b7fa4d5ff4@broadcom.com> (sfid-20170808_142933_507206_CC7E7034)
Date: Tue, 8 Aug 2017 14:29:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-35-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> This introduces no functional changes, but makes the code drastically more
> readable, reducing the amount of dereferencing performed inside functions
> throughout the SDIO core.
> 
> For example, reduce:
> 	sdio_release_host(bus->sdiodev->func1);
> to:
> 	sdio_release_host(func1);
> 
> Fixup a few inconsistently named pointers whilst we are at it ie.
> 
> sdiod -> sdiodev

Last but not least so to speak. I think "drastically" is a bit
overstated. In terms of readability it can go either way at far as I am
concerned. At least the above example does. In terms of instructions it
depends. Both dereferencing and helper variables on stack have their
price. So I (try to) use some soft limits when it comes to
dereferencing. The depth should not be more than 2, ie.:

	bus->sdiodev->func1 is ok, bus->sdiodev->func1->card is not.

The number of dereferences within a particular code path in the function
should not be more than 3.

Also there are some places where you add both func1 and func2 to the
stack, but if you look at it you could do with just one of them.

>From this series I reviewed patches 1 upto and including patch 15, and
patches 29 through 34. Please rework those as requested and resubmit
them. Please also resubmit the remaining patch after that and consider
splitting it up file based. For example below could be a patch series
for chip.c related changes:

$ git log gerrit/brcm-wl-master..HEAD --reverse --oneline --
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
4c75cf9 brcmfmac: Rename SOC_AI to SOC_AXI
acf9f33 brcmfmac: Get rid of chip_priv and core_priv structs
57cef44 brcmfmac: Whitespace patch
fe23a50 brcmfmac: Simplify chip probe routine
89e5bb5 brcmfmac: Rename axi functions for clarity.
a6352d7 brcmfmac: HUGE cleanup of IO access functions.
ee7ea4f brcmfmac: Rename chip.ctx -> chip.bus_priv

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

comments below...

> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 140 +++----
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 409 +++++++++++----------
>  2 files changed, 294 insertions(+), 255 deletions(-)

[...]

>  int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
>  {
> +	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
> +	struct sdio_func *func1 = sdiodev->func1;

Actually only wanted to explicitly mention this one. Probably the
compiler is smart enough to keep sdiodev from the stack, but I would say
it is a variable you do not really need and also in terms of readability
it seems clear enough to do it in one assignment.

>  	int ret;
>  
> -	sdio_claim_host(bus->sdiodev->func1);
> +	sdio_claim_host(func1);
>  	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
> -	sdio_release_host(bus->sdiodev->func1);
> +	sdio_release_host(func1);
>  
>  	return ret;
>  }
> 
