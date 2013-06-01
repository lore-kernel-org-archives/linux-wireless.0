Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60777
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab3FAMCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:02:42 -0400
Date: Sat, 1 Jun 2013 08:02:35 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] cw1200: use module_spi_driver to simplify the code
Message-ID: <20130601120235.GD20362@shaftnet.org> (sfid-20130601_140244_490359_91D4C9F1)
References: <CAPgLHd9e+T7UVET28Xe3RP05s2jVJdLx4TRtw3V635+HnKjnZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
In-Reply-To: <CAPgLHd9e+T7UVET28Xe3RP05s2jVJdLx4TRtw3V635+HnKjnZA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 07:42:54PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> module_spi_driver() makes the code simpler by eliminating
> boilerplate code.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Solomon Peachy <pizza@shaftnet.org>

> ---
>  drivers/net/wireless/cw1200/cw1200_spi.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wirel=
ess/cw1200/cw1200_spi.c
> index 04af685..1e6c58d 100644
> --- a/drivers/net/wireless/cw1200/cw1200_spi.c
> +++ b/drivers/net/wireless/cw1200/cw1200_spi.c
> @@ -464,17 +464,4 @@ static struct spi_driver spi_driver =3D {
>  	},
>  };
> =20
> -/* Init Module function -> Called by insmod */
> -static int __init cw1200_spi_init(void)
> -{
> -	return spi_register_driver(&spi_driver);
> -}
> -
> -/* Called at Driver Unloading */
> -static void __exit cw1200_spi_exit(void)
> -{
> -	spi_unregister_driver(&spi_driver);
> -}
> -
> -module_init(cw1200_spi_init);
> -module_exit(cw1200_spi_exit);
> +module_spi_driver(spi_driver);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (mail/jabber) ^^
Quidquid latine dictum sit, altum viditur.

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqeLbPuLgii2759ARAjFPAJ9m8TzXivskJ4EAhfNRMoY1OZ4A6QCg2H0H
Wq1rMGy6QHUaRt2TQMex9vI=
=yWEn
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
