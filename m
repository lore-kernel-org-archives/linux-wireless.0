Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZGPKO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 06:14:26 -0400
Subject: Re: ath5k and Atheros AR242x - No scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Joel Roth <joelz@pobox.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20090716100743.GC3867@sprite>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
	 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
	 <20090712203449.GA3058@sprite>
	 <b6c5339f0907130708h3996b274qdcc7d7f6056a188c@mail.gmail.com>
	 <20090714065414.GA16708@sprite> <20090716061457.GA1576@sprite>
	 <1247734019.19467.0.camel@johannes.local>  <20090716100743.GC3867@sprite>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Dlj1rrnqaXx0lc4tjuT9"
Date: Thu, 16 Jul 2009 12:13:49 +0200
Message-Id: <1247739229.29762.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dlj1rrnqaXx0lc4tjuT9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 00:07 -1000, Joel Roth wrote:

> Hmm. It does work _now_, provided the interface is UP.

Yes, it has to be UP.

> That may be thanks to having a recent kernel with the latest
> compat-wireless drivers.
>=20
> I was also misled by assuming iwlist's 'ap' option would
> provide useful information.=20

It hasn't for many years, really. Oh well, not much we can do about it.

> To summarize what I now know, the steps to follow for basic
> wireless connectivity to an unencrypted network would be:
>=20
> 1. kernel and driver setup - use compat-wireless
>=20
> 2. set wireless interface to UP
>=20
> 	ifconfig <interface> up
>=20
> 3. find available networks using
>=20
> 	iw dev <interface> scan
>  or=20
> 	iwlist <interface> scan

This isn't strictly necessary if you know the SSID already.

> 4. connect to a network using=20
>=20
> 	iw dev <interface> connect <SSID>=20

The old way of doing this would be
	iwconfig wlan0 essid <SSID>

But as long as you don't need ancient hardware, you're probably better
off using iw. You can also use
	iw dev <interface> connect -w <SSID>
if you run a current git snapshot, and it will wait for the connection
to be established or fail and print the status.

Oh and if you're just doing this on the command line you can do
	iw <interface> connect <SSID>

(i.e. leave out the "dev"), but please don't script it that way :)

johannes

--=-Dlj1rrnqaXx0lc4tjuT9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXv1aAAoJEODzc/N7+QmaSjIQAKZJqsrVxVnod188qhRXcF4E
SFAeXfkWdRChU9WzG3j4QhF08+R7CHtAd+PQ/75xIV+9s2A9JhXwPnaukLuH39xu
sEckhBqNqvcQehHxwq84dyTRFa7HouQh1spQ9bTVCb/A3LFOaOYPJ/SH/nuIS3NB
JE/vt0s4ly6is3KXjOjCfVya2IjlqTn3enGk61mDgqfYou4oS4+x852czepoNBnC
sBxaFAFOPMBTmJF2vxpKE2MM9njnEPR82+nrcw2Kc9y+zGxRjFgv9VwMJOo03zmJ
kmaOngOAj8HK1soGKRYX8ZaSZ7s0toNiQ0mxLUDdYgecQjBzyRS9b3ni2FBcJIox
jJlM8MfzJe6U1Z3ieF1l7slKAx9mI+MaHTto9xNj1oIzCd287b1FufJ1XvbSGj6+
PmvJg/Z0nan5w+jn1IOrtnryW19CBURmJJ/hv95vbwnnkFQhum5xG4d8+p5LBle6
s9UGWhF6mzub5iMWarrRIm9x2XUFNgd2leFePQGjjKePLh2k98s748kC/1ApBq6i
TvDoa1TRFpWbBkMUDCIW9WvobCWxgHdMswrt5JMhBl9mJsEBwxKpqCFpzuhikTFK
byztAFkvbOVuTOMy25mEiJ+zkqcNN/0BjE7o+KMZN78lQ0so0K3rjyJxLofrvq8q
eKjgU2vDuDQ6/g36BGi7
=TlNf
-----END PGP SIGNATURE-----

--=-Dlj1rrnqaXx0lc4tjuT9--

