Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36474 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbdIEVqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:46:54 -0400
Received: by mail-wm0-f49.google.com with SMTP id i145so23864708wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:46:54 -0700 (PDT)
Subject: Re: [PATCH 30/30] brcmfmac: Reduce the noise from repeatedly
 dereferencing common pointers
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-31-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9a9d7005-e11c-815b-806d-38df0c8a01c2@broadcom.com> (sfid-20170905_234706_014085_A15BDFAB)
Date: Tue, 5 Sep 2017 23:46:51 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-31-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> This introduces no functional changes, but makes the code drastically more
> readable, reducing the amount of dereferencing performed inside functions
> throughout the SDIO core.
> 
> For example, reduce:
> 	sdio_release_host(bus->sdiodev->func1);
> to:
> 	sdio_release_host(func1);

I still have problems with this change. The example above does not 
convince me. I explained my rule of thumb regarding using dereferences 
and will stick to that.

> Fixup a few inconsistently named pointers whilst we are at it ie.
> 
> sdiod -> sdiodev
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 140 +++----
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 406 +++++++++++----------
>   2 files changed, 293 insertions(+), 253 deletions(-)

All I see is 40 more lines to read.

Regards,
Arend
