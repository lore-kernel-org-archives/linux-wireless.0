Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbXJ1KtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:49:08 -0400
Subject: Re: Change error message for failed rc module
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <47246844.6020109@gmail.com> (sfid-20071028_104530_132972_8BA4B064)
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>
	 <200710280034.41942.mb@bu3sch.de>
	 (sfid-20071027_233701_549220_BD0E4B1B) <1193568021.3966.15.camel@johannes.berg>
	 <47246844.6020109@gmail.com> (sfid-20071028_104530_132972_8BA4B064)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zZW1mGZY1iTycT+WBkcQ"
Date: Sun, 28 Oct 2007 11:50:27 +0100
Message-Id: <1193568627.3966.27.camel@johannes.berg> (sfid-20071028_104911_458886_F329537C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zZW1mGZY1iTycT+WBkcQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> won't this conflict with drivers that want to use their own rate scaling=20
> modules? (like iwl3945/4965)

The rate control algorithm should be per-hw struct. We still don't have
the "driver preference" patch applied because of some things, but in any
case it is possible to have an algorithm for each hw.

Besides, currently, afaict, if you first load rc80211_simple and then
iwlwifi, the latter doesn't really work well if at all due to simple
being used. That needs to be fixed anyway, the right solution is that
patch we were discussing a long time ago with driver preference for rate
control algorithm (though ISTR there were still some issues with it and
I don't remember whether the initial version was applied)

johannes

--=-zZW1mGZY1iTycT+WBkcQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyRpcqVg1VMiehFYAQIOpg/+IXi/FCzrHKn0qoa5VH68MVMEm0pBWdRU
pomyyUqc9VKIVxd+ntZylSKEyEqZzPTgS1YNF8KaThEQuzKorUWwvksBIOUYgE9w
/dlIlB5BlD26liA3Xfx524iK5HKI6r/NJLB4VWsN/OLEOZ/63lcBoBz+aD8wO9oO
a+jJ+MQvtv1wjjA/YJYHNIEpKJ26vNljp1y66QhbKu9LBnayiXUY7N88tD2OflB0
16WRnSeV5lNFbOU4kZdSCIlL29i78GIH3dUWchL5B3OKCcAowZ81l+pHY8Fu+aqt
yutZXQ1uAR00+p4SMqJpSFDEfOdfWGiomU6CWnkiJ9oxbxfS5Q98p8klg/8QAO82
/bwWle3T5AE0xCptHRnPgKzaUbMOXG/v3mX8Xqd8nuDQ5y/nXbKppUrdpJbGgX7L
7fhzTbFOmKA43gr9650n/OHrKyqZ/D++uxbLlnvOxSQ0lc+DIMNGFCMCx4HMBZ0k
2/nGM3FnT/IWTxqeNaSPjNxgrV8RvLVWLbAuA8gXrkYg1jso8H58/PBij/FlpFfp
DQlKfUAy7jm3Qhy2f/7zjg7NPHwRrYIIst9OPBSMjPlT+z0NVZ7wsnvFLgMv+Q+a
mG9QA8c/JcU2JaqGlWtEPpYUwHAu0DUBxGNvT3Y0L4OZaUeXTdrHlEfbbqR7FV5m
WsPIPwUqwwY=
=KcSG
-----END PGP SIGNATURE-----

--=-zZW1mGZY1iTycT+WBkcQ--

