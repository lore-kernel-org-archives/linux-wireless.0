Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38849 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387572AbeHPPCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 11:02:41 -0400
Received: by mail-yw1-f67.google.com with SMTP id r3-v6so2943394ywc.5
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2018 05:04:32 -0700 (PDT)
Subject: Re: [DEBUG PATCH] brcmfmac: add firmware watchdog running on host
 machine
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20180815180101.15087-1-zajec5@gmail.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B75684E.9010102@broadcom.com> (sfid-20180816_140436_540612_95B1CC75)
Date: Thu, 16 Aug 2018 14:04:30 +0200
MIME-Version: 1.0
In-Reply-To: <20180815180101.15087-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/15/2018 8:01 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> It may happen for FullMAC firmware to crash. It should be detected and
> ideally somehow handled by a driver.
>
> Since commit ff4445a8502c ("brcmfmac: expose device memory to
> devcoredump subsystem") brcmfmac has BRCMF_E_PSM_WATCHDOG event handler
> but it wasn't enough to detect all kind of crashes. E.g. Netgear R8000
> (BCM4709A0 + 3 x BCM43602) user was exepriencing firmware crashes that
> never resulted in passing BRCMF_E_PSM_WATCHDOG to the host driver.

Thanks, Rafał

The PSM watchdog is actually not a firmware crash. It means the lower 
part of the stack, which runs in the d11 core aka PSM, did not complete 
its work in the required timing budget.

> That made me implement this trivial software watchdog that simply checks
> periodically if firmware still replies to the commands.
>
> Luckily this patch DOES NOT seem to be needed anymore since the commit
> 8a3ab2f38f16 ("brcmfmac: trigger memory dump upon firmware halt
> signal"). That change allows brcmfmac to detect firmware crashes
> successfully.

It can still miss a firmware crash if it happens really soon. Those 
crashes mostly happens when trying to load firmware for chip revision A 
on chip with revision B due to differences in code contained in ROM.

Regards,
Arend

> This patch is being posted for research/debugging purposes only. It
> SHOULD NOT be applied until someone notices a firmware crash that
> doesn't trigger the BRCMF_D2H_DEV_FWHALT signal.
>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
