Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZDGM55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 08:57:57 -0400
Subject: Re: [PATCH v2 1/5] cfg80211: Process regulatory max bandwidth
 checks for HT40
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1239048958-11775-2-git-send-email-lrodriguez@atheros.com>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	 <1239048958-11775-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-J4bHQ7JsevKueStPqJ8s"
Date: Tue, 07 Apr 2009 12:08:45 +0200
Message-Id: <1239098925.22453.10.camel@johannes.local> (sfid-20090407_145817_139241_6C0470C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J4bHQ7JsevKueStPqJ8s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-06 at 16:15 -0400, Luis R. Rodriguez wrote:

> +static bool is_ht40_not_allowed(struct ieee80211_channel *chan)

I think it would be nicer on the reader to remove the not?

> +{
> +	if (!chan)
> +		return true;
> +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> +		return true;
> +	/* This would happen when regulatory rules disallow HT40 completely */
> +	if (IEEE80211_CHAN_NO_HT40 =3D=3D (chan->flags & (IEEE80211_CHAN_NO_HT4=
0)))
> +		return true;

How would that happen at this point?

/me stops reading.

Ok, whatever, I know I want to rewrite most of this anyway.

johannes

--=-J4bHQ7JsevKueStPqJ8s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2yYqAAoJEKVg1VMiehFYwb8P/0KNLr0aAsx/rUYiYWSeQpm9
eSOd8Frr473mC/C6FNrt2+x5SfeiIJ7BPI2rXOh4kAXTgSYnQzPMZs81PTNtQZ1v
bdRPn2Mts4ZnNFtVRJ8t5Hyz+wJWnqRMMgO9lUhfP1IMDBwk8sCA2fM9ULfOD17g
//CeXAJMDj5KO0zSSmupqYU+bNC1DcxHfYXKaZH8hI5TyTXf3N20eqbglIc2Idih
fhGatzdVepion+Z0FGmk1Nmj04pglR59qx5lrpVDLScebQWqcMPCo9En3cOwpUUd
5dKiEe7s3dwb5ic32ZGzuIu8X+6Je2gH5f2Y9KtNVKeDSEgzA0cGUimatVOq8F0R
Ir6bmXVfnPI1xJEH7iZQEdqWcirRI95XX4Yh7f9fwL/QdEW0B/56uKEgczCZPWRx
CzNLkEG8QJhqydUW49WA48j7NKy+8VYKlWVxrHR5PN89glGl6OeYkvxtB2j95b4/
1hAF53QhKjzbacbutMMoSCmhW90efgE8MDpc8aX1w1IXrY/ShKZ9xFD5wUZ0xXBi
DphS7KpZZvohX2npaugAksqPk8TclY0EpoHejbxWHHtkn20QCn5kGL/skg1pKnkg
vfZ9wRKhDrQjNXt/LT3n6Uu6y2voX9eXQCZtw0iNyqlLV906LsX5j9trCSD6Qz5D
RLRREH+RQ7nqtmytI5nd
=UN+o
-----END PGP SIGNATURE-----

--=-J4bHQ7JsevKueStPqJ8s--

