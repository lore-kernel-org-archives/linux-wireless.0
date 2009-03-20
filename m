Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZCTKpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:45:24 -0400
Subject: Re: [PATCH v2 4/6] cfg80211: check allowed channel type upon
 userspace requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1237442080-27509-5-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
	 <1237442080-27509-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ucKfFMFeZaX0pQXTLI0A"
Date: Fri, 20 Mar 2009 11:45:18 +0100
Message-Id: <1237545918.5100.146.camel@johannes.local> (sfid-20090320_114526_978276_2FC3F4C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ucKfFMFeZaX0pQXTLI0A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 01:54 -0400, Luis R. Rodriguez wrote:
> Thanks to nl80211 userspace can be verify specific upon device
> configuration. Before processing the request for the new HT40
> channel types (HT40- or HT40+) we need to ensure we can use them
> regulatory-wise. This wasn't required with wireless extensions as
> specifying the channel type wasn't not available and configuration
> was done towards the end implicitly upon association or reception
> of beacons from the AP. For the new nl80211 we have to check this
> when configuring the interfaces explicitly.
>=20

> +		if (channel_type =3D=3D NL80211_CHAN_HT40MINUS &&
> +		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
> +			goto bad_res;
> +		else if (channel_type =3D=3D NL80211_CHAN_HT40PLUS &&
> +			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
> +			goto bad_res;
> +
> +		/*
> +		 * At this point we know if that if HT40 was requested
> +		 * we are allowed to use it and the extension channel
> +		 * exists.
> +		 */
> +
>  		if (channel_type =3D=3D NL80211_CHAN_HT40MINUS)
>  			sec_freq =3D freq - 20;
>  		else if (channel_type =3D=3D NL80211_CHAN_HT40PLUS)

These checks are _already_ there. That's what I mean with duplicate
information ;)

I'm working on a replacement, and it's looking nice so far.

johannes

--=-ucKfFMFeZaX0pQXTLI0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJw3O7AAoJEKVg1VMiehFYiVgQAJ77tiW8RocOjBe0SM0wbiQI
LX/p3Hsauw9Zbz9IVVFROx2BBV5NsToKgfjhHqgF+58SvyHzLfnhAT57KUWTgJfB
zT3L/SjCuutTxcSjBTkC6+G1Cp+vw6DzVm5zqCIyrWqnaQRCWsqb+5bS8KSS6j1H
xKIbNtOeWSto9b8dcKl3natdeMat8E1+3aatYxZDRuwuh0/FOAQ8KICFSp8gvRZ3
jyskhpXvOtHP8xhtJ+1aMkMx65QMiDR6FoVzdMETxS61V5jaKDpycYZYXPTIpvqu
k08zNNcJo/upbEX+lh4uclmLKKt+mrQ2RgjJLEChoCC+9dpEQpJ6wJJHpEkKTz0F
9rup/klZA21WHtxwFgMguqM0qmWSOiE9SqTdB+347Uv8aB+rZoG8pd4tpeLrAgEN
rSpEewq8JKK+7WQU3h+bHYQZtY9KtVIr83jIl9E63XjVNfALtNisq+gO3Xxmxedt
o2pWCI3Ea7fazT97YzTuqsUpJ4bFToKf5EghFGfuh9MdU0a2CHokq/DE6bz/Yklk
+so3rjoTIGshBFDkYOPrglv0xTxJ+qT+AV9xnCxo6s2X+snujQKk9no1caH4gsDj
xR56HrmnKv3wdy2QEs4YRHaCbBb6+PxQ/udqFQdfrUL1tJlSSZuKO0eVxMM8Nx9N
bXb4wVdDPs/n5OzERZRr
=TdtG
-----END PGP SIGNATURE-----

--=-ucKfFMFeZaX0pQXTLI0A--

