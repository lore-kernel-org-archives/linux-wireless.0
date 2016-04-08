Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36500 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcDHBjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 21:39:14 -0400
Received: by mail-ob0-f176.google.com with SMTP id j9so64228488obd.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 18:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 8 Apr 2016 11:38:53 +1000
Message-ID: <CAGRGNgUzQmmdPWAOSkj=AC_0UDXkWUKLsJQpqGHT0sQeFXxvQw@mail.gmail.com> (sfid-20160408_033917_463117_EBFA6204)
Subject: Re: [PATCH MOREWORK 14/19] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
To: Andrea Merello <andrea.merello@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Could someone please review this?

On Fri, Mar 18, 2016 at 1:27 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> From: Jia-Ju Bai <baijiaju1990@163.com>
>
> When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
> the memory allocated by pci_zalloc_consistent is not freed.
>
> This patch fixes the bug by adding pci_free_consistent
> in error handling code.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>
> ---
>
> Could someone else please review this?
>
> In particular, immediately after the call to pci_zalloc_coherent(), it
> fails if the result is null or if '(unsigned long)result & 0xFF'.
>
> Is the second arm of the or statement possible, and if so, should we be
> pci_free_coherent()ing the result there too?

And could someone please comment on this? It doesn't seem correct to
me, however I don't know much about PCI / DMA etc.

> I've had a quick scout around and this check seems to be particular to
> realtek drivers.
>
> Thanks,
>
> Julian Calaby
> ---
>  drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> index c76af5d..a8a23d5 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> @@ -1018,6 +1018,8 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
>                 dma_addr_t *mapping;
>                 entry = priv->rx_ring + priv->rx_ring_sz*i;
>                 if (!skb) {
> +                       pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
> +                                       priv->rx_ring, priv->rx_ring_dma);
>                         wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
>                         return -ENOMEM;
>                 }
> @@ -1028,6 +1030,8 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
>
>                 if (pci_dma_mapping_error(priv->pdev, *mapping)) {
>                         kfree_skb(skb);
> +                       pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
> +                                       priv->rx_ring, priv->rx_ring_dma);
>                         wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
>                         return -ENOMEM;
>                 }
> --
> 2.7.0
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
