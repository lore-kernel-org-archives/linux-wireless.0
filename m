Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39472 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbeE3KMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 06:12:21 -0400
Received: by mail-wm0-f67.google.com with SMTP id f8-v6so46716500wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 03:12:20 -0700 (PDT)
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
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0E7902.1030809@broadcom.com> (sfid-20180530_121225_435151_7B8FFBEC)
Date: Wed, 30 May 2018 12:12:18 +0200
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
>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 +++++-
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 +++++++++++++++
>   4 files changed, 48 insertions(+), 1 deletion(-)
>

[snip]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> index d1193825e559..6e417d104b7f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
> @@ -33,6 +33,8 @@
>    * MFP: 802.11w Management Frame Protection.
>    * GSCAN: enhanced scan offload feature.
>    * FWSUP: Firmware supplicant.
> + * MON_802_11_FLAG: monitor packets flagged as 802.11
> + * MON_FMT_RADIOTAP: monitor packets include radiotap header

Hi Rafał,

I am preparing the 4366c0 release. Can you tell me which firmwares that 
you have provide 802.11 packets and/or radiotap+802.11? Doing 'strings 
fwfile | tail -1' should give me the necessary info.

Regards,
Arend

>    */
>   #define BRCMF_FEAT_LIST \
>   	BRCMF_FEAT_DEF(MBSS) \
> @@ -48,7 +50,9 @@
>   	BRCMF_FEAT_DEF(WOWL_ARP_ND) \
>   	BRCMF_FEAT_DEF(MFP) \
>   	BRCMF_FEAT_DEF(GSCAN) \
> -	BRCMF_FEAT_DEF(FWSUP)
> +	BRCMF_FEAT_DEF(FWSUP) \
> +	BRCMF_FEAT_DEF(MON_802_11_FLAG) \
> +	BRCMF_FEAT_DEF(MON_FMT_RADIOTAP)
