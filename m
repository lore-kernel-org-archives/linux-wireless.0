Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35207 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdB1Juy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 04:50:54 -0500
Received: by mail-wr0-f173.google.com with SMTP id g10so4951270wrg.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 01:50:53 -0800 (PST)
Subject: Re: [PATCH 4.12] brcmfmac: get rid of brcmf_txflowblock helper
 function
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227120606.15506-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <89be1d04-640e-bd59-77d9-13ddde9979bb@broadcom.com> (sfid-20170228_105423_549117_846BA782)
Date: Tue, 28 Feb 2017 10:50:50 +0100
MIME-Version: 1.0
In-Reply-To: <20170227120606.15506-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-2-2017 13:06, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helper function is pretty trivial and we can easily do without it.
> What's important though it's one of FWS (Firmware Signalling)
> dependencies in core.c. The plan is to make FWS required by BCDC only so
> we don't have to use/compile it when using msgbuf.

This is the same discussion as before. Our driver design really wants to
keep bus-specific code separated from common code. Adding more and more
include statements is breaking that design. Whether or not that
resembles the way other drivers do it is not really a consideration. So
I would rather like to see patches that improve that separation.

I will see if I can publish the design summary on our wiki page.

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 10 ----------
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h |  4 ++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |  7 +++++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      |  7 +++++--
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 2f2f3a5ad86a..59831dc446d6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -283,16 +283,6 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
>  	spin_unlock_irqrestore(&ifp->netif_stop_lock, flags);
>  }
>  
> -void brcmf_txflowblock(struct device *dev, bool state)
> -{
> -	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_pub *drvr = bus_if->drvr;
> -
> -	brcmf_dbg(TRACE, "Enter\n");
> -
> -	brcmf_fws_bus_blocked(drvr, state);
> -}
> -
>  void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
>  {
>  	if (skb->pkt_type == PACKET_MULTICAST)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
> index 96df66073b2a..bb4591c4a14a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
> @@ -18,6 +18,10 @@
>  #ifndef FWSIGNAL_H_
>  #define FWSIGNAL_H_
>  
> +struct brcmf_fws_info;
> +struct brcmf_if;
> +struct brcmf_pub;
> +
>  int brcmf_fws_init(struct brcmf_pub *drvr);
>  void brcmf_fws_deinit(struct brcmf_pub *drvr);
>  bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index c5744b45ec8f..10522edc9750 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -44,6 +44,7 @@
>  #include "firmware.h"
>  #include "core.h"
>  #include "common.h"
> +#include "fwsignal.h"
>  
>  #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
>  #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
> @@ -2272,6 +2273,7 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
>  
>  static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
>  {
> +	struct brcmf_pub *pub = bus->sdiodev->bus_if->drvr;
>  	struct sk_buff *pkt;
>  	struct sk_buff_head pktq;
>  	u32 intstatus = 0;
> @@ -2328,7 +2330,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
>  	if ((bus->sdiodev->state == BRCMF_SDIOD_DATA) &&
>  	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
>  		bus->txoff = false;
> -		brcmf_txflowblock(bus->sdiodev->dev, false);
> +		brcmf_fws_bus_blocked(pub, false);
>  	}
>  
>  	return cnt;
> @@ -2723,6 +2725,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
>  	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
>  	struct brcmf_sdio *bus = sdiodev->bus;
> +	struct brcmf_pub *pub = bus->sdiodev->bus_if->drvr;
>  
>  	brcmf_dbg(TRACE, "Enter: pkt: data %p len %d\n", pkt->data, pkt->len);
>  	if (sdiodev->state != BRCMF_SDIOD_DATA)
> @@ -2753,7 +2756,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
>  
>  	if (pktq_len(&bus->txq) >= TXHI) {
>  		bus->txoff = true;
> -		brcmf_txflowblock(dev, true);
> +		brcmf_fws_bus_blocked(pub, true);
>  	}
>  	spin_unlock_bh(&bus->txq_lock);
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> index d93ebbdc7737..c527aa8a5f8f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -26,6 +26,7 @@
>  #include "bus.h"
>  #include "debug.h"
>  #include "firmware.h"
> +#include "fwsignal.h"
>  #include "usb.h"
>  #include "core.h"
>  #include "common.h"
> @@ -476,6 +477,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
>  {
>  	struct brcmf_usbreq *req = (struct brcmf_usbreq *)urb->context;
>  	struct brcmf_usbdev_info *devinfo = req->devinfo;
> +	struct brcmf_pub *pub = devinfo->bus_pub.bus->drvr;
>  	unsigned long flags;
>  
>  	brcmf_dbg(USB, "Enter, urb->status=%d, skb=%p\n", urb->status,
> @@ -488,7 +490,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
>  	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
>  	if (devinfo->tx_freecount > devinfo->tx_high_watermark &&
>  		devinfo->tx_flowblock) {
> -		brcmf_txflowblock(devinfo->dev, false);
> +		brcmf_fws_bus_blocked(pub, false);
>  		devinfo->tx_flowblock = false;
>  	}
>  	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
> @@ -598,6 +600,7 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
>  static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
>  {
>  	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
> +	struct brcmf_pub *pub = devinfo->bus_pub.bus->drvr;
>  	struct brcmf_usbreq  *req;
>  	int ret;
>  	unsigned long flags;
> @@ -635,7 +638,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
>  	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
>  	if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
>  	    !devinfo->tx_flowblock) {
> -		brcmf_txflowblock(dev, true);
> +		brcmf_fws_bus_blocked(pub, true);
>  		devinfo->tx_flowblock = true;
>  	}
>  	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
> 
