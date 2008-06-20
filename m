Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYFTNbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 09:31:22 -0400
Subject: Re: mac80211 suspend gotchas
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200806201507.29030.mb@bu3sch.de>
References: <1213966018.8967.176.camel@johannes.berg>
	 <200806201507.29030.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hx1gKllVv/QkGCZ6EYZ2"
Date: Fri, 20 Jun 2008 15:31:13 +0200
Message-Id: <1213968673.8967.178.camel@johannes.berg> (sfid-20080620_153125_496090_2CD0A4D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hx1gKllVv/QkGCZ6EYZ2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This is not a hard problem to solve.
>=20
> >  - suspend does, in this order (callback used):
> >     * stop aggregation (ampdu_action)
> >     * remove all keys (set_key)
> >     * remove all STAs (sta_notify)
> >     * remove all interfaces (remove_interface)
> >     * stop the hardware (stop)
>=20
> I think the hardware-stop should probably be done in the driver
> suspend routine after the mac80211 notification and not by a mac80211 cal=
lback.
> Otherwise this is going to get complicated wrt locking.

All of those callbacks potentially require locks, you really want to
call them outside of any locked section in your ->resume and ->suspend
handlers.

johannes

--=-Hx1gKllVv/QkGCZ6EYZ2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW7EbAAoJEKVg1VMiehFYtHkP/jKaUYrcp4uOsWQjaSnzjIzL
y7ZXq/5NEm1hDTwkngynexNKyI3zvL6x9uv0sJSIJrcstbfwrdh52VKZs0jKgjqW
Pcoc07hA2zjtHWTWelcMyDmbvum36sCzPBi9sACE2pH9ETvID/aUcgkuFTj/I+VT
nLaVJJW/vqShQx1yOq7nFIlWEv/cF5FeHuNfVWcmexnzFXZIQ0Cdf0aaLoikhEn3
kbHL3qhWT6Sc+03+K59dP27UXcUla60QnM33i8XqAFdYQQReuY51pCY7FWLeS1lt
P/06dMpfSW04LyhuoPLagEnITSbsS4oUFhr51JOAp5NvI3Kk4Sq+9hkDCeWcJXlO
NxtatGYtwTQXIjFwQMroZujEaNzkLwI6RwrnD1YqaIokc+UIP/2Dlcd+HKIyqjg4
14L2ccBVIcBDrveZ57HoKOeCiFywdGRWZU73A/i5q8YQj1diSVk2kfT5CE7yGYlP
z2PuaRyjupLkCgnVvxC09PQsueTbAdyGFGRvbHrPSAAyyXc0nI8RIsjA0YemAZXL
CdQMCxQtJz/Mr7p+O2BhYWcpKpOkun7C+2/+EQfJzLtti8vE6MLYmbfQUVzzkoKZ
7rQ+TLqnWFGsZOjN24fpQSdE4nrp9cNRgVrgearbYIZ3mYjJX+Q16ZXeLVsjkdJL
/Hvw7foSiq65ZfinTxYJ
=GxAF
-----END PGP SIGNATURE-----

--=-Hx1gKllVv/QkGCZ6EYZ2--

