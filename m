Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZEMWXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:23:11 -0400
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090513181458.GB19693@tesla>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
	 <1242208515.29288.0.camel@johannes.local>  <20090513181458.GB19693@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZtDLY6HR2UMMHt1eJoma"
Date: Thu, 14 May 2009 00:22:42 +0200
Message-Id: <1242253362.10076.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZtDLY6HR2UMMHt1eJoma
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 11:14 -0700, Luis R. Rodriguez wrote:

> > > +enum nl80211_wow_triggers {
> > > +	NL80211_WOW_TRIGGER_MAGIC_PACKET	=3D 1 << 0,
> > > +	NL80211_WOW_TRIGGER_BMISS		=3D 1 << 1,
> > > +	NL80211_WOW_TRIGGER_LINK_CHANGE		=3D 1 << 2,
> > > +	NL80211_WOW_TRIGGER_PATTERN		=3D 1 << 3,
> > > +};
> >=20
> > Seems like you need to have a way to set the pattern and magic packet?
>=20
> Yeah TDB -- the code for that is a bit complex and I don't understand how
> things are being broken down yet. We could just not have the cabability
> present until that's properly figured out.

Yeah I think that would be preferable, maybe even not define the bits
until we figure out what else we need. It might not actually make sense
to use bits here, for example if you need a magic packet to wake up it
might make sense to have just a magic packet netlink attribute that, if
userspace passes it, defines that magic packet with that packet should
be used, instead of requiring that the user sets both the bit and gives
the packet. etc.

johannes

--=-ZtDLY6HR2UMMHt1eJoma
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0gvAAoJEODzc/N7+QmaoW8P/RHupwLsL+fJCoG7NdYXlGpQ
f8ybWTiRaTsoyXl8Rww7jzAL2WIgJRx6YeFu1QHaVN3MOZ5GL6bLC4qxDJCPXsEi
zT2sJW7296celEr1lAty/2YOFWJniD6ICR0hzh0v2jzYuVMHilB7/d+H2ye+KSr1
5XU9MZK4Cqc2a3hGuai1YzGQP5v2dm+Wv/0/CnJaX7L6N81lVx0tV0a+G0jL4UOB
up3/UYfTXu5HlkLFlBHEw2bGlw/z9PUHhe2KuCiBDiVTDaZ5H9c/Bb2+FVVSZFzJ
zSIhs5QvaF/bxZa8aEZ2tZCxgrj76LxBkZcSGXAt3bsKPBDEHkwNtLy8R8NDssXU
nSyoXChrioHzXHT02+oypRV3UkwuGVihBvLsx4nUqIgryDaosYm/uR4+4HZXHDCG
h825Ik7oNHcRnIeuB76QYBCadovFFoQIZnYdObYWkbnJpxGIdQjIcs2tSrPCreFP
IpOEzxz+TJMYAFIG6DcX8hd5v+b+MS+VIae1LoTOsatolU6Pmj6N/RTmXv++r7FB
h3YnIxhfillsmLPGpQtI9J1Mfah3KMhiTaesyrgPq01tW7bm4kOmL21lUn+QNUl/
Yj5DRGurK2g74kgllFmHaizeGIAm0nmCYDJN3fbuTAV2+QvXrLJPIYL2KsPemW3f
euSxWr3pHah7APUTN/6z
=cnsv
-----END PGP SIGNATURE-----

--=-ZtDLY6HR2UMMHt1eJoma--

