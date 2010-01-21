Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab0AUJod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 04:44:33 -0500
Subject: Re: RFC/RFT: compat-wireless for 2.6.32.4 - MQ backport support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100121025546.GB8069@bombadil.infradead.org>
References: <20100121025546.GB8069@bombadil.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-brixbLz7KqXtLgLyIJ5/"
Date: Thu, 21 Jan 2010 10:44:29 +0100
Message-ID: <1264067069.11396.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-brixbLz7KqXtLgLyIJ5/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 21:55 -0500, Luis R. Rodriguez wrote:

> @@ -287,7 +287,13 @@
> =20
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27))
>  		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
> +#elif (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,23))
> +		netif_start_subqueue(sdata->dev, queue);
> +#else
> +		netif_wake_queue(sdata->dev);
> +#endif

That's incorrect, you need to check for all hardware queues being awake.

johannes

--=-brixbLz7KqXtLgLyIJ5/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWCH6AAoJEODzc/N7+QmadfMP/R9FoEsgQY2/Qh9o4QEAXrFQ
ZdV6qNOd9Ka3DAadhFA2DgATp+aP1ECtqt4NgeAueb2SyHlL/NJzEMJbxLbmSvUS
PY3MVkKhLnPVQqYbOyv+su0ocLJkr32dGSgx3vPc3A4bvNwod2DjO6n4mhpc4G7W
AS5FPUy1W7C6HZ9fAkY02snrAQXht2e+8GmTU0lx089ktJL3Wu0r2Ke2DZtUdRlL
HtrOTf3nVKauGDlzFiN2mkNgrU1SM1rdvo0SNa+hkRcnxHWPTN4X/PmtLg2MzWJs
5fKNSmSEj6lMHZruR2BsbuY/IVc+p763/an5oUQqnNNE0OkXD3H4aWxi6HVGabuD
XzIZP5/sEgGs2f3LWqKqhAROjXU9ra6drFYIMduKiAZUmG0aedVG2mz3Pkrk9YnH
aeNJmRLfKnsjErMaFxajcFlLB66UWM8e2rLrYpjnimBaD6aWMXeksNfl6EaDbPw1
qsJe9+fYLHL+qYXBoHEnCqgB34vR9ZKEqgPbFmU4uCwrOgPBufeCpp6sM7Q2Oexv
vTXRuMK0PMcuRHP33oDuQUHyZBI/UWlEjSAglmskBo22xVW5NT0MFxKlxdqlVI99
H9Ta6K9HvPlBmlOnl1hIwdTCGSaU/7aPNGjIvFymGjIAe2SJQ7jydc8ejuhfIx/7
w+RlaeLu3CxXEGwsjvPC
=e6wC
-----END PGP SIGNATURE-----

--=-brixbLz7KqXtLgLyIJ5/--

