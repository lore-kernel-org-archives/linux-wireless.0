Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYFBQyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 12:54:10 -0400
Subject: Re: [PATCH 1/2] mac80211: fix unbalanced locking in
	ieee80211_get_buffered_bc
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JcMge9hCXH3AyYyohb+k"
Date: Mon, 02 Jun 2008 18:53:15 +0200
Message-Id: <1212425595.20021.0.camel@johannes.berg> (sfid-20080602_185414_487319_B84B80B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JcMge9hCXH3AyYyohb+k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Good catch. However, we'll leak skb in that case, so how about:
=20
	if (WARN_ON(tx.skb !=3D skb))
-		return NULL;
+		res =3D TX_DROP;

johannes

--=-JcMge9hCXH3AyYyohb+k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEQleqVg1VMiehFYAQJyAA//VN8+hH93U76bsHMWxAoTTRFR2eDVc50S
4KnpL9YLN/90Ca8Yx6kD2ShStv6+E+mp2kLugUsKqj0d7V7VxncElQ656k1cCQHG
QAXo6NgpGXYVkg5q/J7YMiCel+ld9FV4Uy4VOoUPc1BowvtN4MDLnb5gNMXaOnOF
VeJivDh4luBGAJmaLMW9ZKy8z7DC5qFKnwZx1ISWuBEyEpFL5EbHH3ch3MztiSNN
5zlW9m3A4YqFXGy0kQyfD+ateIq+dcmiJ2w69ArRiuw9cMLKVagJy1WnS51vVY9r
npe9Dyc0TSacBNnHuI0IrCuuxfxB8SXwa+cJ2ZedNacvsxFDsLmKgdAByZNML35k
lDEz5lE5XRYfEoUibPXKnwGhiRKobRfQtt9D04vGY7orzXkglwXsuer8NjsfBBqc
ggKcoE8wj9iaQwqLocm06umxKS2WeP2vH37iXePR74Crj+Mgu1TqJ546UU2c87XK
4CEl6S3zshXzmMW7OWiRec2xVaxYCU/jO6Vv1W0IDuLvgOvDdEwseD7Oe4VSJ/aN
6Rd+7W3sdQQYHz4JpjVHOm42NP8eZAR8Z0CovcuxjC1cCgvW4E/8sMnxr8xZ3vtO
EBvDFkii0sImFaqUy8f1e+7HRTnBpEhhhBgXeU3BS9uvoaTLsotgGNvbPV8uiqQP
bnPiULnR6hA=
=vmr/
-----END PGP SIGNATURE-----

--=-JcMge9hCXH3AyYyohb+k--

