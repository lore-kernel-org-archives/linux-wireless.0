Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53246 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932278AbeE3UwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 16:52:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id 18-v6so44593997wml.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 13:52:04 -0700 (PDT)
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
Message-ID: <5B0F0EF2.20102@broadcom.com> (sfid-20180530_225214_557596_984D542C)
Date: Wed, 30 May 2018 22:52:02 +0200
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

No just extra research but actual firmware change.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Use cpu_to_le16 when setting it_len
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 +++++-
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 +++++++++++++++
>   4 files changed, 48 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 72954fd6df3b..c9e1f6fcc57b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -21,6 +21,7 @@
>   #include <net/cfg80211.h>
>   #include <net/rtnetlink.h>
>   #include <net/addrconf.h>
> +#include <net/ieee80211_radiotap.h>
>   #include <net/ipv6.h>
>   #include <brcmu_utils.h>
>   #include <brcmu_wifi.h>
> @@ -404,6 +405,29 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
>   		netif_rx_ni(skb);
>   }
>
> +void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
> +{
> +	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MON_FMT_RADIOTAP)) {
> +		/* Do nothing */
> +	} else {
> +		struct ieee80211_radiotap_header *radiotap;
> +
> +		radiotap = skb_push(skb, sizeof(*radiotap));
> +		memset(radiotap, 0, sizeof(*radiotap));
> +		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
> +
> +		/* TODO: what are these extra 4 bytes? */
> +		skb->len -= 4;

This could be dongle memory location holding receive status needed to 
build radiotap header on the host. Will look into this.

> +	}

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

On branch I created for 4366c0 release firmware includes 'monitor' in 
the 'cap' iovar.

> +	BRCMF_FEAT_DEF(MON_FMT_RADIOTAP)

I intend to add this to the 'cap' iovar as well for 4366c0 release if I 
get green light for it. Either 'rtap' or just 'radiotap'.

As it turns out the 'cap' iovar returns worst case (or best if you are a 
sucker for features) a string of 566 characters, but brcmfmac uses 512 
bytes right now. Better increase that to 768 or so.

Regards,
Arend
