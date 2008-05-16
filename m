Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYEPWEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 18:04:04 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210975040.5915.63.camel@brick> (sfid-20080516_235723_605932_ED6BE89E)
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 <1210971848.5915.58.camel@brick>
	 (sfid-20080516_230412_000613_CA74646C)  <1210972335.6381.52.camel@johannes.berg>
	 <1210975040.5915.63.camel@brick> (sfid-20080516_235723_605932_ED6BE89E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wuidSyCTe3T/Uf9lhDou"
Date: Sat, 17 May 2008 00:03:46 +0200
Message-Id: <1210975426.6381.70.camel@johannes.berg> (sfid-20080517_000410_424891_4B179712)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wuidSyCTe3T/Uf9lhDou
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 14:57 -0700, Harvey Harrison wrote:
> On Fri, 2008-05-16 at 23:12 +0200, Johannes Berg wrote:
> > > > > +static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *hd=
r)
> > > >=20
> > > > That seems fine too.
> > > >=20
> > > > > +static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u16=
 ftype)
> > > >=20
> > > > That, I think, is misnamed, it should be ieee80211_is_ftype()
> > >=20
> > > Well, I didn't expect this to be used directly that much, hence the
> > > following three helpers...ftype_mgmt/ctl/data
> >=20
> > Right. Still, I think it should be named with _is_ in there.
>=20
> Yes, I agree with you, that's what I meant to write.

Actually, maybe it should be "has" and not "is" since it's being passed
a frame that can *have* a given frame type, and is a frame of a given
type. Dunno.

> Ahhh, I see what you are getting at now, how about ieee80211_stype_mask?
>=20
> That makes the & a little clearer and has better semantic meaning.
>=20
> The other option is still to call it stype_mask, but change it to
> return a __le16....so tests against !=3D 0 still work and really
> is just a wrapper around the byteswap of the constant and the &.

Hmm. I'm not sure, how is all this really used? It seems you want

ieee80211_has_qos_stype(hdr)

and

ieee80211_has_stype(hdr, stype)

instead, no?

johannes

--=-wuidSyCTe3T/Uf9lhDou
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC4EwaVg1VMiehFYAQJCRRAAk9ohZLJ6sSZmV2wN/ixMusfql6vtTIX7
Rk3Ig+WNsusA5uEScsDnBxhNAtzAf5izQGhfvoBWa+qVxuMfXMXLGFevIoaam0ZZ
TerrflPyiWia34Ydk82e//NPfJPt/7bjZWRZxSWUrgTvcsnW3EsDIsbBeXXrtxD2
n4w63blg0xO0xBcmgnj5O9Pv/R+eDIWbwWt6xSLDjNvPrLO8iB5Us9PgOgTg530A
O1YpX5VdMHj71xDboh0wmLGmwC8tQ6uzjQDsjuKMxSRoDdf9XXZMcoUYHJre60CD
KGAEhP5ckinx4g/PUsw8PgdfiWBk5xwOuWyQkWsBdfLkD5LzqiA6SKmvL+8g/VWs
+aiEq8kJbb5IbEEKnK+6sSRKCYHN8qd6Oi/RclzACk+5+zSSuyp1mvtGmairveyv
e3tF2EHIdEtHZkbwut/yJEq8yMvw1S14/OsQf98dWn2yR20HkLlmHbYCfElrtmAY
+8vctBJ7VG6SdllkYJczm9ZC11dgV2jKAZaCJeI+bwjEqIMW9ph1MTo4SupVU8HK
E2lZPYVMngLRGxfbVFh48R5iMpB/GqSXaCITYQOE8kZr3dBK1TEpXB8ODwaYaByE
nBJh44aBy/ahP24I7znfJ4HD54P0hs/M3NGvBUGrzv1Ydw4RIsRDdtwiIlxSIdSM
ruroRL5yAH8=
=2J8H
-----END PGP SIGNATURE-----

--=-wuidSyCTe3T/Uf9lhDou--

