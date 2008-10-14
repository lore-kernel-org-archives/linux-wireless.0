Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYJNNUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 09:20:18 -0400
Subject: Re: Problem with "mac80211: free up 2 bytes in skb->cb"
From: Johannes Berg <johannes@sipsolutions.net>
To: "Stephen Blackheath [to Rt2400-devel]"
	<tramp.enshrine.stephen@blacksapphire.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Martel <benm@symmetric.co.nz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48F416A3.3060205@blacksapphire.com>
References: <48F416A3.3060205@blacksapphire.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H9RKTkZfnUJBY6hXo6xe"
Date: Tue, 14 Oct 2008 15:19:24 +0200
Message-Id: <1223990364.10113.28.camel@johannes.berg> (sfid-20081014_152023_769806_681D94C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H9RKTkZfnUJBY6hXo6xe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 16:48 +1300, Stephen Blackheath [to Rt2400-devel]
wrote:
> Felix & John,
>=20
> This patch definitely breaks wifi on the rt73usb.
>=20
> The symptom is that all connection negotiation works, rx works, but=20
> transmitted packets are garbage and are not received at the remote end.=20
>   Tested in AP mode using hostapd and WPA encryption.  Also observed in=20
> managed mode with WEP encryption, but in this case, it wasn't 100%=20
> confirmed to be your patch.
>=20
> The problem goes away completely with this option:
>=20
> modprobe rt73usb nohwcrypt=3D1
>=20
> ...which disables hardware encryption.
>=20
> I don't know the exact reason, and I perhaps the bug is in rt73usb.

Yeah, the hw_key pointer is used (and obviously NULL) after skb->cb is
memset to 0, that is a bug in that patch, Felix will post a fix.

johannes

--=-H9RKTkZfnUJBY6hXo6xe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9JxYAAoJEKVg1VMiehFYTlcQALyF1eJkh99TuO5C8N+vYB/K
nOb6ZO+5rBmyop0rSoWxtYeffIoI52aiwHKllwwJky7dA1niLaSBitBagj9+Ufb8
ZrIX9hpb40uVywKyPAEwY2F7c0NuieRngvhlSgZOfx8O1VGBeat603C8YDgMfboA
wY5uB2GNRL7ycuuozK/r3/CgVNoUldFVZRaNT4Baq+K9DARbOVxf6Py8+viMN2Gs
30sAXwGqyNf2sirddpXH9st5IR0CYvv0WVY2psZXRMdV0EQ5mRQW0Prc42C3qQ/8
TVE34E6Aty/oAGcLwnmLYsoYZVj7xz0q7iIelIBNT9lkCxtVg3WR+aAKA3mpISvk
6YdCE9hsignN3Iui2AeZcl8QOYbNpBTW3Tbr4jUoZB1kRgTaOfzKrfD11Y8g/Ddm
u7vwEK9B3dC6+WlcmojJjxNXnV0W5lIdiL7QczUnMqawbU2ED0wwZYiwm8Kw9V1d
mNJnx3TEeK4qIs0XybUNU3f+4XKeGDenktNSEsZPwD159K6CMQgpyqgY51JRQ29G
h4QiVEX0EJc29ONTLNWzD/3V0ND1mepFORN0aSAG9N3jrc9qdHuLP2L6HaNKGwcT
d4gmhLIvKa0QIbutmXhy0kStQ+C0ZUYPAh7u+Ik+JYBbF3PP8x4OnXnj8sTGC5Bd
dqcJoWLKANWuo0JGbTxU
=g5pt
-----END PGP SIGNATURE-----

--=-H9RKTkZfnUJBY6hXo6xe--

