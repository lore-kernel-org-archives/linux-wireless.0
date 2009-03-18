Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZCRNN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:13:28 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903181348.51609.IvDoorn@gmail.com> (sfid-20090318_134925_116254_40D04E2C)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903181102.21380.IvDoorn@gmail.com>
	 <39909ECD-1C54-4FF2-A029-E99B037DB93A@icix.org>
	 <200903181348.51609.IvDoorn@gmail.com>
	 (sfid-20090318_134925_116254_40D04E2C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jVWT56iFFmJsAXOCN2f5"
Date: Wed, 18 Mar 2009 14:12:52 +0100
Message-Id: <1237381972.5100.21.camel@johannes.local> (sfid-20090318_141331_415639_3C80C6BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jVWT56iFFmJsAXOCN2f5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-18 at 13:48 +0100, Ivo van Doorn wrote:

> Excellent thanks. :)
>=20
> Johannes, my previous assumption is apparently correct,
> The following is happening:
>=20
> ieee80211_open()
> 	-> ops->add_interface()
> 	-> ieee80211_start_mesh()
> 		->  ieee80211_if_config()
> 			-> ops->config_interface()
> 	-> ieee80211_hw_config()
> 		-> ops->config()
>=20
> Because config_interface() is called before config() the radio
> is not enabled at the moment config_interface() is called and
> the call to config() will effectively disable beaconing.

Ah. I thought you were saying ->start() came after ->config_interface(),
->config() coming after it makes no sense either but we haven't even
tried to avoid that so far... In fact, it is perfectly legal for
->config() to be called after ->config_interface() when, for example,
you change the channel. Not that I disagree -- we should be setting the
beacon interval before enabling beaconing...

What exactly is the problem here? The fact that we don't enable the
radio until after having configured beaconing? I'm not sure how to solve
this, to be honest.

johannes

--=-jVWT56iFFmJsAXOCN2f5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwPNSAAoJEKVg1VMiehFYrmsP/3B7+KciHrkvdExhc+Ak258w
HzMI6XbwUvt8POYR2sd9S9OCdigK+H+Pf3XjgXfpzzmUcMJGU0zSmtVpKGlRmfuq
9p6xk5hC54oqMMFeBEUP1Yk0z0QZHNZCeYAGAt+0TGmduV8roEIUjl7ImfqPN39l
64G0V83pZaTNGoc7X9G48fE0apctrA3VbC59j3ALWr+ZF6Zms7O8htnv7SjFvPQo
TEw/T6bVHs/tXZVAB0dC/NZAMBYq2Iw6sKLpbDgUH6pjJZSvMlcWx/dL1JORMWRa
tB63rolE2hzZH9YOQO0G5bQpB4af9WXlPEK9gUTO6+nMtId6y6v0iaLGe+WqKYiC
BaYWfspaCYipZZ20MLn4BYJO7GJOQqclBsDJYxra7shgXSfxZMhmbjAWXsNhW/1r
Jhs5S4RUmYUexUIV4oZtr8dEjlUeaFv8txC02oDEw/mGLT8MRYQBVNe1OgAQuHoq
duD+P2+U0cUwaBZtW8l/JJYcyS3P0+0pXO07M/v2EzUgwaA11jw30VwzVzXXYrOL
M7aaQXFVArbzjgDfnPEFKIvITjMNjP60tjxKJ2FzPMzzzjni4zKu6tXa/+DKaibJ
3ONlxi5YzP5S/BZlVVUuWtz7aA2YFOsskz6i7pfGJj4FiD+PUTd1zzf6JDpqxuH7
P8BdgUDhkrOaljkpQrgO
=d2AE
-----END PGP SIGNATURE-----

--=-jVWT56iFFmJsAXOCN2f5--

