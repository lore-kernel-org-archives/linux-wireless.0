Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36596 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbcDYKkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 06:40:07 -0400
Received: by mail-io0-f178.google.com with SMTP id u185so179002750iod.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2016 03:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460367328-12082-8-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
	<1460367328-12082-8-git-send-email-arend@broadcom.com>
Date: Mon, 25 Apr 2016 12:40:05 +0200
Message-ID: <CACna6rwyCkGukoVmTKZ-Bzu+78fo9my9XU184kSwVCnA0WwZ+Q@mail.gmail.com> (sfid-20160425_124012_165108_2E55EA63)
Subject: Re: [PATCH 7/8] brcmfmac: revise handling events in receive path
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2016 at 11:35, Arend van Spriel <arend@broadcom.com> wrote:
> @@ -298,18 +298,11 @@ void brcmf_txflowblock(struct device *dev, bool state)
>         brcmf_fws_bus_blocked(drvr, state);
>  }
>
> -void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
> -                   bool handle_event)
> +void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
>  {
> -       skb->protocol = eth_type_trans(skb, ifp->ndev);

With this change every brcmf_netif_rx caller has to call
eth_type_trans on its own.


> @@ -348,10 +341,17 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
>                 return;
>         }
>
> -       if (brcmf_proto_is_reorder_skb(skb))
> +       skb->protocol = eth_type_trans(skb, ifp->ndev);
> +
> +       if (brcmf_proto_is_reorder_skb(skb)) {
>                 brcmf_proto_rxreorder(ifp, skb);
> -       else
> -               brcmf_netif_rx(ifp, skb, handle_evnt);
> +       } else {
> +               /* Process special event packets */
> +               if (handle_event)
> +                       brcmf_fweh_process_skb(ifp->drvr, skb);
> +
> +               brcmf_netif_rx(ifp, skb);
> +       }
>  }

You added a call to eth_type_trans in brcmf_rx_frame which is used by
USB and SDIO. My guess it you wanted to avoid having duplicated
eth_type_trans call in brcmf_proto_rxreorder.
However you forgot about calling eth_type_trans from
brcmf_msgbuf_process_rx_complete (used by PCI). So to fix this
regression you'll need another call to eth_type_trans anyway.
