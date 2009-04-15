Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62886 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZDOMUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:20:11 -0400
Received: by bwz17 with SMTP id 17so2872366bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:20:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239796656-20646-5-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
	 <1239796656-20646-5-git-send-email-me@bobcopeland.com>
Date: Wed, 15 Apr 2009 13:20:09 +0100
Message-ID: <6278d2220904150520x2e385e66s146a3dc95db26e3c@mail.gmail.com> (sfid-20090415_142026_951512_12DB5E38)
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: use rx hw descriptor pointer for
	self-linked check
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On Wed, Apr 15, 2009 at 12:57 PM, Bob Copeland <me@bobcopeland.com> wro=
te:
> This patch simplifies the code used to detect when the
> self-linked DMA buffer is still in use by hardware, by
> checking the hardware's rxdp register instead of looking
> at the software buffer list.

Just an observation: Each synchronous read over PCI will take at
minimum 0.9us to return. Accessing tables in the host's cache
hierarchy/memory will likely be much faster - possibly why it is done
like this already.

Is this a worthwhile tradeoff?

Many thanks,
  Daniel

> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> =A0drivers/net/wireless/ath/ath5k/base.c | =A0 24 ++++---------------=
-----
> =A0drivers/net/wireless/ath/ath5k/base.h | =A0 =A01 -
> =A0drivers/net/wireless/ath/ath5k/dma.c =A0| =A0 =A02 --
> =A03 files changed, 4 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wire=
less/ath/ath5k/base.c
> index 3bde18f..1a6e72f 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1780,7 +1780,7 @@ ath5k_tasklet_rx(unsigned long data)
> =A0 =A0 =A0 =A0struct sk_buff *skb, *next_skb;
> =A0 =A0 =A0 =A0dma_addr_t next_skb_addr;
> =A0 =A0 =A0 =A0struct ath5k_softc *sc =3D (void *)data;
> - =A0 =A0 =A0 struct ath5k_buf *bf, *bf_last;
> + =A0 =A0 =A0 struct ath5k_buf *bf;
> =A0 =A0 =A0 =A0struct ath5k_desc *ds;
> =A0 =A0 =A0 =A0int ret;
> =A0 =A0 =A0 =A0int hdrlen;
> @@ -1791,7 +1791,6 @@ ath5k_tasklet_rx(unsigned long data)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ATH5K_WARN(sc, "empty rx buf pool\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 bf_last =3D list_entry(sc->rxbuf.prev, struct ath5k_buf=
, list);
> =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rxs.flag =3D 0;
>
> @@ -1800,24 +1799,9 @@ ath5k_tasklet_rx(unsigned long data)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0skb =3D bf->skb;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ds =3D bf->desc;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* last buffer must not be freed to e=
nsure proper hardware
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* function. When the hardware finish=
es also a packet next to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* it, we are sure, it doesn't use it=
 anymore and we can go on.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bf_last =3D=3D bf)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bf->flags |=3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bf->flags) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ath5k_buf *bf_ne=
xt =3D list_entry(bf->list.next,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct ath5k_buf, list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sc->ah->ah_proc=
_rx_desc(sc->ah, bf_next->desc,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &rs);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bf->flags &=3D ~1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* skip the overwritten=
 one (even status is martian) */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail if HW is still using self-linke=
d descriptor */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ath5k_hw_get_rxdp(sc->ah) =3D=3D bf=
->daddr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D sc->ah->ah_proc_rx_desc(sc->ah=
, ds, &rs);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(ret =3D=3D -EINPROGRESS))
> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wire=
less/ath/ath5k/base.h
> index 8229561..852b2c1 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -56,7 +56,6 @@
>
> =A0struct ath5k_buf {
> =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0list;
> - =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0flags; =A0/* rx des=
criptor flags */
> =A0 =A0 =A0 =A0struct ath5k_desc =A0 =A0 =A0 *desc; =A0/* virtual add=
r of desc */
> =A0 =A0 =A0 =A0dma_addr_t =A0 =A0 =A0 =A0 =A0 =A0 =A0daddr; =A0/* phy=
sical addr of desc */
> =A0 =A0 =A0 =A0struct sk_buff =A0 =A0 =A0 =A0 =A0*skb; =A0 /* skbuff =
for buf */
> diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wirel=
ess/ath/ath5k/dma.c
> index b65b4fe..941b511 100644
> --- a/drivers/net/wireless/ath/ath5k/dma.c
> +++ b/drivers/net/wireless/ath/ath5k/dma.c
> @@ -80,8 +80,6 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
> =A0* ath5k_hw_get_rxdp - Get RX Descriptor's address
> =A0*
> =A0* @ah: The &struct ath5k_hw
> - *
> - * XXX: Is RXDP read and clear ?
> =A0*/
> =A0u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
> =A0{
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
