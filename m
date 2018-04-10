Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:60700 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbeDJQ7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 12:59:25 -0400
Date: Tue, 10 Apr 2018 18:57:56 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Larry.Finger@lwfinger.net, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: b43legacy: Replace GFP_ATOMIC with
 GFP_KERNEL in dma_tx_fragment
Message-ID: <20180410185756.35d4f601@wiggum> (sfid-20180410_185939_128074_21AB5580)
In-Reply-To: <1523368459-32128-1-git-send-email-baijiaju1990@gmail.com>
References: <1523368459-32128-1-git-send-email-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/WVMap.eqQB3oii5eY0bDS=t"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/WVMap.eqQB3oii5eY0bDS=t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2018 21:54:19 +0800
Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> dma_tx_fragment() is never called in atomic context.
>=20
> dma_tx_fragment() is only called by b43legacy_dma_tx(), which is=20
> only called by b43legacy_tx_work().
> b43legacy_tx_work() is only set a parameter of INIT_WORK() in=20
> b43legacy_wireless_init().
>=20
> Despite never getting called from atomic context,
> dma_tx_fragment() calls alloc_skb() with GFP_ATOMIC,
> which does not sleep for allocation.
> GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
> which can sleep and improve the possibility of sucessful allocation.
>=20
> This is found by a static analysis tool named DCNS written by myself.
> And I also manually check it.
>=20
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43legacy/dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/=
wireless/broadcom/b43legacy/dma.c
> index cfa617d..2f0c64c 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/dma.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
> @@ -1064,7 +1064,7 @@ static int dma_tx_fragment(struct b43legacy_dmaring=
 *ring,
>  	meta->dmaaddr =3D map_descbuffer(ring, skb->data, skb->len, 1);
>  	/* create a bounce buffer in zone_dma on mapping failure. */
>  	if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
> -		bounce_skb =3D alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
> +		bounce_skb =3D alloc_skb(skb->len, GFP_KERNEL | GFP_DMA);
>  		if (!bounce_skb) {
>  			ring->current_slot =3D old_top_slot;
>  			ring->used_slots =3D old_used_slots;


Ack.
I think the GFP_ATOMIC came from the days where we did DMA operations
under spinlock instead of mutex.

The same thing can be done in b43.

Also=20
setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC)
could be GFP_KERNEL in dma_rx().
This function is called from IRQ thread context.

--=20
Michael

--Sig_/WVMap.eqQB3oii5eY0bDS=t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlrM7RQACgkQ9TK+HZCN
iw7W1BAAtHAEX2oOYhWd7U+Yt94oXiUeISSBfPl3GIbE5DCx9R4gAUcT9aknAfEC
VOOMmaMDeFbiqsEBfcmWezPOobyBCifS5n+r/IIU8vcTip818LPspmbpOKcTDsLY
XDT27WNEvi0vPBuqbauTza+7V+60ZPoMtA0+FmgE7Wfn1wg1Esi85SfGYyf/b7rL
ZOFofH9rusxLR3pTvpxdN4qg0Umcgv/+tF+diHKsDnrnFnXF9NV3ZRdI+lTz+U31
8hDFqLTBAlssVQkChrferto50bSDl+DVjaeCe+jTchqisb69Ulb0znzJpbEhJVp6
rrTEujZh1vmoc1aCunKH8UTEGzrSMxoMCCIyChSUUKe7XMWNRFtFAVEFjJINMcEU
SwB2d4Mu2bxZPzP2iQROGfLUitA+HRLbNXp3eXqcB5yX/JpyBZYZTGSCtAoOb8M0
5MKdAJ47Cv6rORyySeg2Zv3dgoKeikcDNw+pHoshZsNF/7eobnNYUsGVZKnbk+XY
ITTTxPBzTuKDgDRUicEGLfidcks809Z4rChdXRzy7h/NqIhxFHVH1nIXKUW0QU90
N+mfnEkRgERfKQaKcxUl19ygOiWrOsDDeW8SQKIuM41R5qcWYJDu2qUILztMVqOY
E6fxGqpiwrZxIpiHKlNpzhokfSxmL3tqGGNOFzvt0g7RLod2kik=
=OQBN
-----END PGP SIGNATURE-----

--Sig_/WVMap.eqQB3oii5eY0bDS=t--
