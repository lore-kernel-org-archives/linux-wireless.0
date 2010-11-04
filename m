Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:56529 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0KDPbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 11:31:09 -0400
Date: Thu, 4 Nov 2010 13:30:57 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset
 with 8187B
Message-ID: <20101104153057.GA4610@barata.holoscopio.com>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
 <1288659579-4986-10-git-send-email-herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <1288659579-4986-10-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 01, 2010 at 10:59:39PM -0200, Herton Ronaldo Krzesinski wrote:
> Current 8187B initialization misses anaparam registers restore after
> 8187 reset. This causes ANAPARAM register to stay zeroed out (ANAPARAM2
> kept its value on my tests). To avoid this, call rtl8187_set_anaparam
> right after chip reset (to be on the safe side, as it makes sure we
> restore all ANAPARAM registers).
>=20

Hello, Herton.

Thank you very much for these patches. I am in the process of testing
them right now. The first thing I've noticed is a drop in the signal
level by 10dBm when using this last patch. Is this something we should
be concerned with?

I will do some tests with the distance to the Access Point and send my
results later.

Regards,
Cascardo.

> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: seno <senada@t-online.de>
> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wir=
eless/rtl818x/rtl8187_dev.c
> index 4448647..eeee244 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -771,6 +771,8 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
>  	if (res)
>  		return res;
> =20
> +	rtl8187_set_anaparam(priv, true);
> +
>  	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
>  	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
>  	 * one of the 12 rates, all are enabled */
> --=20
> 1.7.3.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJM0tGwAAoJEEWxSg7udFZIQuwP/ij4C3np+40DT1+H8YrXibto
0w5sTENXaTynzqAAv/lh9F7tNyHQWE14Dj4cHvc2WdPxzvpFYSl6nQDXfcu4Wrdf
k1o61bObDI2utMzt2etXS48GVzW6PE2cxCsY/ttVX7SJfWg4yFL8aWcrPyG31+m1
j6npo52kQJ5aHCsRIobJI5odVlfmawQ5/HzZqgHSzj04KxN5LkstYkMxeItM481X
BTfOdIkDtSGmP1b5p2HcH7YbiWMAenLv1dV0IYOoW/ExQ3XZ91qKaKEQLl/YheGk
lNW2PrCklWWHYIiG4nOugOvhLvd6U2vEh3pZvPeCfYIgpZ+WIu3dE9eSHmqhzYsb
FOaLeS0bjPBXVx5iBlM1eNXABT4s1EkHwRyTqBy4uiFeB2CLRsVVxM4kh/3J1mFa
3jhyVq7iobYo7KgCHQ9dKXnPcdkteBt1MeOxTICalCWnvr7ha2kyMA7jXtq/6CW6
Tt/i88SkKdCvyr6dyje9LfmYV+qiERECwHt+kBIh09ffR002L3V26p76QX1RntfQ
RCJMNouN6+fNhymZcoVwTz6yqQBnLaXQaCOJIgWJH2uTcUg5r/r+bHErwEKpIUAO
gqReurnWJMF9rxUTgl2Ke4aiQHrn2UPqvkqD5zeKdGJCA8ztXjTE0XXJihSEFNYE
8mvet6+YPUcB2fO+VhLS
=Ck6Q
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
