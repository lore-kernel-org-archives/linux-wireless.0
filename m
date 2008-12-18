Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYLRPTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 10:19:19 -0500
Subject: Re: [RFC] mac80211: Add an RX flag to skip Michael MIC verification
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081218124057.GC32267@jm.kir.nu> (sfid-20081218_134107_532732_2FB720A4)
References: <20081218124057.GC32267@jm.kir.nu>
	 (sfid-20081218_134107_532732_2FB720A4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/xuxYQvGynkVXVJo7eoL"
Date: Thu, 18 Dec 2008 16:19:15 +0100
Message-Id: <1229613555.3601.1.camel@johannes.berg> (sfid-20081218_161923_683132_49418796)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/xuxYQvGynkVXVJo7eoL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 14:40 +0200, Jouni Malinen wrote:
> mac80211 used to allow drivers to indicate that Michael MIC has already
> been verified in received frames to allow the somewhat heavy operation
> of validating this in software to be avoided. This disappeared as part
> of hardware crypto flag rework (commit
> 7848ba7d7a010ccb265617fc2bc053e2bdf06f48). The changes below propose a
> bit different mechanism for achieving the same benefit for host CPU with
> wlan designs that can verify Michael MIC for unfragmented frames in
> hardware.
>=20
> I'm also including a patch to ath9k to start using this new mechanism
> and move Michael MIC processing to hardware for both TX and RX whenever
> possible. It seems to work based on minimal testing, but I do not want
> to submit it to be merged before more thorough testing has taken place.
>=20
>=20
> Some hardware acceleration designs for TKIP take care of Michael MIC
> verification in received frames (well, at least for frames that were
> not fragmented). Add an RX status flag to allow the expensive software
> validation of the Michael MIC to be skipped in cases where it has
> already been verified in hardware.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

I probably thought you'd just strip it in that case, but this seems fine
too.

johannes

--=-/xuxYQvGynkVXVJo7eoL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSmnuAAoJEKVg1VMiehFY1HYP/0KboGmeUavHcxQTwmrgFYQa
5sMMQfpVmApMPZlumqzXfZpvX/KIKrc719bni3Sew0msaM8/b9m5USYsWVIKWIP/
KthAM8d2JbvbLCLARhvaNLYPxPrHSt5cnpn00b00o8muxs4M3idIkiprDqTURf5r
JzgRTRrp8vwgmpV01qkJXXDTCMu/bce9aEFtWmLIpJrxbEYE0Yb6cIXctQ4vgxWg
KCifyAtQPqUfFb16sYYOf3lSa0UhE3PLTPL7NCAJX5J94cOUoNn9M/1uSapRfeF7
zAHr2RWgVfqGy0s12kNfzfGxZF+MT74a/1ZNJcz7WmbLNw0Ae9xQNBuoXVNDYMFT
XBmo7AOdwz4Lu1bxwBLw7OYPrQnfh8n6CqE+olLyf9CnMDeaU/FK+j1bHsak7s1m
X2Saoqd2Whdoo3rm/z4v/yoDdfKLPgXBkZX0CBBtqcRcYpzSoypvpId7MzS641mn
8qfyMEHnMA6pcFDnUUiUHF7NmNYupMWOU2QR7x4R1HF6Hqk1eIin4L+S+Dczklqg
lXv9LH8aBquJOAZ1xjyyhzS2MlDSiV2FtYCiOmDKEDIKlM2gcrgFMeEBDCB3Ylc2
xSyqbWLCf/XyS+z7jyn1KCvVbW7GDG1poe6cHJMAXMkik8Gp5ICjtaYMW7QlhxhD
SCcRCzcuXg1dl11G4n6p
=BuqB
-----END PGP SIGNATURE-----

--=-/xuxYQvGynkVXVJo7eoL--

