Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZCQV1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:27:00 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1237299098.31814.12.camel@johannes.local> (sfid-20090317_151227_274610_073D96BB)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903161558.01070.IvDoorn@gmail.com>
	 <A1AF7AF9-047F-41A1-829F-94F58821DB09@icix.org>
	 <200903171031.41302.IvDoorn@gmail.com>
	 (sfid-20090317_103150_606981_0D5CC206)  <1237299098.31814.12.camel@johannes.local>
	 (sfid-20090317_151227_274610_073D96BB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IHLaqMEfNR8K3c3asOzN"
Date: Tue, 17 Mar 2009 21:10:25 +0100
Message-Id: <1237320625.10264.0.camel@johannes.local> (sfid-20090317_222704_505703_3098D605)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IHLaqMEfNR8K3c3asOzN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 15:11 +0100, Johannes Berg wrote:

> > Thanks for the dumps, the reason why the beaconing isn't working
> > is (fortunately) very obvious from the registers point of view.
> > The "generate beacons" bit is simply not enabled. However the reason
> > why this bit has not been set escapes me. Could you apply the attached
> > patch? This will add extra debug messages to the driver to see when the
> > beacon generation bit is set.
>=20
> I think mac80211 is probably not requesting it until you scan -- since
> once you scan it calls ieee80211_if_config internally and changes that
> bit. Some mesh code needs to call ieee80211_if_config() with the beacon
> enable change flag.

Actually, it does, in ieee80211_start_mesh(). I have no idea then.

johannes

--=-IHLaqMEfNR8K3c3asOzN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwAOuAAoJEKVg1VMiehFYa+UP/2RVyA48LtuR8zhCMkPHi9qY
hcVqTx5E+OyJ3EUHx33I7oZfWM+S5/XCFcYUVu+n2OLQ5imQLaaVHXUVwNLNgYC1
/HTQFMJbOdrpFDOytWw/w1CD6cTLX/njxI0ZGrvN9QcLaMddzFJ09uAs+8Ci0IHg
e+xN5LnRhuca4JdA3Bp99hN6Gzd0P3ZXnC8i5SeXHQCp4PgNMdovieluiuYgQ8bY
3O0YB7TfV3iHGOaBdjTw5uhr3C9JB/1J/zihDDowS743MbviTvTEF9/cOXsjJa9f
TZ5JCrmjmFYjmBF16pwPIOqGlzXEE6DZRMAe9MpF4nm4AkljtClH5WvrPKkqzOHK
1oM+cySies+Ii/4IcCKvS79ci9AcNjk89FLTiQ1w2HQvxsdaqjGPD04foau05/Aj
19gmVgk9nhBiW5ny3AuMryLq5D2I3jhZzMv8VvDFciC1NV10PxrGHTnnljajjMi+
O2a6hu9NtebVfU4dppM2z4mUkO7wbGErQVUB1G2uTTHnNHaAjR9S7hcRYgRaywqA
wbea/MtG/yLCVqVcu9itYRWVBVHcuZ4cCiE5UP+0EreeTPeLMXOwwvrIKwgLXS5G
Pq/z1e29Jh7Y23cfIFa60oF+NGLNVPh1HeE2aIxEyhlnwPyWcvoVAefk19V0Z24/
YhUPLTwNBOUZKUm4nVfH
=HlfF
-----END PGP SIGNATURE-----

--=-IHLaqMEfNR8K3c3asOzN--

