Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55262 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934948AbeEJLQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:16:08 -0400
Date: Thu, 10 May 2018 13:15:22 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Taketo Kabe <kabe@sra-tohoku.co.jp>, kvalo@codeaurora.org
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/wireless/broadcom/b43: fix transmit
 failure when VT is switched
Message-ID: <20180510131522.0ac08f84@wiggum> (sfid-20180510_131614_671044_CA8BEB80)
In-Reply-To: <5AF41F55.4060606@sra-tohoku.co.jp>
References: <5AF2DE73.20608@sra-tohoku.co.jp>
        <20180509185101.0888bd7a@wiggum>
        <5AF41F55.4060606@sra-tohoku.co.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/FTmWHs5_KOhqxgfNAu9=K/a"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/FTmWHs5_KOhqxgfNAu9=K/a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2018 19:30:45 +0900
Taketo Kabe <kabe@sra-tohoku.co.jp> wrote:

> Signed-off-by: Taketo Kabe <kabe@sra-tohoku.co.jp>
> ---
> diff -up ./drivers/net/wireless/broadcom/b43/dma.c.b43 ./drivers/net/wire=
less/broadcom/b43/dma.c
> --- ./drivers/net/wireless/broadcom/b43/dma.c.b43	2018-05-04 15:18:12.000=
000000 +0900
> +++ ./drivers/net/wireless/broadcom/b43/dma.c	2018-05-10 18:46:36.0000000=
00 +0900
> @@ -1484,7 +1484,7 @@ void b43_dma_handle_txstatus(struct b43_
>   	int slot, firstused;
>   	bool frame_succeed;
>   	int skip;
> -	static u8 err_out1, err_out2;
> +	static u8 err_out1;
>=20
>   	ring =3D parse_cookie(dev, status->cookie, &slot);
>   	if (unlikely(!ring))
> @@ -1518,13 +1518,13 @@ void b43_dma_handle_txstatus(struct b43_
>   			}
>   		} else {
>   			/* More than a single header/data pair were missed.
> -			 * Report this error once.
> +			 * Report this error, and reset the controller to
> +			 * revive operation.
>   			 */
> -			if (!err_out2)
> -				b43dbg(dev->wl,
> -				       "Out of order TX status report on DMA ring %d. Expected %d, b=
ut got %d\n",
> -				       ring->index, firstused, slot);
> -			err_out2 =3D 1;
> +			b43dbg(dev->wl,
> +			       "Out of order TX status report on DMA ring %d. Expected %d, bu=
t got %d\n",
> +			       ring->index, firstused, slot);
> +			b43_controller_restart(dev, "Out of order TX");
>   			return;
>   		}
>   	}


Reviewed-by: Michael B=C3=BCsch <m@bues.ch>

I think this is a good thing to have.
It improves robustness against firmware/DMA misbehavior.

--=20
Michael

--Sig_/FTmWHs5_KOhqxgfNAu9=K/a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr0KcoACgkQ9TK+HZCN
iw74YA/8DXevVlAiXNDWAZEH2t7HPqD/W5Ig1Ud4+4OxyUAT3eTEfUpIc5QudF5Q
X4dLl30LyyycMe4Ne5WTnmfH+Ek0j1huRGMJO36OIdh/5IqZ2+tTOGkrbG8J9NYC
oCDTivu6uRn0cYh2vgrZbyyPEexXSkymiGwBe+E3RG2pBRS69D9Cbemmaemh5bA7
y9BSX0RyJXDXtZ0nhSbqKzuCnnvVi0at+RRJ/O7yo1c9/c9vTZj809hr2aYFhmn2
+22aAzrI45lQV3/Mx0f8TjPvCI35PYJiAI/1vFEB8WsaRLwWamR7zXpSllwfJpBm
Z4wdW/R1tmsD9la1U1DLfvKbP6MuvJvD85hGstKXaw1Fm5qwywgofIG06muflMek
fIcof2J/4gxqq/i6H5dB6Xfd7Oetm8w7xlT8AWu0D78ccf26p3WYRCey4UQndS3b
Irf/BsaywEzYAveqefP0iEBakM1uo/de2fyV7MWp107wjVBZMOduTpvnsw4UeEKu
vnoTYfrSfENfeKhKXBtEiyFcBjjza4IFGxNj0cIe2igMZrCyj/nKRVf40JKw0rh0
u5zo5TlpXWSDkdN4T9kUGLfuHCtFFI3TRsdjQLD3cxL+SmGj7wCQUZJFgdfDHvsW
ofPr8rL0WrdxrnAC8Tcj+ZKM22P9fEpaGzwJunpq//pFVO1Cql8=
=W4+N
-----END PGP SIGNATURE-----

--Sig_/FTmWHs5_KOhqxgfNAu9=K/a--
