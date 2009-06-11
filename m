Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbZFKUKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 16:10:39 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906101517k5897f1b8i19a8c840c6312d1d@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
	 <83a869cd0906101517k5897f1b8i19a8c840c6312d1d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FxBNq4sgMAFXHfjbe2Ol"
Date: Thu, 11 Jun 2009 22:11:22 +0200
Message-Id: <1244751082.29447.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FxBNq4sgMAFXHfjbe2Ol
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 00:17 +0200, gregor kowski wrote:

> >> Might depend on something else? Anyhow I don't see the point of
> >> continuing to call the callback. Maybe it should just be part of the k=
ey
> >> todo instead when the key is initially uploaded to the hw.
> >
> > Or what do you think about this. This will call the callback only once =
per wrap.

> But this won't work if you want to support QOS.
> So how update_tkip_key is supposed to work with QOS (ie different
> rx->queue value) and multiple tkip IV ?
>=20
> BTW did you know why there only one tkip IV on tx and not one per qos que=
ue ?

Umm, have you read the standard? This is correct behaviour and works as
specified with QoS.

johannes

--=-FxBNq4sgMAFXHfjbe2Ol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMWTnAAoJEODzc/N7+QmamMAP/Ry/kmEVMcujk+LFVRexnBzD
sQVCGPaA/4i4DAhAXJpyu7XQK0mUfn7gqnUbfUPW2BP45SnpzUs+l0BtFu+beugW
XjA4j6CiYz3T2tyrk0nF8NAY/AJW3yCm3UPvW4xbjv/NfbPG23LZSI7HTr7e7/Cl
wrmw7tZnNK3SQFPm0IIa/ZlYLpRw5Q9jjkRUPLl1dxMgV6Byz6fPjwxFEJ50Nhil
K1AYtfWcurVHczDGxzR+LKAne4u2MCaDyA/2tM2d2PJ6XBUy0HkfRsm8xYAWwXKH
c7mX/UydCoSgIt1u9r5q1QmyqK3Nbki2lq85TnZtrJziXSSCFjYGklJ6WUglyyQu
XivUiTO9g7DQpe1ucxV8zQZhBrBeKLAPVz+13OjLohfOj2SINXec0S1cdlZLS/dc
szzyMOVD2G4yThGGggsDarZW1qFAGVm40xAZsVusUrCpY+k3leyrGENmNnBQ5mvZ
isSkVnpu2w/ylczv968+n4yL2c8SZ5Yah4raqOESlUS7kakp/k6BpkNlFRw+hpvh
So+IudWGONwDgDKUlikrnRuePHjjasMtL6J7XCQyNJi1fDRAfZf44chySxl6uOuU
rEs5wQkN/z1/p/YzIS4tEfa2qpLfxkpsxj6jtrC+FpabQalFDWp+4AeSBfg5lZwh
UmPeIYgJB4K7OaQ41Lqi
=RotE
-----END PGP SIGNATURE-----

--=-FxBNq4sgMAFXHfjbe2Ol--

