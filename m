Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJFSZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:25:16 -0400
Subject: Re: [PATCH v2] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223317132.11272.219.camel@violet.holtmann.net>
References: <1223311803.15196.36.camel@johannes.berg>
	 (sfid-20081006_185054_691408_9EB600FE)  <1223315348.3778.13.camel@johannes.berg>
	 <1223317132.11272.219.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cwqqVafzTFD4lMT0vo5S"
Date: Mon, 06 Oct 2008 20:24:41 +0200
Message-Id: <1223317481.3778.16.camel@johannes.berg> (sfid-20081006_202521_185704_A57ABD2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cwqqVafzTFD4lMT0vo5S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 20:18 +0200, Marcel Holtmann wrote:

> > +static inline u8 iwl_get_num_tbs(struct iwl_tfd_frame *frame)
> > +{
> > +	return frame->num_tbs & 0x1f;
> > +}
> > +
> > +static inline void iwl_set_num_tbs(struct iwl_tfd_frame *frame, u8 num=
_tbs)
> > +{
> > +	BUG_ON(num_tbs >=3D 20);
> > +
> > +	frame->num_tbs &=3D ~0x1f;
> > +	frame->num_tbs |=3D num_tbs;
> > +}
>=20
> what is this magic doing and what is wrong with
>=20
> 	frame->num_tbs =3D num_tbs & 0x1f
>=20
> Or do you expect to do something with the upper 3 bits?

I don't know. I was just keeping the original semantics. Maybe future hw
will use those bits? Maybe they are already used and need to be
preserved? This hw programming stuff in the driver is all black magic to
me.

> Personally I think it is important that we always zero any data
> structure and especially the reserved bits of it. Otherwise stuff just
> magically seems to work, but it is pure luck if the right bits are set.

Well, that doesn't just affect that but all other reserved fields too,
so we really need to kzalloc everything anyway.

> The overall patch looks good to me and I think it is the way to go. Less
> home grown bit magic the better.

:)

johannes

--=-cwqqVafzTFD4lMT0vo5S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6lflAAoJEKVg1VMiehFYGNsQAJlnhOs+N3+qCuHvomnN1xyh
YITlPsEgTLMk/qziwlAuO3ybRSjUfJ9EmYm1dvjqg8qoY9JeRvzLaU0/8K1eAawz
lccVGwcJRQmXoB3ORXjD5ojQ05+2AU4mHKz5p25r2CjEEuaJjzeJrIhJGVp5mYBe
cLsAXjizT9Ii1SbVGEBQnbDBvq2jLdyEPQDjuRvO15/rSYcvcVQNgiH7eZre+xwa
9ok+/diJn89PX3BF92eQ2wHzKqoLf+R8bcF5uNB6WEuPyeoHaaM1jHzHFB8MSzn3
gfK0JQlF0W1lvUo1vuXnwIcehGSiuXGMYjhvi4jUlseExKAtIz8MmXRaIYP93E2B
gNov4jvDh3dRnKZAtNgKpM034Bwd08cFziTZXEVm1mQoEHo4TgIDMnZQIBrVOUVg
0fKk+BOTZFwjvzSnpPcEtLhH137L7RwErM6PkEPsJ3xxaXPaeubQVBnOhkGBhEq3
m+BLf2qhWPnG3icMOLtF0J2O6W4hPi9924W00trsIGVMakILGmksRl4mDNRzzfNj
iBVoiTAvxEKtPVeHoOhewQegT5N9YG8IH0btwXsX1+/v5/djj7v8jQhW1KcDLFP4
HyDsVzqkk+r4PcsdAq0cchbjpckr5IhTpJCbK8R4Hmtx22EPtleekIjbMAy0KjP0
HcNzOhioxZ0oRhJqcmpT
=c9UI
-----END PGP SIGNATURE-----

--=-cwqqVafzTFD4lMT0vo5S--

