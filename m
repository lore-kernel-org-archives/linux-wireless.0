Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0AYSX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:23:27 -0500
Subject: Re: [PATCH 1/1] mac80211: only single mutex locked to prevent
 deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1264443136-30865-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1264443136-30865-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SArRobGuyag+AbCKyXpR"
Date: Mon, 25 Jan 2010 19:23:23 +0100
Message-ID: <1264443803.23766.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SArRobGuyag+AbCKyXpR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 10:12 -0800, wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> Both ifmgd->mtx and sdata->local->iflist_mtx are locked in
> ieee80211_mgd_probe_ap(), not sure it will cause deadlock condition. but
> it is better to only has one mutex at a time.

It shouldn't cause a deadlock, we do this all the time, e.g. in
ieee80211_rx_mgmt_probe_resp(), so I don't think the extra locking makes
a lot of sense.

johannes

--=-SArRobGuyag+AbCKyXpR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXeGYAAoJEODzc/N7+QmaKscP/218YjWAi0XcS7T1fp9PmCuI
bHpQuTrhMVoGULAe+Pkgoh4TbwhKdKs2cOoQSBKw0chK/uTv8+efjwY3agmMO5HV
VdXDca5EeC3CkZWyxowTtpsv9jlrRfDsu0Qkw8QS99FgvVaJHCV0xLrdROhB1MGG
QJ6nHbRjoiTWFAADfzZth99gG9aaD5A+ioG2WsYT9K0oTNShY6dbpJqEBR07Il5Z
hcsEFmmMZVCifQNr9cvuuoNe70Hh4K+OYl2mB/O7c64y3MWtKgsLnswC3YhpTUTz
qLVkxsCraXpEor3ty5/bQreKcdJX+vs3F2zTfvGFWbrQKPuSIO6hFgCH74jjlPBh
xv1zpyH4ZsRg33jUY4VCDMBM8HcZv3J11HkWaYzhis/EBcIXirOiinpljM69Q3I8
4UbGGMuUt4rJlXTdF2dEP0XINHp/sqCVfBsTnGLbBYpargMY5BR/sgSpAkj6GOED
+Xap/UBI+el7EyvD9dNDGSCr8FqvCiin6m2FvLN18xtAFV7yTBVavG55x3p8WU5T
o7q4mfcnX4C2o1JppRyjN7g+AkCyastV1Y7Whe5ZOkglDT6TQ40M6CBsZV6/VU+1
LNlXDi4SbaqXge0Jc3RnherkR7kk3lc0VlAAYAhIj9fLqvfiw1zQIzmWqZ+kAScE
tGNMG6R82kE5UrpNsOsq
=X09r
-----END PGP SIGNATURE-----

--=-SArRobGuyag+AbCKyXpR--

