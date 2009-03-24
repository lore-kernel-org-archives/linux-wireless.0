Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38706 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZCXAws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 20:52:48 -0400
To: lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, stable@kernel.org,
	fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH v2] ath9k: fix dma mapping leak of rx buffer upon rmmod
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1237847101-30199-1-git-send-email-lrodriguez@atheros.com>
References: <1237847101-30199-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20090324092128A.fujita.tomonori@lab.ntt.co.jp> (sfid-20090324_015251_259985_BF64E438)
Date: Tue, 24 Mar 2009 09:21:28 +0900
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Mar 2009 18:25:01 -0400
"Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:

> We were claiming DMA buffers on the RX tasklet but never
> upon a simple module removal.
> 
> Cc: stable@kernel.org
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> Sorry, forgot to CC stable
> 
>  drivers/net/wireless/ath9k/recv.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
> index 917bac7..71cb18d 100644
> --- a/drivers/net/wireless/ath9k/recv.c
> +++ b/drivers/net/wireless/ath9k/recv.c
> @@ -344,8 +344,13 @@ void ath_rx_cleanup(struct ath_softc *sc)
>  
>  	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
>  		skb = bf->bf_mpdu;
> -		if (skb)
> +		if (skb) {
> +			dma_unmap_single(sc->dev,
> +					 bf->bf_buf_addr,
> +					 sc->rx.bufsize,
> +					 DMA_FROM_DEVICE);
>  			dev_kfree_skb(skb);
> +		}
>  	}

ath9k uses pci_map/unmap_* families so using dma_map/unmap looks
inconsistent. It works though.

I think that my original patch is fine:

http://marc.info/?l=linux-kernel&m=123725029228065&w=2
