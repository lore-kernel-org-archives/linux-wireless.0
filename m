Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZJWNfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:35:08 -0400
Subject: Re: cfg80211 / libertas: an unusual race
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910161403.37660.hs4233@mail.mn-solutions.de>
References: <200910131055.31739.hs4233@mail.mn-solutions.de>
	 <1255687030.4095.327.camel@johannes.local>
	 <200910161403.37660.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z+AtUlmBYPLzkVspKbCO"
Date: Thu, 22 Oct 2009 10:47:57 +0200
Message-Id: <1256201277.12174.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z+AtUlmBYPLzkVspKbCO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 14:03 +0200, Holger Schurig wrote:
> > I don't see this happening that way -- how are you even getting=20
> to
> > __cfg80211_disconnected() if not through _send_deauth()?
>=20
> See step 7a in the second table.  We got there via=20
> _send_deauth().
>=20
> But later, step 3b in the second table (I kept the original=20
> numbers, so 3b happens after 7a time-wise!) we got into=20
> WARN_ON().

Still not making sense to me, since cfg80211_mlme_deauth() never does
anything after calling you.

johannes


--=-Z+AtUlmBYPLzkVspKbCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4Bw5AAoJEODzc/N7+Qma7QYQAK7zRV6op3qqomegqwaX+Ajp
MVGMLvkt2nBDwrlbVlyyWFxcceVfDVLq5gkn20fqiyuWQZrGe1PI+bvuEQUyPhMG
7F0xMz/s/Yh9MjOh9SdC/DLkpRr2mteLBW4VArQxNIc+d4cZYzvQrGN98E7Y3hMx
jdzbe3Bwxp9/433WImEcyXhS2jN/9qd/wUXy/fk+6EmW7et2o957IR3uLqGZqFw6
3aEn+6vpUiLwp0Dwnrh+LDIP+jl/UrFLvO5mZhqDLjgGOplv/r8SxlgnaMV1a6gz
03uA0se0J+p49bYMKCiIHTtMgbCFQLnWrKSWaFjyxPHK/j6qofq2yZXAyZm26gtf
R059wXfIzsmsWIeLpwdoUY2870sUj6eV+vbvjBkIH+q2re2dKzdJOcC16aywxJ2Y
p7/vO7JcpxQo1dsMyapx7QtG95ZLoeWJYB9Tvcf4M3uJSqPfVsomEsMkRyYJG40W
XkhNiauDzSImFZrQgma3ytFMBKFfIJ8HdtpmNmfp7QATAyNnGGSWA0hcZ6JCjUt4
ItrUVQniA9JxntlDMtliCtXhGTxuDckT9G7C3SsvjJe+fn0DV4Ir5gsBVOFRhSWx
8l7Br4fdmuGZL0Jbb44om+1FBq2cqBP6KhEpOqFlshHvNAv5dPwdEfZpJAePeVvz
1T5u8lBkUgXdBanJ80xz
=pmrJ
-----END PGP SIGNATURE-----

--=-Z+AtUlmBYPLzkVspKbCO--

