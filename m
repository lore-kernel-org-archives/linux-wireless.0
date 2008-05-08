Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764054AbYEHOnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 10:43:55 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com> (sfid-20080508_022003_250745_C12D08D3)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 (sfid-20080508_022003_250745_C12D08D3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XsVRIcx48nR8zfmCJkGX"
Date: Thu, 08 May 2008 16:05:22 +0200
Message-Id: <1210255522.3547.48.camel@johannes.berg> (sfid-20080508_164305_829833_A954823F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XsVRIcx48nR8zfmCJkGX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > This is for scatter gather. Nothing to do with aggregation. If you g=
et
> >  > fragmented frame you can send it out without linearizing in CPU. in
> >  > numer of TB - TX buffers (which is limitted bu MAX_NUM_OF_TBS)  But
> >  > I'm just over ever explaining :)
> >
> >  We don't support that in mac80211 right now, why do you have that ther=
e?
>=20
> Currently we actively use 2 of them. First for TX command second for
> actual frame.  It would be even worth if we need to expand
> each packet also for TX command.

We will no longer do that after davem and I figure out those allocation
patches.

You should implement TCP checksumming in the hardware. *that* would help
a lot.

johannes

--=-XsVRIcx48nR8zfmCJkGX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCMIoaVg1VMiehFYAQLTJRAAxOMvlD5s89cNyMQzPSChRXHRaz6WairZ
03s85bkJlO7UAN3kaLi1cd9HQMl1VQcpCdPKTpHptXHqiIqq+birdtbWgAb44mSB
2Yu/3diVvpuaXE48HNRwFf7y9mhqr23kEFSeSbZroyqHa0rgeUBRgs3XYhXWn4KW
yYvCSW2lIRG5zToEHCe/eO7EpLK9pOUWlXLGny8NT4gS8X+OsrhkcpCRG/S4cpIH
JlJ7962t/qwMdqRQX7Y4Ej2Chhzi2tBmFEsUJzLL8qb84OjS3a7CzQnf+29X7ZVO
+ytou40bkZJFpEeR/cWIXIY9UESqM4O9rC1ZJNK5b0zB+/psKo6W9UDJYVg+YaLo
VBw21vRKTepM1rJczhqKYWoJhk6MdJNmRh1ZaX4N6wKqAS434u/xy+IAKMZ+JPor
c4bRNHG/VbvwqVZNyzOCwzZlroD2TLwfRYGFuhF4e7c/KjhpQLeUzDBO/zjSk4YI
8F6wfrqHXAgV+L8s+wk9cR5aDvnblVyduXtnPHaaoI9rkkvuQRXNl7slCAUFXwdo
0tMlTd82ytZa1l2c49sfAvQqDkKH8bRIM+xOsqfM2mZDzXBxv0+QmYD2kIHClV3x
ZGcUpUk0mLtAPs/4f2sd6q0p1NbNWLgOpcT+N5O/tkUrm8REvbKmwCE5LPZLyV/4
/a+rznAAz94=
=NdCP
-----END PGP SIGNATURE-----

--=-XsVRIcx48nR8zfmCJkGX--

