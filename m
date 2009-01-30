Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16005 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZA3IDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 03:03:09 -0500
Received: by yx-out-2324.google.com with SMTP id 8so139242yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 00:03:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49824BA0.8060505@openwrt.org>
References: <49824BA0.8060505@openwrt.org>
Date: Fri, 30 Jan 2009 10:03:07 +0200
Message-ID: <40f31dec0901300003v438fe5a5j4ec10de09c677d89@mail.gmail.com> (sfid-20090130_090315_370167_282DEAA9)
Subject: Re: [PATCH] ath5k: properly free rx dma descriptors
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/30 Felix Fietkau <nbd@openwrt.org>:
> When freeing rx dma descriptors, use the right buffer size.
> Fixes kernel oopses on module unload on ixp4xx and most likely
> other platforms as well.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -308,6 +308,19 @@ static inline void ath5k_txbuf_free(stru
>        bf->skb = NULL;
>  }
>
> +static inline void ath5k_rxbuf_free(struct ath5k_softc *sc,
> +                               struct ath5k_buf *bf)
> +{
> +       BUG_ON(!bf);
> +       if (!bf->skb)
> +               return;
> +       pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
> +                       PCI_DMA_FROMDEVICE);
> +       dev_kfree_skb_any(bf->skb);
> +       bf->skb = NULL;
> +}
> +
> +
>  /* Queues setup */
>  static struct  ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
>                                int qtype, int subtype);
> @@ -1341,7 +1354,7 @@ ath5k_desc_free(struct ath5k_softc *sc,
>        list_for_each_entry(bf, &sc->txbuf, list)
>                ath5k_txbuf_free(sc, bf);
>        list_for_each_entry(bf, &sc->rxbuf, list)
> -               ath5k_txbuf_free(sc, bf);
> +               ath5k_rxbuf_free(sc, bf);
>
>        /* Free memory associated with all descriptors */
>        pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
