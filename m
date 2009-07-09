Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZGILnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 07:43:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MOs2Y-0006QO-23
	for linux-wireless@vger.kernel.org; Thu, 09 Jul 2009 13:43:50 +0200
Subject: nl80211 and wext interoperability
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OkwWHkZXwl8RwFrrXNza"
Date: Thu, 09 Jul 2009 13:43:17 +0200
Message-Id: <1247139797.2144.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OkwWHkZXwl8RwFrrXNza
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

With the recent work I've done in cfg80211 for nl80211 and wext, we've
mostly removed wext code everywhere. The only thing missing right now is
the key support, and I think then we can declare cfg80211's wext compat
layer pretty much done in terms of what mac80211 had -- orinoco will
need the sensitivity (or AP density) thing but I'm not sure how we
should do that since it's a value that is hardware dependent -- we'll
need to have very good discovery code for the allowed values (unlike
wext where you can set 0..3 and don't know what that means). Anyway,
that wasn't the point of this email.

Currently, if you use wpa_supplicant -Dwext and -Dnl80211 mixed,
-Dnl80211 gets confused because -Dwext will set a 32-byte random SSID to
"disconnect". When then the interface is brought UP again, the cfg80211
code assumes that you set configuration while it was DOWN, and tries to
recover that configuration. This means it will start scanning for the
network, which means -Dnl80211 gets -EBUSY for the scan and it all gets
very delayed. This also happens if you set an SSID with iwconfig before
using -Dnl80211.

Do we just ignore that issue? It's only added timeout and people using
purely nl80211 will never have a problem.

I'm all for ignoring wext issues, but I can also see people complain
about things like this. Not sure what mac80211 did, did it just ignore
settings while interfaces were down? I never really made sense of that
code.

johannes

--=-OkwWHkZXwl8RwFrrXNza
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVdfSAAoJEODzc/N7+QmaG9MP/RaZGWCufhJmhXLiI8Y1Bc5K
nrvqr1Z558XTJTVQYU4j3Dt5zK0ej8acTBiK9u60L4yMVoYNIk6mDOe8yZrNtwHB
SVJlampTHF9hI7lr30NpDuviY/M+2BX1cDKRyclg8nT9ZZVvWp4IHKnDN0xbi5fw
GlvaqxC371PKIbp599r3ZDCGJPHTEd8sq24AGDHkYhF7Yq5OFw9IyFtApMOYITAl
R26h6xAh0u7gOE6+xUzSEbzW4zlf3wj91hz0NqUraKaFBza8Z2WbMsvYqYmBPWoo
/NLcVv4UF5oGv39gA7/3FEi+sAXYJZ5PxEQFN32xE0JIxSvky5Jxu+KMZV4Dug/i
8U9Vgy68Yik8iV9f29aklqURVvlWohuyCt5pHF0jwiyAQ6FIFxuuz9Kh0oVKvowS
gh0wScv0nEdzURP3CQoZPUQzD8sKdv9ks4QAj2FJOCK+/hMiPbZ8pGO6rP6ADpPI
Ic0bbEVKW8lLyHWRnm5Rrykcxfl3jLQOZknFSckoji2dw6Hivgkrcu+YNO05rSBm
PzVE1egrVis4UtNYU7BxgkCbnMDYfGr/um3R2ga21HVgrDsOoM4udwEDgn/32VrY
zpFvquqOSFUYoxF/dSIscGnpTntY9ma3Ukvmbal7aPFXg4PNOYpOEWh0lsA1OWX5
wncGe6T3DS5Yxf8F0+UU
=8szr
-----END PGP SIGNATURE-----

--=-OkwWHkZXwl8RwFrrXNza--

