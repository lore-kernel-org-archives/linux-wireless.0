Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYJILhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 07:37:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Kntq2-000215-Ep
	for linux-wireless@vger.kernel.org; Thu, 09 Oct 2008 13:37:50 +0200
Subject: fixing the mac80211 documentation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CvH9YWTaGNTSHlNdJaJA"
Date: Thu, 09 Oct 2008 13:37:47 +0200
Message-Id: <1223552268.22490.67.camel@johannes.berg> (sfid-20081009_133755_810933_B3FFD431)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CvH9YWTaGNTSHlNdJaJA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Previously I've always tried to document things in mac80211, and
recently I posted a list of driver requirements. Now when digging
through the HT code, I cannot even document driver requirements because
it's not really clear even to me what they are---and I just refactored
the code.

But it's not just HT, also the new rate control API is probably not
documented well enough (nbd has promised clarification though) and
possibly more I can't think of right now (like the unimplemented mesh
security, ...)

I think the process has gotten out of hand. It might be good for you,
but I can't be cleaning up mac80211 forever, this needs to stop at the
original code we "inherited", new code needs to be documented better.
I've also seen promises for documentation to be posted after the patches
go in, but so far those have been empty promises.

I take all the blame here for naively believing such promises would be
followed up on, trusting people too much and accepting code without
fully understanding it. Why did I even get this role?

Therefore, I'm inclined to require (if I get to have any influence on
this) all significant code contributions to mac80211, especially if they
affect the driver API, to be _preceded_ by design documentation.

Such documentation would consist of the documentation that will become
part of the mac80211 header file (driver and rate control API), an
explanation of why the driver API needs to be changed, how it affects
existing drivers, which standard it is based on and why we need to
implement it. Additionally, it should cover thoughts about how this
affects the various modes mac80211 can operate in (AP, STA, IBSS, MESH,
WDS, ...); if it's not implemented for all modes it should come with an
explanation of how such implementations would be possible in the future
should they become necessary.

I'm not sure how to actually collect this documentation, parts of it
(like the "how to implement feature X we have in STA mode for AP mode")
certainly should be part of the kernel tree, other things need not be.

Comments?

johannes

--=-CvH9YWTaGNTSHlNdJaJA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7e0IAAoJEKVg1VMiehFYb6MQAJi3psdk97qqj5f0R02WJgJ+
qYbCKsHS/tRyNATH51WOfrxxSup4q4B1o4iQRzf3qr13o98PbTpbwRUSG8h+IHKw
MCLFJ7886Lt0H5hq5YeILtSPJNKR/yWNxxEf/a7s2Q1DUGm/23WSmbTJQmU2qSSm
49vYNt8BKLdPqX2bcL+zytiuQ8PqD453JYPBezyXsMFHtTN5mki+kVlyictjZFxh
fTAeP5VINgSM1ah6QDD/+ouL6O6uScEt7uOmyC8QjQ0Y7Wc9r4XbBgvePodhPYT3
eRoWip+hpm/AkzMHjOPxPEvNc9afrqCVrovkEOqznlBtcmAv7og9D+NwbURPkX0U
HntxovOx+8PsAhGcimh4zgcI3AjK7PBXLqz4L9ZYysOntHM6fhSwkrg6t1GT6ruk
NqudNKkW/23p8YpW/9haxSDVADoLPK64T4fVGD/XNvUAex22k3NK97X1rnCVYYu+
e6oA4ka/1nrfoMTUt5deJph50z2OEif4IW6SpH5MpaQ9lxHDOkLJz7TN2Db6Vxax
zzkDp48CrQoBirkJkEEoByUTTMTBBq6aaZTwQ/utyMNaqLlCGa75vOgkzd6bIJ+1
VerihpXxcUGlHMHsUVAeMrPCyiUj3Vjia4D88nd/UVirTxJlRga4hDSdw/4Gj1dD
/eCKMOdQ2Qa3YEv6a5CM
=BYIW
-----END PGP SIGNATURE-----

--=-CvH9YWTaGNTSHlNdJaJA--

