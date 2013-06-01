Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60762
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab3FAMCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:02:33 -0400
Date: Sat, 1 Jun 2013 08:02:27 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] cw1200: convert to use simple_open()
Message-ID: <20130601120227.GC20362@shaftnet.org> (sfid-20130601_140236_677501_9790F109)
References: <CAPgLHd_naHj0Y9EsV_XZHBAiBieutbw=+w2Bgn_o0tAuO5DCkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
In-Reply-To: <CAPgLHd_naHj0Y9EsV_XZHBAiBieutbw=+w2Bgn_o0tAuO5DCkw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 07:42:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> This removes an open coded simple_open() function and
> replaces file operations references to the function
> with simple_open() instead.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Solomon Peachy <pizza@shaftnet.org>

> ---
>  drivers/net/wireless/cw1200/debug.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/c=
w1200/debug.c
> index b815181..eb40c9c 100644
> --- a/drivers/net/wireless/cw1200/debug.c
> +++ b/drivers/net/wireless/cw1200/debug.c
> @@ -357,12 +357,6 @@ static const struct file_operations fops_counters =
=3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> -static int cw1200_generic_open(struct inode *inode, struct file *file)
> -{
> -	file->private_data =3D inode->i_private;
> -	return 0;
> -}
> -
>  #ifdef CONFIG_CW1200_ETF
>  static int cw1200_etf_out_show(struct seq_file *seq, void *v)
>  {
> @@ -511,7 +505,7 @@ static ssize_t cw1200_wsm_dumps(struct file *file,
>  }
> =20
>  static const struct file_operations fops_wsm_dumps =3D {
> -	.open =3D cw1200_generic_open,
> +	.open =3D simple_open,
>  	.write =3D cw1200_wsm_dumps,
>  	.llseek =3D default_llseek,
>  };
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

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqeLTPuLgii2759ARAmOXAJ0Z6dB7gnH2WHTprgIUxbPhSJ3A2ACcCIWN
09VZwfW83YwuaDWOe2NHqko=
=3PGB
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
