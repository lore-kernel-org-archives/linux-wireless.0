Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbYEPUlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:41:07 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210969866.6381.46.camel@johannes.berg> (sfid-20080516_223131_709907_6A706BD2)
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 (sfid-20080516_223131_709907_6A706BD2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4HArI4h+vDgUPaLH/JRh"
Date: Fri, 16 May 2008 22:40:51 +0200
Message-Id: <1210970451.6381.48.camel@johannes.berg> (sfid-20080516_224112_011083_2253EA2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4HArI4h+vDgUPaLH/JRh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > +static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u16 stype=
)
> > +{
> > +	return (hdr->frame_control & cpu_to_le16(stype)) !=3D 0;
> > +}
>=20
> And that even seems implemented wrongly? stype is a 4-bit field, this
> doesn't make much sense to me.

Now, before you get any ideas, this code

=EF=BB=BF
-       a4_included =3D (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)=
) =3D=3D
-               (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-       if ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA &&
-           fc & IEEE80211_STYPE_QOS_DATA) {

is still correct. You really want to read the frame type bit assignments
in 802.11-2007 :)

johannes

--=-4HArI4h+vDgUPaLH/JRh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC3xUaVg1VMiehFYAQIH9BAAnGjyiZSpurtw+yBxa1Jpqm05FPqp1xRR
62WMEcRAxxvI4LfgHtzFC06INFXd6zRu7GFD3dfV6dwWZ+BJShNYsAWQY5qQrdgz
y1nYIGOO6yyQqP9kE6Zdcg9Bg5/EHeox+8iT8AJ8BI5Vvr3mLvA5nf6vEuMk64EF
+J5Cc3fDj3v6Lf+2u2F//Gw8i52O6fOsIqfCSsw/KUrAE4J8ce5YRhnPkxXZ6kkH
4OlFVR4tgPFOex1JEMDFK6/dBq2Zfw7h83cMVql9v8YDq0O0EsvkuB41RF458Ab3
dYAY1FRuLoO7NAZVBkXVY5L6NG95CEzH9UdmqiNqvB8EWAlcz1QO5CZqGX7nqOgx
WbQOTswM3av9d7zrocZIp8HUTzpXkjNWPEXDGYhqwpFRauHDf8uzUPgzAUj2Am2I
cILAJGB080a4iIQmehJZEgceebXDadL4HBpsS6bjsdikvS8Eltx2rNuokNU0sReH
P0GIv3BnVwdrMOuUmg6Ic0cjmhxxlVOZMSN6JGaEEctIrV1I5sxPgoBBvp0mO359
GQuxO6GraHhQL+H+BJ2h79mExNwAf0mDxK9ZLxmkiZmeNhzZDmRWtlGS2PT9fVs/
NWznfmj9vlvBdvRizh++cejEv0MRKClzix3MjBanbjHomk9nMzMQAE4fpriezPCa
+nDynGgSJ34=
=rU6t
-----END PGP SIGNATURE-----

--=-4HArI4h+vDgUPaLH/JRh--

