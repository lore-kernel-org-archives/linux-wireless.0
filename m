Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:55906 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdHSUSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:18:13 -0400
Subject: Re: [PATCH 09/34] brcmfmac: Remove noisy debugging.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-10-ian@mnementh.co.uk> <59884E5C.1050007@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <bbe0840d-c847-82b4-17fa-541a720842e6@mnementh.co.uk> (sfid-20170819_221822_230410_39FF47DB)
Date: Sat, 19 Aug 2017 21:18:11 +0100
MIME-Version: 1.0
In-Reply-To: <59884E5C.1050007@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:26, Arend van Spriel wrote:
> 
> Needing this debugging does not necessarily means you are doing
> something wrong. You may be dealing with hardware that is doing
> something wrong and when that happens this debug can be useful. I
> frankly hardly ever enable SDIO debug level unless I am in that
> scenario. Maybe adding a debug level for low-level access would be
> useful to reduce the noise for SDIO debug level.

Perhaps, but its only actually called from a half dozen or so places in
the code + the buscore_*32 entrypoints.

All it actually does now is ensure the address window is right and call
the Linux SDIO core readl method. if we can't trust that, we're kinda
screwed anyway. If we later bring the SDIO code in line with the PCIe
code, it wont even do the address window checking (it'll just assume its
already correct).

We can always enable the SDIO core lowlevel debug if we really want to
see register level acceses.

-Ian
