Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZCNIal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 04:30:41 -0400
Subject: Re: [PATCH] cfg80211: drop wext channel list if too long
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1236964730.9657.10.camel@localhost.localdomain>
References: <1236882244.25931.5.camel@johannes.local>
	 <20090313145445.GC5551@tuxdriver.com>
	 <1236964730.9657.10.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-seSVlPB7KV7LZeoYM91J"
Date: Sat, 14 Mar 2009 09:30:32 +0100
Message-Id: <1237019432.5235.61.camel@johannes.local> (sfid-20090314_093058_502968_0AE38739)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-seSVlPB7KV7LZeoYM91J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 13:18 -0400, Dan Williams wrote:

> It doesn't look like wpa_supplicant cares about the returned channel
> list from SIOCGIWRANGE.
>=20
> NM, however, uses the returned channel list to figure out a free
> supported adhoc frequency to use when creating an adhoc network (like
> for connection sharing).  If it can't find an intersection between an
> internal "safe" frequency list and what the card supports (which it
> wouldn't be able to with this patch), it will simply use 2462 or 5180
> MHz.
>=20
> Thus, I don't think you'll *break* anything specifically, but this patch
> would cause the default frequency for an IBSS created by NM  to move
> from channel 1 to channel 11.

In that case, let's just drop the patch, I have no problem with that.

We just couldn't figure out why some channels were missing in iwlist
when they were in iw, but that's due to the 32 channel limit. Since most
people probably don't use this particular functionality, I guess it
doesn't really matter. Eventually NM should just use nl80211, or at
least try to, because there it gets more information like "cannot do
IBSS on channel XY", something that wext doesn't give you, but mac80211
enforces.

johannes

--=-seSVlPB7KV7LZeoYM91J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu2slAAoJEKVg1VMiehFYeFcP/0/Z1q6DxJPauKl2fqkW17ip
WFZGES5rHvnbt7VQkXU4ikv81IRIDaKchiWbZjcild4AC/54qNoI1w6cYDd3fjIB
DR07bpR8Lb2H91LMOW/rnsCtdRKhfS4b+JXUlEnv+G8soPspSKo757JcoA8L2Fnh
RoKwQ0YbcNfby6D8IBNvxi1okqpuBlydYw6O/5D4xIu4D9xYVzsxXRx9E64EIOT6
w6FVSjScUu0OFTBGBaEdUKqspbgJtmbRO7qJgK9r7hjm2OZQXJOCLD6Tp6M+RUvs
BxZG7F7w36PvBuEcQBbFyf0yjwV0aaFLI6mIs7lu9lPRytguqO0winkdvuOBhyjT
mOlyiMZapLhx+zj6zg6UC3zNYkFwtNJpw4dvZ+RiNnWVHdTjcKdKjQ6D2ayMXQ9r
WGO+DGERDmeRTKpHgdqax0E09JSpA0ZjgwAciIXP3A+NJbpwmkDGwxtfXPd0GfFI
bxjEycZMFTVRg5vvMZFQzCw0iYgn+zuUNzZXR10WeXwkCZbpHcGHdhXHa01hDn2S
QTjPz9OkBXkV9+VFUVheLyCroC6PYkWBc9TJ2h3e1wurMQsTmWTjFEHQlo7M01BY
WZgZpqWckUdpXZ68sCY69k7PoNAvv4XH8VRCJ8ymVGy7xoJfkZpLKm3ZgBGQeb5a
N2LOtnKqZAtmx4PLwu0A
=AAXl
-----END PGP SIGNATURE-----

--=-seSVlPB7KV7LZeoYM91J--

