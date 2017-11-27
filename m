Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46450 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdK0VFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 16:05:42 -0500
Received: by mail-wm0-f66.google.com with SMTP id u83so37015260wmb.5
        for <linux-wireless@vger.kernel.org>; Mon, 27 Nov 2017 13:05:41 -0800 (PST)
Subject: Re: [PATCH v1] brcmfmac: Avoid build error with make W=1
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20171123155704.44878-1-andriy.shevchenko@linux.intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cf5fb89e-2a69-207f-a3a4-3ec204eed408@broadcom.com> (sfid-20171127_220551_763630_4AB2777D)
Date: Mon, 27 Nov 2017 22:05:39 +0100
MIME-Version: 1.0
In-Reply-To: <20171123155704.44878-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-11-17 16:57, Andy Shevchenko wrote:
> When I run make W=1 on gcc (Debian 7.2.0-16) 7.2.0 I got an error for
> the first run, all next ones are okay.
> 
>    CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:2078: error: Cannot parse struct or union!
> scripts/Makefile.build:310: recipe for target 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o' failed
> 
> Seems like something happened with W=1 and wrong kernel doc format.
> As a quick fix remove dubious /** in the code.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
