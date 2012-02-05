Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2BET7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 14:59:36 -0500
Date: Sun, 5 Feb 2012 20:59:24 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	Olof Johansson <olof@lixom.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH 1/3] net: rfkill-gpio: add device tree support
Message-ID: <20120205195924.GA18267@avionic-0098.adnet.avionic-design.de> (sfid-20120205_205939_975394_5817AE30)
References: <215249735783e9fe35db1c594d901f591725de50.1328461986.git.marvin24@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
In-Reply-To: <215249735783e9fe35db1c594d901f591725de50.1328461986.git.marvin24@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Marc Dietrich wrote:
> +#ifdef CONFIG_OF
[...]
> +#else
[...]
> +#define of_rfkill_gpio_match NULL

This can be dropped, see below.

> +#endif
> +
>  static int rfkill_gpio_probe(struct platform_device *pdev)
>  {
>  	struct rfkill_gpio_data *rfkill;
>  	struct rfkill_gpio_platform_data *pdata =3D pdev->dev.platform_data;
> +	struct device_node *np =3D pdev->dev.of_node;
>  	int ret =3D 0;
>  	int len =3D 0;
> =20
> +	if (np)
> +		pdata =3D rfkill_gpio_parse_pdata(pdev);
> +
>  	if (!pdata) {
>  		pr_warn("%s: No platform data specified\n", __func__);
>  		return -EINVAL;
> @@ -210,13 +268,13 @@ static int rfkill_gpio_remove(struct platform_devic=
e *pdev)
> =20
>  	return 0;
>  }
> -

Are you removing this line on purpose?

>  static struct platform_driver rfkill_gpio_driver =3D {
>  	.probe =3D rfkill_gpio_probe,
>  	.remove =3D __devexit_p(rfkill_gpio_remove),
>  	.driver =3D {
>  		   .name =3D "rfkill_gpio",
>  		   .owner =3D THIS_MODULE,
> +		   .of_match_table =3D of_rfkill_gpio_match,

I think the canonical way to do this is of_match_ptr() and leave out the
definition to NULL in the !CONFIG_OF above.

Thierry

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8u35wACgkQZ+BJyKLjJp/p+QCff0z2Od44D8yJlA6ZzBFD0aQZ
YzAAnREqWiOX3+Ul674jviPzY/QgHsdz
=Ij7q
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
