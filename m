Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33189 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdARI4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 03:56:33 -0500
Received: by mail-pg0-f43.google.com with SMTP id 204so3077487pge.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 00:56:32 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: drop unneeded function declarations from
 headers
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170117163419.1184-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <69bf3e19-67a3-c5ad-aca4-62ae6b475210@broadcom.com> (sfid-20170118_095636_800296_D0371E47)
Date: Wed, 18 Jan 2017 09:56:25 +0100
MIME-Version: 1.0
In-Reply-To: <20170117163419.1184-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-1-2017 17:34, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Functions brcmf_c_prec_enq and brcmf_sdio_init don't exist so we
> really don't need their declarations. Function brcmf_parse_tlvs is used
> in cfg80211.c only so make it static and drop from header as well.

brcmf_c_prec_enq has been long gone (3.18 or so). Thanks for the cleanup.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h      | 4 ----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 2 --
>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index e21f760..b5bb971 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -218,9 +218,6 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
>   * interface functions from common layer
>   */
>  
> -bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
> -		      int prec);
> -
>  /* Receive frame for delivery to OS.  Callee disposes of rxp. */
>  void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
>  /* Receive async event packet from firmware. Callee disposes of rxp. */
> @@ -247,7 +244,6 @@ void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
>  
>  #ifdef CONFIG_BRCMFMAC_SDIO
>  void brcmf_sdio_exit(void);
> -void brcmf_sdio_init(void);
>  void brcmf_sdio_register(void);
>  #endif
>  #ifdef CONFIG_BRCMFMAC_USB
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 729bf33..ec1171c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -326,7 +326,7 @@ u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
>   * triples, returning a pointer to the substring whose first element
>   * matches tag
>   */
> -const struct brcmf_tlv *
> +static const struct brcmf_tlv *
>  brcmf_parse_tlvs(const void *buf, int buflen, uint key)
>  {
>  	const struct brcmf_tlv *elt = buf;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> index 0c9a708..8f19d95 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> @@ -396,8 +396,6 @@ void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
>  s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
>  			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
>  s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif);
> -const struct brcmf_tlv *
> -brcmf_parse_tlvs(const void *buf, int buflen, uint key);
>  u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
>  			struct ieee80211_channel *ch);
>  bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg,
> 
