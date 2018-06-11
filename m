Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:39532 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbeFKKzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 06:55:14 -0400
Received: by mail-qk0-f194.google.com with SMTP id g14-v6so12615437qkm.6
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 03:55:13 -0700 (PDT)
Subject: Re: [PATCH V2 2/3] brcmfmac: handle monitor mode marked msgbuf
 packets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180530201301.4648-1-zajec5@gmail.com>
 <20180530201301.4648-2-zajec5@gmail.com>
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
Message-ID: <5B1E550D.7050005@broadcom.com> (sfid-20180611_125518_139947_49A2FCA7)
Date: Mon, 11 Jun 2018 12:55:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180530201301.4648-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/30/2018 10:13 PM, Rafał Miłecki wrote:
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
> V2: Use cpu_to_le16 when setting it_len
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 +++++-
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 +++++++++++++++
>   4 files changed, 48 insertions(+), 1 deletion(-)

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

No sure if I want to expose such detail. I would want a feature flag to 
indicate monitor mode is present, but leave out details on how protocol 
layer like msgbuf passes them to the driver.

> +	BRCMF_FEAT_DEF(MON_FMT_RADIOTAP)

For firmware not passing the packets with radiotap there is some info 
passed, ie. rx status, which the driver can use to fill specific 
radiotap fields. We need to look into that.

Regards,
Arend
