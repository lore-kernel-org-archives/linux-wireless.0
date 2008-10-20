Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYJTI5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:57:22 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com> (sfid-20081020_105546_649034_66038002)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 <1224492335.18024.34.camel@johannes.berg>
	 <18684.17816.702853.44986@gargle.gargle.HOWL>
	 <43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com>
	 (sfid-20081020_105546_649034_66038002)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9fDOHDn558pb4uMPi3LO"
Date: Mon, 20 Oct 2008 10:57:18 +0200
Message-Id: <1224493038.18024.36.camel@johannes.berg> (sfid-20081020_105731_285636_C210C977)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9fDOHDn558pb4uMPi3LO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 01:55 -0700, Luis R. Rodriguez wrote:
> On Mon, Oct 20, 2008 at 1:47 AM, Sujith <Sujith.Manoharan@atheros.com> wr=
ote:
> > Johannes Berg wrote:
> >  > On Mon, 2008-10-20 at 01:35 -0700, Luis R. Rodriguez wrote:
> >  >
> >  > > >> + *   @is_part_ampdu: set to indicate that the wireless core sh=
ould should
> >  > > >> + *           treat this frame as part of an AMPDU
> >  > > >
> >  > > > I thought we said we could keep the flag instead of moving to th=
e skb
> >  > > > here?
> >  > >
> >  > > That was just because the changes required to add this was too muc=
h
> >  > > for 2.6.27 but since we don't care about this fix in 2.6.27 we can=
 do
> >  > > whatever is needed to fix this properly.
> >  >
> >  > Right, but adding random stuff into skb isn't really "properly" imho=
.
> >  > And we don't really need this afaict.
> >  >
> >
> > Sorry, just saw that Tomas had fixed it by setting the flag in ieee8021=
1_tx_h_sequence().
> > Will fix that.
>=20
> No that was a hack too, this was to minimize code changes for 2.6.27 as w=
ell.

Well the fact that it's in tx_h_sequence is a bit weird, but we should
be able to get around not using an extra bit in skb I think. Especially
for this since it's only really between the driver and mac80211, and
after a requeue the ampdu status might actually change.

johannes

--=-9fDOHDn558pb4uMPi3LO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/EfqAAoJEKVg1VMiehFYU94QAJvrQKTNUNzXhiE2hY29jhtk
rGSsr9oSgjtL7w1IXPiRkgaXfeGfX8Ai4pWqeDUNgvTdavPeWGhlmQAJkGDtN3Nl
ztWzGUa1kljIDkcuDwwkm7xV0jxK3jRcpBZtA2fM60geadny5MZp5VBBhMW/XRZm
TmaNNiXnHp1HzC5I8G5hytC5vX6xB0l2iywdcLB+fXflya1DIf/LMgeP8SPKbzIL
jK5sGpBTrbEubZZr/LJT5WsgOrxdn7up+p7ajSxMNCsDVuL9oeFdgIDR/kYoPQ/a
ijFIU3WO8jry4iRKpabIIn2z0VxPUWYDoEC4XFFEQYOMslrwLJV05lh/qIaGs+Nu
B/HJMN+c4npTCAuAexcA2I2/WU+DwP5dasIx1mQ6alp1XDSbL8yyYU5r2a8dJJtQ
UILw0RmYyYz4cTRv2qquLtV5YIKi7P5c+4mJIbaRXc/P1/tepL6CZ1KBP3PQUvYT
o7gLDvw8ba6txHPltRh3dBdxRs1rrnVqm2L2hjwy69IiRUcrEtMNNeY57WOU5fyT
3T4FHPhQOhuJR9s8GodQHwwxMpiPu537Uz1fhQaRAZGAKSBxvb/ZcF1CmUS/sJhx
Wrvypz44a2tBDc51NtRYCjh6I2W9+6pXQkoZyF6O9LGujl1BryS9EDe5tn2daCwp
iAKjwZ1uy8BaGx2n7p7a
=cmWN
-----END PGP SIGNATURE-----

--=-9fDOHDn558pb4uMPi3LO--

