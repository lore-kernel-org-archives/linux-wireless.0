Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbXJJRly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 13:41:54 -0400
Subject: Re: warning in ieee80211 tkip code
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1186986902.27916.26.camel@johannes.berg>
References: <1186986902.27916.26.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hJfkYB32wf08UD/0RrLb"
Date: Wed, 10 Oct 2007 14:54:32 +0200
Message-Id: <1192020872.12541.26.camel@johannes.berg> (sfid-20071010_184159_870346_C449329A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hJfkYB32wf08UD/0RrLb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 08:35 +0200, Johannes Berg wrote:
> net/ieee80211/ieee80211_crypt_tkip.c: In function 'michael_mic_hdr':
> net/ieee80211/ieee80211_crypt_tkip.c:587: warning: overflow in implicit
> constant conversion
>=20
> The reason is pretty obvious:
> hdr[12] =3D qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TID);
>=20
> where IEEE80211_QCTL_TID is 0xF, so that's made into 0xF00 on BE and
> then truncated to 0x00. Not very useful.
>=20
> This was introduced in this commit:
>=20
> commit 65b6a2775102cd81e57158ef4b1cb89641f76cfd
> Author: Zhu Yi <yi.zhu@intel.com>
> Date:   Mon Aug 21 11:32:31 2006 +0800

Ping? Any comments on this? It's been two months.

johannes

--=-hJfkYB32wf08UD/0RrLb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwzLh6Vg1VMiehFYAQJX3g//SbMbCw5IBU8zKE5+Ur4KyPIOWiQ1Mw9g
o+Gi17OygzvWYUeG6GC5KaJNfy4kEsOs+saivI7oghcrm2JoWjcWyEk8TJLgvrud
7NCfMpuIS49UEVosdKVhD88Ui/s88rz7xmZr2IruQBBNKPXKjsa549eYuWB9bcRq
Y5bNaF/QTdM7HRyvS903PfpV0Gky4OgzZjIFWdnn+3ywWdcwgQRXJuTpMvhUSw5n
Y3WrDsJFbmMnnKm1LGatI7ikchaIBTkrBEq+EXdYl4MIE8U0DXQoTwJu5RazyxpS
M5ddKam6NtAuasfE5UhwFRB0s1mEw3On2JkShQHEbPYkHgSfy47/Gjnh1mjqdiVI
U9corN7qYvxwoIDw4EopV5yig57df9URzxBfYlNXEhj7n+gP/fJGUUV5PdeknWC1
tV0hnc0VgeDGZuaVLP+I/75k5qUv/k1N4CHSckt00I77hIa7B5F2FzOqtZ/pntv0
grywY3hV1yszUTvz8mMcdLVM+JsDIMqf3idzfwJ1W8j67hSYk4L98QCSePOG5Z5R
k41ebdYdqes7L7xLodN+cn+ZRW/cTA3FPOJlVopvgofX52xL23yqSd4mQYZeoUMX
jvcX50L6HF9/00psthsEIZ+ICZWNCSRA6XHV2eTElaekQPxi+HARUZcPmo857jy9
Ig3RQLvP1HE=
=wLMH
-----END PGP SIGNATURE-----

--=-hJfkYB32wf08UD/0RrLb--

