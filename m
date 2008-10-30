Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYJ3KjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:39:01 -0400
Subject: Re: [PATCH] don't use net/ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <490880EA.9090207@gmail.com> (sfid-20081029_162811_514174_02C4E1A0)
References: <1225243531.1369.18.camel@johannes.berg>
	 <490880EA.9090207@gmail.com> (sfid-20081029_162811_514174_02C4E1A0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ix4a/H94XoYEEsq1zc+S"
Date: Thu, 30 Oct 2008 11:38:58 +0100
Message-Id: <1225363138.3690.13.camel@johannes.berg> (sfid-20081030_113909_965499_28EE481C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ix4a/H94XoYEEsq1zc+S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 15:27 +0000, Dave wrote:

> > -static inline u8 *orinoco_get_ie(u8 *data, size_t len,
> > -				 enum ieee80211_mfie eid)
> > +static inline u8 *orinoco_get_ie(u8 *data, size_t len, u8 eid)
>=20
> Would it be better to change to enum ieee80211_eid here?

Not sure. You could very well use it to find arbitrary IEs that don't
have constants, or find dynamic ones based on a u8 variable. I don't
really care, up to you, which would you prefer?

> > @@ -839,7 +838,8 @@ static int orinoco_change_mtu(struct net
> >  	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
> >  		return -EINVAL;
> > =20
> > -	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
> > +	/* MTU + encapsulation + header length */
> > +	if ( (new_mtu + ENCAPS_OVERHEAD + 24) >
>=20
> I think that constant should be 30. I'd prefer it if we didn't use a
> magic number here. How about sizeof(ieee80211_hdr)?

I wanted to use sizeof, but then I checked and realised the driver
doesn't support WDS mode, so it never needs a 4-addr header format, so
24 is the right header size.

> > @@ -3289,7 +3289,7 @@ static int orinoco_init(struct net_devic
> > =20
> >  	/* No need to lock, the hw_unavailable flag is already set in
> >  	 * alloc_orinocodev() */
> > -	priv->nicbuf_size =3D IEEE80211_FRAME_LEN + ETH_HLEN;
> > +	priv->nicbuf_size =3D IEEE80211_MAX_FRAME_LEN + ETH_HLEN;
>=20
> Note that this changes nicbuf_size from 2334 to 2352. I don't expect any
> problems, and haven't noticed anything while running my version with
> this change.

Oh. I wasn't aware the constants differed. What's this used for?

johannes

--=-Ix4a/H94XoYEEsq1zc+S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCY6+AAoJEKVg1VMiehFYEdwQAJdN0nF7AUdFUFxzG2buBRWh
p7E4T20wDiyBq8Ofld9UnWlI4xPwFbb4dgaKSauMj6CkfhN95Mf3fIxd7Hsi1T+K
kfP5W+r7SiHILA/SBJ6FqtXUtlnvpBOdA6vzYibWWyTJ4QnBZKo6YPIBkqMcGhRt
xySB6oUtACUnyulyfUk0eEUzQmGCzvSIs3Mm8BlTeXr+sXaiIAsO7TaTAgfQGt8V
W+p6QrSfrMTrz8F/UqJWYO7elYpMXz2UL5ERUlng7ACTTsP4Q2CbKmdyU39mryh9
xYP7baYy8n/F3cM82I0RhchutZPscmSKgs4ejpygxltxFl/ZePDgXkkEa6mRiQOv
/Kf44XZgRZvncbpmGgkn44DMuZmhvDkdIXcuhtfguJDXY2ih+bP7NR2z3UBaPyeS
izzv/6BhA1nUKNp8Kh5KJQxuWjiB+FJ43KxVSH8RYf717vWhBDQr/BQF1M19yfKT
IzkbzeBxePqczqzzZ5dU4o1yRtSBcJEdQ9OpaxysWpUd+jNIr4QE920RzZ8eHmva
QuaBZVl2oPrCMvP4naZNGWXHTuXAC8MonR2Zt5L+eZ541vBe82EYnzdJF3hPxVcr
Pj4EbrJfnlGY/r++Iuzo7zILC7ySLCk6UtJl2xuqyJRlvS17FpowquTt1yuqIwmY
E+KQ+76XbNxFe2hrCVTP
=gisa
-----END PGP SIGNATURE-----

--=-Ix4a/H94XoYEEsq1zc+S--

