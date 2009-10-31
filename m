Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZJaPhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 11:37:09 -0400
Subject: Re: Re[2]: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <7724371.20091031172437@mail.ru>
References: <1094614475.20091030230028@mail.ru>
	 <200910310959.43260.IvDoorn@gmail.com>
	 <1256981113.3555.92.camel@johannes.local>
	 <200910311030.45582.IvDoorn@gmail.com>
	 <1256981677.3555.94.camel@johannes.local>  <7724371.20091031172437@mail.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QEoKHMiejIlVA7pIx8bT"
Date: Sat, 31 Oct 2009 16:35:44 +0100
Message-ID: <1257003344.3555.136.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QEoKHMiejIlVA7pIx8bT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 17:24 +0300, Nikolai ZHUBR wrote:
> Saturday, October 31, 2009, 12:34:37 PM, Johannes Berg wrote:
> >> > > 4 actually, wasn't there some cases where the header could have an=
 odd
> >> > > number of bytes and would require 3 bytes for alignment?
> >> >=20
> >> > Hm, is there? I thought they changed the 11s draft to no longer have
> >> > that.
> >>=20
> >> Well 2 is fine in that case, (I was basing my comment on something sai=
d on this mailinglist
> >> a long time ago). :)
>=20
> > However, it really all depends on the hardware too ... Maybe we should
> > put more of the logic into drivers, and have mac80211 only export its
> > required headroom?
>=20
> > Or maybe we should just not bother with having drivers do the alignment
> > any more -- mac80211 does that now and it only does it if necessary
> > (i.e. not on powerpc/x86)
>=20
> I'm having this issue on mips platform, if it matters. I cannot test
> it on x86 yet.
>=20
> Now, searching for "extra_tx_headroom" gives me essentially the
> following two:
>=20
> net/mac80211/main.c:
>         local->tx_headroom =3D max_t(unsigned int , local->hw.extra_tx_he=
adroom,
>                                    sizeof(struct ieee80211_tx_status_rtap=
_hdr));
>=20
> drivers/net/wireless/rt*pci.c:
>         rt2x00dev->hw->extra_tx_headroom =3D 0;
>=20
> So, as a quick-and-dirty fix, should I replace "max_t(..." by "4 + max_t(=
..."
> or "=3D 0" by "=3D 4" ?

4 + max ... should work if it's what we think it is. Let us know.

johannes

--=-QEoKHMiejIlVA7pIx8bT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7FlLAAoJEODzc/N7+Qma1loQAJhsL+8pcK1fpf41TT0eKYWj
3EwuEvMTUB4D6EJJhQc04nmn31f5/bTsAH2E9cIj+GzNuY21gFyTMXs1QHH6PRnj
zK176gHoJGnBcT6vXGIW/FP7qd4lwNvqpZZFTpNiBKwt8pYcQcYZnJI4aRAk4LkB
TSFsN1gudvm6mzaK7aSdTVQQSjPFe39qZsLzrVImUVMvV+Cy2bMTiTxSyWO3KhVW
R9dDLpG73XLRaW5Ud9AAgnO+z37ivTGvnjyXmXPbSKMNZ7W3GBGibn9wGUkRTYxy
iIE5EsQVqtElLpjzoaqBzjE56EpMpNs83GuSJAq5fl0qglauMi/DigPDxqz/75Q7
SEQBzgmG24Si+Uw+8T6PEE5N/hnYTetCvczvdEKK3QD8sl/LWIaqN/WIz+52cP39
mXxZe5Z7YLeuDG1agrXgQRD+uqXhmhmUlgkY7b1DPZTJbn7wcJvAUbowflIun5MN
wijMw1Fbv5vJ/wqOEb0Jdewpz/Yj4a13W0PevJd7IFXasEo9wyF8gUJOpUatHpai
26RBhvoh2w6PrIX2f0rsXtuGT2XSMc8qGRm6dMSyzD0FCoESC1aeSgBMVesm+PfD
NJKAJtJXK8jRbeADLvzT9RkCFPoXzftyMbjFq7hp86YLXL0ufDQWNtabKsqHc3Dv
bLIhnEwhz176qdr9Y4tS
=AZJ/
-----END PGP SIGNATURE-----

--=-QEoKHMiejIlVA7pIx8bT--

