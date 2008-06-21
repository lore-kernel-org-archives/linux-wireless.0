Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYFUMHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 08:07:45 -0400
Subject: Re: [PATCH] mac80211: Let drivers have access to TKIP key offets
	for TX and RX MIC
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806211423.59465.IvDoorn@gmail.com> (sfid-20080621_140607_717979_1FFB6CDD)
References: <20080621115133.GI17936@ruslug.rutgers.edu>
	 <1214049613.8967.243.camel@johannes.berg>
	 <200806211423.59465.IvDoorn@gmail.com>
	 (sfid-20080621_140607_717979_1FFB6CDD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FP3OU/vstwGuEKOAA1Gc"
Date: Sat, 21 Jun 2008 14:07:32 +0200
Message-Id: <1214050052.8967.245.camel@johannes.berg> (sfid-20080621_140829_730196_FDAE7CCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FP3OU/vstwGuEKOAA1Gc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-06-21 at 14:23 +0200, Ivo van Doorn wrote:
> On Saturday 21 June 2008, Johannes Berg wrote:
> > On Sat, 2008-06-21 at 07:51 -0400, Luis R. Rodriguez wrote:
> > > Some drivers may want to to use the TKIP key offsets for TX and RX
> > > MIC so lets move this out.
> > >=20
> > > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > > ---
> > >  include/net/cfg80211.h |    5 +++++
> > >  net/mac80211/key.h     |   37 ++++++++++++-------------------------
> > >  2 files changed, 17 insertions(+), 25 deletions(-)
> > >=20
> > > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > > index e007508..6cb8b02 100644
> > > --- a/include/net/cfg80211.h
> > > +++ b/include/net/cfg80211.h
> > > @@ -12,6 +12,11 @@
> > >   * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
> > >   */
> > > =20
> > > +/* Starting offsets for each key for TKIP */
> > > +#define ALG_TKIP_TEMP_ENCR_KEY		0
> > > +#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY	16
> > > +#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY	24
> >=20
> > put it into nl80211 and give it proper namespace prefixes, please.
>=20
> Don't we need something similar for AES keys as well?

I don't think there is a separate MIC key for AES, is there?

johannes

--=-FP3OU/vstwGuEKOAA1Gc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIXO8BAAoJEKVg1VMiehFYWx0QAMVhGGjMd01zB/kzmQfAdCwz
Noh5AVWueXDIIlQfKo08+8MTP4rTPH9In00HruPxs/wSMNnitDxPe4dBB4IZ6Txr
ok4lT8SAB5ASq3Cfvv/4s22ctd6uF81REKDfHraCBa8Kweam550/sEZVMZpgq9K5
lnNoiPoPWPsXRqjSWzPQc96ZJPpxYzxVwKY1APkQgLzkeokCPcVot3XoHaCKEwR5
MMi2QJBzpW9i5BPQ7PnVZkPyUmgqldGgFIG+8ny3W2HHvBK3VlKilwaLgDlJ98AN
PM0a9F4gtl4mGmZzvKZzomtJsHWuNapI0VO0z1ajOYZcuCFnkDAKNqTsRh8lFYke
E1xGuSRyDookBOjfRu48M7/tKFW2ssUP6uRvDF72kRiFZto20J5rY6AvSzuON1he
CJnrPmBxTP4cjz0w/AkZVmZZm3qCRF3A6FJy5bVgw8bfTU+Q3uh21M9SQlkTN6G+
60bVfk8Mkm8q+r8Twh5sR6/dMpYnzbq3dGnQRZA7MdgprVzBJc+PDxIHhH0IaZR6
aGSdmStlQ2cAWSWEf1f7mSIW7a8ZAuv8CxCVa8nUwPpq8LjhcX+34sWMNCHzRoRd
Ot4H5NZ7pUaqiFe8U3qzhQpDa90Qhya1KVFgsgVzRxU4+kqL1KlnFzIpxEvnymbw
xY7XYq8e0j40Qln630SR
=bB9A
-----END PGP SIGNATURE-----

--=-FP3OU/vstwGuEKOAA1Gc--

