Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYJ3LoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 07:44:12 -0400
Subject: Re: [PATCH] don't use net/ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49099C8E.9000303@gmail.com> (sfid-20081030_123805_013044_38918F80)
References: <1225243531.1369.18.camel@johannes.berg>
	 <490880EA.9090207@gmail.com>
	 (sfid-20081029_162811_514174_02C4E1A0) <1225363138.3690.13.camel@johannes.berg>
	 <49099C8E.9000303@gmail.com> (sfid-20081030_123805_013044_38918F80)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s2atMmsp20XK4FK1H1qz"
Date: Thu, 30 Oct 2008 12:44:05 +0100
Message-Id: <1225367045.3690.38.camel@johannes.berg> (sfid-20081030_124415_269744_BA29DCC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s2atMmsp20XK4FK1H1qz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 11:37 +0000, Dave wrote:
> Johannes Berg wrote:
> > On Wed, 2008-10-29 at 15:27 +0000, Dave wrote:
> >=20
> >>> -static inline u8 *orinoco_get_ie(u8 *data, size_t len,
> >>> -				 enum ieee80211_mfie eid)
> >>> +static inline u8 *orinoco_get_ie(u8 *data, size_t len, u8 eid)
> >> Would it be better to change to enum ieee80211_eid here?

> I don't expect orinoco to be doing anything non-standard with IE's, so
> anything we want should be available from the enum. And I like the extra
> type checking. So I'd go with the enum if you don't mind.

Ok, sure. I think I deleted the patch locally, but I'll import my own
email and edit it :)

> >>> -	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
> >>> +	/* MTU + encapsulation + header length */
> >>> +	if ( (new_mtu + ENCAPS_OVERHEAD + 24) >
> >> I think that constant should be 30. I'd prefer it if we didn't use a
> >> magic number here. How about sizeof(ieee80211_hdr)?
> >=20
> > I wanted to use sizeof, but then I checked and realised the driver
> > doesn't support WDS mode, so it never needs a 4-addr header format, so
> > 24 is the right header size.
>=20
> I'm not sure how this was originally set, and what the MTU is all
> about... so I'll defer to you on this. However it might make sense to do
> the change in value in a separate commit.

Well IEEE82011_HLEN is 30 =3D=3D sizeof(ieee80211_hdr) (I think) But when I
saw this, I noticed that since it doesn't support WDS mode it'll never
actually need 30 bytes of header. The check here is to verify that all
packets passed down from the networking stack actually fit into 802.11
packets, so using 30 obviously won't matter since it means a smaller MTU
is supposed, and since ethernet tends to have a 1500 byte MTU with
wireless being much larger, that is typically not an issue. I don't know
anybody who sets their wireless MTU larger than the default of 1500.

> I had a quick reread for sanity: in orinoco_xmit we always write at
> least 46 (HERMES_802_3_OFFSET) bytes of header before the payload.
> Shouldn't our max MTU key off of that? It looks fishy to me.

That I don't understand, the value 46 doesn't tell me anything.

> > Oh. I wasn't aware the constants differed. What's this used for?
>=20
> I think this just allocates the hardware buffer we copy our frames into
> for transmission. It looks like the hw buffer can go up to 4k (except on
> buggy Symbol firmware).

Ok.

I'll change the HLEN and element ID things and resend, thanks for the
review.

johannes

--=-s2atMmsp20XK4FK1H1qz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCZ4BAAoJEKVg1VMiehFYxS4P/Rc8el0eMjx6zOJliH1DlKPS
sIgBJxHu8GEuVVcWIl5qYTjAmRQhkpjLZIJC6xuQ2f9dRUpDnkZX7FehRXNcNOPT
81SGMhoQij4KpJW58APLoA8B0H7fKxagNGwZXPBZbEark8bjiEE9hojnbuWaZS/I
iXVbmt6Q0qYTCv+CmJwP042IjFntQ4qOvAtHItjSzNukwNW1Yh8efW3GP1fETG3V
EEa2aU4tS5ODaPraL4SAN+3iaKKAY3nCpX8hdmb/UZBKLsrF7tX5AmHvhX2RyZk6
sb4x4lO0Fm4oNPLN2NxeACGdfXKJiZS9rZ/Zt36GErtRGWF2cWMOYuryvRFyMMSU
Dc5Xg19SpX8WALN4a/y0EC85EJL/JvmfRIhOl8sJhDBeiJ8JO3XKQONzcyaR9nHe
zWozeDJ/nN9orpHesIqLyGLg+iDgRetPyXcCr0wElGlCibeTePLVKCW8aFxHkRi7
I357kQRuXj8ot8XeKkZsoDtnVeX7WAPi3Zt+YmBwsIb3DtFlCmv9HifFWT8N+ulI
0y43eY38MWz2W9csxWbKCpslry2t0s2T0P8CkxnF5dZlKNLWaofOtbtVLyLz+0VQ
rIK08Q/3tbo4XlVd6z4296386AMNX17DKpGeO2GWyozBjksiwVDVg8T+PDyK3OGS
fNoU8P+pogTCGuWyBwk0
=RQCj
-----END PGP SIGNATURE-----

--=-s2atMmsp20XK4FK1H1qz--

