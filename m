Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZEMWJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:09:30 -0400
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
 custom apply
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
	 <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-drtdkudUjAYAq/+dw7WD"
Date: Thu, 14 May 2009 00:08:59 +0200
Message-Id: <1242252539.10076.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-drtdkudUjAYAq/+dw7WD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 17:04 -0400, Luis R. Rodriguez wrote:

>  	queue_regulatory_request(request);
> =20
> +	/*
> +	 * This ensures last_request is populated once modules
> +	 * come swinging in and calling regulatory hints and
> +	 * wiphy_apply_custom_regulatory().
> +	 */
> +	flush_scheduled_work();
> +

Umm, this is a little stupid, first you queue it and then you flush the
workqueue... Why not call the function that runs off the workqueue
directly?

johannes

--=-drtdkudUjAYAq/+dw7WD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0TzAAoJEODzc/N7+QmalmQP/0CL3hFaF3JBD6U5Jh5wtKAc
mdi0m2HTBfvC1cPhC0h2zJQ9OLMAUmqL4ffppPYXWK7EuhL8xjXaixCtqXoQb0Oj
sp7s/PI4zRkHLsEXXNzg4LvU4RAppIefog4VbwaMPGIVh/jK435mjhCvpvjHVqz5
qc64B+E1lrTIQlEQxTGuB9ZqB+57LIoJYDPASnWUHyUROygI9yHguLXk9ONs1PBc
x+C9J7HFqKcA5NpUD0K77nN16ZCa70lZl/+P/eAScDjaby12JWhb5y0oTjRl2E5j
Obtu1QqzarKSCpGm7KzItGmOrb4nRo/x8RxGaA6OOMZJMngumc5vrrVTlpJtyHnn
5gy0YKDfPoViAZxdO2rQymwaDlEc2WCCW7/VLvuf7oSZEqOP75ds85s9EkJHOs0G
IJEcXq3q0T/MaMUGzVBmoL9eVE8dw4DJTrEEghH1zynjkIckPBhrHkq4to9GnpCD
8n5LjzqugAEj+tlr0CaEMo/0IFxaiWYSBHNQGOwh/c+Dgk5ugvlFLZ8SFDWezg7w
wcydCDqEwIKkJFJhrVbcRwScL5Gnjr7fLQS9EqZIq/nAtpXgnPGS0PFkxerVZs6P
lFnWamrh62ctLVAWIpa0VIp7ZlSzK9FSyq3wVGoRbdlrT0aS7dnbZ7OreKGHHgV7
YgIGWX4bwg+4+5eWmqWk
=gsIG
-----END PGP SIGNATURE-----

--=-drtdkudUjAYAq/+dw7WD--

