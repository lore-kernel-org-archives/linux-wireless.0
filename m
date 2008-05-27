Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYE0RGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 13:06:15 -0400
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com, j@w1.fi,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7JMG45k3tgkj0IQde9/j"
Date: Tue, 27 May 2008 19:04:52 +0200
Message-Id: <1211907892.3930.19.camel@johannes.berg> (sfid-20080527_190618_822539_D882DE2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7JMG45k3tgkj0IQde9/j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (bss && bss->ht_ie) {
> +		memset(&iwe, 0, sizeof(iwe));
> +		iwe.cmd =3D IWEVGENIE;
> +		iwe.u.data.length =3D bss->ht_ie_len;
> +		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
> +						  bss->ht_ie);

I'm fine with this, but I'm wondering if maybe we should just pass out
the whole IE area of the beacon/probe response?

johannes

--=-7JMG45k3tgkj0IQde9/j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDw/M6Vg1VMiehFYAQLnkxAAgxloca4+QeNQLMc99QP4rQkrZZpLx6CF
FwQ5yBNl6F+FwzpC4k8fstdLCR/ha+5QUKP/Fw4LkUIovxIQiW6LXa4lldnKjwVt
IC+0c+TiZmDrr6/TxUnXXJpLZcaH3ZGnZjOZCw8+TjB7ACPhOxPAQ30ia3ZK9j4S
JI2CdWWC6ZUSfEQv/a1m6c2JBdAsIJ0yw40/fFBMR5x43eT/8lrxbWySW0VJcdw5
nTdR1Ri0SzFUbC/Vjn9K66vQLu+mUgilEAwIKn4Qb4CJp+BIXsFsidOYWQukRww8
C48a8qal2dP3WFIGURFF537vYh3C4AsYyHO8DZVDi6HNYNXc18aCSpPBENU7fT31
t8eRB6LYvyuxge2HqPqmago7GwGTT0gzCkCKyUtOhY14wwPNv1OZ1ZWZ5RG2jxD5
e6xyHHbY7z3vWNnA1nlzmiP1hxaGaPFODRbEL0DyJgB46NSYJCy3pkSxEDLUj9zH
1T5Kl/zkJcWmnbBjjnUD94slrYY5puTv77VSFhySKw+ddZNX3XQPbB0qs64gSRuq
X6tkJ4/m3LaF75SZlSgcBhDJ2GQq5s/jHRP5laz4OEMm7ODMrtIjDLg44aJTycyb
n4c9fcGnFrLtKY9nUB5LRqEC5nwkuS2GxvctoLWGUsSfG2YBKaYSq3PR2BY9njsF
o+FhfNc3gkc=
=xl2a
-----END PGP SIGNATURE-----

--=-7JMG45k3tgkj0IQde9/j--

