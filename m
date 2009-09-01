Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZIAPeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:34:08 -0400
Subject: Re: soft lockup in cfg80211 find_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090901121728.GA15790@hash.localnet>
References: <20090901121728.GA15790@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UkOhJLGYQDz6QaPlGoZg"
Date: Tue, 01 Sep 2009 17:33:37 +0200
Message-Id: <1251819217.22442.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UkOhJLGYQDz6QaPlGoZg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-01 at 08:17 -0400, Bob Copeland wrote:
> Hi,
>=20
> My laptop was on all night and at some point got stuck in a loop.
> Unfortunately I don't know exactly what happened since dmesg buffer
> filled up and there was nothing incriminating in /var/log, but
> here's my interpretation:
>=20
> EIP points to line 146:
>=20
>    while (len > 2 && ies[0] !=3D num) ...
>=20
> ECX holds len, which is negative (unfortunately size_t is unsigned)
> EDX holds ies, looks like a valid pointer
> EBX holds num, which is 0.
>=20
> This looks like this is a DoS-able bug if there are any malformed
> packets, no?  I think we should change 'len' to int here.

Absolutely. Can you send a patch? Also to .31/stable.

johannes

--=-UkOhJLGYQDz6QaPlGoZg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnT7NAAoJEODzc/N7+QmaXNcQAMamXDrgGUtO8MeFvMI8QA11
gTrIgD6UfS+K0Lwr3S5eq8xondmSF70jSHhBPfL+VSqmOWb5qyOKd6lESTLaAe6l
pmiCxi1jbR/CnI6YlLOsa9XikrsmJ5piCVBZCZNCVTOP24iqdr5URqhhyjXG3IFF
nrCp00tah3C3lyvKu63AO2cIPKC/JVIxHgCNTqhceFA+xnZa7SYJINl8T0FIZagV
8PmZUqDqrfC+Ev7XYjOAPZaLNcBSRzp5ujIKu15XsKfM+vlSkzoMYdYlhTaanUON
FSXr3+IPAyVRmruycFfb2L67aPcgs1+UeNneSh15Vb2wXkCK7lWDJK6fSrFHEG7t
C3XkbqgIGmszjxNudbpLXNmhzyMCEMiBSZHyMG7Ca5qvoVvazfXyQj6RKh4PATU7
NrGtKOZbIDduaFm4CU5Fon/l9KJGrufJXjN7kxQNPCiseG/qyVpHQmLCEa/U4qrr
AECLZFGJQ7pdYkKuvmS4/0XeOF5oggIFXwqwa0jAEK4WFeONvdxSMoqpMPyeO/Jo
GIEun8JJIX1C+j/m7dMJ6VV3He3p9Vn0Fxb+6bHtB2Om6qfKfy4oP/a0NbFilmNA
5vxGGe1FGx1W8hVmeDQX9kkr5L5fkfR6f19Hkskzi/ae5jIbgBSYGAMr4PPPOSvQ
yzW2iU8h9B9PbmgDMgrD
=AjmN
-----END PGP SIGNATURE-----

--=-UkOhJLGYQDz6QaPlGoZg--

