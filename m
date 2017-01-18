Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36703 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdARI7C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 03:59:02 -0500
Received: by mail-pf0-f169.google.com with SMTP id 189so2903032pfu.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 00:59:02 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: move function declarations to proper
 headers
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170117163419.1184-1-zajec5@gmail.com>
 <20170117163419.1184-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d1aca4b7-3493-5935-befb-af1b2dadc7d1@broadcom.com> (sfid-20170118_095905_577928_1D5C4C11)
Date: Wed, 18 Jan 2017 09:58:56 +0100
MIME-Version: 1.0
In-Reply-To: <20170117163419.1184-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-1-2017 17:34, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Function brcmf_c_set_joinpref_default is in common.c, so move it to the
> related header. All other (touched) ones are in core.c so take them out
> of the bus.h.
> I just needed to include bus.h to have enum brcmf_bus_state defined.

I prefer to keep the bus api in separate include file so please leave
those. That leaves the move of brcmf_c_set_joinpref_default(). Please
send a v2 and consider it acked by me.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 28 ----------------------
>  .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    | 21 +++++++++++++++-
>  3 files changed, 22 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index b5bb971..58a3de6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -214,34 +214,6 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
>  	return bus->ops->get_memdump(bus->dev, data, len);
>  }
>  
> -/*
> - * interface functions from common layer
> - */
> -
> -/* Receive frame for delivery to OS.  Callee disposes of rxp. */
> -void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
> -/* Receive async event packet from firmware. Callee disposes of rxp. */
> -void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
> -
> -/* Indication from bus module regarding presence/insertion of dongle. */
> -int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings);
> -/* Indication from bus module regarding removal/absence of dongle */
> -void brcmf_detach(struct device *dev);
> -/* Indication from bus module that dongle should be reset */
> -void brcmf_dev_reset(struct device *dev);
> -/* Indication from bus module to change flow-control state */
> -void brcmf_txflowblock(struct device *dev, bool state);
> -
> -/* Notify the bus has transferred the tx packet to firmware */
> -void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
> -
> -/* Configure the "global" bus state used by upper layers */
> -void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
> -
> -int brcmf_bus_start(struct device *dev);
> -s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
> -void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
> -
>  #ifdef CONFIG_BRCMFMAC_SDIO
>  void brcmf_sdio_exit(void);
>  void brcmf_sdio_register(void);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index bd095ab..a62f8e7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -65,6 +65,8 @@ struct brcmf_mp_device {
>  	} bus;
>  };
>  
> +void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
> +
>  struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
>  					       enum brcmf_bus_type bus_type,
>  					       u32 chip, u32 chiprev);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> index c94dcab..d92beca 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> @@ -22,6 +22,7 @@
>  #define BRCMFMAC_CORE_H
>  
>  #include <net/cfg80211.h>
> +#include "bus.h"
>  #include "fweh.h"
>  
>  #define TOE_TX_CSUM_OL		0x00000001
> @@ -213,10 +214,28 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
>  void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
>  void brcmf_txflowblock_if(struct brcmf_if *ifp,
>  			  enum brcmf_netif_stop_reason reason, bool state);
> +/* Indication from bus module to change flow-control state */
> +void brcmf_txflowblock(struct device *dev, bool state);
>  void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
>  void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
> +/* Receive frame for delivery to OS.  Callee disposes of rxp. */
> +void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
> +/* Receive async event packet from firmware. Callee disposes of rxp. */
> +void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
> +/* Notify the bus has transferred the tx packet to firmware */
> +void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
>  void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
> -void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
> +/* Indication from bus module regarding presence/insertion of dongle. */
> +int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings);
> +int brcmf_bus_start(struct device *dev);
> +void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
> +/* Indication from bus module that dongle should be reset */
> +void brcmf_dev_reset(struct device *dev);
> +/* Indication from bus module regarding removal/absence of dongle */
> +void brcmf_detach(struct device *dev);
> +s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
> +/* Configure the "global" bus state used by upper layers */
> +void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
>  int __init brcmf_core_init(void);
>  void __exit brcmf_core_exit(void);
>  
> 
