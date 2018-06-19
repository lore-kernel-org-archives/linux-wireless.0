Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40718 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966263AbeFSTfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 15:35:32 -0400
Received: by mail-wm0-f67.google.com with SMTP id n5-v6so2506083wmc.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 12:35:31 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] brcmfmac: handle monitor mode marked msgbuf
 packets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180619154809.25698-1-zajec5@gmail.com>
 <20180619154809.25698-3-zajec5@gmail.com>
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
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B295B01.7060909@broadcom.com> (sfid-20180619_213535_641113_78A1C9F6)
Date: Tue, 19 Jun 2018 21:35:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180619154809.25698-3-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 5:48 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> New Broadcom firmwares mark monitor mode packets using a newly defined
> bit in the flags field. Use it to filter them out and pass to the
> monitor interface. These defines were found in bcmmsgbuf.h from SDK.
>
> As not every firmware generates radiotap header this commit introduces
> BRCMF_FEAT_MONITOR_FMT_RADIOTAP flag. It has to be has based on firmware
> capabilities. If not present brcmf_netif_mon_rx() will assume packet is
> a raw 802.11 frame and will prepend it with an empty radiotap header.
>
> This new code is limited to the msgbuf protocol at this point. Adding
> support for SDIO/USB devices will require some extra work (possibly a
> new firmware release).

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Use cpu_to_le16 when setting it_len
> V3: Update TODO comments
>      Rename flag (after adding MONITOR)
>      Update commit message
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 25 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  4 +++-
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 +++++++++++++++
>   4 files changed, 47 insertions(+), 1 deletion(-)
