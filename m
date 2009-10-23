Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZJWOTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 10:19:32 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20091022133425.317619132@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vsTXzqRy6GdtmTORrFR6"
Date: Fri, 23 Oct 2009 16:19:31 +0200
Message-Id: <1256307572.12174.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vsTXzqRy6GdtmTORrFR6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 15:31 +0200, Holger Schurig wrote:

> +#ifdef CONFIG_LIBERTAS_WEXT
>  	dev->ethtool_ops =3D &lbs_ethtool_ops;
>  	dev->wireless_handlers =3D &lbs_handler_def;
>  #endif

So here you make the wireless_handlers optional.

I still don't understand why you can't just replace only some of the
handlers, i.e. instead of doing this, simply do

-	(iw_handler) lbs_set_freq,      /* SIOCSIWFREQ */
+	(iw_handler) cfg80211_wext_siwfreq,

etc.

That's why those exist and are exported. And that way you don't need the
Kconfig at all, and can remove most of the wext code.

johannes

--=-vsTXzqRy6GdtmTORrFR6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4btuAAoJEODzc/N7+QmadrUQAK7cJnILzuaznx38WompjQ84
W5d8c/EY4lpa/FMlI0SCHjtNkARX8BCPUo0GgyufnMPsQPciU8XhtZ9fppW0IdUF
8UQvV5nfZ9oQuwsg6L4wqphQfrZDY0AR71DQA6BRX5FPYFpqaJ6nqW5YID3YSpXC
N/IWSZXBXRnCL8Q9uZRekq9Oc7ItxrxATg3CX1AVGmCibSF/VEzNSGzlg3nczOtZ
hPNOGRWjO/bLyI2Bj5Umx5My66nzlFsoHp9X1eEcNmaUbJAjTD9mbVuWakHVAhS6
0mJGt3tleJ1UGO/2rHdibsrVKE51PWoPm4xirX14rRHj1yDHZar3v12p+UZWCdK9
y7TXqsX8OI3rLR9K5lzUatFe9HAtCUk8K/bn/enGnWxjTZloOC+qpMrkGRPq9oDF
3KENWcWDz7vb3BunUXbLF8GMjsjYij5RE7V7G3/fIqJ72cemf5q1Go8kJNOjnVWP
9FHW5w77gXFDoaNGCYOk6YZRkeDv36+UoTz8ZuPhViTqMfaOuO5vl07gOcI0b9t8
lbk1eM24OkXL8IpuiaGEny8+JxShDRumQ5xYw4DQeoFVGbfd6mz5Dg+ibRt+Z9aY
xRMqo7MLfs8ayrEC52x0HHQnr//nWvy9F52FtpFIRZmdMXhPfcbtpcnEaezURBvw
z4nuA4TE/YwFbuEhuiXk
=1LIW
-----END PGP SIGNATURE-----

--=-vsTXzqRy6GdtmTORrFR6--

