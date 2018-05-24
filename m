Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51158 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032744AbeEXSya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 14:54:30 -0400
Received: by mail-wm0-f67.google.com with SMTP id t11-v6so7951042wmt.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 11:54:30 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 2/3] brcmfmac: handle monitor mode marked msgbuf packets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180522131836.26858-1-zajec5@gmail.com>
 <20180522131836.26858-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <5B070A5D.3080400@broadcom.com> (sfid-20180524_205524_594651_A3E593C9)
Date: Thu, 24 May 2018 20:54:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180522131836.26858-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 3:18 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> New Broadcom firmwares mark monitor mode packets using a newly defined
> bit in the flags field. Use it to filter them out and pass to the
> monitor interface. These defines were found in bcmmsgbuf.h from SDK.
>
> As not every firmware generates radiotap header this commit introduces
> BRCMF_FEAT_MON_FMT_RADIOTAP that has to be set per firmware version. If
> not present brcmf_netif_mon_rx() assumed packet being a raw 802.11 frame
> and prepends it with an empty radiotap header.
>
> It's limited to the msgbuf protocol. Adding support for SDIO/USB devices
> will require some extra research.

So I went looking on my shelf and found the patch I made for SDIO a 
while back. It relies on firmware change and I did not introduce a 
firmware flag for it. I will send the patch as RFT so you can have a 
look at it.

I checked our internal driver and it turns out the raw vs. radiotap is a 
compilation option. So depending on customer they would get either 
firmware doing the radiotap header generation or the host driver, 
without any run-time way to determine it. Not nice for brcmfmac.

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 +++++-
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 +++++++++++++++
>   4 files changed, 48 insertions(+), 1 deletion(-)
>
