Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYGIPvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:51:45 -0400
Subject: Re: [PATCH 2/3] mac80211: use ieee80211 frame control directly
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215618572.476.70.camel@brick> (sfid-20080709_174958_675805_8C01ADF0)
References: <1215568845.476.67.camel@brick>
	 (sfid-20080709_040049_850302_67F9F0D2)  <1215589460.3670.30.camel@johannes.berg>
	 <1215618572.476.70.camel@brick> (sfid-20080709_174958_675805_8C01ADF0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BVOszoahl+56PUaPSRDL"
Date: Wed, 09 Jul 2008 17:50:59 +0200
Message-Id: <1215618659.3246.32.camel@johannes.berg> (sfid-20080709_175159_284112_3B1C29F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BVOszoahl+56PUaPSRDL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 08:49 -0700, Harvey Harrison wrote:
> On Wed, 2008-07-09 at 09:44 +0200, Johannes Berg wrote:
> > > --- a/net/mac80211/wep.c
> > > +++ b/net/mac80211/wep.c
> > > @@ -291,9 +291,10 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *sk=
b, struct ieee80211_key *key)
> > >  ieee80211_rx_result
> > >  ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
> > >  {
> > > -	if ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA &&
> > > -	    ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_MGMT ||
> > > -	     (rx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_AUTH))
> > > +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)rx->skb->data=
;
> > > +
> > > +	if (ieee80211_is_data(hdr->frame_control) &&
> > > +	    ieee80211_is_auth(hdr->frame_control))
> > >  		return RX_CONTINUE;
> >=20
> > That one seems impossible to hit now and should be !is_data && !is_auth
> > I think.
>=20
> Yep.  I'll have another look over this to see if I made any others.

You can also set up the mac80211_hwsim driver to test things without any
hardware. :) It even comes with examples in
Documentation/networking/mac80211_hwsim/.

johannes

--=-BVOszoahl+56PUaPSRDL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdN5fAAoJEKVg1VMiehFYXH0P/12AkWZrr8/F1zwmT0+Cgo+L
K1ffPzNgNy9ZITOcc/eS9uMbrPm1TXgGuQkUsowaToh3fZnjZOwIP6j1g3aoXtbp
CPnKoh0o3F54F2crfrIPii9r85aLgH/CSVV3S1r7LlWtzw5TcxTdaAo+0+h3xrwH
p0SIhbk15jwEFdgcqOkAyq/YL7uymTs6IBfWD2rDIbeeIpzzL3VoAsfF4GoHpV+r
K9Yx8PZNKiNkOEuIIFwFkFv9wpvgN7R76fYaLwBx51CQMprMh+/O+IoKFTDwS63z
xvbWVFuuz7t2W3BPYOPLNDai7zgRPS9P2QAnasLsjfyk9KIdpJyP1oPCOHquT2Od
tzV0f+4TPBJGpaqEjGgGzvubOWabXdOYWIvp16kEqvFhJAeB0kt9l+Q5+tR0gw4Y
Rm9gg96gR0XxgTT1/7YRq7x5BMyLzEFEXLEASGeYVCBt63FZa5k0+SgVTc5Z0XbC
TdwCAcbbUsCdOR/cfGmbZnJoUEALFzlEIZp78Trd2t3dY3kI4jnJZPHOe7VLK+gq
DyBT/wH5LhzMTqdCiMt1oEztBfRLxsV3DN7/zrXIrUczyncjfI+NUe/v87oTrprM
4DQYQc8KOhmVEMvQsVXPDyZPLsjGVPzaAuK13AfmafjH6ZjiB7dNCqS4JKhI4FQO
OJd/uhD5YZcIGgq2chu2
=HxEy
-----END PGP SIGNATURE-----

--=-BVOszoahl+56PUaPSRDL--

